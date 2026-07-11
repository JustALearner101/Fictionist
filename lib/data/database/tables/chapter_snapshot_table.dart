import 'package:drift/drift.dart';

import 'manuscript_chapter_table.dart';

@DataClassName('ChapterSnapshotRow')
class ChapterSnapshots extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get chapterId =>
      text().references(ManuscriptChapters, #id, onDelete: KeyAction.cascade)();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
