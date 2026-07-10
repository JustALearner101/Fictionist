import 'package:fictionist/data/dao/manuscript_dao.dart';
import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/data/repository/manuscript_repository_impl.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_database.dart';

ManuscriptChapter _makeChapter({
  required String id,
  String title = 'Chapter One',
  String content = 'Lorem ipsum dolor sit amet.',
  int sortOrder = 0,
  String? dateLabel,
  String? eraLabel,
}) {
  final now = DateTime.now();
  return ManuscriptChapter(
    id: id,
    title: title,
    content: content,
    sortOrder: sortOrder,
    dateLabel: dateLabel,
    eraLabel: eraLabel,
    isDeleted: false,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  late AppDatabase db;
  late ManuscriptDao dao;
  late ManuscriptRepositoryImpl repository;

  setUp(() async {
    db = createTestDatabase();
    dao = ManuscriptDao(db);
    repository = ManuscriptRepositoryImpl(dao);
  });

  tearDown(() async {
    await db.close();
  });

  group('ManuscriptRepositoryImpl (integration)', () {
    group('create', () {
      test('should persist chapter and return it on getById', () async {
        const id = 'aaaaaaaa-bbbb-cccc-dddd-000000000001';
        final chapter = _makeChapter(id: id, title: 'The Beginning');
        final createResult = await repository.create(chapter);
        expect(createResult.isRight(), true);

        final getResult = await repository.getById(id);
        expect(getResult.isRight(), true);
        getResult.fold(
          (_) => fail('chapter should exist'),
          (retrieved) {
            expect(retrieved.id, id);
            expect(retrieved.title, 'The Beginning');
            expect(retrieved.content, 'Lorem ipsum dolor sit amet.');
          },
        );
      });

      test('should persist dateLabel and eraLabel', () async {
        const id = 'aaaaaaaa-bbbb-cccc-dddd-000000000002';
        final chapter = _makeChapter(
          id: id,
          dateLabel: 'TA 3018',
          eraLabel: 'Third Age',
        );

        await repository.create(chapter);
        final result = await repository.getById(id);

        result.fold(
          (_) => fail('should exist'),
          (retrieved) {
            expect(retrieved.dateLabel, 'TA 3018');
            expect(retrieved.eraLabel, 'Third Age');
          },
        );
      });
    });

    group('update', () {
      test('should update chapter content', () async {
        const id = 'aaaaaaaa-bbbb-cccc-dddd-000000000003';
        final chapter = _makeChapter(id: id, content: 'Original');
        await repository.create(chapter);

        final updated = chapter.copyWith(content: 'Modified content.');
        await repository.update(updated);

        final result = await repository.getById(id);
        result.fold(
          (_) => fail('should exist'),
          (retrieved) {
            expect(retrieved.content, 'Modified content.');
          },
        );
      });

      test('should update chapter title', () async {
        const id = 'aaaaaaaa-bbbb-cccc-dddd-000000000004';
        final chapter = _makeChapter(id: id, title: 'Old Title');
        await repository.create(chapter);

        final updated = chapter.copyWith(title: 'New Title');
        await repository.update(updated);

        final result = await repository.getById(id);
        result.fold(
          (_) => fail('should exist'),
          (retrieved) {
            expect(retrieved.title, 'New Title');
          },
        );
      });
    });

    group('softDelete', () {
      test('should mark chapter as deleted', () async {
        const id = 'aaaaaaaa-bbbb-cccc-dddd-000000000005';
        final chapter = _makeChapter(id: id);
        await repository.create(chapter);

        final delResult = await repository.softDelete(id);
        // softDelete returns Right(unit) on success
        expect(delResult.isRight(), true);

        // getById still returns the row (it doesn't filter soft-deleted)
        // Verify soft delete via getAllActive which excludes isDeleted=true
        final active = await repository.getAllActive();
        active.fold(
          (_) => fail('getAllActive should succeed'),
          (chapters) {
            expect(chapters.any((c) => c.id == id), false,
                reason: 'Soft-deleted chapter should not appear in active list');
          },
        );
      });

      test('soft deleted chapters excluded from getAllActive', () async {
        await repository.create(_makeChapter(id: 'aaaaaaaa-bbbb-cccc-dddd-000000000006', title: 'Visible'));
        await repository.create(_makeChapter(id: 'aaaaaaaa-bbbb-cccc-dddd-000000000007', title: 'Hidden'));
        await repository.softDelete('aaaaaaaa-bbbb-cccc-dddd-000000000007');

        final result = await repository.getAllActive();
        result.fold(
          (_) => fail('should succeed'),
          (chapters) {
            expect(chapters.length, 1);
            expect(chapters.first.title, 'Visible');
          },
        );
      });

      test('delete non-existent returns failure', () async {
        final result = await repository.softDelete('nonexistent');
        expect(result.isLeft(), true);
      });
    });

    group('getAllActive', () {
      test('returns empty list when no chapters', () async {
        final result = await repository.getAllActive();
        result.fold(
          (_) => fail('should succeed'),
          (chapters) => expect(chapters, isEmpty),
        );
      });
    });

    group('sortOrder', () {
      test('chapters returned in sort order', () async {
        await repository.create(
            _makeChapter(id: 'aaaaaaaa-bbbb-cccc-dddd-000000000008', title: 'Third', sortOrder: 2));
        await repository.create(
            _makeChapter(id: 'aaaaaaaa-bbbb-cccc-dddd-000000000009', title: 'First', sortOrder: 0));
        await repository.create(
            _makeChapter(id: 'aaaaaaaa-bbbb-cccc-dddd-000000000010', title: 'Second', sortOrder: 1));

        final result = await repository.getAllActive();
        result.fold(
          (_) => fail('should succeed'),
          (chapters) {
            expect(chapters.length, 3);
            expect(chapters[0].title, 'First');
            expect(chapters[1].title, 'Second');
            expect(chapters[2].title, 'Third');
          },
        );
      });
    });

    group('reorder', () {
      test('reorder updates sort order for all chapters', () async {
        await repository.create(
            _makeChapter(id: 'aaaaaaaa-bbbb-cccc-dddd-000000000011', title: 'A', sortOrder: 0));
        await repository.create(
            _makeChapter(id: 'aaaaaaaa-bbbb-cccc-dddd-000000000012', title: 'B', sortOrder: 1));
        await repository.create(
            _makeChapter(id: 'aaaaaaaa-bbbb-cccc-dddd-000000000013', title: 'C', sortOrder: 2));

        // Reverse order
        await repository.reorder(['aaaaaaaa-bbbb-cccc-dddd-000000000013', 'aaaaaaaa-bbbb-cccc-dddd-000000000012', 'aaaaaaaa-bbbb-cccc-dddd-000000000011']);

        final result = await repository.getAllActive();
        result.fold(
          (_) => fail('should succeed'),
          (chapters) {
            expect(chapters[0].title, 'C');
            expect(chapters[1].title, 'B');
            expect(chapters[2].title, 'A');
          },
        );
      });
    });

    group('getById', () {
      test('returns not found failure for non-existent chapter', () async {
        final result = await repository.getById('no-such-chapter');
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('not found')),
          (_) => fail('should fail'),
        );
      });
    });
  });
}
