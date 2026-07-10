import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../repository/relationship_repository.dart';

@lazySingleton
class DeleteRelationshipUseCase implements UseCase<Unit, String> {
  final RelationshipRepository _repository;

  DeleteRelationshipUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return _repository.delete(id);
  }
}
