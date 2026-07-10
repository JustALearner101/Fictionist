import 'package:fictionist/data/dao/timeline_dao.dart';
import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/data/repository/timeline_repository_impl.dart';
import 'package:fictionist/domain/timeline/timeline_entry.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_database.dart';

int _counter = 0;

TimelineEntry makeTimelineEntry({
  String? id,
  String title = 'Test Event',
  String? description,
  String? dateLabel,
  String? eraLabel,
  int sortOrder = 0,
  String? entityId,
}) {
  final now = DateTime.now();
  return TimelineEntry(
    id: id ?? 't-${++_counter}',
    title: title,
    description: description,
    dateLabel: dateLabel,
    eraLabel: eraLabel,
    sortOrder: sortOrder,
    entityId: entityId,
    isDeleted: false,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  late AppDatabase db;
  late TimelineDao dao;
  late TimelineRepositoryImpl repository;

  setUp(() async {
    db = createTestDatabase();
    dao = db.timelineDao;
    repository = TimelineRepositoryImpl(dao);
  });

  tearDown(() async {
    await db.close();
  });

  group('TimelineRepositoryImpl (integration)', () {
    group('create', () {
      test('should persist entry and return it', () async {
        final entry = makeTimelineEntry(title: 'The Fall of Numenor');
        final result = await repository.create(entry);

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('should succeed'),
          (e) {
            expect(e.id, entry.id);
            expect(e.title, 'The Fall of Numenor');
            expect(e.sortOrder, 0);
          },
        );
      });

      test('should persist all optional fields', () async {
        final entry = makeTimelineEntry(
          title: 'Battle of Helm\'s Deep',
          description: 'A great battle',
          dateLabel: 'TA 3019',
          eraLabel: 'Third Age',
          sortOrder: 5,
        );

        await repository.create(entry);
        final getResult = await repository.getById(entry.id);

        getResult.fold(
          (_) => fail('should exist'),
          (e) {
            expect(e.title, 'Battle of Helm\'s Deep');
            expect(e.description, 'A great battle');
            expect(e.dateLabel, 'TA 3019');
            expect(e.eraLabel, 'Third Age');
            expect(e.sortOrder, 5);
            expect(e.entityId, isNull);
          },
        );
      });
    });

    group('getById', () {
      test('should return failure for non-existent entry', () async {
        final result = await repository.getById('non-existent');
        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect(f.message, contains('not found')),
          (_) => fail('should have failed'),
        );
      });

      test('should exclude soft-deleted entry', () async {
        final entry = makeTimelineEntry(title: 'Soft Deleted Event');
        await repository.create(entry);
        await repository.delete(entry.id);

        final result = await repository.getById(entry.id);
        expect(result.isLeft(), isTrue);
      });
    });

    group('update', () {
      test('should update entry fields', () async {
        final entry = makeTimelineEntry(title: 'Original Title');
        await repository.create(entry);

        final updated = entry.copyWith(title: 'Updated Title');
        final result = await repository.update(updated);

        expect(result.isRight(), isTrue);

        final getResult = await repository.getById(entry.id);
        getResult.fold(
          (_) => fail('should exist'),
          (e) => expect(e.title, 'Updated Title'),
        );
      });

      test('should return not-found for non-existent entry', () async {
        final entry = makeTimelineEntry(id: 'non-existent', title: 'Ghost');
        final result = await repository.update(entry);
        expect(result.isLeft(), isTrue);
      });
    });

    group('softDelete', () {
      test('should mark entry as deleted', () async {
        final entry = makeTimelineEntry(title: 'Delete Me');
        await repository.create(entry);

        final deleteResult = await repository.delete(entry.id);
        expect(deleteResult.isRight(), isTrue);

        final getResult = await repository.getById(entry.id);
        expect(getResult.isLeft(), isTrue);
      });

      test('should exclude deleted entry from getAllActiveOrdered',
          () async {
        final entry = makeTimelineEntry(title: 'Deleted');
        await repository.create(entry);
        await repository.delete(entry.id);

        final result = await repository.getAllActiveOrdered();
        result.fold(
          (_) => fail('should succeed'),
          (entries) {
            expect(entries.where((e) => e.id == entry.id), isEmpty);
          },
        );
      });
    });

    group('getAllActiveOrdered', () {
      test('should return empty list when no entries exist', () async {
        final result = await repository.getAllActiveOrdered();
        result.fold(
          (_) => fail('should succeed'),
          (entries) => expect(entries, isEmpty),
        );
      });

      test('should return entries ordered by sortOrder then createdAt',
          () async {
        final e1 = makeTimelineEntry(title: 'Third', sortOrder: 30);
        final e2 = makeTimelineEntry(title: 'First', sortOrder: 10);
        final e3 = makeTimelineEntry(title: 'Second', sortOrder: 20);

        await repository.create(e1);
        await repository.create(e2);
        await repository.create(e3);

        final result = await repository.getAllActiveOrdered();
        result.fold(
          (_) => fail('should succeed'),
          (entries) {
            expect(entries.length, 3);
            expect(entries[0].title, 'First');
            expect(entries[1].title, 'Second');
            expect(entries[2].title, 'Third');
          },
        );
      });
    });

    group('getActiveForEntity', () {
      test('should return only entries for the specified entity', () async {
        await repository.create(makeTimelineEntry(
            title: 'Event A', entityId: null, sortOrder: 1));
        await repository.create(makeTimelineEntry(
            title: 'Event B', entityId: null, sortOrder: 2));
        await repository.create(makeTimelineEntry(
            title: 'Event C', entityId: null, sortOrder: 3));

        final result = await repository.getActiveForEntity('e1');
        result.fold(
          (_) => fail('should succeed'),
          (entries) {
            expect(entries, isEmpty);
          },
        );
      });

      test('should return empty list for entity with no timeline entries',
          () async {
        await repository.create(makeTimelineEntry(
            title: 'Other Event', entityId: 'e99', sortOrder: 1));

        final result = await repository.getActiveForEntity('e1');
        result.fold(
          (_) => fail('should succeed'),
          (entries) => expect(entries, isEmpty),
        );
      });
    });

    group('sortOrder operations', () {
      test('getMaxSortOrder should return max value', () async {
        await repository.create(makeTimelineEntry(
            title: 'A', sortOrder: 10));
        await repository.create(makeTimelineEntry(
            title: 'B', sortOrder: 50));
        await repository.create(makeTimelineEntry(
            title: 'C', sortOrder: 30));

        final result = await repository.getMaxSortOrder();
        result.fold(
          (_) => fail('should succeed'),
          (max) => expect(max, 50),
        );
      });

      test('updateSortOrder should update single entry order', () async {
        final entry = makeTimelineEntry(title: 'Movable', sortOrder: 5);
        await repository.create(entry);

        final result = await repository.updateSortOrder(entry.id, 100);
        expect(result.isRight(), isTrue);

        final getResult = await repository.getById(entry.id);
        getResult.fold(
          (_) => fail('should exist'),
          (e) => expect(e.sortOrder, 100),
        );
      });
    });
  });
}
