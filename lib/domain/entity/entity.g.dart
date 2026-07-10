// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Entity _$EntityFromJson(Map<String, dynamic> json) => _Entity(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$EntityTypeEnumMap, json['type']),
      status: $enumDecodeNullable(_$EntityStatusEnumMap, json['status']) ??
          EntityStatus.draft,
      description: json['description'] as String?,
      customFields: (json['customFields'] as List<dynamic>?)
              ?.map((e) => CustomField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      iconColor: (json['iconColor'] as num).toInt(),
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$EntityToJson(_Entity instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$EntityTypeEnumMap[instance.type]!,
      'status': _$EntityStatusEnumMap[instance.status]!,
      'description': instance.description,
      'customFields': instance.customFields,
      'iconColor': instance.iconColor,
      'isDeleted': instance.isDeleted,
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

const _$EntityStatusEnumMap = {
  EntityStatus.draft: 'draft',
  EntityStatus.canon: 'canon',
  EntityStatus.archived: 'archived',
  EntityStatus.deprecated: 'deprecated',
};
