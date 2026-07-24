import 'dart:convert';
import 'dart:developer' as dev;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failure.dart';
import '../../domain/entity/entity.dart';
import '../../domain/entity/entity_status.dart';
import '../../domain/entity/entity_type.dart';
import '../../domain/search/search_result.dart';
import '../dao/entity_dao.dart';
import '../mapper/entity_mapper.dart';

@lazySingleton
class EntityRepositoryImpl {
  final EntityDao _dao;

  EntityRepositoryImpl(this._dao);

  Future<Either<Failure, Entity>> create(Entity entity, {String? projectId}) async {
    try {
      dev.log('EntityRepository.create: name=${entity.name}, type=${entity.type.key}, id=${entity.id}');
      final companion = EntityMapper.toCompanion(entity, projectId: projectId);
      dev.log('Companion: name=${companion.name.value}, entityType=${companion.entityType.value}');
      await _dao.insertEntity(companion);
      dev.log('Entity inserted successfully: ${entity.id}');
      return Right(entity);
    } catch (e, st) {
      dev.log('Entity create FAILED: $e', level: 1000);
      dev.log('Stack: $st', level: 1000);
      final json = jsonEncode(entity.toJson());
      dev.log('Entity JSON: $json', level: 1000);
      return Left(Failure.database(
        message: 'Failed to create entity: $e',
        originalError: e,
      ));
    }
  }

  Future<Either<Failure, Entity>> getById(String id, {String? projectId}) async {
    try {
      final row = await _dao.getById(id, projectId);
      if (row == null) {
        return Left(Failure.notFound(resourceType: 'Entity', resourceId: id));
      }
      return Right(EntityMapper.toDomain(row));
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve entity from database',
        originalError: e,
      ));
    }
  }

  Future<Either<Failure, Entity>> update(Entity entity) async {
    try {
      final companion = EntityMapper.toCompanion(entity);
      final success = await _dao.updateEntity(companion);
      if (!success) {
        return Left(Failure.notFound(resourceType: 'Entity', resourceId: entity.id));
      }
      return Right(entity);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to update entity in database',
        originalError: e,
      ));
    }
  }

  Future<Either<Failure, Unit>> softDelete(String id) async {
    try {
      final count = await _dao.deleteEntity(id);
      if (count == 0) {
        return Left(Failure.notFound(resourceType: 'Entity', resourceId: id));
      }
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to soft delete entity in database',
        originalError: e,
      ));
    }
  }

  Future<Either<Failure, List<Entity>>> search(String query, {String? projectId}) async {
    try {
      if (query.trim().isEmpty) {
        return const Right([]);
      }
      final results = await _dao.searchFts(query, projectId);
      final list = <Entity>[];
      for (final res in results) {
        final entityId = res['entity_id'] as String;
        final row = await _dao.getById(entityId);
        if (row != null && !row.isDeleted) {
          list.add(EntityMapper.toDomain(row));
        }
      }
      return Right(list);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to perform search query',
        originalError: e,
      ));
    }
  }

  Future<Either<Failure, List<SearchResult>>> searchWithSnippets(
      String query, {String? projectId}) async {
    try {
      if (query.trim().isEmpty) {
        return const Right([]);
      }
      final results = await _dao.searchFts(query, projectId);
      final list = <SearchResult>[];
      for (final res in results) {
        final entityId = res['entity_id'] as String;
        final snippet = res['snippet'] as String;
        final row = await _dao.getById(entityId);
        if (row != null && !row.isDeleted) {
          list.add(SearchResult(
            entity: EntityMapper.toDomain(row),
            snippet: snippet,
          ));
        }
      }
      return Right(list);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to perform snippet search query',
        originalError: e,
      ));
    }
  }

  Future<Either<Failure, List<Entity>>> getAllActive({String? projectId}) async {
    try {
      final rows = await _dao.getAllActive(projectId);
      return Right(rows.map(EntityMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve active entities',
        originalError: e,
      ));
    }
  }

  Future<Either<Failure, List<Entity>>> getActiveByType(EntityType type, {String? projectId}) async {
    try {
      final rows = await _dao.getActiveByType(type.key, projectId);
      return Right(rows.map(EntityMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve active entities by type',
        originalError: e,
      ));
    }
  }

  Future<Either<Failure, List<Entity>>> getActiveByStatus(
      EntityStatus status, {String? projectId}) async {
    try {
      final rows = await _dao.getActiveByStatus(status.key, projectId);
      return Right(rows.map(EntityMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve active entities by status',
        originalError: e,
      ));
    }
  }

  Future<Either<Failure, Unit>> purgeSoftDeleted() async {
    try {
      await _dao.customStatement('DELETE FROM entities WHERE is_deleted = 1');
      await _dao.customStatement('DELETE FROM relationships WHERE is_deleted = 1');
      await _dao.customStatement('DELETE FROM timeline_entries WHERE is_deleted = 1');
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to purge soft-deleted items from database',
        originalError: e,
      ));
    }
  }

  Future<Either<Failure, Unit>> purgeAllData() async {
    try {
      // This must be done in order respecting foreign keys:
      // tables with FK dependencies first, then parents
      await _dao.customStatement('DELETE FROM entity_fts');
      await _dao.customStatement('DELETE FROM entity_tags');
      await _dao.customStatement('DELETE FROM chapter_snapshots');
      await _dao.customStatement('DELETE FROM map_pins');
      await _dao.customStatement('DELETE FROM plot_connections');
      await _dao.customStatement('DELETE FROM setup_payoffs');
      await _dao.customStatement('DELETE FROM entity_versions');
      await _dao.customStatement('DELETE FROM timeline_entries');
      await _dao.customStatement('DELETE FROM relationships');
      await _dao.customStatement('DELETE FROM plot_cards');
      await _dao.customStatement('DELETE FROM manuscript_chapters');
      await _dao.customStatement('DELETE FROM world_maps');
      await _dao.customStatement('DELETE FROM templates');
      await _dao.customStatement('DELETE FROM tags');
      await _dao.customStatement('DELETE FROM entities');
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to purge all data from database',
        originalError: e,
      ));
    }
  }
}
