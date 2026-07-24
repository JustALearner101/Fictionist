import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failure.dart';
import '../../domain/relationship/relationship.dart';

import '../../domain/repository/relationship_repository.dart';

import '../dao/relationship_dao.dart';
import '../mapper/relationship_mapper.dart';

@LazySingleton(as: RelationshipRepository)
class RelationshipRepositoryImpl implements RelationshipRepository {
  final RelationshipDao _dao;

  RelationshipRepositoryImpl(this._dao);

  @override
  Future<Either<Failure, Relationship>> create(Relationship relationship) async {
    try {
      final companion = RelationshipMapper.toCompanion(relationship);
      await _dao.insertRelationship(companion);
      return Right(relationship);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to create relationship in database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      final count = await _dao.deleteRelationship(id);
      if (count == 0) {
        return Left(Failure.notFound(resourceType: 'Relationship', resourceId: id));
      }
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to soft delete relationship in database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteForEntity(String entityId) async {
    try {
      await _dao.deleteRelationshipsForEntity(entityId);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to delete relationships for entity',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<Relationship>>> getRelationshipsForEntity(
      String entityId) async {
    try {
      final rows = await _dao.getRelationshipsForEntity(entityId);
      return Right(rows.map(RelationshipMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve relationships for entity',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Relationship?>> getDuplicate(
      String sourceId, String targetId, String typeKey) async {
    try {
      final row = await _dao.getDuplicate(sourceId, targetId, typeKey);
      return Right(row != null ? RelationshipMapper.toDomain(row) : null);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to check duplicate relationship',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Relationship>> getById(String id) async {
    try {
      final row = await _dao.getById(id);
      if (row == null) {
        return Left(Failure.notFound(resourceType: 'Relationship', resourceId: id));
      }
      return Right(RelationshipMapper.toDomain(row));
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve relationship from database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<Relationship>>> getAllActive() async {
    try {
      final rows = await _dao.getAllActive();
      return Right(rows.map(RelationshipMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve active relationships',
        originalError: e,
      ));
    }
  }
}
