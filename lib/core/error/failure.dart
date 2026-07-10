import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const Failure._();

  const factory Failure.database({
    required String message,
    Object? originalError,
  }) = DatabaseFailure;

  const factory Failure.validation({
    required String message,
    String? field,
  }) = ValidationFailure;

  const factory Failure.notFound({
    required String resourceType,
    required String resourceId,
  }) = NotFoundFailure;

  const factory Failure.fileSystem({
    required String message,
    required String path,
  }) = FileSystemFailure;

  const factory Failure.unexpected({
    required String message,
    Object? originalError,
    StackTrace? stackTrace,
  }) = UnexpectedFailure;

  String get message {
    return map(
      database: (f) => f.message,
      validation: (f) => f.message,
      notFound: (f) =>
          '${f.resourceType} with ID "${f.resourceId}" was not found.',
      fileSystem: (f) => f.message,
      unexpected: (f) => f.message,
    );
  }
}
