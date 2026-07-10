import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../repository/timeline_repository.dart';
import '../../timeline/timeline_entry.dart';

@lazySingleton
class GetTimelineUseCase implements UseCase<List<TimelineEntry>, String?> {
  final TimelineRepository _repository;

  GetTimelineUseCase(this._repository);

  @override
  Future<Either<Failure, List<TimelineEntry>>> call(String? entityId) {
    if (entityId != null && entityId.isNotEmpty) {
      return _repository.getActiveForEntity(entityId);
    }
    return _repository.getAllActiveOrdered();
  }
}
