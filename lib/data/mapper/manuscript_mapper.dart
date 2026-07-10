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
      isDeleted: row.isDeleted,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static ManuscriptChaptersCompanion toCompanion(ManuscriptChapter chapter) {
    return ManuscriptChaptersCompanion(
      id: Value(chapter.id),
      title: Value(chapter.title),
      content: Value(chapter.content),
      sortOrder: Value(chapter.sortOrder),
      dateLabel: Value(chapter.dateLabel),
      eraLabel: Value(chapter.eraLabel),
      isDeleted: Value(chapter.isDeleted),
      createdAt: Value(chapter.createdAt),
      updatedAt: Value(chapter.updatedAt),
    );
  }
}
