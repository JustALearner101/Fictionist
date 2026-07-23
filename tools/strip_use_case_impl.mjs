import fs from 'fs';

const files = [
  'lib/domain/use_case/bootstrap/sample_world_use_case.dart',
  'lib/domain/use_case/bootstrap/bootstrap_use_case.dart',
  'lib/domain/use_case/continuity_check_use_case.dart',
  'lib/domain/use_case/entity/create_entity_use_case.dart',
  'lib/domain/use_case/entity/delete_entity_use_case.dart',
  'lib/domain/use_case/entity/get_entity_references_use_case.dart',
  'lib/domain/use_case/entity/get_entity_use_case.dart',
  'lib/domain/use_case/entity/list_entities_use_case.dart',
  'lib/domain/use_case/entity/search_entities_use_case.dart',
  'lib/domain/use_case/entity/search_entities_with_snippets_use_case.dart',
  'lib/domain/use_case/entity/update_entity_use_case.dart',
  'lib/domain/use_case/export/export_database_use_case.dart',
  'lib/domain/use_case/export/import_database_use_case.dart',
  'lib/domain/use_case/manuscript/manuscript_use_cases.dart',
  'lib/domain/use_case/name_generator/generate_names_use_case.dart',
  'lib/domain/use_case/relationship/create_relationship_use_case.dart',
  'lib/domain/use_case/relationship/delete_relationship_use_case.dart',
  'lib/domain/use_case/relationship/get_all_relationships_use_case.dart',
  'lib/domain/use_case/relationship/get_entity_relationships_use_case.dart',
  'lib/domain/use_case/sync/sync_backup_use_case.dart',
  'lib/domain/use_case/tag/assign_tag_use_case.dart',
  'lib/domain/use_case/tag/create_tag_use_case.dart',
  'lib/domain/use_case/tag/get_tags_use_case.dart',
  'lib/domain/use_case/template/get_templates_use_case.dart',
  'lib/domain/use_case/timeline/create_timeline_entry_use_case.dart',
  'lib/domain/use_case/timeline/get_timeline_use_case.dart',
  'lib/domain/use_case/timeline/reorder_timeline_use_case.dart',
  'lib/domain/use_case/trait/analyze_trait_inheritance_use_case.dart',
];

for (const f of files) {
  let content = fs.readFileSync(f, 'utf8');
  // Remove implements clauses for UseCase or UseCaseNoParams
  const before = content;
  content = content.replace(/,?\s*implements\s+UseCase(?:NoParams)?<[^>]+>/g, '');
  content = content.replace(/implements\s+UseCase(?:NoParams)?<[^>]+>\s*/g, '');
  if (content !== before) {
    fs.writeFileSync(f, content);
    console.log('fixed: ' + f);
  } else {
    console.log('SKIP: ' + f);
  }
}
