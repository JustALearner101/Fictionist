import 'package:drift/drift.dart';
import '../../domain/relationship/relationship.dart';
import '../database/app_database.dart';

class RelationshipMapper {
  static Relationship toDomain(RelationshipRow row) {
    return Relationship(
      id: row.id,
      sourceId: row.sourceId,
      targetId: row.targetId,
      typeKey: row.typeKey,
      description: row.description,
      weight: row.weight,
      isDeleted: row.isDeleted,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static RelationshipsCompanion toCompanion(Relationship relationship) {
    return RelationshipsCompanion(
      id: Value(relationship.id),
      sourceId: Value(relationship.sourceId),
      targetId: Value(relationship.targetId),
      typeKey: Value(relationship.typeKey),
      description: Value(relationship.description),
      weight: Value(relationship.weight),
      isDeleted: Value(relationship.isDeleted),
      createdAt: Value(relationship.createdAt),
      updatedAt: Value(relationship.updatedAt),
    );
  }
}
