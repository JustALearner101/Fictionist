import 'package:fpdart/fpdart.dart';
import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';

/// Abstract repository for manuscript chapter operations.
abstract class ManuscriptRepository {
  Future<Either<Failure, ManuscriptChapter>> create(
    ManuscriptChapter chapter,
  );

  Future<Either<Failure, ManuscriptChapter>> getById(String id);

  Future<Either<Failure, ManuscriptChapter>> update(
    ManuscriptChapter chapter,
  );

  Future<Either<Failure, Unit>> softDelete(String id);

  Future<Either<Failure, List<ManuscriptChapter>>> getAllActive();

  Future<Either<Failure, Unit>> reorder(
    List<String> chapterIdsInOrder,
  );
}
