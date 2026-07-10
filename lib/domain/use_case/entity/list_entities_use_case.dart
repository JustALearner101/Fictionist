import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../entity/entity.dart';
import '../../entity/entity_status.dart';
import '../../entity/entity_type.dart';
import '../../repository/entity_repository.dart';

class ListEntitiesParams {
  final EntityType? type;
  final EntityStatus? status;

  const ListEntitiesParams({this.type, this.status});
}

@lazySingleton
class ListEntitiesUseCase implements UseCase<List<Entity>, ListEntitiesParams> {
  final EntityRepository _repository;

  ListEntitiesUseCase(this._repository);

  @override
  Future<Either<Failure, List<Entity>>> call(ListEntitiesParams params) async {
    if (params.type != null) {
      final result = await _repository.getActiveByType(params.type!);
      if (params.status == null) return result;
      return result.map(
        (list) => list.where((e) => e.status == params.status).toList(),
      );
    }

    if (params.status != null) {
      final result = await _repository.getActiveByStatus(params.status!);
      return result;
    }

    return _repository.getAllActive();
  }
}
