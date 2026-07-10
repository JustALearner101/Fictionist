import 'package:fpdart/fpdart.dart';
import '../../core/error/failure.dart';
import '../quick_capture/quick_capture.dart';

abstract class QuickCaptureRepository {
  Future<Either<Failure, QuickCapture>> create(QuickCapture capture);
  Future<Either<Failure, Unit>> delete(String id);
  Future<Either<Failure, List<QuickCapture>>> getUnprocessedOrdered();
  Future<Either<Failure, Unit>> markProcessed(String id);
  Future<Either<Failure, QuickCapture>> getById(String id);
}
