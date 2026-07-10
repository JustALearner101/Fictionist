// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimelineEntry _$TimelineEntryFromJson(Map<String, dynamic> json) =>
    _TimelineEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dateLabel: json['dateLabel'] as String?,
      eraLabel: json['eraLabel'] as String?,
      sortOrder: (json['sortOrder'] as num).toInt(),
      entityId: json['entityId'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TimelineEntryToJson(_TimelineEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dateLabel': instance.dateLabel,
      'eraLabel': instance.eraLabel,
      'sortOrder': instance.sortOrder,
      'entityId': instance.entityId,
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
