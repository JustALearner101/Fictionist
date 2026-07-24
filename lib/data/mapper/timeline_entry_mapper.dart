import 'package:drift/drift.dart';
import '../../domain/timeline/timeline_entry.dart';
import '../database/app_database.dart';

class TimelineEntryMapper {
  static TimelineEntry toDomain(TimelineEntryRow row) {
    return TimelineEntry(
      id: row.id,
      title: row.title,
      description: row.description,
      dateLabel: row.dateLabel,
      eraLabel: row.eraLabel,
      sortOrder: row.sortOrder,
      entityId: row.entityId,
      isDeleted: row.isDeleted,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static TimelineEntriesCompanion toCompanion(TimelineEntry entry, {String? projectId}) {
    return TimelineEntriesCompanion(
      id: Value(entry.id),
      projectId: projectId != null ? Value(projectId) : const Value.absent(),
      title: Value(entry.title),
      description: Value(entry.description),
      dateLabel: Value(entry.dateLabel),
      eraLabel: Value(entry.eraLabel),
      sortOrder: Value(entry.sortOrder),
      entityId: Value(entry.entityId),
      isDeleted: Value(entry.isDeleted),
      createdAt: Value(entry.createdAt),
      updatedAt: Value(entry.updatedAt),
    );
  }
}
