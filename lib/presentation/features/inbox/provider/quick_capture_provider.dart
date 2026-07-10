import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/quick_capture/quick_capture.dart';
import '../../../../domain/repository/quick_capture_repository.dart';
import '../../../../domain/use_case/quick_capture/create_quick_capture_use_case.dart';
import '../../../../domain/use_case/quick_capture/process_quick_capture_use_case.dart';
import '../../../../injection.dart';

part 'quick_capture_provider.g.dart';

@riverpod
class QuickCaptureList extends _$QuickCaptureList {
  @override
  FutureOr<List<QuickCapture>> build() async {
    final repository = getIt<QuickCaptureRepository>();
    final result = await repository.getUnprocessedOrdered();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (list) => list,
    );
  }

  Future<void> createCapture(String text) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final createUseCase = getIt<CreateQuickCaptureUseCase>();
      final result = await createUseCase(text);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) async {
          final repository = getIt<QuickCaptureRepository>();
          final listResult = await repository.getUnprocessedOrdered();
          return listResult.fold(
            (f) => throw Exception(f.message),
            (list) => list,
          );
        },
      );
    });
  }

  Future<void> processCapture(ProcessQuickCaptureParams params) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final processUseCase = getIt<ProcessQuickCaptureUseCase>();
      final result = await processUseCase(params);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) async {
          final repository = getIt<QuickCaptureRepository>();
          final listResult = await repository.getUnprocessedOrdered();
          return listResult.fold(
            (f) => throw Exception(f.message),
            (list) => list,
          );
        },
      );
    });
  }

  Future<void> deleteCapture(String id) async {
    final repository = getIt<QuickCaptureRepository>();
    final result = await repository.delete(id);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }
}
