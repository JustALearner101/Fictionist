// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_pin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MapPin _$MapPinFromJson(Map<String, dynamic> json) => _MapPin(
      id: json['id'] as String,
      mapId: json['mapId'] as String,
      entityId: json['entityId'] as String,
      xPercent: (json['xPercent'] as num).toDouble(),
      yPercent: (json['yPercent'] as num).toDouble(),
      label: json['label'] as String?,
    );

Map<String, dynamic> _$MapPinToJson(_MapPin instance) => <String, dynamic>{
      'id': instance.id,
      'mapId': instance.mapId,
      'entityId': instance.entityId,
      'xPercent': instance.xPercent,
      'yPercent': instance.yPercent,
      'label': instance.label,
    };
