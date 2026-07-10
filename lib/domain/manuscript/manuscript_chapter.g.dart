// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manuscript_chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ManuscriptChapter _$ManuscriptChapterFromJson(Map<String, dynamic> json) =>
    _ManuscriptChapter(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      dateLabel: json['dateLabel'] as String?,
      eraLabel: json['eraLabel'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ManuscriptChapterToJson(_ManuscriptChapter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'sortOrder': instance.sortOrder,
      'dateLabel': instance.dateLabel,
      'eraLabel': instance.eraLabel,
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
