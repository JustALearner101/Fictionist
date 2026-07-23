import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_status.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:fictionist/data/repository/entity_repository_impl.dart';
import 'package:fictionist/data/repository/entity_version_repository_impl.dart';
import 'package:fictionist/domain/use_case/entity/create_entity_use_case.dart';
import 'package:fictionist/domain/version/entity_version.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockEntityRepository extends Mock implements EntityRepositoryImpl {}

class MockEntityVersionRepository extends Mock
    implements EntityVersionRepositoryImpl {}

void main() {
  late CreateEntityUseCase useCase;
  late MockEntityRepository mockEntityRepo;
  late MockEntityVersionRepository mockVersionRepo;

  setUpAll(() {
    registerFallbackValue(
      Entity(
        id: '',
        name: '',
        type: EntityType.character,
        status: EntityStatus.draft,
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
  });

  setUp(() {
    mockEntityRepo = MockEntityRepository();
    mockVersionRepo = MockEntityVersionRepository();
    useCase = CreateEntityUseCase(mockEntityRepo, mockVersionRepo);
  });

  test('should return validation failure when name is empty', () async {
    final result = await useCase(const CreateEntityParams(
      name: '  ',
      type: EntityType.character,
      iconColor: 0,
    ));

    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Entity name cannot be empty');
      },
      (_) => fail('Should have failed'),
    );
  });

  test('should successfully save entity and create initial version snapshot',
      () async {
    when(() => mockEntityRepo.create(any())).thenAnswer((invocation) =>
        Future.value(Right(invocation.positionalArguments[0] as Entity)));
    when(() => mockVersionRepo.create(any())).thenAnswer((invocation) =>
        Future.value(Right(invocation.positionalArguments[0] as EntityVersion)));

    final result = await useCase(const CreateEntityParams(
      name: 'Elrond',
      type: EntityType.character,
      iconColor: 0xFF8B5CF6,
    ));

    expect(result.isRight(), true);
    result.fold(
      (failure) => fail('Should have succeeded'),
      (entity) {
        expect(entity.name, 'Elrond');
        expect(entity.type, EntityType.character);
        expect(entity.iconColor, 0xFF8B5CF6);
      },
    );

    verify(() => mockEntityRepo.create(any())).called(1);
    verify(() => mockVersionRepo.create(any())).called(1);
  });
}
