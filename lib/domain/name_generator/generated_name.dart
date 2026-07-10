import 'package:freezed_annotation/freezed_annotation.dart';

import 'generation_type.dart';

part 'generated_name.freezed.dart';
part 'generated_name.g.dart';

/// A single generated name with metadata about its origin.
@freezed
abstract class GeneratedName with _$GeneratedName {
  const factory GeneratedName({
    /// The generated name string.
    required String name,

    /// The category of name generation.
    required GenerationType type,

    /// The cultural archetype used for generation
    /// (e.g., 'Elven', 'Dwarven').
    required String archetype,

    /// The raw syllable components used, for display or regeneration.
    @Default([]) List<String> components,
  }) = _GeneratedName;

  factory GeneratedName.fromJson(Map<String, dynamic> json) =>
      _$GeneratedNameFromJson(json);
}
