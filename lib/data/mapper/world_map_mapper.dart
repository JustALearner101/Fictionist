import 'package:drift/drift.dart';
import '../../domain/map/world_map.dart';
import '../database/app_database.dart';

class WorldMapMapper {
  static WorldMap toDomain(WorldMapRow row) {
    return WorldMap(
      id: row.id,
      name: row.name,
      imagePath: row.imagePath,
    );
  }

  static WorldMapsCompanion toCompanion(WorldMap map) {
    return WorldMapsCompanion(
      id: Value(map.id),
      name: Value(map.name),
      imagePath: Value(map.imagePath),
    );
  }
}
