import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:fictionist/domain/relationship/relationship.dart';
import 'package:fictionist/domain/repository/entity_repository.dart';
import 'package:fictionist/domain/repository/entity_version_repository.dart';
import 'package:fictionist/domain/repository/relationship_repository.dart';
import 'package:fictionist/domain/repository/timeline_repository.dart';
import 'package:fictionist/domain/timeline/timeline_entry.dart';
import 'package:fictionist/domain/use_case/bootstrap/sample_world_use_case.dart';
import 'package:fictionist/domain/version/entity_version.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockEntityRepository extends Mock implements EntityRepository {}

class MockEntityVersionRepository extends Mock
    implements EntityVersionRepository {}

class MockRelationshipRepository extends Mock
    implements RelationshipRepository {}

class MockTimelineRepository extends Mock implements TimelineRepository {}

void main() {
  late SampleWorldUseCase useCase;
  late MockEntityRepository mockEntityRepo;
  late MockEntityVersionRepository mockVersionRepo;
  late MockRelationshipRepository mockRelationshipRepo;
  late MockTimelineRepository mockTimelineRepo;

  setUpAll(() {
    registerFallbackValue(
      Entity(
        id: '',
        name: '',
        type: EntityType.character,
        iconColor: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    registerFallbackValue(
      EntityVersion(
        id: '',
        entityId: '',
        snapshotJson: '',
        changedAt: DateTime.now(),
      ),
    );
    registerFallbackValue(
      Relationship(
        id: '',
        sourceId: '',
        targetId: '',
        typeKey: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    registerFallbackValue(
      TimelineEntry(
        id: '',
        title: '',
        sortOrder: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  });

  setUp(() {
    mockEntityRepo = MockEntityRepository();
    mockVersionRepo = MockEntityVersionRepository();
    mockRelationshipRepo = MockRelationshipRepository();
    mockTimelineRepo = MockTimelineRepository();
    useCase = SampleWorldUseCase(
      mockEntityRepo,
      mockVersionRepo,
      mockRelationshipRepo,
      mockTimelineRepo,
    );
  });

  test(
      'should successfully save sample entities, relationships, timeline entries and snapshots',
      () async {
    when(() => mockEntityRepo.create(any())).thenAnswer((invocation) =>
        Future.value(Right(invocation.positionalArguments[0] as Entity)));
    when(() => mockVersionRepo.create(any())).thenAnswer((invocation) =>
        Future.value(
            Right(invocation.positionalArguments[0] as EntityVersion)));
    when(() => mockRelationshipRepo.create(any())).thenAnswer((invocation) =>
        Future.value(Right(invocation.positionalArguments[0] as Relationship)));
    when(() => mockTimelineRepo.create(any())).thenAnswer((invocation) =>
        Future.value(Right(invocation.positionalArguments[0] as TimelineEntry)));

    final result = await useCase();

    expect(result.isRight(), true);
    result.fold(
      (failure) => fail('Should have succeeded but failed with $failure'),
      (val) => expect(val, unit),
    );

    verify(() => mockEntityRepo.create(any())).called(6);
    verify(() => mockVersionRepo.create(any())).called(6);
    verify(() => mockRelationshipRepo.create(any())).called(4);
    verify(() => mockTimelineRepo.create(any())).called(3);
  });

  test('should halt and return failure if entity insertion fails', () async {
    when(() => mockEntityRepo.create(any())).thenAnswer((_) => Future.value(
        const Left(Failure.database(message: 'Database error creating entity'))));

    final result = await useCase();

    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<DatabaseFailure>());
        expect(failure.message, 'Database error creating entity');
      },
      (_) => fail('Should have failed'),
    );

    verify(() => mockEntityRepo.create(any())).called(1);
    verifyNever(() => mockVersionRepo.create(any()));
    verifyNever(() => mockRelationshipRepo.create(any()));
    verifyNever(() => mockTimelineRepo.create(any()));
  });
}
