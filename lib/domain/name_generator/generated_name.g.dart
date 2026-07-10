// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated_name.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeneratedName _$GeneratedNameFromJson(Map<String, dynamic> json) =>
    _GeneratedName(
      name: json['name'] as String,
      type: $enumDecode(_$GenerationTypeEnumMap, json['type']),
      archetype: json['archetype'] as String,
      components: (json['components'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GeneratedNameToJson(_GeneratedName instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$GenerationTypeEnumMap[instance.type]!,
      'archetype': instance.archetype,
      'components': instance.components,
    };

const _$GenerationTypeEnumMap = {
  GenerationType.characterName: 'characterName',
  GenerationType.factionName: 'factionName',
  GenerationType.artifactName: 'artifactName',
  GenerationType.locationName: 'locationName',
  GenerationType.legendaryTitle: 'legendaryTitle',
};
