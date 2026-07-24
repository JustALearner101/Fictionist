import 'package:fpdart/fpdart.dart';
import '../../core/error/failure.dart';
import '../relationship/relationship.dart';

abstract class RelationshipRepository {
  Future<Either<Failure, Relationship>> create(Relationship relationship);
  Future<Either<Failure, Unit>> delete(String id);
  Future<Either<Failure, Unit>> deleteForEntity(String entityId);
  Future<Either<Failure, List<Relationship>>> getRelationshipsForEntity(String entityId);
  Future<Either<Failure, Relationship?>> getDuplicate(String sourceId, String targetId, String typeKey);
  Future<Either<Failure, Relationship>> getById(String id);
  Future<Either<Failure, List<Relationship>>> getAllActive();
}
