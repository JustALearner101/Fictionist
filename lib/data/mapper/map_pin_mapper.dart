import 'package:drift/drift.dart';
import '../../domain/map/map_pin.dart';
import '../database/app_database.dart';

class MapPinMapper {
  static MapPin toDomain(MapPinRow row) {
    return MapPin(
      id: row.id,
      mapId: row.mapId,
      entityId: row.entityId,
      xPercent: row.xPercent,
      yPercent: row.yPercent,
      label: row.label,
    );
  }

  static MapPinsCompanion toCompanion(MapPin pin) {
    return MapPinsCompanion(
      id: Value(pin.id),
      mapId: Value(pin.mapId),
      entityId: Value(pin.entityId),
      xPercent: Value(pin.xPercent),
      yPercent: Value(pin.yPercent),
      label: Value(pin.label),
    );
  }
}
