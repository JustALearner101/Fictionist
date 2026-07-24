import 'package:drift/drift.dart';
import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/data/dao/project_dao.dart';
import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/data/repositories/project_repository_impl.dart';
import 'package:fictionist/domain/project/project.dart';
import 'package:fictionist/domain/repository/project_repository.dart';
import 'package:fictionist/domain/use_case/project/create_project_use_case.dart';
import 'package:fictionist/domain/use_case/project/delete_project_use_case.dart';
import 'package:fictionist/domain/use_case/project/get_latest_accessed_project_use_case.dart';
import 'package:fictionist/domain/use_case/project/get_projects_use_case.dart';
import 'package:fictionist/domain/use_case/project/update_project_last_accessed_use_case.dart';
import 'package:fictionist/presentation/features/project/provider/active_project_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockProjectDao extends Mock implements ProjectDao {}

class MockProjectRepository extends Mock implements ProjectRepository {}

void main() {
  registerFallbackValue(ProjectsCompanion(id: Value('f'), name: Value('f'), lastAccessedAt: Value(DateTime(2020)), createdAt: Value(DateTime(2020)), updatedAt: Value(DateTime(2020))));

  final now = DateTime(2026, 7, 23, 12, 0);

  final testProject = Project(
    id: 'proj-123',
    name: 'Middle Earth',
    description: 'Fantasy worldbuilding workspace',
    coverImagePath: '/covers/me.png',
    lastAccessedAt: now,
    createdAt: now,
    updatedAt: now,
    isDeleted: false,
  );

  group('Project Domain Model', () {
    test('should construct Project with correct fields and default isDeleted', () {
      expect(testProject.id, 'proj-123');
      expect(testProject.name, 'Middle Earth');
      expect(testProject.description, 'Fantasy worldbuilding workspace');
      expect(testProject.coverImagePath, '/covers/me.png');
      expect(testProject.lastAccessedAt, now);
      expect(testProject.createdAt, now);
      expect(testProject.updatedAt, now);
      expect(testProject.isDeleted, false);
    });

    test('should serialize to and deserialize from JSON correctly', () {
      final json = testProject.toJson();
      final deserialized = Project.fromJson(json);

      expect(deserialized.id, testProject.id);
      expect(deserialized.name, testProject.name);
      expect(deserialized.description, testProject.description);
      expect(deserialized.coverImagePath, testProject.coverImagePath);
      expect(deserialized.isDeleted, false);
    });

    test('copyWith should update specified fields', () {
      final updated = testProject.copyWith(name: 'New Middle Earth');
      expect(updated.name, 'New Middle Earth');
      expect(updated.id, testProject.id);
    });
  });

  group('ProjectRepositoryImpl Unit Tests', () {
    late MockProjectDao mockDao;
    late ProjectRepositoryImpl repository;

    setUp(() {
      mockDao = MockProjectDao();
      repository = ProjectRepositoryImpl(mockDao);
    });

    test('getProjects should return list of domain Projects', () async {
      final row = ProjectRow(
        id: testProject.id,
        name: testProject.name,
        description: testProject.description,
        coverImagePath: testProject.coverImagePath,
        lastAccessedAt: now,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );

      when(() => mockDao.getAllProjects()).thenAnswer((_) async => [row]);

      final result = await repository.getProjects();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (projects) {
          expect(projects.length, 1);
          expect(projects.first.id, testProject.id);
          expect(projects.first.name, 'Middle Earth');
        },
      );
    });

    test('getProjectById should return NotFoundFailure when null', () async {
      when(() => mockDao.getProjectById('non-existent')).thenAnswer((_) async => null);

      final result = await repository.getProjectById('non-existent');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Should fail'),
      );
    });

    test('createProject should insert companion and return project', () async {
      when(() => mockDao.insertProject(any())).thenAnswer((_) async => 1);

      final result = await repository.createProject(testProject);

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (project) => expect(project.id, testProject.id),
      );
    });

    test('deleteProject should return Unit when count > 0', () async {
      when(() => mockDao.deleteProject('proj-123')).thenAnswer((_) async => 1);

      final result = await repository.deleteProject('proj-123');

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (u) => expect(u, unit),
      );
    });

    test('touchProjectLastAccessed should return updated project', () async {
      final updatedRow = ProjectRow(
        id: testProject.id,
        name: testProject.name,
        description: testProject.description,
        coverImagePath: testProject.coverImagePath,
        lastAccessedAt: now,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );

      when(() => mockDao.touchLastAccessed(any(), any())).thenAnswer((_) async => 1);
      when(() => mockDao.getProjectById('proj-123')).thenAnswer((_) async => updatedRow);

      final result = await repository.touchProjectLastAccessed('proj-123');

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (project) => expect(project.id, 'proj-123'),
      );
    });
  });

  group('Use Cases Unit Tests', () {
    late MockProjectRepository mockRepo;

    setUp(() {
      mockRepo = MockProjectRepository();
    });

    test('GetProjectsUseCase delegates to repository', () async {
      when(() => mockRepo.getProjects()).thenAnswer((_) async => Right([testProject]));

      final useCase = GetProjectsUseCase(mockRepo);
      final result = await useCase();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (list) => expect(list.first.name, 'Middle Earth'),
      );
    });

    test('GetLatestAccessedProjectUseCase delegates to repository', () async {
      when(() => mockRepo.getLatestAccessedProject()).thenAnswer((_) async => Right(testProject));

      final useCase = GetLatestAccessedProjectUseCase(mockRepo);
      final result = await useCase();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (proj) => expect(proj?.id, 'proj-123'),
      );
    });

    test('CreateProjectUseCase validates empty name', () async {
      final useCase = CreateProjectUseCase(mockRepo);

      final result = await useCase.fromParams(const CreateProjectParams(name: '   '));

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Should fail validation'),
      );
    });

    test('DeleteProjectUseCase validates empty id', () async {
      final useCase = DeleteProjectUseCase(mockRepo);

      final result = await useCase('  ');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Should fail validation'),
      );
    });

    test('UpdateProjectLastAccessedUseCase delegates to repository', () async {
      when(() => mockRepo.touchProjectLastAccessed('proj-123'))
          .thenAnswer((_) async => Right(testProject));

      final useCase = UpdateProjectLastAccessedUseCase(mockRepo);
      final result = await useCase('proj-123');

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (proj) => expect(proj.id, 'proj-123'),
      );
    });
  });
}
