import 'package:fictionist/data/dao/entity_version_dao.dart';
import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/data/repository/entity_version_repository_impl.dart';
import 'package:fictionist/domain/version/entity_version.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_database.dart';

EntityVersion _makeVersion({
  String id = 'v-1',
  String entityId = 'entity-1',
  String snapshotJson = '{"name":"Test"}',
  DateTime? changedAt,
  String? changeNote,
}) {
  return EntityVersion(
    id: id,
    entityId: entityId,
    snapshotJson: snapshotJson,
    changedAt: changedAt ?? DateTime.now(),
    changeNote: changeNote,
  );
}

void main() {
  late AppDatabase db;
  late EntityVersionDao dao;
  late EntityVersionRepositoryImpl repository;

  setUp(() async {
    db = createTestDatabase();
    // Disable FK checks since we test versions without creating parent entities
    await db.customStatement('PRAGMA foreign_keys = OFF');
    dao = db.entityVersionDao;
    repository = EntityVersionRepositoryImpl(dao);
  });

  tearDown(() async {
    await db.close();
  });

  group('EntityVersionRepositoryImpl (integration)', () {
    group('create', () {
      test('should persist version and return it on getVersionById', () async {
        final version = _makeVersion(id: 'v-id');
        final createResult = await repository.create(version);
        expect(createResult.isRight(), true);

        final getResult = await repository.getVersionById('v-id');
        expect(getResult.isRight(), true);
        getResult.fold(
          (_) => fail('version should exist'),
          (retrieved) {
            expect(retrieved.id, 'v-id');
            expect(retrieved.entityId, 'entity-1');
            expect(retrieved.snapshotJson, '{"name":"Test"}');
          },
        );
      });

      test('should persist changeNote', () async {
        final version = _makeVersion(
          id: 'v-note',
          changeNote: 'Updated name',
        );
        await repository.create(version);

        final result = await repository.getVersionById('v-note');
        result.fold(
          (_) => fail('should exist'),
          (retrieved) {
            expect(retrieved.changeNote, 'Updated name');
          },
        );
      });
    });

    group('getVersionsForEntity', () {
      test('should return all versions for an entity in order (newest first)',
          () async {
        final v1 = _makeVersion(
          id: 'v-1',
          entityId: 'shared-entity',
          changedAt: DateTime(2025, 1, 1),
        );
        final v2 = _makeVersion(
          id: 'v-2',
          entityId: 'shared-entity',
          changedAt: DateTime(2025, 6, 1),
        );
        final v3 = _makeVersion(
          id: 'v-3',
          entityId: 'shared-entity',
          changedAt: DateTime(2025, 12, 1),
        );

        await repository.create(v1);
        await repository.create(v2);
        await repository.create(v3);

        final result = await repository.getVersionsForEntity('shared-entity');
        result.fold(
          (_) => fail('should succeed'),
          (versions) {
            expect(versions.length, 3);
            // Should be ordered by changedAt descending (newest first)
            expect(versions[0].id, 'v-3');
            expect(versions[1].id, 'v-2');
            expect(versions[2].id, 'v-1');
          },
        );
      });

      test('should return empty list for entity with no versions', () async {
        final result =
            await repository.getVersionsForEntity('no-versions-entity');
        result.fold(
          (_) => fail('should succeed'),
          (versions) {
            expect(versions, isEmpty);
          },
        );
      });

      test('should only return versions for the requested entity', () async {
        final v1 = _makeVersion(id: 'v-a', entityId: 'entity-a');
        final v2 = _makeVersion(id: 'v-b', entityId: 'entity-b');

        await repository.create(v1);
        await repository.create(v2);

        final resultA = await repository.getVersionsForEntity('entity-a');
        resultA.fold(
          (_) => fail('should succeed'),
          (versions) {
            expect(versions.length, 1);
            expect(versions.first.id, 'v-a');
          },
        );

        final resultB = await repository.getVersionsForEntity('entity-b');
        resultB.fold(
          (_) => fail('should succeed'),
          (versions) {
            expect(versions.length, 1);
            expect(versions.first.id, 'v-b');
          },
        );
      });
    });

    group('getVersionById', () {
      test('returns not found for non-existent version', () async {
        final result = await repository.getVersionById('nonexistent');
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('not found')),
          (_) => fail('should fail'),
        );
      });
    });

    group('pruneOldVersions', () {
      test('should prune versions beyond keep limit', () async {
        final versions = List.generate(
          5,
          (i) => _makeVersion(
            id: 'prune-v-$i',
            entityId: 'prune-entity',
            changedAt: DateTime(2025, i + 1),
          ),
        );

        for (final v in versions) {
          await repository.create(v);
        }

        // Keep only 2
        await repository.pruneOldVersions('prune-entity', 2);

        final result =
            await repository.getVersionsForEntity('prune-entity');
        result.fold(
          (_) => fail('should succeed'),
          (remaining) {
            expect(remaining.length, 2);
            // Should keep the 2 newest
            expect(remaining[0].id, 'prune-v-4');
            expect(remaining[1].id, 'prune-v-3');
          },
        );
      });
    });
  });
}
