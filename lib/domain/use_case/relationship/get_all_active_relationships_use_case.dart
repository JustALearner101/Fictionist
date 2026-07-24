import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../relationship/relationship.dart';
import '../../repository/relationship_repository.dart';

@lazySingleton
class GetAllActiveRelationshipsUseCase {
  final RelationshipRepository _repository;

  GetAllActiveRelationshipsUseCase(this._repository);

  Future<Either<Failure, List<Relationship>>> call() async {
    return _repository.getAllActive();
  }
}
