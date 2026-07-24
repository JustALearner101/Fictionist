import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/data/repository/entity_repository_impl.dart';
import 'package:fictionist/data/repository/map_repository_impl.dart';
import 'package:fictionist/data/repository/manuscript_repository_impl.dart';
import 'package:fictionist/domain/repository/relationship_repository.dart';
import 'package:fictionist/data/repository/tag_repository_impl.dart';
import 'package:fictionist/data/repository/template_repository_impl.dart';
import 'package:fictionist/data/repository/timeline_repository_impl.dart';
import 'package:fictionist/domain/services/backup_synchronizer.dart';

@lazySingleton
class SyncRepositoryImpl {
  final EntityRepositoryImpl _entityRepo;
  final RelationshipRepository _relationshipRepo;
  final TagRepositoryImpl _tagRepo;
  final TimelineRepositoryImpl _timelineRepo;
  final TemplateRepositoryImpl _templateRepo;
  final MapRepositoryImpl _mapRepo;
  final ManuscriptRepositoryImpl _manuscriptRepo;
  final BackupSynchronizer _synchronizer;

  SyncRepositoryImpl(
    this._entityRepo,
    this._relationshipRepo,
    this._tagRepo,
    this._timelineRepo,
    this._templateRepo,
    this._mapRepo,
    this._manuscriptRepo,
    this._synchronizer,
  );

  Future<Either<Failure, Map<String, List<Map<String, dynamic>>>>> exportAll() async {
    try {
      final result = <String, List<Map<String, dynamic>>>{};

      // Entities
      final entities = await _entityRepo.getAllActive();
      entities.fold(
        (_) {},
        (list) => result['entities'] = list.map((e) => e.toJson()).toList(),
      );

      // Relationships
      final rels = await _relationshipRepo.getAllActive();
      rels.fold(
        (_) {},
        (list) => result['relationships'] = list.map((r) => r.toJson()).toList(),
      );

      // Tags
      final tags = await _tagRepo.getAllTags();
      tags.fold(
        (_) {},
        (list) => result['tags'] = list.map((t) => t.toJson()).toList(),
      );

      // Timeline entries
      final timeline = await _timelineRepo.getAllActiveOrdered();
      timeline.fold(
        (_) {},
        (list) => result['timeline_entries'] = list.map((e) => e.toJson()).toList(),
      );

      // Templates
      final templates = await _templateRepo.getAllTemplates();
      templates.fold(
        (_) {},
        (list) => result['templates'] = list.map((t) => t.toJson()).toList(),
      );

      // Maps
      final maps = await _mapRepo.getAllMaps();
      maps.fold(
        (_) {},
        (list) => result['world_maps'] = list.map((m) => m.toJson()).toList(),
      );

      // Manuscript chapters
      final chapters = await _manuscriptRepo.getAllActive();
      chapters.fold(
        (_) {},
        (list) => result['manuscript_chapters'] = list.map((c) => c.toJson()).toList(),
      );

      return Right(result);
    } on Exception catch (e) {
      return Left(
        Failure.unexpected(message: 'Export all failed: $e', originalError: e),
      );
    }
  }

