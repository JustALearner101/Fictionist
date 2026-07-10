import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:fictionist/core/error/failure.dart';

/// Result of a backup merge operation.
class MergeResult {
  final List<Map<String, dynamic>> mergedRecords;
  final int inserted;
  final int updated;
  final int skipped;

  const MergeResult({
    required this.mergedRecords,
    this.inserted = 0,
    this.updated = 0,
    this.skipped = 0,
  });
}

/// Git-style Last-Write-Wins (LWW) backup synchronizer.
///
/// Merges JSON backup records into the local database by comparing
/// `updatedAt` timestamps on a per-record basis.
///
/// Moved from lib/domain/use_case/backup_synchronizer.dart.
/// Old file left in place with a redirect comment.
@lazySingleton
class BackupSynchronizer {
  /// Merge [incoming] records into [local] records using LWW.
  ///
  /// Each record must have `id` (String) and `updatedAt` (ISO 8601 string).
  /// Returns the merged list.
  Future<Either<Failure, List<Map<String, dynamic>>>> merge({
    required List<Map<String, dynamic>> local,
    required List<Map<String, dynamic>> incoming,
  }) async {
    try {
      final merged = <String, Map<String, dynamic>>{};

      // Index local by ID
      for (final record in local) {
        final id = record['id'] as String?;
        if (id != null) merged[id] = record;
      }

      // Merge incoming — keep if newer or doesn't exist
      for (final record in incoming) {
        final id = record['id'] as String?;
        if (id == null) continue;

        final existing = merged[id];
        if (existing == null) {
          merged[id] = record;
          continue;
        }

        // LWW: keep whichever has newer updatedAt
        final incomingTime =
            DateTime.tryParse(record['updatedAt']?.toString() ?? '') ??
                DateTime(2000);
        final existingTime =
            DateTime.tryParse(existing['updatedAt']?.toString() ?? '') ??
                DateTime(2000);

        if (incomingTime.isAfter(existingTime)) {
          merged[id] = record;
        }
      }

      return Right(merged.values.toList());
    } on Exception catch (e) {
      return Left(
        Failure.unexpected(message: 'Merge failed: $e', originalError: e),
      );
    }
  }

  /// Merge two lists and return detailed conflict report.
  Future<Either<Failure, MergeResult>> mergeWithReport({
    required List<Map<String, dynamic>> local,
    required List<Map<String, dynamic>> incoming,
  }) async {
    try {
      var inserted = 0;
      var updated = 0;
      var skipped = 0;

      final merged = <String, Map<String, dynamic>>{};

      // Index local by ID
      for (final record in local) {
        final id = record['id'] as String?;
        if (id != null) merged[id] = record;
      }

      // Merge incoming
      for (final record in incoming) {
        final id = record['id'] as String?;
        if (id == null) {
          skipped++;
          continue;
        }

        final existing = merged[id];
        if (existing == null) {
          merged[id] = record;
          inserted++;
          continue;
        }

        // LWW: keep whichever has newer updatedAt
        final incomingTime =
            DateTime.tryParse(record['updatedAt']?.toString() ?? '') ??
                DateTime(2000);
        final existingTime =
            DateTime.tryParse(existing['updatedAt']?.toString() ?? '') ??
                DateTime(2000);

        if (incomingTime.isAfter(existingTime)) {
          merged[id] = record;
          updated++;
        } else {
          skipped++;
        }
      }

      return Right(MergeResult(
        mergedRecords: merged.values.toList(),
        inserted: inserted,
        updated: updated,
        skipped: skipped,
      ));
    } on Exception catch (e) {
      return Left(
        Failure.unexpected(message: 'Merge failed: $e', originalError: e),
      );
    }
  }

  /// Static helper: LWW comparison for a single record pair.
  /// Returns true if [incoming] should replace [existing] (newer updatedAt).
  static bool shouldReplace(
    Map<String, dynamic> existing,
    Map<String, dynamic> incoming,
  ) {
    final incomingTime =
        DateTime.tryParse(incoming['updatedAt']?.toString() ?? '') ??
            DateTime(2000);
    final existingTime =
        DateTime.tryParse(existing['updatedAt']?.toString() ?? '') ??
            DateTime(2000);
    return incomingTime.isAfter(existingTime);
  }
}
