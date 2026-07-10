import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../repository/timeline_repository.dart';

class ReorderTimelineParams {
  final String entryId;
  final int targetIndex;

  const ReorderTimelineParams({
    required this.entryId,
    required this.targetIndex,
  });
}

@lazySingleton
class ReorderTimelineUseCase implements UseCase<Unit, ReorderTimelineParams> {
  final TimelineRepository _repository;

  ReorderTimelineUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(ReorderTimelineParams params) async {
    final listResult = await _repository.getAllActiveOrdered();
    return listResult.fold(
      (failure) => Left(failure),
      (list) async {
        if (list.isEmpty) return const Right(unit);

        // Find the entry to move
        final movedIndex = list.indexWhere((e) => e.id == params.entryId);
        if (movedIndex == -1) {
          return Left(Failure.notFound(
            resourceType: 'TimelineEntry',
            resourceId: params.entryId,
          ));
        }

        final movedEntry = list.removeAt(movedIndex);
        
        // Correct target index if out of range
        int target = params.targetIndex;
        if (target < 0) target = 0;
        if (target > list.length) target = list.length;

        list.insert(target, movedEntry);

        int newSortOrder;
        bool triggerReindex = false;

        if (list.length == 1) {
          newSortOrder = 1000;
        } else if (target == 0) {
          newSortOrder = list[1].sortOrder - 1000;
        } else if (target == list.length - 1) {
          newSortOrder = list[list.length - 2].sortOrder + 1000;
        } else {
          final prevOrder = list[target - 1].sortOrder;
          final nextOrder = list[target + 1].sortOrder;
          newSortOrder = (prevOrder + nextOrder) ~/ 2;

          if (newSortOrder - prevOrder <= 1 || nextOrder - newSortOrder <= 1) {
            triggerReindex = true;
          }
        }

        if (triggerReindex) {
          // Reindex all entries starting from 1000 in increments of 1000
          for (int i = 0; i < list.length; i++) {
            final order = (i + 1) * 1000;
            final updateRes = await _repository.updateSortOrder(list[i].id, order);
            if (updateRes.isLeft()) {
              return Left(Failure.database(
                message: 'Failed to reindex timeline sort orders',
              ));
            }
          }
        } else {
          // Just update the moved entry
          final updateRes = await _repository.updateSortOrder(params.entryId, newSortOrder);
          if (updateRes.isLeft()) {
            return Left(Failure.database(
              message: 'Failed to update timeline sort order',
            ));
          }
        }

        return const Right(unit);
      },
    );
  }
}
