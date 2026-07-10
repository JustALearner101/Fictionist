import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../entity/entity_type.dart';
import '../../repository/template_repository.dart';
import '../../template/template.dart';

@lazySingleton
class GetTemplatesUseCase implements UseCase<List<Template>, EntityType?> {
  final TemplateRepository _repository;

  GetTemplatesUseCase(this._repository);

  @override
  Future<Either<Failure, List<Template>>> call(EntityType? type) {
    if (type != null) {
      return _repository.getTemplatesByType(type);
    }
    return _repository.getAllTemplates();
  }
}
