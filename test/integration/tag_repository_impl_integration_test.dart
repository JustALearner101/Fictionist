import 'package:fictionist/data/dao/tag_dao.dart';
import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/data/repository/tag_repository_impl.dart';
import 'package:fictionist/domain/tag/tag.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_database.dart';

int _counter = 0;

Tag makeTag({String? id, String name = 'test-tag', int color = 0xFF8B5CF6}) {
  return Tag(
    id: id ?? 'tag-${DateTime.now().microsecondsSinceEpoch}-${++_counter}',
    name: name,
    color: color,
  );
}

void main() {
  late AppDatabase db;
  late TagDao dao;
  late TagRepositoryImpl repository;

  setUp(() async {
    db = createTestDatabase();
    dao = db.tagDao;
    repository = TagRepositoryImpl(dao);
  });

  tearDown(() async => db.close());

  group('TagRepositoryImpl (integration)', () {
    group('create', () {
      test('should persist tag and retrieve by id', () async {
        final tag = makeTag(name: 'Fantasy');
        final result = await repository.create(tag);

        expect(result.isRight(), isTrue);
        final retrieved = await repository.getById(tag.id);
        retrieved.fold(
          (_) => fail('tag should exist'),
          (t) {
            expect(t.name, 'Fantasy');
            expect(t.color, 0xFF8B5CF6);
          },
        );
      });

      test('should persist multiple tags', () async {
        await repository.create(makeTag(name: 'Fantasy'));
        await repository.create(makeTag(name: 'SciFi'));
        await repository.create(makeTag(name: 'Horror'));

        final all = await repository.getAllTags();
        all.fold(
          (_) => fail('should succeed'),
          (tags) => expect(tags.length, 3),
        );
      });
    });

    group('getById', () {
      test('should return failure for non-existent tag', () async {
        final result = await repository.getById('no-such-tag');
        expect(result.isLeft(), isTrue);
      });
    });

    group('getByName', () {
      test('should find tag by exact name', () async {
        await repository.create(makeTag(name: 'Elves'));
        await repository.create(makeTag(name: 'Dwarves'));

        final result = await repository.getByName('Elves');
        result.fold(
          (_) => fail('should succeed'),
          (tag) {
            expect(tag, isNotNull);
            expect(tag!.name, 'Elves');
          },
        );
      });

      test('should return null for non-existent name', () async {
        final result = await repository.getByName('Nonexistent');
        result.fold(
          (_) => fail('should succeed'),
          (tag) => expect(tag, isNull),
        );
      });
    });

    group('entity-tag assignment', () {
      test('should assign tag to entity and retrieve', () async {
        final tag = makeTag(name: 'Magic');
        await repository.create(tag);

        // Need an entity in DB (insert via DAO directly)
        await db.customStatement(
          "INSERT INTO entities (id, name, entity_type, icon_color, created_at, updated_at) "
          "VALUES ('ent-1', 'Gandalf', 'character', 123, '2025-01-01', '2025-01-01')",
        );

        final assignResult =
            await repository.assignTagToEntity('ent-1', tag.id);
        expect(assignResult.isRight(), isTrue);

        final tags = await repository.getTagsForEntity('ent-1');
        tags.fold(
          (_) => fail('should succeed'),
          (list) {
            expect(list.length, 1);
            expect(list.first.name, 'Magic');
          },
        );
      });

      test('should remove tag from entity', () async {
        final tag = makeTag(name: 'Temporary');
        await repository.create(tag);
        await db.customStatement(
          "INSERT INTO entities (id, name, entity_type, icon_color, created_at, updated_at) "
          "VALUES ('ent-2', 'Saruman', 'character', 456, '2025-01-01', '2025-01-01')",
        );
        await repository.assignTagToEntity('ent-2', tag.id);

        await repository.removeTagFromEntity('ent-2', tag.id);

        final tags = await repository.getTagsForEntity('ent-2');
        tags.fold(
          (_) => fail('should succeed'),
          (list) => expect(list, isEmpty),
        );
      });

      test('should remove all tags from entity', () async {
        final t1 = makeTag(name: 'A');
        final t2 = makeTag(name: 'B');
        await repository.create(t1);
        await repository.create(t2);
        await db.customStatement(
          "INSERT INTO entities (id, name, entity_type, icon_color, created_at, updated_at) "
          "VALUES ('ent-3', 'Frodo', 'character', 789, '2025-01-01', '2025-01-01')",
        );
        await repository.assignTagToEntity('ent-3', t1.id);
        await repository.assignTagToEntity('ent-3', t2.id);

        await repository.removeAllTagsFromEntity('ent-3');

        final tags = await repository.getTagsForEntity('ent-3');
        tags.fold(
          (_) => fail('should succeed'),
          (list) => expect(list, isEmpty),
        );
      });
    });
  });
}
