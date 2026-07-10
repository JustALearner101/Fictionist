import 'package:freezed_annotation/freezed_annotation.dart';

part 'culture.freezed.dart';
part 'culture.g.dart';

/// A culture profile defining phoneme pools, syllable patterns,
/// and naming conventions for procedurally generated names.
@freezed
abstract class Culture with _$Culture {
  const factory Culture({
    required String name,
    required String description,
    /// Consonant sounds available in this language.
    required List<String> consonants,
    /// Vowel sounds available in this language.
    required List<String> vowels,
    /// Syllable patterns: 'CVC' = consonant-vowel-consonant, 'CV' = consonant-vowel, etc.
    required List<String> syllablePatterns,
    /// Forbidden consonant clusters (e.g., ['tk', 'dg', 'bp']).
    @Default([]) List<String> forbiddenClusters,
    /// Probability weights corresponding to [syllablePatterns] order.
    @Default([0.4, 0.35, 0.25]) List<double> patternWeights,
    /// Minimum syllables per generated name.
    @Default(1) int minSyllables,
    /// Maximum syllables per generated name.
    @Default(3) int maxSyllables,
    /// Prefixes used for faction/group name generation.
    @Default([]) List<String> factionPrefixes,
    /// Suffixes used for faction/group name generation.
    @Default([]) List<String> factionSuffixes,
    /// Prefixes used for artifact/item name generation.
    @Default([]) List<String> artifactPrefixes,
    /// Suffixes used for artifact/item name generation.
    @Default([]) List<String> artifactSuffixes,
    /// Prefixes used for location/place name generation.
    @Default([]) List<String> locationPrefixes,
    /// Suffixes used for location/place name generation.
    @Default([]) List<String> locationSuffixes,
    /// Epithets used for legendary title generation.
    @Default([]) List<String> epithets,
  }) = _Culture;

  factory Culture.fromJson(Map<String, dynamic> json) =>
      _$CultureFromJson(json);
}
