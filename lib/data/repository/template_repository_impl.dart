import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failure.dart';
import '../../domain/entity/entity_type.dart';
import '../../domain/repository/template_repository.dart';
import '../../domain/template/template.dart';
import '../dao/template_dao.dart';
import '../mapper/template_mapper.dart';

@LazySingleton(as: TemplateRepository)
class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateDao _dao;

  TemplateRepositoryImpl(this._dao);

  @override
  Future<Either<Failure, Template>> create(Template template) async {
    try {
      final companion = TemplateMapper.toCompanion(template);
      await _dao.insertTemplate(companion);
      return Right(template);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to create template in database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Template>> update(Template template) async {
    try {
      final companion = TemplateMapper.toCompanion(template);
      final success = await _dao.updateTemplate(companion);
      if (!success) {
        return Left(Failure.notFound(
            resourceType: 'Template', resourceId: template.id));
      }
      return Right(template);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to update template in database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      final count = await _dao.deleteTemplate(id);
      if (count == 0) {
        return Left(Failure.notFound(
            resourceType: 'Template',
            resourceId: '$id (or template is built-in and protected)'));
      }
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to delete template in database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<Template>>> getAllTemplates() async {
    try {
      final rows = await _dao.getAllTemplates();
      return Right(rows.map(TemplateMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve templates from database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<Template>>> getTemplatesByType(
      EntityType entityType) async {
    try {
      final rows = await _dao.getTemplatesByType(entityType.key);
      return Right(rows.map(TemplateMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve templates by type',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Template>> getTemplateById(String id) async {
    try {
      final row = await _dao.getTemplateById(id);
      if (row == null) {
        return Left(Failure.notFound(resourceType: 'Template', resourceId: id));
      }
      return Right(TemplateMapper.toDomain(row));
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve template from database',
        originalError: e,
      ));
    }
  }
}
