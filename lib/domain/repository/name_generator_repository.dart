import 'package:fpdart/fpdart.dart';

import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/domain/name_generator/generated_name.dart';
import 'package:fictionist/domain/name_generator/generation_type.dart';
import 'package:fictionist/domain/name_generator/name_generator_params.dart';

/// Abstract repository for generating thematic names
/// from syllable/assets data.
abstract class NameGeneratorRepository {
  /// Generates a list of [GeneratedName]s based on the given [params].
  Future<Either<Failure, List<GeneratedName>>> generate(
    NameGeneratorParams params,
  );

  /// Returns the list of available archetypes for a given [type].
  List<String> getArchetypesForType(GenerationType type);
}
