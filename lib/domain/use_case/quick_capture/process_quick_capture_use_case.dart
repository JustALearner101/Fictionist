import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../entity/entity_type.dart';
import '../../repository/entity_repository.dart';
import '../../repository/quick_capture_repository.dart';
import '../entity/create_entity_use_case.dart';
import '../entity/update_entity_use_case.dart';

enum QuickCaptureAction {
  createEntity,
  linkToEntity,
  dismiss,
}

class ProcessQuickCaptureParams {
  final String captureId;
  final QuickCaptureAction action;
  final String? entityName;
  final EntityType? entityType;
  final int? entityIconColor;
  final String? targetEntityId;

  const ProcessQuickCaptureParams({
    required this.captureId,
    required this.action,
    this.entityName,
    this.entityType,
    this.entityIconColor,
    this.targetEntityId,
  });
}

@lazySingleton
class ProcessQuickCaptureUseCase
    implements UseCase<Unit, ProcessQuickCaptureParams> {
  final QuickCaptureRepository _captureRepository;
  final EntityRepository _entityRepository;
  final CreateEntityUseCase _createEntityUseCase;
  final UpdateEntityUseCase _updateEntityUseCase;

  ProcessQuickCaptureUseCase(
    this._captureRepository,
    this._entityRepository,
    this._createEntityUseCase,
    this._updateEntityUseCase,
  );

  @override
  Future<Either<Failure, Unit>> call(ProcessQuickCaptureParams params) async {
    final noteResult = await _captureRepository.getById(params.captureId);
    return noteResult.fold(
      (failure) => Left(failure),
      (note) async {
        if (params.action == QuickCaptureAction.dismiss) {
          final res = await _captureRepository.markProcessed(params.captureId);
          return res.fold((f) => Left(f), (_) => const Right(unit));
        }

        if (params.action == QuickCaptureAction.createEntity) {
          if (params.entityName == null || params.entityType == null) {
            return const Left(Failure.validation(
              message: 'Name and Type are required to create an entity',
            ));
          }

          final createRes = await _createEntityUseCase(CreateEntityParams(
            name: params.entityName!,
            type: params.entityType!,
            description: note.rawText,
            iconColor: params.entityIconColor ?? 0xFF8B5CF6,
          ));

          return createRes.fold(
            (f) => Left(f),
            (_) async {
              final res =
                  await _captureRepository.markProcessed(params.captureId);
              return res.fold((f) => Left(f), (_) => const Right(unit));
            },
          );
        }

        if (params.action == QuickCaptureAction.linkToEntity) {
          if (params.targetEntityId == null) {
            return const Left(Failure.validation(
              message: 'Target entity is required to link capture',
            ));
          }

          final targetRes =
              await _entityRepository.getById(params.targetEntityId!);
          return targetRes.fold(
            (f) => Left(f),
            (entity) async {
              final newDesc = entity.description != null &&
                      entity.description!.trim().isNotEmpty
                  ? '${entity.description}\n\nNotes from capture:\n${note.rawText}'
                  : note.rawText;
              final updatedEntity = entity.copyWith(description: newDesc);

              final updateRes = await _updateEntityUseCase(UpdateEntityParams(
                entity: updatedEntity,
                changeNote: 'Linked quick capture note',
              ));

              return updateRes.fold(
                (f) => Left(f),
                (_) async {
                  final res =
                      await _captureRepository.markProcessed(params.captureId);
                  return res.fold((f) => Left(f), (_) => const Right(unit));
                },
              );
            },
          );
        }

        return const Right(unit);
      },
    );
  }
}
