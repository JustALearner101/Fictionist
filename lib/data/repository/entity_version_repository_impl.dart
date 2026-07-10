import 'dart:convert';
import 'dart:developer' as dev;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failure.dart';
import '../../domain/repository/entity_version_repository.dart';
import '../../domain/version/entity_version.dart';
import '../dao/entity_version_dao.dart';
import '../mapper/entity_version_mapper.dart';

@LazySingleton(as: EntityVersionRepository)
class EntityVersionRepositoryImpl implements EntityVersionRepository {
  final EntityVersionDao _dao;

  EntityVersionRepositoryImpl(this._dao);

  @override
  Future<Either<Failure, EntityVersion>> create(EntityVersion version) async {
    try {
      dev.log('EntityVersion.create: entityId=${version.entityId}, versionId=${version.id}');
      final companion = EntityVersionMapper.toCompanion(version);
      await _dao.insertVersion(companion);
      dev.log('Version created: ${version.id}');
      return Right(version);
    } catch (e, st) {
      dev.log('Version create FAILED: $e', level: 1000);
      dev.log('Stack: $st', level: 1000);
      final json = jsonEncode(version.toJson());
      dev.log('Version JSON: $json', level: 1000);
      return Left(Failure.database(
        message: 'Failed to save entity version snapshot',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<EntityVersion>>> getVersionsForEntity(
      String entityId) async {
    try {
      final rows = await _dao.getVersionsForEntity(entityId);
      return Right(rows.map(EntityVersionMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve entity versions',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, EntityVersion>> getVersionById(String id) async {
    try {
      final row = await _dao.getVersionById(id);
      if (row == null) {
        return Left(Failure.notFound(resourceType: 'EntityVersion', resourceId: id));
      }
      return Right(EntityVersionMapper.toDomain(row));
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve entity version from database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> pruneOldVersions(
      String entityId, int keepLimit) async {
    try {
      await _dao.pruneOldVersions(entityId, keepLimit);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to prune older entity versions',
        originalError: e,
      ));
    }
  }
}
