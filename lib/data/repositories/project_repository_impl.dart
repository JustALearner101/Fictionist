import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failure.dart';
import '../../domain/project/project.dart';
import '../../domain/repository/project_repository.dart';
import '../dao/project_dao.dart';
import '../database/app_database.dart';

@LazySingleton(as: ProjectRepository)
class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectDao _dao;

  ProjectRepositoryImpl(this._dao);

  Project _rowToDomain(ProjectRow row) {
    return Project(
      id: row.id,
      name: row.name,
      description: row.description,
      coverImagePath: row.coverImagePath,
      lastAccessedAt: row.lastAccessedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isDeleted: row.isDeleted,
    );
  }

  ProjectsCompanion _domainToCompanion(Project project) {
    return ProjectsCompanion(
      id: Value(project.id),
      name: Value(project.name),
      description: Value(project.description),
      coverImagePath: Value(project.coverImagePath),
      lastAccessedAt: Value(project.lastAccessedAt),
      createdAt: Value(project.createdAt),
      updatedAt: Value(project.updatedAt),
      isDeleted: Value(project.isDeleted),
    );
  }

  @override
  Future<Either<Failure, List<Project>>> getProjects() async {
    try {
      final rows = await _dao.getAllProjects();
      return Right(rows.map(_rowToDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve projects: $e',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Project>> getProjectById(String id) async {
    try {
      final row = await _dao.getProjectById(id);
      if (row == null) {
        return Left(Failure.notFound(
          resourceType: 'Project',
          resourceId: id,
        ));
      }
      return Right(_rowToDomain(row));
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve project: $e',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Project?>> getLatestAccessedProject() async {
    try {
      final row = await _dao.getMostRecentlyAccessed();
      if (row == null) {
        return const Right(null);
      }
      return Right(_rowToDomain(row));
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve latest accessed project: $e',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Project>> createProject(Project project) async {
    try {
      final companion = _domainToCompanion(project);
      await _dao.insertProject(companion);
      return Right(project);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to create project: $e',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Project>> updateProject(Project project) async {
    try {
      final companion = _domainToCompanion(project);
      final success = await _dao.updateProject(companion);
      if (!success) {
        return Left(Failure.notFound(
          resourceType: 'Project',
          resourceId: project.id,
        ));
      }
      return Right(project);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to update project: $e',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProject(String id) async {
    try {
      final count = await _dao.deleteProject(id);
      if (count == 0) {
        return Left(Failure.notFound(
          resourceType: 'Project',
          resourceId: id,
        ));
      }
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to delete project: $e',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Project>> touchProjectLastAccessed(String id) async {
    try {
      final now = DateTime.now();
      final count = await _dao.touchLastAccessed(id, now);
      if (count == 0) {
        return Left(Failure.notFound(
          resourceType: 'Project',
          resourceId: id,
        ));
      }
      final updatedRow = await _dao.getProjectById(id);
      if (updatedRow == null) {
        return Left(Failure.notFound(
          resourceType: 'Project',
          resourceId: id,
        ));
      }
      return Right(_rowToDomain(updatedRow));
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to update last accessed timestamp for project: $e',
        originalError: e,
      ));
    }
  }
}
