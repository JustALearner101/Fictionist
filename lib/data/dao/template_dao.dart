import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../database/app_database.dart';
import '../database/tables/template_table.dart';

part 'template_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [Templates])
class TemplateDao extends DatabaseAccessor<AppDatabase> with _$TemplateDaoMixin {
  TemplateDao(AppDatabase db) : super(db);

  Future<int> insertTemplate(TemplatesCompanion entry) {
    return into(templates).insert(entry);
  }

  Future<bool> updateTemplate(TemplatesCompanion entry) {
    return update(templates).replace(entry);
  }

  Future<int> deleteTemplate(String id) {
    // Only delete custom templates
    return (delete(templates)
          ..where((t) => t.id.equals(id) & t.isBuiltIn.equals(false)))
        .go();
  }

  Future<List<TemplateRow>> getAllTemplates() {
    return select(templates).get();
  }

  Future<List<TemplateRow>> getTemplatesByType(String entityType) {
    return (select(templates)..where((t) => t.entityType.equals(entityType))).get();
  }

  Future<TemplateRow?> getTemplateById(String id) {
    return (select(templates)..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}
