// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plot_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlotCard _$PlotCardFromJson(Map<String, dynamic> json) => _PlotCard(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String?,
      xPosition: (json['xPosition'] as num).toDouble(),
      yPosition: (json['yPosition'] as num).toDouble(),
      colorHex: (json['colorHex'] as num?)?.toInt() ?? 0xFFA78BFA,
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PlotCardToJson(_PlotCard instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'summary': instance.summary,
      'xPosition': instance.xPosition,
      'yPosition': instance.yPosition,
      'colorHex': instance.colorHex,
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_PlotConnection _$PlotConnectionFromJson(Map<String, dynamic> json) =>
    _PlotConnection(
      id: json['id'] as String,
      sourceId: json['sourceId'] as String,
      targetId: json['targetId'] as String,
      label: json['label'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PlotConnectionToJson(_PlotConnection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceId': instance.sourceId,
      'targetId': instance.targetId,
      'label': instance.label,
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt.toIso8601String(),
    };
