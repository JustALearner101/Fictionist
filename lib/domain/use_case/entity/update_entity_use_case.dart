import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../entity/entity.dart';
import '../../repository/entity_repository.dart';
import '../../repository/entity_version_repository.dart';
import '../../version/entity_version.dart';

class UpdateEntityParams {
  final Entity entity;
  final String? changeNote;

  const UpdateEntityParams({
    required this.entity,
    this.changeNote,
  });
}

@lazySingleton
class UpdateEntityUseCase implements UseCase<Entity, UpdateEntityParams> {
  final EntityRepository _entityRepository;
  final EntityVersionRepository _versionRepository;

  UpdateEntityUseCase(this._entityRepository, this._versionRepository);

  @override
  Future<Either<Failure, Entity>> call(UpdateEntityParams params) async {
    final trimmedName = params.entity.name.trim();
    if (trimmedName.isEmpty) {
      return const Left(Failure.validation(
        message: 'Entity name cannot be empty',
        field: 'name',
      ));
    }

    final entityToUpdate = params.entity.copyWith(
      name: trimmedName,
      updatedAt: DateTime.now(),
    );

    final updateResult = await _entityRepository.update(entityToUpdate);
    return updateResult.fold(
      (failure) => Left(failure),
      (updatedEntity) async {
        // Create version snapshot
        final snapshot = jsonEncode(updatedEntity.toJson());
        final version = EntityVersion(
          id: const Uuid().v4(),
          entityId: updatedEntity.id,
          snapshotJson: snapshot,
          changedAt: DateTime.now(),
          changeNote: params.changeNote ?? 'Entity updated',
        );
        await _versionRepository.create(version);
        // Prune old versions (keep last 50)
        await _versionRepository.pruneOldVersions(updatedEntity.id, 50);
        return Right(updatedEntity);
      },
    );
  }
}
