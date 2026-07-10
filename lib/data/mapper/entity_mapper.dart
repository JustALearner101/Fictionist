import 'dart:convert';
import 'package:drift/drift.dart';
import '../../domain/entity/custom_field.dart';
import '../../domain/entity/entity.dart';
import '../../domain/entity/entity_status.dart';
import '../../domain/entity/entity_type.dart';
import '../database/app_database.dart';

class EntityMapper {
  static Entity toDomain(EntityRow row) {
    final customFieldsList = (jsonDecode(row.customFields) as List)
        .map((e) => CustomField.fromJson(e as Map<String, dynamic>))
        .toList();

    return Entity(
      id: row.id,
      name: row.name,
      type: EntityType.fromKey(row.entityType),
      status: EntityStatus.fromKey(row.status),
      description: row.description,
      customFields: customFieldsList,
      iconColor: row.iconColor | 0xFF000000,
      isDeleted: row.isDeleted,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static EntitiesCompanion toCompanion(Entity entity) {
    return EntitiesCompanion(
      id: Value(entity.id),
      name: Value(entity.name),
      entityType: Value(entity.type.key),
      status: Value(entity.status.key),
      description: Value(entity.description),
      customFields:
          Value(jsonEncode(entity.customFields.map((e) => e.toJson()).toList())),
      iconColor: Value(entity.iconColor & 0x00FFFFFF),
      isDeleted: Value(entity.isDeleted),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );
  }
}
