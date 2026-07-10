import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/data/database/tables/chapter_snapshot_table.dart';

part 'snapshot_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [ChapterSnapshots])
class SnapshotDao extends DatabaseAccessor<AppDatabase>
    with _$SnapshotDaoMixin {
  SnapshotDao(AppDatabase db) : super(db);

  Future<void> createSnapshot(ChapterSnapshotsCompanion companion) {
    return into(chapterSnapshots).insert(companion);
  }

  Future<List<ChapterSnapshotRow>> getSnapshotsForChapter(
    String chapterId,
  ) {
    return (select(chapterSnapshots)
          ..where((t) => t.chapterId.equals(chapterId))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  /// Deletes old snapshots for a chapter, keeping only the most recent
  /// [keepCount] entries.
  Future<void> deleteOldSnapshots(String chapterId,
      {int keepCount = 10}) async {
    final keepIdsQuery = selectOnly(chapterSnapshots)
      ..addColumns([chapterSnapshots.id])
      ..where(chapterSnapshots.chapterId.equals(chapterId))
      ..orderBy([
        OrderingTerm(expression: chapterSnapshots.createdAt, mode: OrderingMode.desc),
      ])
      ..limit(keepCount);

    final keepRows = await keepIdsQuery.get();
    final keepIds = keepRows.map((r) => r.read(chapterSnapshots.id)!).toList();

    if (keepIds.isNotEmpty) {
      await (delete(chapterSnapshots)
            ..where((t) =>
                t.chapterId.equals(chapterId) & t.id.isNotIn(keepIds)))
          .go();
    }
  }
}
