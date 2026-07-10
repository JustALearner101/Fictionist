import 'package:drift/drift.dart';

@DataClassName('ManuscriptChapterRow')
class ManuscriptChapters extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get title => text().withLength(min: 1, max: 500)();
  TextColumn get content => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get dateLabel => text().nullable()();
  TextColumn get eraLabel => text().nullable()();
  TextColumn get synopsis => text().nullable()();
  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
