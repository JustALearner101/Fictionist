import 'package:drift/drift.dart';
import '../../domain/version/entity_version.dart';
import '../database/app_database.dart';

class EntityVersionMapper {
  static EntityVersion toDomain(EntityVersionRow row) {
    return EntityVersion(
      id: row.id,
      entityId: row.entityId,
      snapshotJson: row.snapshotJson,
      changedAt: row.changedAt,
      changeNote: row.changeNote,
    );
  }

  static EntityVersionsCompanion toCompanion(EntityVersion version) {
    return EntityVersionsCompanion(
      id: Value(version.id),
      entityId: Value(version.entityId),
      snapshotJson: Value(version.snapshotJson),
      changedAt: Value(version.changedAt),
      changeNote: Value(version.changeNote),
    );
  }
}
