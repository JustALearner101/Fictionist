import 'package:fictionist/domain/services/backup_synchronizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BackupSynchronizer synchronizer;

  setUp(() {
    synchronizer = BackupSynchronizer();
  });

  group('BackupSynchronizer.merge', () {
    test('empty inputs returns empty list', () async {
      final result = await synchronizer.merge(local: [], incoming: []);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('should succeed'),
        (merged) => expect(merged, isEmpty),
      );
    });

    test('all new incoming records are inserted', () async {
      final incoming = [
        {
          'id': 'a',
          'name': 'Alpha',
          'updatedAt': '2025-06-01T00:00:00.000Z',
        },
        {
          'id': 'b',
          'name': 'Bravo',
          'updatedAt': '2025-06-01T00:00:00.000Z',
        },
      ];

      final result = await synchronizer.merge(local: [], incoming: incoming);

      result.fold(
        (_) => fail('should succeed'),
        (merged) {
          expect(merged.length, 2);
          expect(merged.any((r) => r['id'] == 'a'), true);
          expect(merged.any((r) => r['id'] == 'b'), true);
        },
      );
    });

    test('newer incoming overwrites local', () async {
      final local = [
        {
          'id': 'a',
          'name': 'Old Name',
          'updatedAt': '2025-01-01T00:00:00.000Z',
        },
      ];
      final incoming = [
        {
          'id': 'a',
          'name': 'New Name',
          'updatedAt': '2025-06-01T00:00:00.000Z',
        },
      ];

      final result = await synchronizer.merge(local: local, incoming: incoming);

      result.fold(
        (_) => fail('should succeed'),
        (merged) {
          expect(merged.length, 1);
          expect(merged.first['name'], 'New Name');
        },
      );
    });

    test('older incoming does not overwrite local', () async {
      final local = [
        {
          'id': 'a',
          'name': 'Newer Local',
          'updatedAt': '2025-06-01T00:00:00.000Z',
        },
      ];
      final incoming = [
        {
          'id': 'a',
          'name': 'Older Incoming',
          'updatedAt': '2025-01-01T00:00:00.000Z',
        },
      ];

      final result = await synchronizer.merge(local: local, incoming: incoming);

      result.fold(
        (_) => fail('should succeed'),
        (merged) {
          expect(merged.length, 1);
          expect(merged.first['name'], 'Newer Local');
        },
      );
    });

    test('records missing in incoming are preserved from local', () async {
      final local = [
        {
          'id': 'a',
          'name': 'Alpha',
          'updatedAt': '2025-01-01T00:00:00.000Z',
        },
        {
          'id': 'b',
          'name': 'Bravo',
          'updatedAt': '2025-01-01T00:00:00.000Z',
        },
      ];
      final incoming = [
        {
          'id': 'a',
          'name': 'Alpha Updated',
          'updatedAt': '2025-06-01T00:00:00.000Z',
        },
      ];

      final result = await synchronizer.merge(local: local, incoming: incoming);

      result.fold(
        (_) => fail('should succeed'),
        (merged) {
          expect(merged.length, 2);
          // Alpha should be updated
          final alpha = merged.firstWhere((r) => r['id'] == 'a');
          expect(alpha['name'], 'Alpha Updated');
          // Bravo should be preserved
          final bravo = merged.firstWhere((r) => r['id'] == 'b');
          expect(bravo['name'], 'Bravo');
        },
      );
    });

    test('records with missing updatedAt handled gracefully', () async {
      final local = [
        {
          'id': 'a',
          'name': 'NoTimestamp',
        },
      ];
      final incoming = [
        {
          'id': 'a',
          'name': 'AlsoNoTimestamp',
        },
      ];

      final result = await synchronizer.merge(local: local, incoming: incoming);

      result.fold(
        (_) => fail('should succeed'),
        (merged) {
          expect(merged.length, 1);
          // With both missing, incoming defaults to 2000-01-01
          // existing defaults to 2000-01-01 — so equal, local kept
          expect(merged.first['name'], 'NoTimestamp');
        },
      );
    });

    test('records with no id field are skipped', () async {
      final incoming = [
        {
          'name': 'No ID',
          'updatedAt': '2025-06-01T00:00:00.000Z',
        },
      ];

      final result = await synchronizer.merge(local: [], incoming: incoming);

      result.fold(
        (_) => fail('should succeed'),
        (merged) {
          expect(merged, isEmpty);
        },
      );
    });
  });

  group('BackupSynchronizer.mergeWithReport', () {
    test('reports correct insert/update/skip counts', () async {
      final local = [
        {
          'id': 'a',
          'name': 'Old A',
          'updatedAt': '2025-01-01T00:00:00.000Z',
        },
        {
          'id': 'b',
          'name': 'Local B',
          'updatedAt': '2025-06-01T00:00:00.000Z',
        },
      ];
      final incoming = [
        {
          'id': 'a',
          'name': 'New A',
          'updatedAt': '2025-06-01T00:00:00.000Z',
        },
        {
          'id': 'b',
          'name': 'Old B',
          'updatedAt': '2025-01-01T00:00:00.000Z',
        },
        {
          'id': 'c',
          'name': 'New C',
          'updatedAt': '2025-06-01T00:00:00.000Z',
        },
      ];

      final result = await synchronizer.mergeWithReport(
        local: local,
        incoming: incoming,
      );

      result.fold(
        (_) => fail('should succeed'),
        (report) {
          expect(report.inserted, 1); // c is new
          expect(report.updated, 1);  // a overwrites
          expect(report.skipped, 1);  // b is older, skipped
          expect(report.mergedRecords.length, 3);
        },
      );
    });
  });

  group('BackupSynchronizer.shouldReplace static', () {
    test('returns true when incoming is newer', () {
      final existing = {
        'id': 'a',
        'updatedAt': '2025-01-01T00:00:00.000Z',
      };
      final incoming = {
        'id': 'a',
        'updatedAt': '2025-06-01T00:00:00.000Z',
      };
      expect(BackupSynchronizer.shouldReplace(existing, incoming), true);
    });

    test('returns false when incoming is older', () {
      final existing = {
        'id': 'a',
        'updatedAt': '2025-06-01T00:00:00.000Z',
      };
      final incoming = {
        'id': 'a',
        'updatedAt': '2025-01-01T00:00:00.000Z',
      };
      expect(BackupSynchronizer.shouldReplace(existing, incoming), false);
    });

    test('returns false when timestamps are missing (both default to 2000)', () {
      final existing = {'id': 'a'};
      final incoming = {'id': 'a'};
      expect(BackupSynchronizer.shouldReplace(existing, incoming), false);
    });
  });
}
