import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../quick_capture/quick_capture.dart';
import '../../repository/quick_capture_repository.dart';

@lazySingleton
class CreateQuickCaptureUseCase implements UseCase<QuickCapture, String> {
  final QuickCaptureRepository _repository;

  CreateQuickCaptureUseCase(this._repository);

  @override
  Future<Either<Failure, QuickCapture>> call(String text) {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) {
      final failure = Failure.validation(
        message: 'Quick capture text cannot be empty',
        field: 'rawText',
      );
      return Future.value(Left(failure));
    }

    final capture = QuickCapture(
      id: const Uuid().v4(),
      rawText: trimmedText,
      createdAt: DateTime.now(),
    );

    return _repository.create(capture);
  }
}
