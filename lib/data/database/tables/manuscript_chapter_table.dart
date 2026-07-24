import 'package:drift/drift.dart';
import 'projects_table.dart';

@DataClassName('ManuscriptChapterRow')
class ManuscriptChapters extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get projectId =>
      text().references(Projects, #id, onDelete: KeyAction.cascade).nullable()();
  TextColumn get title => text().withLength(min: 1, max: 500)();
  TextColumn get content => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get dateLabel => text().nullable()();
  TextColumn get eraLabel => text().nullable()();
  TextColumn get synopsis => text().nullable()();
  TextColumn get povCharacterId => text().nullable()();
  TextColumn get locationId => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
