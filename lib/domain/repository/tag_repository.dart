import 'package:fpdart/fpdart.dart';
import '../../core/error/failure.dart';
import '../tag/tag.dart';

abstract class TagRepository {
  Future<Either<Failure, Tag>> create(Tag tag);
  Future<Either<Failure, List<Tag>>> getAllTags();
  Future<Either<Failure, Tag>> getById(String id);
  Future<Either<Failure, Tag?>> getByName(String name);
  Future<Either<Failure, Unit>> assignTagToEntity(String entityId, String tagId);
  Future<Either<Failure, Unit>> removeTagFromEntity(String entityId, String tagId);
  Future<Either<Failure, Unit>> removeAllTagsFromEntity(String entityId);
  Future<Either<Failure, List<Tag>>> getTagsForEntity(String entityId);
}
