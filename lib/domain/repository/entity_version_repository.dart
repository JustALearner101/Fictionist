import 'package:fpdart/fpdart.dart';
import '../../core/error/failure.dart';
import '../version/entity_version.dart';

abstract class EntityVersionRepository {
  Future<Either<Failure, EntityVersion>> create(EntityVersion version);
  Future<Either<Failure, List<EntityVersion>>> getVersionsForEntity(
      String entityId);
  Future<Either<Failure, EntityVersion>> getVersionById(String id);
  Future<Either<Failure, Unit>> pruneOldVersions(String entityId, int keepLimit);
}
