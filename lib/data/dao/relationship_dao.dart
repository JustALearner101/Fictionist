import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../database/app_database.dart';
import '../database/tables/entity_table.dart';
import '../database/tables/relationship_table.dart';

part 'relationship_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [Relationships, Entities])
class RelationshipDao extends DatabaseAccessor<AppDatabase>
    with _$RelationshipDaoMixin {
  RelationshipDao(AppDatabase db) : super(db);

  Future<int> insertRelationship(RelationshipsCompanion entry) {
    return into(relationships).insert(entry);
  }

  Future<int> deleteRelationship(String id) {
    return (update(relationships)..where((t) => t.id.equals(id)))
        .write(const RelationshipsCompanion(isDeleted: Value(true)));
  }

  Future<int> deleteRelationshipsForEntity(String entityId) {
    return (update(relationships)
          ..where((t) => t.sourceId.equals(entityId) | t.targetId.equals(entityId)))
        .write(const RelationshipsCompanion(isDeleted: Value(true)));
  }

  Future<List<RelationshipRow>> getRelationshipsForEntity(String entityId) {
    return (select(relationships)
          ..where((t) =>
              t.isDeleted.equals(false) &
              (t.sourceId.equals(entityId) | t.targetId.equals(entityId))))
        .get();
  }

  Future<RelationshipRow?> getDuplicate(
      String sourceId, String targetId, String typeKey) {
    return (select(relationships)
          ..where((t) =>
              t.isDeleted.equals(false) &
              t.sourceId.equals(sourceId) &
              t.targetId.equals(targetId) &
              t.typeKey.equals(typeKey)))
        .getSingleOrNull();
  }

  Future<RelationshipRow?> getById(String id) {
    return (select(relationships)
          ..where((t) => t.id.equals(id) & t.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  Future<List<RelationshipRow>> getAllActive([String? projectId]) async {
    if (projectId == null) {
      return (select(relationships)..where((t) => t.isDeleted.equals(false))).get();
    }
    final query = select(relationships).join([
      innerJoin(entities, entities.id.equalsExp(relationships.sourceId)),
    ])..where(
      entities.projectId.equals(projectId) &
      entities.isDeleted.equals(false) &
      relationships.isDeleted.equals(false),
    );
    final rows = await query.get();
    return rows.map((r) => r.readTable(relationships)).toList();
  }
}
