import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../data/repository/entity_repository_impl.dart';
import '../../repository/relationship_repository.dart';

@lazySingleton
class DeleteEntityUseCase {
  final EntityRepositoryImpl _entityRepository;
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
