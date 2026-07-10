import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failure.dart';
import '../../domain/repository/timeline_repository.dart';
import '../../domain/timeline/timeline_entry.dart';
import '../dao/timeline_dao.dart';
import '../mapper/timeline_entry_mapper.dart';

@LazySingleton(as: TimelineRepository)
class TimelineRepositoryImpl implements TimelineRepository {
  final TimelineDao _dao;

  TimelineRepositoryImpl(this._dao);

  @override
  Future<Either<Failure, TimelineEntry>> create(TimelineEntry entry) async {
    try {
      final companion = TimelineEntryMapper.toCompanion(entry);
      await _dao.insertEntry(companion);
      return Right(entry);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to create timeline entry in database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, TimelineEntry>> update(TimelineEntry entry) async {
    try {
      final companion = TimelineEntryMapper.toCompanion(entry);
      final success = await _dao.updateEntry(companion);
      if (!success) {
        return Left(Failure.notFound(
            resourceType: 'TimelineEntry', resourceId: entry.id));
      }
      return Right(entry);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to update timeline entry in database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      final count = await _dao.deleteEntry(id);
      if (count == 0) {
        return Left(Failure.notFound(resourceType: 'TimelineEntry', resourceId: id));
      }
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to soft delete timeline entry in database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, TimelineEntry>> getById(String id) async {
    try {
      final row = await _dao.getById(id);
      if (row == null) {
        return Left(Failure.notFound(resourceType: 'TimelineEntry', resourceId: id));
      }
      return Right(TimelineEntryMapper.toDomain(row));
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve timeline entry from database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<TimelineEntry>>> getAllActiveOrdered() async {
    try {
      final rows = await _dao.getAllActiveOrdered();
      return Right(rows.map(TimelineEntryMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve ordered timeline entries',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<TimelineEntry>>> getActiveForEntity(
      String entityId) async {
    try {
      final rows = await _dao.getActiveForEntity(entityId);
      return Right(rows.map(TimelineEntryMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve timeline entries for entity',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, int>> getMaxSortOrder() async {
    try {
      final val = await _dao.getMaxSortOrder();
      return Right(val);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve maximum sort order index',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateSortOrder(String id, int sortOrder) async {
    try {
      final count = await _dao.updateSortOrder(id, sortOrder);
      if (count == 0) {
        return Left(Failure.notFound(resourceType: 'TimelineEntry', resourceId: id));
      }
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to update sort order index in database',
        originalError: e,
      ));
    }
  }
}
