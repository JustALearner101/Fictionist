import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/core/use_case/use_case.dart';
import 'package:fictionist/domain/name_generator/generated_name.dart';
import 'package:fictionist/domain/name_generator/generation_type.dart';
import 'package:fictionist/domain/name_generator/name_generator_params.dart';
import 'package:fictionist/domain/repository/name_generator_repository.dart';

/// Generates thematic names (characters, factions, artifacts, locations)
/// from syllable-based JSON asset data.
///
/// Returns [ValidationFailure] if [NameGeneratorParams.count] is less than 1
/// or greater than 50.
@lazySingleton
class GenerateNamesUseCase
    implements UseCase<List<GeneratedName>, NameGeneratorParams> {
  final NameGeneratorRepository _repository;

  GenerateNamesUseCase(this._repository);

  @override
  Future<Either<Failure, List<GeneratedName>>> call(
    NameGeneratorParams params,
  ) async {
    if (params.count < 1) {
      return const Left(Failure.validation(
        message: 'Must generate at least 1 name',
        field: 'count',
      ));
    }

    if (params.count > 50) {
      return Left(Failure.validation(
        message:
            'Cannot generate more than 50 names at once '
            '(requested: ${params.count})',
        field: 'count',
      ));
    }

    return _repository.generate(params);
  }

  /// Delegates to the repository's archetype lookup.
  List<String> getArchetypesForType(GenerationType type) {
    return _repository.getArchetypesForType(type);
  }
}
