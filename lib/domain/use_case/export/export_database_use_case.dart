import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../data/repository/entity_repository_impl.dart';
import '../../entity/entity.dart';
import '../../../data/repository/entity_version_repository_impl.dart';
import '../../../data/repository/map_repository_impl.dart';
import '../../../data/repository/relationship_repository_impl.dart';
import '../../../data/repository/tag_repository_impl.dart';
import '../../../data/repository/template_repository_impl.dart';
import '../../../data/repository/timeline_repository_impl.dart';
import '../../version/entity_version.dart';

@lazySingleton
class ExportDatabaseUseCase {
  final EntityRepositoryImpl _entityRepository;
  final RelationshipRepositoryImpl _relationshipRepository;
  final TagRepositoryImpl _tagRepository;
  final TimelineRepositoryImpl _timelineRepository;
  final TemplateRepositoryImpl _templateRepository;
  final EntityVersionRepositoryImpl _versionRepository;
  final MapRepositoryImpl _mapRepository;

  ExportDatabaseUseCase(
    this._entityRepository,
    this._relationshipRepository,
    this._tagRepository,
    this._timelineRepository,
    this._templateRepository,
    this._versionRepository,
    this._mapRepository,
  );

  @override
  Future<Either<Failure, String>> call() async {
    try {
      final entities = await _entityRepository.getAllActive();
      final relationships = await _relationshipRepository.getAllActive();
      final tags = await _tagRepository.getAllTags();
      final timeline = await _timelineRepository.getAllActiveOrdered();
      final templates = await _templateRepository.getAllTemplates();
      final maps = await _mapRepository.getAllMaps();

      // Collect entity version histories
      final entitiesList = entities.getOrElse((_) => <Entity>[]);
      final versions = <EntityVersion>[];
      for (final entity in entitiesList) {
        final entityVersions =
            await _versionRepository.getVersionsForEntity(entity.id);
        entityVersions.fold(
          (_) {}, // skip if versions can't be loaded
          (list) => versions.addAll(list),
        );
      }

      final dataMap = {
        'fictionist_version': '1.0.0',
        'export_format_version': 1,
        'exported_at': DateTime.now().toIso8601String(),
        'data': {
          'entities': entitiesList,
          'relationships': relationships.getOrElse((_) => []),
          'tags': tags.getOrElse((_) => []),
          'timeline_entries': timeline.getOrElse((_) => []),
          'templates': templates.getOrElse((_) => []),
          'world_maps': maps.getOrElse((_) => []),
          'entity_versions': versions,
        }
      };

      const encoder = JsonEncoder.withIndent('  ');
      return Right(encoder.convert(dataMap));
    } catch (e) {
      return Left(Failure.unexpected(
        message: 'Failed to serialize export database JSON',
        originalError: e,
      ));
    }
  }
}
