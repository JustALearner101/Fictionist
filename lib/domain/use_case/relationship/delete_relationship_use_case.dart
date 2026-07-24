import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../repository/relationship_repository.dart';

@lazySingleton
class DeleteRelationshipUseCase {
  final RelationshipRepository _repository;

  DeleteRelationshipUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String id) async {
    return _repository.delete(id);
  }
}