  Future<Either<Failure, Map<String, int>>> importAll(
    Map<String, List<Map<String, dynamic>>> records,
  ) async {
    try {
      var totalInserted = 0;
      var totalUpdated = 0;
      var totalSkipped = 0;

      // Import Tags first (dependency)
      if (records.containsKey('tags')) {
        final allTags = await _tagRepo.getAllTags();
        final local = allTags.fold(
          (_) => <Map<String, dynamic>>[],
          (list) => list.map((t) => t.toJson()).toList(),
        );
        final result = await _synchronizer.mergeWithReport(
          local: local,
          incoming: records['tags']!,
        );
        result.fold(
          (_) {},
          (merged) {
            totalInserted += merged.inserted;
            totalUpdated += merged.updated;
            totalSkipped += merged.skipped;
          },
        );
      }

      // Import Entities
      if (records.containsKey('entities')) {
        final allEntities = await _entityRepo.getAllActive();
        final local = allEntities.fold(
          (_) => <Map<String, dynamic>>[],
          (list) => list.map((e) => e.toJson()).toList(),
        );
        final result = await _synchronizer.mergeWithReport(
          local: local,
          incoming: records['entities']!,
        );
        result.fold(
          (_) {},
          (merged) {
            totalInserted += merged.inserted;
            totalUpdated += merged.updated;
            totalSkipped += merged.skipped;
          },
        );
      }

      // Import Relationships
      if (records.containsKey('relationships')) {
        final allRels = await _relationshipRepo.getAllActive();
        final local = allRels.fold(
          (_) => <Map<String, dynamic>>[],
          (list) => list.map((r) => r.toJson()).toList(),
        );
        final result = await _synchronizer.mergeWithReport(
          local: local,
          incoming: records['relationships']!,
        );
        result.fold(
          (_) {},
          (merged) {
            totalInserted += merged.inserted;
            totalUpdated += merged.updated;
            totalSkipped += merged.skipped;
          },
        );
      }

      // Import Timeline Entries
      if (records.containsKey('timeline_entries')) {
        final allTimeline = await _timelineRepo.getAllActiveOrdered();
        final local = allTimeline.fold(
          (_) => <Map<String, dynamic>>[],
          (list) => list.map((e) => e.toJson()).toList(),
        );
        final result = await _synchronizer.mergeWithReport(
          local: local,
          incoming: records['timeline_entries']!,
        );
        result.fold(
          (_) {},
          (merged) {
            totalInserted += merged.inserted;
            totalUpdated += merged.updated;
            totalSkipped += merged.skipped;
          },
        );
      }

      // Import Templates
      if (records.containsKey('templates')) {
        final allTemplates = await _templateRepo.getAllTemplates();
        final local = allTemplates.fold(
          (_) => <Map<String, dynamic>>[],
          (list) => list.map((t) => t.toJson()).toList(),
        );
        final result = await _synchronizer.mergeWithReport(
          local: local,
          incoming: records['templates']!,
        );
        result.fold(
          (_) {},
          (merged) {
            totalInserted += merged.inserted;
            totalUpdated += merged.updated;
            totalSkipped += merged.skipped;
          },
        );
      }

      // Import Maps
      if (records.containsKey('world_maps')) {
        final allMaps = await _mapRepo.getAllMaps();
        final local = allMaps.fold(
          (_) => <Map<String, dynamic>>[],
          (list) => list.map((m) => m.toJson()).toList(),
        );
        final result = await _synchronizer.mergeWithReport(
          local: local,
          incoming: records['world_maps']!,
        );
        result.fold(
          (_) {},
          (merged) {
            totalInserted += merged.inserted;
            totalUpdated += merged.updated;
            totalSkipped += merged.skipped;
          },
        );
      }

      // Import Manuscript Chapters
      if (records.containsKey('manuscript_chapters')) {
        final allChapters = await _manuscriptRepo.getAllActive();
        final local = allChapters.fold(
          (_) => <Map<String, dynamic>>[],
          (list) => list.map((c) => c.toJson()).toList(),
        );
        final result = await _synchronizer.mergeWithReport(
          local: local,
          incoming: records['manuscript_chapters']!,
        );
        result.fold(
          (_) {},
          (merged) {
            totalInserted += merged.inserted;
            totalUpdated += merged.updated;
            totalSkipped += merged.skipped;
          },
        );
      }

      return Right({
        'inserted': totalInserted,
        'updated': totalUpdated,
        'skipped': totalSkipped,
      });
    } on Exception catch (e) {
      return Left(
        Failure.unexpected(message: 'Import all failed: $e', originalError: e),
      );
    }
  }
}
