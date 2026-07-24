import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../core/error/failure.dart';
import '../../project/project.dart';
import '../../repository/project_repository.dart';

class CreateProjectParams {
  final String name;
  final String? description;
  final String? coverImagePath;

  const CreateProjectParams({
    required this.name,
    this.description,
    this.coverImagePath,
  });
}

@lazySingleton
class CreateProjectUseCase {
  final ProjectRepository _repository;

  CreateProjectUseCase(this._repository);

  Future<Either<Failure, Project>> call(Project project) async {
    final trimmedName = project.name.trim();
    if (trimmedName.isEmpty) {
      return const Left(Failure.validation(
        message: 'Project name cannot be empty',
        field: 'name',
      ));
    }
    final sanitized = project.copyWith(name: trimmedName);
    return _repository.createProject(sanitized);
  }

  Future<Either<Failure, Project>> fromParams(CreateProjectParams params) async {
    final trimmedName = params.name.trim();
    if (trimmedName.isEmpty) {
      return const Left(Failure.validation(
        message: 'Project name cannot be empty',
        field: 'name',
      ));
    }

    final now = DateTime.now();
    final project = Project(
      id: const Uuid().v4(),
      name: trimmedName,
      description: params.description?.trim(),
      coverImagePath: params.coverImagePath,
      lastAccessedAt: now,
      createdAt: now,
      updatedAt: now,
    );

    return _repository.createProject(project);
  }
}
