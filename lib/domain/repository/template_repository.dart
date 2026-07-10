import 'package:fpdart/fpdart.dart';
import '../../core/error/failure.dart';
import '../entity/entity_type.dart';
import '../template/template.dart';

abstract class TemplateRepository {
  Future<Either<Failure, Template>> create(Template template);
  Future<Either<Failure, Template>> update(Template template);
  Future<Either<Failure, Unit>> delete(String id);
  Future<Either<Failure, List<Template>>> getAllTemplates();
  Future<Either<Failure, List<Template>>> getTemplatesByType(
      EntityType entityType);
  Future<Either<Failure, Template>> getTemplateById(String id);
}
