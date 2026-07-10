import 'package:fpdart/fpdart.dart';
import '../../core/error/failure.dart';
import '../timeline/timeline_entry.dart';

abstract class TimelineRepository {
  Future<Either<Failure, TimelineEntry>> create(TimelineEntry entry);
  Future<Either<Failure, TimelineEntry>> update(TimelineEntry entry);
  Future<Either<Failure, Unit>> delete(String id);
  Future<Either<Failure, TimelineEntry>> getById(String id);
  Future<Either<Failure, List<TimelineEntry>>> getAllActiveOrdered();
  Future<Either<Failure, List<TimelineEntry>>> getActiveForEntity(String entityId);
  Future<Either<Failure, int>> getMaxSortOrder();
  Future<Either<Failure, Unit>> updateSortOrder(String id, int sortOrder);
}
