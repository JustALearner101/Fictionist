import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../database/app_database.dart';
import '../database/tables/entity_version_table.dart';

part 'entity_version_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [EntityVersions])
class EntityVersionDao extends DatabaseAccessor<AppDatabase>
    with _$EntityVersionDaoMixin {
  EntityVersionDao(AppDatabase db) : super(db);

  Future<int> insertVersion(EntityVersionsCompanion entry) {
    return into(entityVersions).insert(entry);
  }

  Future<List<EntityVersionRow>> getVersionsForEntity(String entityId) {
    return (select(entityVersions)
          ..where((t) => t.entityId.equals(entityId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.changedAt, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<EntityVersionRow?> getVersionById(String id) {
    return (select(entityVersions)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> pruneOldVersions(String entityId, int keepLimit) async {
    // Select the versions to keep (top keepLimit ordered by changedAt desc)
    final keepVersionsQuery = selectOnly(entityVersions)
      ..addColumns([entityVersions.id])
      ..where(entityVersions.entityId.equals(entityId))
      ..orderBy([OrderingTerm(expression: entityVersions.changedAt, mode: OrderingMode.desc)])
      ..limit(keepLimit);

    final keepRows = await keepVersionsQuery.get();
    final keepIds = keepRows.map((r) => r.read(entityVersions.id)!).toList();

    if (keepIds.isNotEmpty) {
      // Delete all others
      await (delete(entityVersions)
            ..where((t) => t.entityId.equals(entityId) & t.id.isNotIn(keepIds)))
          .go();
    }
  }
}
