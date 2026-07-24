import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../data/repository/entity_repository_impl.dart';
import '../../../../domain/use_case/entity/update_entity_use_case.dart';
import '../../../../injection.dart';
import '../../project/provider/active_project_provider.dart';

part 'entity_detail_provider.g.dart';

@riverpod
class EntityDetail extends _$EntityDetail {
  @override
  FutureOr<Entity> build(String entityId) async {
    final projectId = ref.watch(activeProjectProvider).valueOrNull?.id;
    final repo = getIt<EntityRepositoryImpl>();
    final result = await repo.getById(entityId, projectId: projectId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (entity) => entity,
    );
  }

  Future<void> updateEntity(Entity updatedEntity, {String? changeNote}) async {
    state = const AsyncValue.loading();
    final projectId = ref.read(activeProjectProvider).valueOrNull?.id;
    state = await AsyncValue.guard(() async {
      final updateUseCase = getIt<UpdateEntityUseCase>();
      final result = await updateUseCase(UpdateEntityParams(
        entity: updatedEntity,
        changeNote: changeNote,
      ));
      return result.fold(
        (failure) => throw Exception(failure.message),
        (entity) => entity,
      );
    });
  }
}
