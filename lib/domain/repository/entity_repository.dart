import 'package:fpdart/fpdart.dart';
import '../../core/error/failure.dart';
import '../entity/entity.dart';
import '../entity/entity_status.dart';
import '../entity/entity_type.dart';
import '../search/search_result.dart';

abstract class EntityRepository {
  Future<Either<Failure, Entity>> create(Entity entity);
  Future<Either<Failure, Entity>> getById(String id);
  Future<Either<Failure, Entity>> update(Entity entity);
  Future<Either<Failure, Unit>> softDelete(String id);
  Future<Either<Failure, List<Entity>>> search(String query);
  Future<Either<Failure, List<SearchResult>>> searchWithSnippets(String query);
  Future<Either<Failure, List<Entity>>> getAllActive();
  Future<Either<Failure, List<Entity>>> getActiveByType(EntityType type);
  Future<Either<Failure, List<Entity>>> getActiveByStatus(EntityStatus status);
  Future<Either<Failure, Unit>> purgeSoftDeleted();
}
