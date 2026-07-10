import 'package:fictionist/data/dao/entity_dao.dart';
import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/data/mapper/entity_mapper.dart';
import 'package:fictionist/data/repository/entity_repository_impl.dart';
import 'package:fictionist/domain/entity/custom_field.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_status.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_database.dart';

int _entityCounter = 0;

/// Creates a domain Entity with sensible defaults for integration tests.
Entity makeEntity({
  String? id,
  String name = 'Test Entity',
  EntityType type = EntityType.character,
  EntityStatus status = EntityStatus.draft,
  String? description,
  List<CustomField>? customFields,
  int iconColor = 0xFF8B5CF6,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return Entity(
    id: id ?? 'entity-test-${now.microsecondsSinceEpoch}-${++_entityCounter}',
    name: name,
    type: type,
    status: status,
    description: description,
    customFields: customFields ?? [],
    iconColor: iconColor,
    isDeleted: false,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
  );
}

void main() {
  late AppDatabase db;
  late EntityDao dao;
  late EntityRepositoryImpl repository;

  setUp(() async {
    db = createTestDatabase();
    dao = db.entityDao;
    repository = EntityRepositoryImpl(dao);
  });

  tearDown(() async {
    await db.close();
  });

  group('EntityRepositoryImpl (integration)', () {
    group('create', () {
      test('should persist entity and return it on getById', () async {
        final entity = makeEntity(name: 'Gandalf');
        final createResult = await repository.create(entity);

        expect(createResult.isRight(), isTrue,
            reason: 'create should succeed');

        final getResult = await repository.getById(entity.id);
        expect(getResult.isRight(), isTrue);

        getResult.fold(
          (_) => fail('entity should exist'),
          (retrieved) {
            expect(retrieved.id, entity.id);
            expect(retrieved.name, 'Gandalf');
            expect(retrieved.type, EntityType.character);
            expect(retrieved.status, EntityStatus.draft);
            expect(retrieved.iconColor, 0xFF8B5CF6);
            expect(retrieved.isDeleted, isFalse);
          },
        );
      });

      test('should persist description when provided', () async {
        final entity = makeEntity(
          name: 'Minas Tirith',
          type: EntityType.location,
          description: 'The great city of Gondor',
        );
        await repository.create(entity);

        final result = await repository.getById(entity.id);
        result.fold(
          (_) => fail('entity should exist'),
          (retrieved) =>
              expect(retrieved.description, 'The great city of Gondor'),
        );
      });

      test('should persist entity with null description', () async {
        final entity = makeEntity(name: 'Ringwraith', description: null);
        await repository.create(entity);

        final result = await repository.getById(entity.id);
        result.fold(
          (_) => fail('entity should exist'),
          (retrieved) => expect(retrieved.description, isNull),
        );
      });

      test('should persist two entities independently without interference',
          () async {
        final gandalf = makeEntity(name: 'Gandalf');
        final sauron = makeEntity(name: 'Sauron', type: EntityType.faction);

        final r1 = await repository.create(gandalf);
        final r2 = await repository.create(sauron);

        if (r1.isLeft()) {
          fail('first create failed: ${r1.swap().toOption().toNullable()!.message}');
        }
        if (r2.isLeft()) {
          fail('second create failed: ${r2.swap().toOption().toNullable()!.message}');
        }

        final all = await repository.getAllActive();
        all.fold(
          (_) => fail('getAllActive should succeed'),
          (entities) {
            expect(entities.length, 2);
            expect(entities.map((e) => e.name),
                containsAll(['Gandalf', 'Sauron']));
          },
        );
      });

      test('should persist and round-trip custom fields', () async {
        final entity = makeEntity(
          name: 'Legolas',
          type: EntityType.character,
          customFields: [
            CustomField(
              id: 'cf-1',
              key: 'bow_type',
              label: 'Bow Type',
              fieldType: 'text',
              value: 'Galadhrim Longbow',
            ),
          ],
        );
        await repository.create(entity);

        final result = await repository.getById(entity.id);
        result.fold(
          (_) => fail('entity should exist'),
          (retrieved) {
            expect(retrieved.customFields.length, 1);
            expect(retrieved.customFields.first.key, 'bow_type');
            expect(retrieved.customFields.first.value, 'Galadhrim Longbow');
          },
        );
      });
    });

    group('getById', () {
      test('should return failure for non-existent entity', () async {
        final result = await repository.getById('non-existent-id');
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) =>
              expect(failure.message, contains('not found')),
          (_) => fail('should have failed'),
        );
      });
    });

    group('getAllActive', () {
      test('should return empty list when no entities exist', () async {
        final result = await repository.getAllActive();
        result.fold(
          (_) => fail('should succeed'),
          (entities) => expect(entities, isEmpty),
        );
      });

      test('should exclude soft-deleted entities', () async {
        final entity = makeEntity(name: 'Temporary');
        await repository.create(entity);
        await repository.softDelete(entity.id);

        final result = await repository.getAllActive();
        result.fold(
          (_) => fail('should succeed'),
          (entities) {
            expect(
                entities.where((e) => e.id == entity.id).length, 0,
                reason: 'soft-deleted entity should not appear in active list');
          },
        );
      });
    });

    group('getActiveByType', () {
      test('should return only entities of the specified type', () async {
        await repository
            .create(makeEntity(name: 'Frodo', type: EntityType.character));
        await repository
            .create(makeEntity(name: 'Shire', type: EntityType.location));
        await repository
            .create(makeEntity(name: 'Sam', type: EntityType.character));

        final result = await repository.getActiveByType(EntityType.character);
        result.fold(
          (_) => fail('should succeed'),
          (entities) {
            expect(entities.length, 2);
            expect(entities.every((e) => e.type == EntityType.character),
                isTrue);
          },
        );
      });
    });

    group('getActiveByStatus', () {
      test('should filter by status correctly', () async {
        await repository.create(
            makeEntity(name: 'Draft', status: EntityStatus.draft));
        await repository.create(
            makeEntity(name: 'Canon', status: EntityStatus.canon));

        final drafts =
            await repository.getActiveByStatus(EntityStatus.draft);
        drafts.fold(
          (_) => fail('should succeed'),
          (entities) {
            expect(entities.length, 1);
            expect(entities.first.name, 'Draft');
          },
        );
      });
    });

    group('update', () {
      test('should update entity fields', () async {
        final entity = makeEntity(name: 'Original Name');
        await repository.create(entity);

        final updated = entity.copyWith(name: 'Updated Name');
        await repository.update(updated);

        final result = await repository.getById(entity.id);
        result.fold(
          (_) => fail('should exist'),
          (retrieved) => expect(retrieved.name, 'Updated Name'),
        );
      });
    });

    group('softDelete', () {
      test('should mark entity as deleted so getById fails', () async {
        final entity = makeEntity(name: 'To Be Deleted');
        await repository.create(entity);
        await repository.softDelete(entity.id);

        final getResult = await repository.getById(entity.id);
        expect(getResult.isLeft(), isTrue);
      });
    });

    group('search (FTS5)', () {
      test('should find entity by exact name', () async {
        await repository.create(makeEntity(name: 'Aragorn'));
        await repository.create(makeEntity(name: 'Legolas'));

        final result = await repository.search('Aragorn');
        result.fold(
          (failure) => fail('search failed: ${failure.message}'),
          (entities) {
            expect(entities.length, 1);
            expect(entities.first.name, 'Aragorn');
          },
        );
      });

      test('should find entities by partial name', () async {
        await repository.create(makeEntity(name: 'Kingdom of Aldara'));
        await repository.create(makeEntity(name: 'Aldric the Bold'));
        await repository.create(makeEntity(name: 'Gondor'));

        final result = await repository.search('Ald');
        result.fold(
          (failure) => fail('search failed: ${failure.message}'),
          (entities) {
            expect(entities.length, 2);
            expect(entities.map((e) => e.name),
                containsAll(['Kingdom of Aldara', 'Aldric the Bold']));
          },
        );
      });

      test('should return empty list for non-matching query', () async {
        await repository.create(makeEntity(name: 'Frodo'));

        final result = await repository.search('Saruman');
        result.fold(
          (failure) => fail('search failed: ${failure.message}'),
          (entities) => expect(entities, isEmpty),
        );
      });

      test('should return empty list for empty query', () async {
        await repository.create(makeEntity(name: 'Frodo'));

        final result = await repository.search('');
        result.fold(
          (failure) => fail('search failed: ${failure.message}'),
          (entities) => expect(entities, isEmpty),
        );
      });

      test('should exclude soft-deleted entities from search', () async {
        await repository.create(makeEntity(name: 'Visible'));
        final deleted = makeEntity(name: 'Hidden');
        await repository.create(deleted);
        await repository.softDelete(deleted.id);

        final result = await repository.search('Hidden');
        result.fold(
          (failure) => fail('search failed: ${failure.message}'),
          (entities) => expect(entities, isEmpty),
        );
      });
    });

    group('mapper round-trip', () {
      test('domain -> EntityRow -> domain should be identity', () {
        final entity = makeEntity(
          id: 'test-id-1',
          name: 'Thranduil',
          type: EntityType.character,
          status: EntityStatus.canon,
          description: 'King of the Woodland Realm',
          customFields: [],
          iconColor: 0xFF3B82F6,
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 6, 1),
        );

        final companion = EntityMapper.toCompanion(entity);
        final row = EntityRow(
          id: companion.id.value,
          name: companion.name.value,
          entityType: companion.entityType.value,
          status: companion.status.value,
          description: companion.description.value,
          customFields: companion.customFields.value,
          iconColor: companion.iconColor.value,
          isDeleted: companion.isDeleted.value,
          createdAt: companion.createdAt.value,
          updatedAt: companion.updatedAt.value,
        );

        final roundTrip = EntityMapper.toDomain(row);

        expect(roundTrip.id, entity.id);
        expect(roundTrip.name, entity.name);
        expect(roundTrip.type, entity.type);
        expect(roundTrip.status, entity.status);
        expect(roundTrip.description, entity.description);
        expect(roundTrip.iconColor, entity.iconColor);
        expect(roundTrip.isDeleted, entity.isDeleted);
        expect(roundTrip.createdAt, entity.createdAt);
        expect(roundTrip.updatedAt, entity.updatedAt);
      });
    });
  });
}
