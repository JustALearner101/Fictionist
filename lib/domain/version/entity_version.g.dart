// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EntityVersion _$EntityVersionFromJson(Map<String, dynamic> json) =>
    _EntityVersion(
      id: json['id'] as String,
      entityId: json['entityId'] as String,
      snapshotJson: json['snapshotJson'] as String,
      changedAt: DateTime.parse(json['changedAt'] as String),
      changeNote: json['changeNote'] as String?,
    );

Map<String, dynamic> _$EntityVersionToJson(_EntityVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityId': instance.entityId,
      'snapshotJson': instance.snapshotJson,
      'changedAt': instance.changedAt.toIso8601String(),
      'changeNote': instance.changeNote,
    };
