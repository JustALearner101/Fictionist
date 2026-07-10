import 'package:fpdart/fpdart.dart';
import 'package:fictionist/core/error/failure.dart';

/// Repository for full database export/import for sync and backup.
abstract class SyncRepository {
  /// Export all database tables as a map of table name → list of records.
  /// Each record includes id, all fields, and updatedAt timestamp.
  Future<Either<Failure, Map<String, List<Map<String, dynamic>>>>> exportAll();

  /// Import records into the database, merging by id using LWW.
  /// Returns counts: {inserted: N, updated: N, skipped: N}
  Future<Either<Failure, Map<String, int>>> importAll(
    Map<String, List<Map<String, dynamic>>> records,
  );
}
