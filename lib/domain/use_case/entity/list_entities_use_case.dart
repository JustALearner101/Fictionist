import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../entity/entity.dart';
import '../../entity/entity_status.dart';
import '../../entity/entity_type.dart';
import '../../../data/repository/entity_repository_impl.dart';

class ListEntitiesParams {
  final EntityType? type;
  final EntityStatus? status;
  final String? projectId;

  const ListEntitiesParams({this.type, this.status, this.projectId});
}

@lazySingleton
class ListEntitiesUseCase {
  final EntityRepositoryImpl _repository;

  ListEntitiesUseCase(this._repository);

  Future<Either<Failure, List<Entity>>> call(ListEntitiesParams params) async {
    if (params.type != null) {
      final result = await _repository.getActiveByType(params.type!, projectId: params.projectId);
      if (params.status == null) return result;
      return result.map(
        (list) => list.where((e) => e.status == params.status).toList(),
      );
    }

    if (params.status != null) {
      final result = await _repository.getActiveByStatus(params.status!, projectId: params.projectId);
      return result;
    }

    return _repository.getAllActive(projectId: params.projectId);
  }
}
