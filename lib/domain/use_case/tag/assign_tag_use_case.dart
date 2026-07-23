import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../data/repository/tag_repository_impl.dart';

class AssignTagParams {
  final String entityId;
  final String tagId;

  const AssignTagParams({required this.entityId, required this.tagId});
}

@lazySingleton
class AssignTagUseCase {
  final TagRepositoryImpl _repository;

  AssignTagUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(AssignTagParams params) {
    return _repository.assignTagToEntity(params.entityId, params.tagId);
  }
}
