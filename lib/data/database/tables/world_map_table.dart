import 'package:drift/drift.dart';

@DataClassName('WorldMapRow')
class WorldMaps extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get imagePath => text()();

  @override
  Set<Column> get primaryKey => {id};
}
