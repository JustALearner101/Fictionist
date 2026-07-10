import 'package:drift/drift.dart';
import 'entity_table.dart';

@DataClassName('EntityVersionRow')
class EntityVersions extends Table {
  TextColumn get id => text()();
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  TextColumn get snapshotJson => text()();
  DateTimeColumn get changedAt => dateTime()();
  TextColumn get changeNote => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
