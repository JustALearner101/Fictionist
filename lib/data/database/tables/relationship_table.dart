import 'package:drift/drift.dart';
import 'entity_table.dart';

@DataClassName('RelationshipRow')
class Relationships extends Table {
  TextColumn get id => text()();

  @ReferenceName('sourceRelationships')
  TextColumn get sourceId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();

  @ReferenceName('targetRelationships')
  TextColumn get targetId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();

  TextColumn get typeKey => text()();
  TextColumn get description => text().nullable()();
  IntColumn get weight => integer().withDefault(const Constant(5))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
