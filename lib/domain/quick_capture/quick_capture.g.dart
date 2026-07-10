// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_capture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuickCapture _$QuickCaptureFromJson(Map<String, dynamic> json) =>
    _QuickCapture(
      id: json['id'] as String,
      rawText: json['rawText'] as String,
      isProcessed: json['isProcessed'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$QuickCaptureToJson(_QuickCapture instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rawText': instance.rawText,
      'isProcessed': instance.isProcessed,
      'createdAt': instance.createdAt.toIso8601String(),
    };
