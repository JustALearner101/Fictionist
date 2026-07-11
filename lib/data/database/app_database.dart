import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:injectable/injectable.dart';
import '../dao/entity_dao.dart';
import '../dao/manuscript_dao.dart';
import '../dao/map_dao.dart';
import '../dao/plot_dao.dart';
import '../dao/setup_payoff_dao.dart';
import '../dao/relationship_dao.dart';
import '../dao/tag_dao.dart';
import '../dao/template_dao.dart';
import '../dao/timeline_dao.dart';
import '../dao/entity_version_dao.dart';
import '../dao/snapshot_dao.dart';

import 'tables/entity_table.dart';
import 'tables/entity_tag_table.dart';
import 'tables/entity_version_table.dart';
import 'tables/manuscript_chapter_table.dart';
import 'tables/chapter_snapshot_table.dart';
import 'tables/map_pin_table.dart';
import 'tables/plot_tables.dart';
import 'tables/setup_payoff_table.dart';
import 'tables/relationship_table.dart';
import 'tables/tag_table.dart';
import 'tables/template_table.dart';
import 'tables/timeline_entry_table.dart';
import 'tables/world_map_table.dart';

part 'app_database.g.dart';

@lazySingleton
@DriftDatabase(
  tables: [
    Entities,
    Relationships,
    Tags,
    EntityTags,
    TimelineEntries,
    EntityVersions,
    Templates,
    ManuscriptChapters,
    ChapterSnapshots,
    PlotCards,
    PlotConnections,
    WorldMaps,
    MapPins,
    SetupPayoffs,
  ],
  daos: [
    EntityDao,
    RelationshipDao,
    TagDao,
    TimelineDao,
    EntityVersionDao,
    TemplateDao,
    MapDao,
    ManuscriptDao,
    SnapshotDao,
    PlotDao,
    SetupPayoffDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        // Custom creation of FTS5 table and triggers
        // Standalone FTS5 (no content= sync) — we maintain it via triggers
        await customStatement('''
          CREATE VIRTUAL TABLE entity_fts USING fts5(
            entity_id UNINDEXED,
            name,
            description,
            custom_fields_text
          );
        ''');
        await customStatement('''
          CREATE TRIGGER trg_entity_fts_insert AFTER INSERT ON entities BEGIN
            INSERT INTO entity_fts(rowid, entity_id, name, description, custom_fields_text)
            VALUES (new.rowid, new.id, new.name, new.description, new.custom_fields);
          END;
        ''');
        await customStatement('''
          CREATE TRIGGER trg_entity_fts_update AFTER UPDATE ON entities BEGIN
            DELETE FROM entity_fts WHERE rowid = old.rowid;
            INSERT INTO entity_fts(rowid, entity_id, name, description, custom_fields_text)
            VALUES (new.rowid, new.id, new.name, new.description, new.custom_fields);
          END;
        ''');
        await customStatement('''
          CREATE TRIGGER trg_entity_fts_delete AFTER DELETE ON entities BEGIN
            DELETE FROM entity_fts WHERE rowid = old.rowid;
          END;
        ''');
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.createTable(manuscriptChapters);
        }
        if (from < 3) {
          await m.createTable(plotCards);
          await m.createTable(plotConnections);
        }
        if (from < 4) {
          await m.createTable(chapterSnapshots);
        }
        if (from >= 2 && from < 5) {
          // Add columns added to manuscript_chapters after the original v2 creation
          // Only needed for installs that were created at v2 (not fresh installs)
          await m.addColumn(manuscriptChapters, manuscriptChapters.synopsis);
          await m.addColumn(manuscriptChapters, manuscriptChapters.dateLabel);
          await m.addColumn(manuscriptChapters, manuscriptChapters.eraLabel);
          await m.addColumn(manuscriptChapters, manuscriptChapters.status);
        }
        if (from < 6) {
          await m.addColumn(manuscriptChapters, manuscriptChapters.povCharacterId);
          await m.addColumn(manuscriptChapters, manuscriptChapters.locationId);
        }
        if (from < 7) {
          await m.createTable(setupPayoffs);
        }
      },
      beforeOpen: (details) async {
        // Enforce foreign keys in SQLite
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fictionist.db'));

    return NativeDatabase(file);
  });
}
