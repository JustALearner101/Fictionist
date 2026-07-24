import 'package:drift/drift.dart';
import 'projects_table.dart';

@DataClassName('EntityRow')
class Entities extends Table {
  TextColumn get id => text()();
  TextColumn get projectId =>
      text().references(Projects, #id, onDelete: KeyAction.cascade).nullable()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get entityType => text()();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  TextColumn get description => text().nullable()();
  TextColumn get customFields => text().withDefault(const Constant('[]'))();
  IntColumn get iconColor => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
