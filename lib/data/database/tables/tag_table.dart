import 'package:drift/drift.dart';
import 'projects_table.dart';

@DataClassName('TagRow')
class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get projectId =>
      text().references(Projects, #id, onDelete: KeyAction.cascade).nullable()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get color => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
