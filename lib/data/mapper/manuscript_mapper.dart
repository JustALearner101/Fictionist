import 'package:drift/drift.dart';

import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';

class ManuscriptMapper {
  static ManuscriptChapter toDomain(ManuscriptChapterRow row) {
    return ManuscriptChapter(
      id: row.id,
      title: row.title,
      content: row.content,
      sortOrder: row.sortOrder,
      dateLabel: row.dateLabel,
      eraLabel: row.eraLabel,
      synopsis: row.synopsis,
      isDeleted: row.isDeleted,
      status: _parseStatus(row.status),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static ChapterStatus _parseStatus(String status) {
    return ChapterStatus.values.firstWhere(
      (s) => s.name == status,
      orElse: () => ChapterStatus.draft,
    );
  }

  static ManuscriptChaptersCompanion toCompanion(ManuscriptChapter chapter, {String? projectId}) {
    return ManuscriptChaptersCompanion(
      id: Value(chapter.id),
      projectId: projectId != null ? Value(projectId) : const Value.absent(),
      title: Value(chapter.title),
      content: Value(chapter.content),
      sortOrder: Value(chapter.sortOrder),
      dateLabel: Value(chapter.dateLabel),
      eraLabel: Value(chapter.eraLabel),
      synopsis: Value(chapter.synopsis),
      isDeleted: Value(chapter.isDeleted),
      status: Value(chapter.status.name),
      createdAt: Value(chapter.createdAt),
      updatedAt: Value(chapter.updatedAt),
    );
  }
}
