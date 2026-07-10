// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Template _$TemplateFromJson(Map<String, dynamic> json) => _Template(
      id: json['id'] as String,
      name: json['name'] as String,
      entityType: $enumDecode(_$EntityTypeEnumMap, json['entityType']),
      customFieldsSchema: (json['customFieldsSchema'] as List<dynamic>?)
              ?.map((e) => CustomField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isBuiltIn: json['isBuiltIn'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TemplateToJson(_Template instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'entityType': _$EntityTypeEnumMap[instance.entityType]!,
      'customFieldsSchema': instance.customFieldsSchema,
      'isBuiltIn': instance.isBuiltIn,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$EntityTypeEnumMap = {
  EntityType.character: 'character',
  EntityType.faction: 'faction',
  EntityType.raceCulture: 'raceCulture',
  EntityType.location: 'location',
  EntityType.powerMagicSystem: 'powerMagicSystem',
  EntityType.itemArtifact: 'itemArtifact',
  EntityType.event: 'event',
  EntityType.conceptGlossary: 'conceptGlossary',
};
