import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../relationship/relationship.dart';
import '../../repository/relationship_repository.dart';

@lazySingleton
class GetRelationshipsForEntityUseCase {
  final RelationshipRepository _repository;

  GetRelationshipsForEntityUseCase(this._repository);

  Future<Either<Failure, List<Relationship>>> call(String entityId) async {
    return _repository.getRelationshipsForEntity(entityId);
  }
}
