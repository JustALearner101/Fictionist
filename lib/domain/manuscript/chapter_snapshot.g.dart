// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChapterSnapshot _$ChapterSnapshotFromJson(Map<String, dynamic> json) =>
    _ChapterSnapshot(
      id: json['id'] as String,
      chapterId: json['chapterId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ChapterSnapshotToJson(_ChapterSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapterId': instance.chapterId,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
    };
