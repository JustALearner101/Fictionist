import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../database/app_database.dart';
import '../database/tables/entity_tag_table.dart';
import '../database/tables/tag_table.dart';

part 'tag_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [Tags, EntityTags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(AppDatabase db) : super(db);

  Future<int> insertTag(TagsCompanion entry) {
    return into(tags).insert(entry);
  }

  Future<List<TagRow>> getAllTags([String? projectId]) {
    final query = select(tags);
    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }
    return query.get();
  }

  Future<TagRow?> getTagById(String id, [String? projectId]) {
    final query = select(tags)..where((t) => t.id.equals(id));
    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }
    return query.getSingleOrNull();
  }

  Future<TagRow?> getTagByName(String name, [String? projectId]) {
    final query = select(tags)..where((t) => t.name.equals(name));
    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }
    return query.getSingleOrNull();
  }

  Future<int> assignTagToEntity(EntityTagsCompanion entry) {
    return into(entityTags).insert(entry, mode: InsertMode.insertOrIgnore);
  }

  Future<int> removeTagFromEntity(String entityId, String tagId) {
    return (delete(entityTags)
          ..where((t) => t.entityId.equals(entityId) & t.tagId.equals(tagId)))
        .go();
  }

  Future<int> removeAllTagsFromEntity(String entityId) {
    return (delete(entityTags)..where((t) => t.entityId.equals(entityId))).go();
  }

  Future<List<TagRow>> getTagsForEntity(String entityId) async {
    final query = select(entityTags).join([
      innerJoin(tags, tags.id.equalsExp(entityTags.tagId)),
    ])..where(entityTags.entityId.equals(entityId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(tags)).toList();
  }
}
