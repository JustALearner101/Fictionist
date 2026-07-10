import 'package:drift/drift.dart';
import 'entity_table.dart';
import 'world_map_table.dart';

@DataClassName('MapPinRow')
class MapPins extends Table {
  TextColumn get id => text()();
  TextColumn get mapId =>
      text().references(WorldMaps, #id, onDelete: KeyAction.cascade)();
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  RealColumn get xPercent => real()();
  RealColumn get yPercent => real()();
  TextColumn get label => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
