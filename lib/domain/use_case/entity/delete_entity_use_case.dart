import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../repository/entity_repository.dart';
import '../../repository/relationship_repository.dart';

@lazySingleton
class DeleteEntityUseCase implements UseCase<Unit, String> {
  final EntityRepository _entityRepository;
  final RelationshipRepository _relationshipRepository;

  DeleteEntityUseCase(this._entityRepository, this._relationshipRepository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    final deleteResult = await _entityRepository.softDelete(id);
    return deleteResult.fold(
      (failure) => Left(failure),
      (_) async {
        // Cascade delete relationships involving this entity
        final relResult = await _relationshipRepository.deleteForEntity(id);
        return relResult.fold(
          (failure) => Left(failure),
          (_) => const Right(unit),
        );
      },
    );
  }
}
