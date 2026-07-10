// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trait_inheritance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TraitInheritance _$TraitInheritanceFromJson(Map<String, dynamic> json) =>
    _TraitInheritance(
      traitKey: json['traitKey'] as String,
      traitLabel: json['traitLabel'] as String,
      traitValue: json['traitValue'] as String,
      entityId: json['entityId'] as String,
      entityName: json['entityName'] as String,
      inheritedFromIds: (json['inheritedFromIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      inheritedFromNames: (json['inheritedFromNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isInherited: json['isInherited'] as bool? ?? false,
      colorIndex: (json['colorIndex'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TraitInheritanceToJson(_TraitInheritance instance) =>
    <String, dynamic>{
      'traitKey': instance.traitKey,
      'traitLabel': instance.traitLabel,
      'traitValue': instance.traitValue,
      'entityId': instance.entityId,
      'entityName': instance.entityName,
      'inheritedFromIds': instance.inheritedFromIds,
      'inheritedFromNames': instance.inheritedFromNames,
      'isInherited': instance.isInherited,
      'colorIndex': instance.colorIndex,
    };
