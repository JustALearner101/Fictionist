import 'package:drift/drift.dart';
import 'entity_table.dart';
import 'tag_table.dart';

@DataClassName('EntityTagRow')
class EntityTags extends Table {
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  TextColumn get tagId =>
      text().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {entityId, tagId};
}
