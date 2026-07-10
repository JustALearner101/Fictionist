import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/timeline/timeline_entry.dart';
import '../../../../domain/use_case/timeline/create_timeline_entry_use_case.dart';
import '../../../../domain/use_case/timeline/get_timeline_use_case.dart';
import '../../../../domain/use_case/timeline/reorder_timeline_use_case.dart';
import '../../../../domain/repository/timeline_repository.dart';
import '../../../../injection.dart';

part 'timeline_provider.g.dart';

@riverpod
class TimelineList extends _$TimelineList {
  @override
  FutureOr<List<TimelineEntry>> build({String? entityId}) async {
    final getUseCase = getIt<GetTimelineUseCase>();
    final result = await getUseCase(entityId);
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
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final createUseCase = getIt<CreateTimelineEntryUseCase>();
      final result = await createUseCase(CreateTimelineEntryParams(
        title: title,
        description: description,
        dateLabel: dateLabel,
        eraLabel: eraLabel,
        entityId: entityId,
      ));
      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) async {
          final getUseCase = getIt<GetTimelineUseCase>();
          final listResult = await getUseCase(entityId);
          return listResult.fold(
            (f) => throw Exception(f.message),
            (list) => list,
          );
        },
      );
    });
  }

  Future<void> deleteEntry(String id) async {
    final repository = getIt<TimelineRepository>();
    final result = await repository.delete(id);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }

  Future<void> reorderEntries(String entryId, int targetIndex) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final reorderUseCase = getIt<ReorderTimelineUseCase>();
      final result = await reorderUseCase(ReorderTimelineParams(
        entryId: entryId,
        targetIndex: targetIndex,
      ));
      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) async {
          final getUseCase = getIt<GetTimelineUseCase>();
          final listResult = await getUseCase(entityId);
          return listResult.fold(
            (f) => throw Exception(f.message),
            (list) => list,
          );
        },
      );
    });
  }
}
