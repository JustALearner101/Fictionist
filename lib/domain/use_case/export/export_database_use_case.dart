import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../repository/entity_repository.dart';
import '../../entity/entity.dart';
import '../../repository/entity_version_repository.dart';
import '../../repository/map_repository.dart';
import '../../repository/quick_capture_repository.dart';
import '../../repository/relationship_repository.dart';
import '../../repository/tag_repository.dart';
import '../../repository/template_repository.dart';
import '../../repository/timeline_repository.dart';
import '../../version/entity_version.dart';

@lazySingleton
class ExportDatabaseUseCase implements UseCaseNoParams<String> {
  final EntityRepository _entityRepository;
  final RelationshipRepository _relationshipRepository;
  final TagRepository _tagRepository;
  final TimelineRepository _timelineRepository;
  final TemplateRepository _templateRepository;
  final QuickCaptureRepository _captureRepository;
  final EntityVersionRepository _versionRepository;
  final MapRepository _mapRepository;

  ExportDatabaseUseCase(
    this._entityRepository,
    this._relationshipRepository,
    this._tagRepository,
    this._timelineRepository,
    this._templateRepository,
    this._captureRepository,
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
      final captures = await _captureRepository.getUnprocessedOrdered();
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
          'quick_captures': captures.getOrElse((_) => []),
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
