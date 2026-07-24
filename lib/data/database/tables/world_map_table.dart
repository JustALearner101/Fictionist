import 'package:drift/drift.dart';
import 'projects_table.dart';

@DataClassName('WorldMapRow')
class WorldMaps extends Table {
  TextColumn get id => text()();
  TextColumn get projectId =>
      text().references(Projects, #id, onDelete: KeyAction.cascade).nullable()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get imagePath => text()();

  @override
  Set<Column> get primaryKey => {id};
}
