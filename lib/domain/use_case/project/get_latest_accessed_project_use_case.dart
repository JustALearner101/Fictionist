import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../project/project.dart';
import '../../repository/project_repository.dart';

@lazySingleton
class GetLatestAccessedProjectUseCase {
  final ProjectRepository _repository;

  GetLatestAccessedProjectUseCase(this._repository);

  Future<Either<Failure, Project?>> call() async {
    return _repository.getLatestAccessedProject();
  }
}
