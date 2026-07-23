import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/data/dao/manuscript_dao.dart';
import 'package:fictionist/data/mapper/manuscript_mapper.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';


@lazySingleton
class ManuscriptRepositoryImpl {
  final ManuscriptDao _dao;

  ManuscriptRepositoryImpl(this._dao);

  Future<Either<Failure, ManuscriptChapter>> create(
    ManuscriptChapter chapter,
  ) async {
    try {
      final companion = ManuscriptMapper.toCompanion(chapter);
      await _dao.insertChapter(companion);
      return Right(chapter);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to create chapter',
        originalError: e,
      ));
    }
  }

  Future<Either<Failure, ManuscriptChapter>> getById(String id) async {
    try {
      final row = await _dao.getById(id);
      if (row == null) {
        return Left(
          Failure.notFound(resourceType: 'ManuscriptChapter', resourceId: id),
        );
      }
      return Right(ManuscriptMapper.toDomain(row));
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to fetch chapter',
        originalError: e,
      ));
    }
  }

  Future<Either<Failure, ManuscriptChapter>> update(
    ManuscriptChapter chapter,
  ) async {
    try {
      final companion = ManuscriptMapper.toCompanion(chapter);
      final success = await _dao.updateChapter(companion);
      if (!success) {
        return Left(Failure.notFound(
          resourceType: 'ManuscriptChapter',
          resourceId: chapter.id,
        ));
      }
      return Right(chapter);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to update chapter',
        originalError: e,
      ));
    }
  }

  Future<Either<Failure, Unit>> softDelete(String id) async {
    try {
      final count = await _dao.softDelete(id);
      if (count == 0) {
        return Left(
          Failure.notFound(resourceType: 'ManuscriptChapter', resourceId: id),
        );
      }
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to delete chapter',
        originalError: e,
      ));
    }
  }

  Future<Either<Failure, List<ManuscriptChapter>>> getAllActive() async {
    try {
      final rows = await _dao.getAllActive();
      return Right(rows.map(ManuscriptMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to list chapters',
        originalError: e,
      ));
    }
  }

  Future<Either<Failure, Unit>> reorder(
    List<String> chapterIdsInOrder,
  ) async {
    try {
      for (int i = 0; i < chapterIdsInOrder.length; i++) {
        await _dao.updateSortOrder(chapterIdsInOrder[i], i);
      }
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to reorder chapters',
        originalError: e,
      ));
    }
  }
}
