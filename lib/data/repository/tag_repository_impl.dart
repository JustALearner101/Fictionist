import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failure.dart';
import '../../domain/repository/tag_repository.dart';
import '../../domain/tag/tag.dart';
import '../dao/tag_dao.dart';
import '../database/app_database.dart';
import '../mapper/tag_mapper.dart';

@LazySingleton(as: TagRepository)
class TagRepositoryImpl implements TagRepository {
  final TagDao _dao;

  TagRepositoryImpl(this._dao);

  @override
  Future<Either<Failure, Tag>> create(Tag tag) async {
    try {
      final companion = TagMapper.toCompanion(tag);
      await _dao.insertTag(companion);
      return Right(tag);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to create tag in database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<Tag>>> getAllTags() async {
    try {
      final rows = await _dao.getAllTags();
      return Right(rows.map(TagMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve tags from database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Tag>> getById(String id) async {
    try {
      final row = await _dao.getTagById(id);
      if (row == null) {
        return Left(Failure.notFound(resourceType: 'Tag', resourceId: id));
      }
      return Right(TagMapper.toDomain(row));
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve tag from database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Tag?>> getByName(String name) async {
    try {
      final row = await _dao.getTagByName(name);
      return Right(row != null ? TagMapper.toDomain(row) : null);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve tag by name',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> assignTagToEntity(
      String entityId, String tagId) async {
    try {
      final companion = EntityTagsCompanion(
        entityId: Value(entityId),
        tagId: Value(tagId),
      );
      await _dao.assignTagToEntity(companion);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to assign tag to entity',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeTagFromEntity(
      String entityId, String tagId) async {
    try {
      await _dao.removeTagFromEntity(entityId, tagId);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to remove tag from entity',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeAllTagsFromEntity(String entityId) async {
    try {
      await _dao.removeAllTagsFromEntity(entityId);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to clear tags for entity',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<Tag>>> getTagsForEntity(String entityId) async {
    try {
      final rows = await _dao.getTagsForEntity(entityId);
      return Right(rows.map(TagMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve tags associated with entity',
        originalError: e,
      ));
    }
  }
}
