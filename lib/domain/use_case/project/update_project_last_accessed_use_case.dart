import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../project/project.dart';
import '../../repository/project_repository.dart';

@lazySingleton
class UpdateProjectLastAccessedUseCase {
  final ProjectRepository _repository;

  UpdateProjectLastAccessedUseCase(this._repository);

  Future<Either<Failure, Project>> call(String id) async {
    final trimmedId = id.trim();
    if (trimmedId.isEmpty) {
      return const Left(Failure.validation(
        message: 'Project ID cannot be empty',
        field: 'id',
      ));
    }
    return _repository.touchProjectLastAccessed(trimmedId);
  }
}
