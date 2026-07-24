import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../data/repository/entity_repository_impl.dart';
import '../../../../domain/use_case/entity/delete_entity_use_case.dart';
import '../../../../domain/use_case/entity/list_entities_use_case.dart';
import '../../../../injection.dart';
import '../../project/provider/active_project_provider.dart';

part 'entity_list_provider.g.dart';

@riverpod
class EntityList extends _$EntityList {
  @override
  FutureOr<List<Entity>> build() async {
    final projectId = ref.watch(activeProjectProvider).valueOrNull?.id;
    final listUseCase = getIt<ListEntitiesUseCase>();
    final result = await listUseCase(ListEntitiesParams(projectId: projectId));
    return result.fold(
      (failure) => throw Exception(failure.message),
      (entities) => entities,
    );
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    final projectId = ref.read(activeProjectProvider).valueOrNull?.id;
    state = await AsyncValue.guard(() async {
      if (query.trim().isEmpty) {
        final listUseCase = getIt<ListEntitiesUseCase>();
        final result = await listUseCase(ListEntitiesParams(projectId: projectId));
        return result.fold(
          (failure) => throw Exception(failure.message),
          (entities) => entities,
        );
      }
      final repo = getIt<EntityRepositoryImpl>();
      final result = await repo.search(query, projectId: projectId);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (entities) => entities,
      );
    });
  }

  Future<void> delete(String id) async {
    final deleteUseCase = getIt<DeleteEntityUseCase>();
    final result = await deleteUseCase(id);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }
}
