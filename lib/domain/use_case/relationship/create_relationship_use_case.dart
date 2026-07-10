import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../relationship/relationship.dart';
import '../../relationship/relationship_type_registry.dart';
import '../../repository/relationship_repository.dart';

class CreateRelationshipParams {
  final String sourceId;
  final String targetId;
  final String typeKey;
  final String? description;
  final int weight;

  const CreateRelationshipParams({
    required this.sourceId,
    required this.targetId,
    required this.typeKey,
    this.description,
    this.weight = 5,
  });
}

class CreateRelationshipResult {
  final Relationship relationship;
  final String? reciprocalSuggestionTypeKey;

  const CreateRelationshipResult({
    required this.relationship,
    this.reciprocalSuggestionTypeKey,
  });
}

@lazySingleton
class CreateRelationshipUseCase
    implements UseCase<CreateRelationshipResult, CreateRelationshipParams> {
  final RelationshipRepository _repository;

  CreateRelationshipUseCase(this._repository);

  @override
  Future<Either<Failure, CreateRelationshipResult>> call(
      CreateRelationshipParams params) async {
    if (params.sourceId == params.targetId) {
      return const Left(Failure.validation(
        message: 'An entity cannot have a relationship with itself.',
      ));
    }

    final typeDef = RelationshipTypeRegistry.getDef(params.typeKey);
    final isBidi = typeDef?.isBidirectional ?? false;

    // Lexicographical normalization for bidirectional links
    String normSourceId = params.sourceId;
    String normTargetId = params.targetId;
    if (isBidi) {
      if (params.sourceId.compareTo(params.targetId) > 0) {
        normSourceId = params.targetId;
        normTargetId = params.sourceId;
      }
    }

    // Check duplicate
    final dupCheck = await _repository.getDuplicate(
      normSourceId,
      normTargetId,
      params.typeKey,
    );

    return dupCheck.fold(
      (failure) => Left(failure),
      (existingRel) async {
        if (existingRel != null) {
          return const Left(Failure.validation(
            message: 'This relationship already exists',
          ));
        }

        final relationship = Relationship(
          id: const Uuid().v4(),
          sourceId: normSourceId,
          targetId: normTargetId,
          typeKey: params.typeKey,
          description: params.description,
          weight: params.weight,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final createResult = await _repository.create(relationship);
        return createResult.fold(
          (failure) => Left(failure),
          (savedRel) async {
            // Check for reciprocal suggestion
            String? reciprocalKey;
            if (!isBidi) {
              final inverseKey =
                  RelationshipTypeRegistry.getInverseKey(params.typeKey);
              if (inverseKey != null) {
                // Check if reciprocal already exists
                final reciprocalDup = await _repository.getDuplicate(
                  params.targetId,
                  params.sourceId,
                  inverseKey,
                );
                final hasReciprocal = reciprocalDup.fold(
                  (_) => false,
                  (rel) => rel != null,
                );
                if (!hasReciprocal) {
                  reciprocalKey = inverseKey;
                }
              }
            }

            return Right(CreateRelationshipResult(
              relationship: savedRel,
              reciprocalSuggestionTypeKey: reciprocalKey,
            ));
          },
        );
      },
    );
  }
}
