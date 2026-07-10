import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../entity/entity.dart';
import '../../repository/entity_repository.dart';

@lazySingleton
class GetEntityUseCase implements UseCase<Entity, String> {
  final EntityRepository _repository;

  GetEntityUseCase(this._repository);

  @override
  Future<Either<Failure, Entity>> call(String id) {
    return _repository.getById(id);
  }
}
