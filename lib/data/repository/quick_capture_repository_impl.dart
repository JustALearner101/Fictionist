import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failure.dart';
import '../../domain/quick_capture/quick_capture.dart';
import '../../domain/repository/quick_capture_repository.dart';
import '../dao/quick_capture_dao.dart';
import '../mapper/quick_capture_mapper.dart';

@LazySingleton(as: QuickCaptureRepository)
class QuickCaptureRepositoryImpl implements QuickCaptureRepository {
  final QuickCaptureDao _dao;

  QuickCaptureRepositoryImpl(this._dao);

  @override
  Future<Either<Failure, QuickCapture>> create(QuickCapture capture) async {
    try {
      final companion = QuickCaptureMapper.toCompanion(capture);
      await _dao.insertCapture(companion);
      return Right(capture);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to create quick capture in database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      final count = await _dao.deleteCapture(id);
      if (count == 0) {
        return Left(Failure.notFound(resourceType: 'QuickCapture', resourceId: id));
      }
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to delete quick capture from database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<QuickCapture>>> getUnprocessedOrdered() async {
    try {
      final rows = await _dao.getUnprocessedOrdered();
      return Right(rows.map(QuickCaptureMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve unprocessed quick captures',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> markProcessed(String id) async {
    try {
      final count = await _dao.markProcessed(id);
      if (count == 0) {
        return Left(Failure.notFound(resourceType: 'QuickCapture', resourceId: id));
      }
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to mark quick capture as processed',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, QuickCapture>> getById(String id) async {
    try {
      final row = await _dao.getById(id);
      if (row == null) {
        return Left(Failure.notFound(resourceType: 'QuickCapture', resourceId: id));
      }
      return Right(QuickCaptureMapper.toDomain(row));
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve quick capture from database',
        originalError: e,
      ));
    }
  }
}
