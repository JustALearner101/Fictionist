import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../repository/tag_repository.dart';

class AssignTagParams {
  final String entityId;
  final String tagId;

  const AssignTagParams({required this.entityId, required this.tagId});
}

@lazySingleton
class AssignTagUseCase implements UseCase<Unit, AssignTagParams> {
  final TagRepository _repository;

  AssignTagUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(AssignTagParams params) {
    return _repository.assignTagToEntity(params.entityId, params.tagId);
  }
}
