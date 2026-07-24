import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../domain/timeline/timeline_entry.dart';
import '../../../../data/repository/timeline_repository_impl.dart';
import '../../../../domain/use_case/timeline/create_timeline_entry_use_case.dart';
import '../../../../domain/use_case/timeline/reorder_timeline_use_case.dart';
import '../../../../injection.dart';
import '../../project/provider/active_project_provider.dart';

part 'timeline_provider.g.dart';

@riverpod
class TimelineList extends _$TimelineList {
  @override
  FutureOr<List<TimelineEntry>> build({String? entityId}) async {
    final projectId = ref.watch(activeProjectProvider).valueOrNull?.id;
    final repo = getIt<TimelineRepositoryImpl>();
    final Either<Failure, List<TimelineEntry>> result;
    if (entityId != null && entityId.isNotEmpty) {
      result = await repo.getActiveForEntity(entityId!, projectId: projectId);
    } else {
      result = await repo.getAllActiveOrdered(projectId: projectId);
    }
    return result.fold(
      (failure) => throw Exception(failure.message),
      (list) => list,
    );
  }

  Future<void> createEntry({
    required String title,
    String? description,
    String? dateLabel,
    String? eraLabel,
    String? entityId,
  }) async {
    final projectId = ref.read(activeProjectProvider).valueOrNull?.id;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final createUseCase = getIt<CreateTimelineEntryUseCase>();
      final result = await createUseCase(CreateTimelineEntryParams(
        title: title,
        description: description,
        dateLabel: dateLabel,
        eraLabel: eraLabel,
        entityId: entityId,
        projectId: projectId,
      ));
      final eid = entityId;
      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) async {
          final repo = getIt<TimelineRepositoryImpl>();
          final Either<Failure, List<TimelineEntry>> listResult;
          if (eid != null && eid.isNotEmpty) {
            listResult = await repo.getActiveForEntity(eid, projectId: projectId);
          } else {
            listResult = await repo.getAllActiveOrdered(projectId: projectId);
          }
          return listResult.fold(
            (f) => throw Exception(f.message),
            (list) => list,
          );
        },
      );
    });
  }

  Future<void> deleteEntry(String id) async {
    final repository = getIt<TimelineRepositoryImpl>();
    final result = await repository.delete(id);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }

  Future<void> reorderEntries(String entryId, int targetIndex) async {
    final projectId = ref.read(activeProjectProvider).valueOrNull?.id;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final reorderUseCase = getIt<ReorderTimelineUseCase>();
      final result = await reorderUseCase(ReorderTimelineParams(
        entryId: entryId,
        targetIndex: targetIndex,
      ));
      final eid = entityId;
      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) async {
          final repo = getIt<TimelineRepositoryImpl>();
          final Either<Failure, List<TimelineEntry>> listResult;
          if (eid != null && eid.isNotEmpty) {
            listResult = await repo.getActiveForEntity(eid, projectId: projectId);
          } else {
            listResult = await repo.getAllActiveOrdered(projectId: projectId);
          }
          return listResult.fold(
            (f) => throw Exception(f.message),
            (list) => list,
          );
        },
      );
    });
  }
}
