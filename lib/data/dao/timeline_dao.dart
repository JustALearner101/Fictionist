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

  Future<TimelineEntryRow?> getById(String id) {
    return (select(timelineEntries)
          ..where((t) => t.id.equals(id) & t.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  Future<List<TimelineEntryRow>> getAllActiveOrdered() {
    return (select(timelineEntries)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc),
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)
          ]))
        .get();
  }

  Future<List<TimelineEntryRow>> getActiveForEntity(String entityId) {
    return (select(timelineEntries)
          ..where((t) => t.isDeleted.equals(false) & t.entityId.equals(entityId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc),
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)
          ]))
        .get();
  }

  Future<int> getMaxSortOrder() async {
    final query = selectOnly(timelineEntries)
      ..addColumns([timelineEntries.sortOrder.max()]);
    final result = await query.getSingle();
    return result.read(timelineEntries.sortOrder.max()) ?? 0;
  }

  Future<int> updateSortOrder(String id, int sortOrder) {
    return (update(timelineEntries)..where((t) => t.id.equals(id)))
        .write(TimelineEntriesCompanion(sortOrder: Value(sortOrder)));
  }
}
