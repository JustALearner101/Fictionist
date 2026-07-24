import 'package:drift/drift.dart';
import 'projects_table.dart';

@DataClassName('PlotCardRow')
class PlotCards extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get projectId =>
      text().references(Projects, #id, onDelete: KeyAction.cascade).nullable()();
  TextColumn get title => text().withLength(min: 1, max: 300)();
  TextColumn get summary => text().nullable()();
  RealColumn get xPosition => real()();
  RealColumn get yPosition => real()();
  IntColumn get colorHex => integer().withDefault(const Constant(0xFFA78BFA))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PlotConnectionRow')
class PlotConnections extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get projectId =>
      text().references(Projects, #id, onDelete: KeyAction.cascade).nullable()();
  TextColumn get sourceId => text().withLength(min: 36, max: 36)();
  TextColumn get targetId => text().withLength(min: 36, max: 36)();
  TextColumn get label => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
