import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../project/project.dart';
import '../../repository/project_repository.dart';

@lazySingleton
class GetProjectsUseCase {
  final ProjectRepository _repository;

  GetProjectsUseCase(this._repository);

  Future<Either<Failure, List<Project>>> call() async {
    return _repository.getProjects();
  }
}
