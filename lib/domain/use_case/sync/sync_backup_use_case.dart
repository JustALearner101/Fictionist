import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/core/use_case/use_case.dart';
import 'package:fictionist/domain/repository/sync_repository.dart';

/// Parameters for syncing a backup into the local database.
class SyncBackupParams {
  /// Map of table name → list of records to import.
  final Map<String, List<Map<String, dynamic>>> incomingRecords;

  const SyncBackupParams({required this.incomingRecords});
}

/// Orchestrates importing a backup into the local database using LWW merge.
@lazySingleton
class SyncBackupUseCase
    implements UseCase<Map<String, int>, SyncBackupParams> {
  final SyncRepository _syncRepo;

  SyncBackupUseCase(this._syncRepo);

  @override
  Future<Either<Failure, Map<String, int>>> call(
    SyncBackupParams params,
  ) {
    return _syncRepo.importAll(params.incomingRecords);
  }
}
