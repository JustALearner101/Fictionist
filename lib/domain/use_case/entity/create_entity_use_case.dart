import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../entity/custom_field.dart';
import '../../entity/entity.dart';
import '../../entity/entity_status.dart';
import '../../entity/entity_type.dart';
import '../../repository/entity_repository.dart';
import '../../repository/entity_version_repository.dart';
import '../../version/entity_version.dart';

class CreateEntityParams {
  final String name;
  final EntityType type;
  final EntityStatus status;
  final String? description;
  final List<CustomField> customFields;
  final int iconColor;

  const CreateEntityParams({
    required this.name,
    required this.type,
    this.status = EntityStatus.draft,
    this.description,
    this.customFields = const [],
    required this.iconColor,
  });
}

@lazySingleton
class CreateEntityUseCase implements UseCase<Entity, CreateEntityParams> {
  final EntityRepository _entityRepository;
  final EntityVersionRepository _versionRepository;

  CreateEntityUseCase(this._entityRepository, this._versionRepository);

  @override
  Future<Either<Failure, Entity>> call(CreateEntityParams params) async {
    final trimmedName = params.name.trim();
    if (trimmedName.isEmpty) {
      return const Left(Failure.validation(
        message: 'Entity name cannot be empty',
        field: 'name',
      ));
    }

    final entity = Entity(
      id: const Uuid().v4(),
      name: trimmedName,
      type: params.type,
      status: params.status,
      description: params.description,
      customFields: params.customFields,
      iconColor: params.iconColor,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final createResult = await _entityRepository.create(entity);
    return createResult.fold(
      (failure) => Left(failure),
      (savedEntity) async {
        // Create initial version snapshot
        final snapshot = jsonEncode(savedEntity.toJson());
        final version = EntityVersion(
          id: const Uuid().v4(),
          entityId: savedEntity.id,
          snapshotJson: snapshot,
          changedAt: DateTime.now(),
          changeNote: 'Initial creation',
        );
        await _versionRepository.create(version);
        return Right(savedEntity);
      },
    );
  }
}
