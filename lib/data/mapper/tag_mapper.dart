import 'package:drift/drift.dart';
import '../../domain/tag/tag.dart';
import '../database/app_database.dart';

class TagMapper {
  static Tag toDomain(TagRow row) {
    return Tag(
      id: row.id,
      name: row.name,
      color: row.color,
    );
  }

  static TagsCompanion toCompanion(Tag tag, {String? projectId}) {
    return TagsCompanion(
      id: Value(tag.id),
      projectId: projectId != null ? Value(projectId) : const Value.absent(),
      name: Value(tag.name),
      color: Value(tag.color),
    );
  }
}
