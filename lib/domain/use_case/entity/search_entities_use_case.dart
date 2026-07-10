import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../entity/entity.dart';
import '../../repository/entity_repository.dart';

@lazySingleton
class SearchEntitiesUseCase implements UseCase<List<Entity>, String> {
  final EntityRepository _repository;

  SearchEntitiesUseCase(this._repository);

  @override
  Future<Either<Failure, List<Entity>>> call(String query) {
    return _repository.search(query);
  }
}
