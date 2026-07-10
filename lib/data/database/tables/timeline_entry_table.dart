import 'package:drift/drift.dart';
import 'entity_table.dart';

@DataClassName('TimelineEntryRow')
class TimelineEntries extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 500)();
  TextColumn get description => text().nullable()();
  TextColumn get dateLabel => text().nullable()();
  TextColumn get eraLabel => text().nullable()();
  IntColumn get sortOrder => integer()();
  TextColumn get entityId =>
      text().nullable().references(Entities, #id, onDelete: KeyAction.setNull)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
