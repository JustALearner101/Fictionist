import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/data/database/tables/manuscript_chapter_table.dart';

part 'manuscript_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [ManuscriptChapters])
class ManuscriptDao extends DatabaseAccessor<AppDatabase>
    with _$ManuscriptDaoMixin {
  ManuscriptDao(AppDatabase db) : super(db);

  Future<void> insertChapter(ManuscriptChaptersCompanion companion) {
    return into(manuscriptChapters).insert(companion);
  }

  Future<ManuscriptChapterRow?> getById(String id) {
    return (select(manuscriptChapters)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<bool> updateChapter(ManuscriptChaptersCompanion companion) {
    return (update(manuscriptChapters)
          ..where((t) => t.id.equals(companion.id.value)))
        .write(companion)
        .then((count) => count > 0);
  }

  Future<int> softDelete(String id) {
    return (update(manuscriptChapters)
          ..where((t) => t.id.equals(id)))
        .write(const ManuscriptChaptersCompanion(isDeleted: Value(true)));
  }

  Future<List<ManuscriptChapterRow>> getAllActive() {
    return (select(manuscriptChapters)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Future<void> updateSortOrder(String id, int sortOrder) {
    return (update(manuscriptChapters)
          ..where((t) => t.id.equals(id)))
        .write(ManuscriptChaptersCompanion(sortOrder: Value(sortOrder)));
  }
}
