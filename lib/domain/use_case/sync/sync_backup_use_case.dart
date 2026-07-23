import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/data/repository/sync_repository_impl.dart';

class SyncBackupParams {
  final Map<String, List<Map<String, dynamic>>> incomingRecords;

  const SyncBackupParams({required this.incomingRecords});
}

@lazySingleton
class SyncBackupUseCase {
  final SyncRepositoryImpl _syncRepo;

  SyncBackupUseCase(this._syncRepo);

  Future<Either<Failure, Map<String, int>>> call(
    SyncBackupParams params,
  ) {
    return _syncRepo.importAll(params.incomingRecords);
  }
}
