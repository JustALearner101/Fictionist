import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../database/app_database.dart';
import '../database/tables/timeline_entry_table.dart';

part 'timeline_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [TimelineEntries])
class TimelineDao extends DatabaseAccessor<AppDatabase> with _$TimelineDaoMixin {
  TimelineDao(AppDatabase db) : super(db);

  Future<int> insertEntry(TimelineEntriesCompanion entry) {
    return into(timelineEntries).insert(entry);
  }

  Future<bool> updateEntry(TimelineEntriesCompanion entry) {
    return update(timelineEntries).replace(entry);
  }

  Future<int> deleteEntry(String id) {
    return (update(timelineEntries)..where((t) => t.id.equals(id)))
        .write(const TimelineEntriesCompanion(isDeleted: Value(true)));
  }

  Future<TimelineEntryRow?> getById(String id, [String? projectId]) {
    final query = select(timelineEntries)
      ..where((t) => t.id.equals(id) & t.isDeleted.equals(false));
    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }
    return query.getSingleOrNull();
  }

  Future<List<TimelineEntryRow>> getAllActiveOrdered([String? projectId]) {
    final query = select(timelineEntries)
      ..where((t) => t.isDeleted.equals(false));
    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }
    return (query
          ..orderBy([
            (t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc),
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)
          ]))
        .get();
  }

  Future<List<TimelineEntryRow>> getActiveForEntity(String entityId, [String? projectId]) {
    final query = select(timelineEntries)
      ..where((t) => t.isDeleted.equals(false) & t.entityId.equals(entityId));
    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }
    return (query
          ..orderBy([
            (t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc),
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)
          ]))
        .get();
  }

  Future<int> getMaxSortOrder([String? projectId]) async {
    final query = selectOnly(timelineEntries)
      ..addColumns([timelineEntries.sortOrder.max()]);
    if (projectId != null) {
      query.where(timelineEntries.projectId.equals(projectId) & timelineEntries.isDeleted.equals(false));
    } else {
      query.where(timelineEntries.isDeleted.equals(false));
    }
    final result = await query.getSingle();
    return result.read(timelineEntries.sortOrder.max()) ?? 0;
  }

  Future<int> updateSortOrder(String id, int sortOrder) {
    return (update(timelineEntries)..where((t) => t.id.equals(id)))
        .write(TimelineEntriesCompanion(sortOrder: Value(sortOrder)));
  }
}
