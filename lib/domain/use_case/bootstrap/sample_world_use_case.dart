import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../../core/utils/sample_world_data.dart';
import '../../entity/entity.dart';
import '../../relationship/relationship.dart';
import '../../repository/entity_repository.dart';
import '../../repository/entity_version_repository.dart';
import '../../repository/relationship_repository.dart';
import '../../repository/timeline_repository.dart';
import '../../timeline/timeline_entry.dart';
import '../../version/entity_version.dart';

@lazySingleton
class SampleWorldUseCase implements UseCaseNoParams<Unit> {
  final EntityRepository _entityRepo;
  final EntityVersionRepository _versionRepo;
  final RelationshipRepository _relationshipRepo;
  final TimelineRepository _timelineRepo;

  SampleWorldUseCase(
    this._entityRepo,
    this._versionRepo,
    this._relationshipRepo,
    this._timelineRepo,
  );

  @override
  Future<Either<Failure, Unit>> call() async {
    try {
      // 1. Generate data
      final data = SampleWorldData.generate();
      final entities = data['entities'] as List<Entity>;
      final relationships = data['relationships'] as List<Relationship>;
      final timelineEntries = data['timelineEntries'] as List<TimelineEntry>;

      // 2. Insert Entities and their initial versions
      for (final entity in entities) {
        final entResult = await _entityRepo.create(entity);
        if (entResult.isLeft()) {
          return Left(entResult.fold((l) => l, (r) => throw Exception()));
        }

        // Add version
        final version = EntityVersion(
          id: SampleWorldData.uuid.v4(),
          entityId: entity.id,
          snapshotJson: jsonEncode(entity.toJson()),
          changedAt: DateTime.now(),
          changeNote: 'Initial bootstrap snapshot',
        );

        final verResult = await _versionRepo.create(version);
        if (verResult.isLeft()) {
          return Left(verResult.fold((l) => l, (r) => throw Exception()));
        }
      }

      // 3. Insert Relationships
      for (final rel in relationships) {
        final relResult = await _relationshipRepo.create(rel);
        if (relResult.isLeft()) {
          return Left(relResult.fold((l) => l, (r) => throw Exception()));
        }
      }

      // 4. Insert Timeline Entries
      for (final entry in timelineEntries) {
        final timeResult = await _timelineRepo.create(entry);
        if (timeResult.isLeft()) {
          return Left(timeResult.fold((l) => l, (r) => throw Exception()));
        }
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(
        message: 'Failed to complete sample world bootstrap: $e',
        originalError: e,
      ));
    }
  }
}
