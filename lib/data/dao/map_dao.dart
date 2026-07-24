import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../database/app_database.dart';
import '../database/tables/map_pin_table.dart';
import '../database/tables/world_map_table.dart';

part 'map_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [WorldMaps, MapPins])
class MapDao extends DatabaseAccessor<AppDatabase> with _$MapDaoMixin {
  MapDao(AppDatabase db) : super(db);

  Future<int> insertMap(WorldMapsCompanion entry) {
    return into(worldMaps).insert(entry);
  }

  Future<int> deleteMap(String id) {
    return (delete(worldMaps)..where((t) => t.id.equals(id))).go();
  }

  Future<List<WorldMapRow>> getAllMaps([String? projectId]) {
    final query = select(worldMaps);
    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }
    return query.get();
  }

  Future<WorldMapRow?> getMapById(String id, [String? projectId]) {
    final query = select(worldMaps)..where((t) => t.id.equals(id));
    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }
    return query.getSingleOrNull();
  }

  Future<int> insertPin(MapPinsCompanion entry) {
    return into(mapPins).insert(entry, mode: InsertMode.insertOrReplace);
  }

  Future<int> deletePin(String id) {
    return (delete(mapPins)..where((t) => t.id.equals(id))).go();
  }

  Future<List<MapPinRow>> getPinsForMap(String mapId) {
    return (select(mapPins)..where((t) => t.mapId.equals(mapId))).get();
  }

  Future<MapPinRow?> getPinById(String id) {
    return (select(mapPins)..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}
