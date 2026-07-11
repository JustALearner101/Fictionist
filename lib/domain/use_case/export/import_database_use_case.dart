import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../entity/entity.dart';
import '../../map/world_map.dart';
import '../../relationship/relationship.dart';
import '../../repository/entity_repository.dart';
import '../../repository/map_repository.dart';
import '../../repository/relationship_repository.dart';
import '../../repository/tag_repository.dart';
import '../../repository/template_repository.dart';
import '../../repository/timeline_repository.dart';
import '../../tag/tag.dart';
import '../../template/template.dart';
import '../../timeline/timeline_entry.dart';

class ImportDatabaseParams {
  final String jsonContent;
  final bool isReplace;

  const ImportDatabaseParams({
    required this.jsonContent,
    required this.isReplace,
  });
}

@lazySingleton
class ImportDatabaseUseCase implements UseCase<Unit, ImportDatabaseParams> {
  final EntityRepository _entityRepository;
  final RelationshipRepository _relationshipRepository;
  final TagRepository _tagRepository;
  final TimelineRepository _timelineRepository;
  final TemplateRepository _templateRepository;
  final MapRepository _mapRepository;

  ImportDatabaseUseCase(
    this._entityRepository,
    this._relationshipRepository,
    this._tagRepository,
    this._timelineRepository,
    this._templateRepository,
    this._mapRepository,
  );

  @override
  Future<Either<Failure, Unit>> call(ImportDatabaseParams params) async {
    try {
      final Map<String, dynamic> decoded =
          jsonDecode(params.jsonContent) as Map<String, dynamic>;
      final formatVersion = decoded['export_format_version'] as int?;
      if (formatVersion == null || formatVersion > 1) {
        return const Left(Failure.validation(
          message: 'Unsupported export format version',
        ));
      }

      final data = decoded['data'] as Map<String, dynamic>?;
      if (data == null) {
        return const Left(Failure.validation(
          message: 'Invalid export file structure',
        ));
      }

      // Parse JSON lists to domain objects
      final entitiesList = (data['entities'] as List? ?? [])
          .map((e) => Entity.fromJson(e as Map<String, dynamic>))
          .toList();

      final relationshipsList = (data['relationships'] as List? ?? [])
          .map((e) => Relationship.fromJson(e as Map<String, dynamic>))
          .toList();

      final tagsList = (data['tags'] as List? ?? [])
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList();

      final timelineList = (data['timeline_entries'] as List? ?? [])
          .map((e) => TimelineEntry.fromJson(e as Map<String, dynamic>))
          .toList();

      final templatesList = (data['templates'] as List? ?? [])
          .map((e) => Template.fromJson(e as Map<String, dynamic>))
          .toList();

      final mapsList = (data['world_maps'] as List? ?? [])
          .map((e) => WorldMap.fromJson(e as Map<String, dynamic>))
          .toList();

      if (params.isReplace) {
        // Phase 1: Gather existing IDs to detect orphans (items in DB but not in import)
        final existingEntities = await _entityRepository.getAllActive();
        final existingRels = await _relationshipRepository.getAllActive();
        final existingTimeline = await _timelineRepository.getAllActiveOrdered();

        final importEntityIds = entitiesList.map((e) => e.id).toSet();
        final importRelIds = relationshipsList.map((r) => r.id).toSet();
        final importTimelineIds = timelineList.map((t) => t.id).toSet();

        // Phase 2: Soft-delete orphans not present in the import
        existingEntities.fold(
          (_) {},
          (list) {
            for (final e in list) {
              if (!importEntityIds.contains(e.id)) {
                _entityRepository.softDelete(e.id);
              }
            }
          },
        );
        existingRels.fold(
          (_) {},
          (list) {
            for (final r in list) {
              if (!importRelIds.contains(r.id)) {
                _relationshipRepository.delete(r.id);
              }
            }
          },
        );
        existingTimeline.fold(
          (_) {},
          (list) {
            for (final t in list) {
              if (!importTimelineIds.contains(t.id)) {
                _timelineRepository.delete(t.id);
              }
            }
          },
        );
      }

      // Import Tags first (dependency)
      for (final tag in tagsList) {
        await _tagRepository.create(tag);
      }

      // Import Entities
      for (final entity in entitiesList) {
        final existingResult = await _entityRepository.getById(entity.id);
        await existingResult.fold(
          (failure) => _entityRepository.create(entity),
          (existingEntity) async {
            if (entity.updatedAt.isAfter(existingEntity.updatedAt)) {
              return _entityRepository.update(entity);
            }
            return Right<Failure, Entity>(existingEntity);
          },
        );
      }

      // Import Relationships
      for (final rel in relationshipsList) {
        final existingResult = await _relationshipRepository.getById(rel.id);
        await existingResult.fold(
          (failure) => _relationshipRepository.create(rel),
          (existingRel) async {
            if (rel.updatedAt.isAfter(existingRel.updatedAt)) {
              // Drift update
              await _relationshipRepository.delete(rel.id);
              return _relationshipRepository.create(rel);
            }
            return Right<Failure, Relationship>(existingRel);
          },
        );
      }

      // Import Timeline Entries
      for (final entry in timelineList) {
        final existingResult = await _timelineRepository.getById(entry.id);
        await existingResult.fold(
          (failure) => _timelineRepository.create(entry),
          (existingEntry) async {
            if (entry.updatedAt.isAfter(existingEntry.updatedAt)) {
              return _timelineRepository.update(entry);
            }
            return Right<Failure, TimelineEntry>(existingEntry);
          },
        );
      }

      // Import Templates
      for (final template in templatesList) {
        final existingResult = await _templateRepository.getTemplateById(template.id);
        await existingResult.fold(
          (failure) => _templateRepository.create(template),
          (existingTemplate) async {
            if (template.updatedAt.isAfter(existingTemplate.updatedAt)) {
              return _templateRepository.update(template);
            }
            return Right<Failure, Template>(existingTemplate);
          },
        );
      }

      // Import Maps
      for (final map in mapsList) {
        final existingResult = await _mapRepository.getMapById(map.id);
        await existingResult.fold(
          (failure) => _mapRepository.createMap(map),
          (existingMap) => Right<Failure, WorldMap>(existingMap),
        );
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(
        message: 'Failed to parse or import database JSON file',
        originalError: e,
      ));
    }
  }
}
