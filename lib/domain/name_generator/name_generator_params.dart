import 'generation_type.dart';

/// Parameters for name generation.
class NameGeneratorParams {
  /// The category of name to generate.
  final GenerationType type;

  /// The cultural archetype (e.g., 'Elven', 'Dwarven').
  /// If null, a random archetype is selected.
  final String? archetype;

  /// Number of names to generate.
  final int count;

  const NameGeneratorParams({
    required this.type,
    this.archetype,
    this.count = 5,
  });
}
