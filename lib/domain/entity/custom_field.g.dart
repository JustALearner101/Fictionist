// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomField _$CustomFieldFromJson(Map<String, dynamic> json) => _CustomField(
      id: json['id'] as String,
      key: json['key'] as String,
      label: json['label'] as String,
      fieldType: json['fieldType'] as String,
      value: json['value'],
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CustomFieldToJson(_CustomField instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'label': instance.label,
      'fieldType': instance.fieldType,
      'value': instance.value,
      'options': instance.options,
      'sortOrder': instance.sortOrder,
    };
