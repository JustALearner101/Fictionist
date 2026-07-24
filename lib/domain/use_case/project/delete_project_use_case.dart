import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../repository/project_repository.dart';

@lazySingleton
class DeleteProjectUseCase {
  final ProjectRepository _repository;

  DeleteProjectUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String id) async {
    final trimmedId = id.trim();
    if (trimmedId.isEmpty) {
      return const Left(Failure.validation(
        message: 'Project ID cannot be empty',
        field: 'id',
      ));
    }
    return _repository.deleteProject(trimmedId);
  }
}
