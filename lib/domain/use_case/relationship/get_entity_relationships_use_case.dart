import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../relationship/relationship.dart';
import '../../repository/relationship_repository.dart';

@lazySingleton
class GetEntityRelationshipsUseCase
    implements UseCase<List<Relationship>, String> {
  final RelationshipRepository _repository;

  GetEntityRelationshipsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Relationship>>> call(String entityId) {
    return _repository.getRelationshipsForEntity(entityId);
  }
}
