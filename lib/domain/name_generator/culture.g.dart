// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'culture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Culture _$CultureFromJson(Map<String, dynamic> json) => _Culture(
      name: json['name'] as String,
      description: json['description'] as String,
      consonants: (json['consonants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      vowels:
          (json['vowels'] as List<dynamic>).map((e) => e as String).toList(),
      syllablePatterns: (json['syllablePatterns'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      forbiddenClusters: (json['forbiddenClusters'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      patternWeights: (json['patternWeights'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [0.4, 0.35, 0.25],
      minSyllables: (json['minSyllables'] as num?)?.toInt() ?? 1,
      maxSyllables: (json['maxSyllables'] as num?)?.toInt() ?? 3,
      factionPrefixes: (json['factionPrefixes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      factionSuffixes: (json['factionSuffixes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      artifactPrefixes: (json['artifactPrefixes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      artifactSuffixes: (json['artifactSuffixes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      locationPrefixes: (json['locationPrefixes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      locationSuffixes: (json['locationSuffixes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      epithets: (json['epithets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CultureToJson(_Culture instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'consonants': instance.consonants,
      'vowels': instance.vowels,
      'syllablePatterns': instance.syllablePatterns,
      'forbiddenClusters': instance.forbiddenClusters,
      'patternWeights': instance.patternWeights,
      'minSyllables': instance.minSyllables,
      'maxSyllables': instance.maxSyllables,
      'factionPrefixes': instance.factionPrefixes,
      'factionSuffixes': instance.factionSuffixes,
      'artifactPrefixes': instance.artifactPrefixes,
      'artifactSuffixes': instance.artifactSuffixes,
      'locationPrefixes': instance.locationPrefixes,
      'locationSuffixes': instance.locationSuffixes,
      'epithets': instance.epithets,
    };
