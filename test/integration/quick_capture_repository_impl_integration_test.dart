import 'package:fictionist/data/dao/quick_capture_dao.dart';
import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/data/repository/quick_capture_repository_impl.dart';
import 'package:fictionist/domain/quick_capture/quick_capture.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_database.dart';

int _counter = 0;

QuickCapture makeCapture({String? id, String rawText = 'test note', bool isProcessed = false}) {
  return QuickCapture(
    id: id ?? 'qc-${DateTime.now().microsecondsSinceEpoch}-${++_counter}',
    rawText: rawText,
    isProcessed: isProcessed,
    createdAt: DateTime.now(),
  );
}

void main() {
  late AppDatabase db;
  late QuickCaptureDao dao;
  late QuickCaptureRepositoryImpl repository;

  setUp(() async {
    db = createTestDatabase();
    dao = db.quickCaptureDao;
    repository = QuickCaptureRepositoryImpl(dao);
  });

  tearDown(() async => db.close());

  group('QuickCaptureRepositoryImpl (integration)', () {
    group('create', () {
      test('should persist capture and retrieve by id', () async {
        final capture = makeCapture(rawText: 'Idea: magic sword');
        final result = await repository.create(capture);
        expect(result.isRight(), isTrue);

        final retrieved = await repository.getById(capture.id);
        retrieved.fold(
          (_) => fail('capture should exist'),
          (c) {
            expect(c.rawText, 'Idea: magic sword');
            expect(c.isProcessed, isFalse);
          },
        );
      });
    });

    group('getById', () {
      test('should return failure for non-existent capture', () async {
        final result = await repository.getById('no-such');
        expect(result.isLeft(), isTrue);
      });
    });

    group('getUnprocessedOrdered', () {
      test('should return empty list when none exist', () async {
        final result = await repository.getUnprocessedOrdered();
        result.fold(
          (_) => fail('should succeed'),
          (list) => expect(list, isEmpty),
        );
      });

      test('should return only unprocessed captures', () async {
        await repository.create(makeCapture(rawText: 'Note A'));
        await repository.create(makeCapture(rawText: 'Note B'));
        final processed = makeCapture(rawText: 'Note C (done)', isProcessed: true);
        await repository.create(processed);

        final unprocessed = await repository.getUnprocessedOrdered();
        unprocessed.fold(
          (_) => fail('should succeed'),
          (list) {
            expect(list.length, 2);
            expect(list.every((c) => !c.isProcessed), isTrue);
          },
        );
      });
    });

    group('markProcessed', () {
      test('should mark capture as processed', () async {
        final capture = makeCapture(rawText: 'Process me');
        await repository.create(capture);

        await repository.markProcessed(capture.id);

        final unprocessed = await repository.getUnprocessedOrdered();
        unprocessed.fold(
          (_) => fail('should succeed'),
          (list) => expect(list, isEmpty),
        );
      });

      test('should return failure for non-existent capture', () async {
        final result = await repository.markProcessed('no-such');
        expect(result.isLeft(), isTrue);
      });
    });

    group('delete', () {
      test('should hard-delete capture', () async {
        final capture = makeCapture(rawText: 'Delete me');
        await repository.create(capture);

        await repository.delete(capture.id);

        final result = await repository.getById(capture.id);
        expect(result.isLeft(), isTrue);
      });

      test('should return failure for non-existent capture', () async {
        final result = await repository.delete('no-such');
        expect(result.isLeft(), isTrue);
      });
    });
  });
}
