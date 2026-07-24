import 'package:fpdart/fpdart.dart';
import '../../core/error/failure.dart';
import '../project/project.dart';

/// Abstract contract for managing Project persistence and retrieval.
abstract class ProjectRepository {
  /// Retrieves all active (non-deleted) projects.
  Future<Either<Failure, List<Project>>> getProjects();

  /// Retrieves a specific project by its unique ID.
  Future<Either<Failure, Project>> getProjectById(String id);

  /// Retrieves the most recently accessed project, or null if none exist.
  Future<Either<Failure, Project?>> getLatestAccessedProject();

  /// Persists a newly created project.
  Future<Either<Failure, Project>> createProject(Project project);

  /// Updates existing project attributes or metadata.
  Future<Either<Failure, Project>> updateProject(Project project);

  /// Deletes a project by ID.
  Future<Either<Failure, Unit>> deleteProject(String id);

  /// Updates [lastAccessedAt] to current timestamp for the specified project.
  Future<Either<Failure, Project>> touchProjectLastAccessed(String id);
}
