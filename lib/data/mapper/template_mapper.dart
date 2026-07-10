import 'dart:convert';
import 'package:drift/drift.dart';
import '../../domain/entity/custom_field.dart';
import '../../domain/entity/entity_type.dart';
import '../../domain/template/template.dart';
import '../database/app_database.dart';

class TemplateMapper {
  static Template toDomain(TemplateRow row) {
    final customFieldsList = (jsonDecode(row.customFieldsSchema) as List)
        .map((e) => CustomField.fromJson(e as Map<String, dynamic>))
        .toList();

    return Template(
      id: row.id,
      name: row.name,
      entityType: EntityType.fromKey(row.entityType),
      customFieldsSchema: customFieldsList,
      isBuiltIn: row.isBuiltIn,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static TemplatesCompanion toCompanion(Template template) {
    return TemplatesCompanion(
      id: Value(template.id),
      name: Value(template.name),
      entityType: Value(template.entityType.key),
      customFieldsSchema: Value(
          jsonEncode(template.customFieldsSchema.map((e) => e.toJson()).toList())),
      isBuiltIn: Value(template.isBuiltIn),
      createdAt: Value(template.createdAt),
      updatedAt: Value(template.updatedAt),
    );
  }
}
