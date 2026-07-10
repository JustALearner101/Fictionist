import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../relationship/relationship.dart';
import '../../repository/relationship_repository.dart';

@lazySingleton
class GetAllRelationshipsUseCase implements UseCaseNoParams<List<Relationship>> {
  final RelationshipRepository _repository;

  GetAllRelationshipsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Relationship>>> call() {
    return _repository.getAllActive();
  }
}
