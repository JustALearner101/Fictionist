import 'package:freezed_annotation/freezed_annotation.dart';

part 'trait_inheritance.freezed.dart';
part 'trait_inheritance.g.dart';

/// Represents a heritable trait found on a character and its
/// inheritance path through the family tree.
@freezed
abstract class TraitInheritance with _$TraitInheritance {
  const factory TraitInheritance({
    /// The trait/custom-field key (e.g., 'hair_color', 'eye_color').
    required String traitKey,

    /// The trait label (e.g., 'Hair Color').
    required String traitLabel,

    /// The trait value (e.g., 'Silver', 'Blue').
    required String traitValue,

    /// The character entity ID that exhibits this trait.
    required String entityId,

    /// The character name.
    required String entityName,

    /// IDs of ancestor entities that also carry this trait.
    @Default([]) List<String> inheritedFromIds,

    /// Names of ancestor entities that also carry this trait.
    @Default([]) List<String> inheritedFromNames,

    /// Whether this trait was inherited from at least one ancestor.
    @Default(false) bool isInherited,

    /// A deterministic color index for rendering the trait badge.
    @Default(0) int colorIndex,
  }) = _TraitInheritance;

  factory TraitInheritance.fromJson(Map<String, dynamic> json) =>
      _$TraitInheritanceFromJson(json);
}
