import 'package:drift/drift.dart';
import 'projects_table.dart';

@DataClassName('SetupPayoffRow')
class SetupPayoffs extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get projectId =>
      text().references(Projects, #id, onDelete: KeyAction.cascade).nullable()();
  TextColumn get setupChapterId =>
      text().withLength(min: 36, max: 36)();
  TextColumn get setupDescription => text()();
  TextColumn get payoffChapterId => text().nullable()();
  TextColumn get payoffDescription => text().nullable()();
  TextColumn get entityId => text().nullable()();
  BoolColumn get isResolved =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
