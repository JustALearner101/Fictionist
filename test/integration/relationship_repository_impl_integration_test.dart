import 'package:fictionist/data/dao/entity_dao.dart';
import 'package:fictionist/data/dao/relationship_dao.dart';
import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/data/mapper/entity_mapper.dart';
import 'package:fictionist/data/repository/relationship_repository_impl.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_status.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:fictionist/domain/relationship/relationship.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_database.dart';

int _counter = 0;

Entity makeEntity({
  String? id,
  String name = 'Test',
  EntityType type = EntityType.character,
}) {
  final now = DateTime.now();
  return Entity(
    id: id ?? 'e-${++_counter}',
    name: name,
    type: type,
    status: EntityStatus.draft,
    iconColor: 0xFF8B5CF6,
    isDeleted: false,
    createdAt: now,
    updatedAt: now,
  );
}

Relationship makeRelationship({
  String? id,
  required String sourceId,
  required String targetId,
  String typeKey = 'ally',
  String? description,
}) {
  final now = DateTime.now();
  return Relationship(
    id: id ?? 'r-${++_counter}',
    sourceId: sourceId,
    targetId: targetId,
    typeKey: typeKey,
    description: description,
    isDeleted: false,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  late AppDatabase db;
  late EntityDao entityDao;
  late RelationshipDao dao;
  late RelationshipRepositoryImpl repository;

  setUp(() async {
    db = createTestDatabase();
    entityDao = db.entityDao;
    dao = db.relationshipDao;
    repository = RelationshipRepositoryImpl(dao);
  });

  tearDown(() async {
    await db.close();
  });

  /// Helper: creates two entities (source + target) and returns their IDs.
  Future<({String sourceId, String targetId})> createEntityPair() async {
    final source = makeEntity(name: 'Frodo');
    final target = makeEntity(name: 'Sam');
    await entityDao.insertEntity(EntityMapper.toCompanion(source));
    await entityDao.insertEntity(EntityMapper.toCompanion(target));
    return (sourceId: source.id, targetId: target.id);
  }

  group('RelationshipRepositoryImpl (integration)', () {
    group('create', () {
      test('should persist relationship and return it', () async {
        final pair = await createEntityPair();
        final rel = makeRelationship(
            sourceId: pair.sourceId, targetId: pair.targetId);

        final result = await repository.create(rel);
        expect(result.isRight(), isTrue);

        result.fold(
          (_) => fail('should succeed'),
          (r) {
            expect(r.id, rel.id);
            expect(r.sourceId, pair.sourceId);
            expect(r.targetId, pair.targetId);
            expect(r.typeKey, 'ally');
          },
        );
      });

      test('should persist description when provided', () async {
        final pair = await createEntityPair();
        final rel = makeRelationship(
          sourceId: pair.sourceId,
          targetId: pair.targetId,
          description: 'They are best friends',
        );

        await repository.create(rel);
        final getResult = await repository.getById(rel.id);

        getResult.fold(
          (_) => fail('should exist'),
          (r) => expect(r.description, 'They are best friends'),
        );
      });

      test('should persist description as null when not provided', () async {
        final pair = await createEntityPair();
        final rel = makeRelationship(
            sourceId: pair.sourceId, targetId: pair.targetId);

        await repository.create(rel);
        final getResult = await repository.getById(rel.id);

        getResult.fold(
          (_) => fail('should exist'),
          (r) => expect(r.description, isNull),
        );
      });
    });

    group('getById', () {
      test('should return failure for non-existent relationship', () async {
        final result = await repository.getById('non-existent');
        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect(f.message, contains('not found')),
          (_) => fail('should have failed'),
        );
      });

      test('should return failure for soft-deleted relationship', () async {
        final pair = await createEntityPair();
        final rel = makeRelationship(
            sourceId: pair.sourceId, targetId: pair.targetId);
        await repository.create(rel);
        await repository.delete(rel.id);

        final result = await repository.getById(rel.id);
        expect(result.isLeft(), isTrue);
      });
    });

    group('softDelete', () {
      test('should mark relationship as deleted', () async {
        final pair = await createEntityPair();
        final rel = makeRelationship(
            sourceId: pair.sourceId, targetId: pair.targetId);
        await repository.create(rel);

        final deleteResult = await repository.delete(rel.id);
        expect(deleteResult.isRight(), isTrue);

        // getById should now fail (isDeleted filter)
        final getResult = await repository.getById(rel.id);
        expect(getResult.isLeft(), isTrue);
      });

      test('should return not-found for non-existent relationship', () async {
        final result = await repository.delete('non-existent');
        expect(result.isLeft(), isTrue);
      });
    });

    group('getRelationshipsForEntity', () {
      test('should return all relationships where entity is source or target',
          () async {
        final a = makeEntity(name: 'Entity A');
        final b = makeEntity(name: 'Entity B');
        final c = makeEntity(name: 'Entity C');
        await entityDao.insertEntity(EntityMapper.toCompanion(a));
        await entityDao.insertEntity(EntityMapper.toCompanion(b));
        await entityDao.insertEntity(EntityMapper.toCompanion(c));

        // A → B (A is source)
        await repository.create(
            makeRelationship(sourceId: a.id, targetId: b.id));
        // C → A (A is target)
        await repository.create(
            makeRelationship(sourceId: c.id, targetId: a.id));

        final result = await repository.getRelationshipsForEntity(a.id);
        result.fold(
          (_) => fail('should succeed'),
          (rels) {
            expect(rels.length, 2);
          },
        );
      });

      test('should return empty list for entity with no relationships',
          () async {
        final a = makeEntity(name: 'Lonely Entity');
        await entityDao.insertEntity(EntityMapper.toCompanion(a));

        final result = await repository.getRelationshipsForEntity(a.id);
        result.fold(
          (_) => fail('should succeed'),
          (rels) => expect(rels, isEmpty),
        );
      });
    });

    group('getDuplicate', () {
      test('should find duplicate relationship with same source/target/type',
          () async {
        final pair = await createEntityPair();
        final rel = makeRelationship(
            sourceId: pair.sourceId, targetId: pair.targetId);
        await repository.create(rel);

        final result = await repository.getDuplicate(
            pair.sourceId, pair.targetId, 'ally');
        result.fold(
          (_) => fail('should succeed'),
          (duplicate) {
            expect(duplicate, isNotNull);
            expect(duplicate!.sourceId, pair.sourceId);
          },
        );
      });

      test('should return null when no duplicate exists', () async {
        final pair = await createEntityPair();

        final result = await repository.getDuplicate(
            pair.sourceId, pair.targetId, 'enemy');
        result.fold(
          (_) => fail('should succeed'),
          (duplicate) => expect(duplicate, isNull),
        );
      });
    });

    group('deleteRelationshipsForEntity', () {
      test('should soft-delete all relationships for an entity', () async {
        final a = makeEntity(name: 'Entity A');
        final b = makeEntity(name: 'Entity B');
        final c = makeEntity(name: 'Entity C');
        await entityDao.insertEntity(EntityMapper.toCompanion(a));
        await entityDao.insertEntity(EntityMapper.toCompanion(b));
        await entityDao.insertEntity(EntityMapper.toCompanion(c));

        // A → B
        final r1 = makeRelationship(sourceId: a.id, targetId: b.id);
        // C → A
        final r2 = makeRelationship(sourceId: c.id, targetId: a.id,
            typeKey: 'enemy');
        await repository.create(r1);
        await repository.create(r2);

        await repository.deleteForEntity(a.id);

        // getById should fail for both (soft-deleted)
        final r1Result = await repository.getById(r1.id);
        final r2Result = await repository.getById(r2.id);
        expect(r1Result.isLeft(), isTrue);
        expect(r2Result.isLeft(), isTrue);
      });
    });

    group('getAllActive', () {
      test('should return empty list when no relationships exist', () async {
        final result = await repository.getAllActive();
        result.fold(
          (_) => fail('should succeed'),
          (rels) => expect(rels, isEmpty),
        );
      });

      test('should exclude soft-deleted relationships', () async {
        final pair = await createEntityPair();
        final rel = makeRelationship(
            sourceId: pair.sourceId, targetId: pair.targetId);
        await repository.create(rel);
        await repository.delete(rel.id);

        final result = await repository.getAllActive();
        result.fold(
          (_) => fail('should succeed'),
          (rels) => expect(rels.where((r) => r.id == rel.id), isEmpty),
        );
      });
    });
  });
}
