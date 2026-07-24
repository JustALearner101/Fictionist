import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../database/app_database.dart';
import '../database/tables/entity_table.dart';

part 'entity_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [Entities])
class EntityDao extends DatabaseAccessor<AppDatabase> with _$EntityDaoMixin {
  EntityDao(AppDatabase db) : super(db);

  Future<EntityRow?> getById(String id, [String? projectId]) {
    final query = select(entities)
      ..where((t) => t.id.equals(id) & t.isDeleted.equals(false));
    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }
    return query.getSingleOrNull();
  }

  Future<int> insertEntity(EntitiesCompanion entity) {
    return into(entities).insert(entity);
  }

  Future<bool> updateEntity(EntitiesCompanion entity) {
    return update(entities).replace(entity);
  }

  Future<int> deleteEntity(String id) {
    // Soft delete
    return (update(entities)..where((t) => t.id.equals(id)))
        .write(const EntitiesCompanion(isDeleted: Value(true)));
  }

  Future<List<EntityRow>> getAllActive([String? projectId]) {
    final query = select(entities)..where((t) => t.isDeleted.equals(false));
    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }
    return (query
          ..orderBy([
            (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<List<EntityRow>> getActiveByType(String type, [String? projectId]) {
    final query = select(entities)
      ..where((t) => t.isDeleted.equals(false) & t.entityType.equals(type));
    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }
    return (query
          ..orderBy([
            (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)
          ]))
        .get();
  }

  Future<List<EntityRow>> getActiveByStatus(String status, [String? projectId]) {
    final query = select(entities)
      ..where((t) => t.isDeleted.equals(false) & t.status.equals(status));
    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }
    return (query
          ..orderBy([
            (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)
          ]))
        .get();
  }

  // FTS5 fuzzy match query using customSelect
  Future<List<Map<String, dynamic>>> searchFts(String query, [String? projectId]) async {
    final escapedQuery = _escapeFtsQuery(query);
    if (escapedQuery.isEmpty) return [];

    final Selectable<QueryRow> selectable;
    if (projectId != null) {
      selectable = customSelect(
        'SELECT entity_fts.entity_id, snippet(entity_fts, 1, "<b>", "</b>", "...", 32) as snippet '
        'FROM entity_fts '
        'INNER JOIN entities ON entities.id = entity_fts.entity_id '
        'WHERE entities.project_id = ? AND entities.is_deleted = 0 AND entity_fts MATCH ? '
        'ORDER BY rank LIMIT 50',
        variables: [Variable.withString(projectId), Variable.withString(escapedQuery)],
        readsFrom: {entities},
      );
    } else {
      selectable = customSelect(
        'SELECT entity_id, snippet(entity_fts, 1, "<b>", "</b>", "...", 32) as snippet '
        'FROM entity_fts WHERE entity_fts MATCH ? ORDER BY rank LIMIT 50',
        variables: [Variable.withString(escapedQuery)],
        readsFrom: {entities},
      );
    }

    final rows = await selectable.get();
    return rows.map((row) => {
      'entity_id': row.read<String>('entity_id'),
      'snippet': row.read<String>('snippet'),
    }).toList();
  }

  String _escapeFtsQuery(String query) {
    // Escape FTS5 operators and append prefix matching wildcard *
    final cleaned = query.replaceAll(RegExp(r'[^\w\s]'), ' ').trim();
    if (cleaned.isEmpty) return '';
    final words = cleaned.split(RegExp(r'\s+'));
    return words.map((w) => '$w*').join(' AND ');
  }
}
