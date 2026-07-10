import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../database/app_database.dart';
import '../database/tables/entity_table.dart';

part 'entity_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [Entities])
class EntityDao extends DatabaseAccessor<AppDatabase> with _$EntityDaoMixin {
  EntityDao(AppDatabase db) : super(db);

  Future<EntityRow?> getById(String id) {
    return (select(entities)
          ..where((t) => t.id.equals(id) & t.isDeleted.equals(false)))
        .getSingleOrNull();
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

  Future<List<EntityRow>> getAllActive() {
    return (select(entities)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<List<EntityRow>> getActiveByType(String type) {
    return (select(entities)
          ..where((t) => t.isDeleted.equals(false) & t.entityType.equals(type))
          ..orderBy([
            (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)
          ]))
        .get();
  }

  Future<List<EntityRow>> getActiveByStatus(String status) {
    return (select(entities)
          ..where((t) => t.isDeleted.equals(false) & t.status.equals(status))
          ..orderBy([
            (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)
          ]))
        .get();
  }

  // FTS5 fuzzy match query using customSelect
  Future<List<Map<String, dynamic>>> searchFts(String query) async {
    final escapedQuery = _escapeFtsQuery(query);
    final rows = await customSelect(
      'SELECT entity_id, snippet(entity_fts, 1, "<b>", "</b>", "...", 32) as snippet '
      'FROM entity_fts WHERE entity_fts MATCH ? ORDER BY rank LIMIT 50',
      variables: [Variable.withString(escapedQuery)],
      readsFrom: {entities},
    ).get();

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
