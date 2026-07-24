import 'package:fictionist/data/dao/project_dao.dart';
import 'package:fictionist/data/dao/tag_dao.dart';
import 'package:fictionist/data/database/app_database.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ProjectDao projectDao;
  late TagDao tagDao;

  setUp(() async {
    db = createTestDatabase();
    projectDao = db.projectDao;
    tagDao = db.tagDao;
  });

  tearDown(() async {
    await db.close();
  });

  group('Multi-Project Capabilities Stress Tests', () {
    test('1. Tag uniqueness is per-project (two projects can have tags with the same name)', () async {
      final now = DateTime.now();

      await projectDao.insertProject(ProjectsCompanion.insert(
        id: '11111111-1111-1111-1111-111111111111',
        name: 'Project One',
        lastAccessedAt: now,
        createdAt: now,
        updatedAt: now,
      ));

      await projectDao.insertProject(ProjectsCompanion.insert(
        id: '22222222-2222-2222-2222-222222222222',
        name: 'Project Two',
        lastAccessedAt: now,
        createdAt: now,
        updatedAt: now,
      ));

      await tagDao.insertTag(TagsCompanion.insert(
        id: 'tag-1',
        projectId: Value('11111111-1111-1111-1111-111111111111'),
        name: 'Protagonist',
        color: 0xFF0000FF,
      ));

      await tagDao.insertTag(TagsCompanion.insert(
        id: 'tag-2',
        projectId: Value('22222222-2222-2222-2222-222222222222'),
        name: 'Protagonist',
        color: 0xFFFF0000,
      ));

      final allTags = await tagDao.getAllTags();
      expect(allTags.length, 2);

      final p1Tags = await tagDao.getAllTags('11111111-1111-1111-1111-111111111111');
      expect(p1Tags.length, 1);
      expect(p1Tags.first.id, 'tag-1');
      expect(p1Tags.first.name, 'Protagonist');
      expect(p1Tags.first.color, 0xFF0000FF);

      final p2Tags = await tagDao.getAllTags('22222222-2222-2222-2222-222222222222');
      expect(p2Tags.length, 1);
      expect(p2Tags.first.id, 'tag-2');
      expect(p2Tags.first.name, 'Protagonist');
      expect(p2Tags.first.color, 0xFFFF0000);

      final p1TagByName = await tagDao.getTagByName('Protagonist', '11111111-1111-1111-1111-111111111111');
      expect(p1TagByName, isNotNull);
      expect(p1TagByName!.id, 'tag-1');

      final p2TagByName = await tagDao.getTagByName('Protagonist', '22222222-2222-2222-2222-222222222222');
      expect(p2TagByName, isNotNull);
      expect(p2TagByName!.id, 'tag-2');
    });

    test('2. Cascade deletion wipes associated entities, tags, maps, timelines, chapters, plot cards, setup/payoffs, map pins, snapshots, relationships, and FTS entries when project is deleted', () async {
      final now = DateTime.now();

      const p1Id = '11111111-1111-1111-1111-111111111111';
      const p2Id = '22222222-2222-2222-2222-222222222222';

      await projectDao.insertProject(ProjectsCompanion.insert(
        id: p1Id,
        name: 'Project One',
        lastAccessedAt: now,
        createdAt: now,
        updatedAt: now,
      ));
      await projectDao.insertProject(ProjectsCompanion.insert(
        id: p2Id,
        name: 'Project Two',
        lastAccessedAt: now,
        createdAt: now,
        updatedAt: now,
      ));

      // Populate Project 1
      await db.into(db.entities).insert(EntitiesCompanion.insert(
        id: 'ent-p1-1',
        projectId: Value(p1Id),
        name: 'Arthur Pendragon',
        entityType: 'character',
        iconColor: 0xFF123456,
        createdAt: now,
        updatedAt: now,
      ));
      await db.into(db.entities).insert(EntitiesCompanion.insert(
        id: 'ent-p1-2',
        projectId: Value(p1Id),
        name: 'Excalibur',
        entityType: 'item',
        iconColor: 0xFF654321,
        createdAt: now,
        updatedAt: now,
      ));

      await db.into(db.entityVersions).insert(EntityVersionsCompanion.insert(
        id: 'ver-p1-1',
        entityId: 'ent-p1-1',
        snapshotJson: '{"name":"Arthur"}',
        changedAt: now,
      ));

      await db.into(db.relationships).insert(RelationshipsCompanion.insert(
        id: 'rel-p1-1',
        sourceId: 'ent-p1-1',
        targetId: 'ent-p1-2',
        typeKey: 'owner_of',
        createdAt: now,
        updatedAt: now,
      ));

      await db.into(db.tags).insert(TagsCompanion.insert(
        id: 'tag-p1-1',
        projectId: Value(p1Id),
        name: 'Royalty',
        color: 0xFFFFD700,
      ));

      await db.into(db.entityTags).insert(EntityTagsCompanion.insert(
        entityId: 'ent-p1-1',
        tagId: 'tag-p1-1',
      ));

      await db.into(db.worldMaps).insert(WorldMapsCompanion.insert(
        id: 'map-p1-1',
        projectId: Value(p1Id),
        name: 'Camelot Realm',
        imagePath: '/maps/camelot.png',
      ));

      await db.into(db.mapPins).insert(MapPinsCompanion.insert(
        id: 'pin-p1-1',
        mapId: 'map-p1-1',
        entityId: 'ent-p1-1',
        xPercent: 45.0,
        yPercent: 60.0,
      ));

      await db.into(db.timelineEntries).insert(TimelineEntriesCompanion.insert(
        id: 'timeline-p1-1',
        projectId: Value(p1Id),
        title: 'Coronation of Arthur',
        sortOrder: 1,
        entityId: Value('ent-p1-1'),
        createdAt: now,
        updatedAt: now,
      ));

      await db.into(db.manuscriptChapters).insert(ManuscriptChaptersCompanion.insert(
        id: '11111111-1111-1111-1111-111111111111',
        projectId: Value(p1Id),
        title: 'Chapter 1: The Sword in the Stone',
        createdAt: now,
        updatedAt: now,
      ));

      await db.into(db.chapterSnapshots).insert(ChapterSnapshotsCompanion.insert(
        id: '33333333-3333-3333-3333-333333333333',
        chapterId: '11111111-1111-1111-1111-111111111111',
        content: 'Draft content snapshot',
        createdAt: now,
      ));

      await db.into(db.plotCards).insert(PlotCardsCompanion.insert(
        id: '44444444-4444-4444-4444-444444444444',
        projectId: Value(p1Id),
        title: 'Plot 1: Pulling the Sword',
        xPosition: 100.0,
        yPosition: 200.0,
        createdAt: now,
        updatedAt: now,
      ));

      await db.into(db.plotConnections).insert(PlotConnectionsCompanion.insert(
        id: '66666666-6666-6666-6666-666666666666',
        projectId: Value(p1Id),
        sourceId: '44444444-4444-4444-4444-444444444444',
        targetId: '44444444-4444-4444-4444-444444444444',
        createdAt: now,
      ));

      await db.into(db.setupPayoffs).insert(SetupPayoffsCompanion.insert(
        id: '77777777-7777-7777-7777-777777777777',
        projectId: Value(p1Id),
        setupChapterId: '11111111-1111-1111-1111-111111111111',
        setupDescription: 'Merlin predicts the true king',
        createdAt: now,
        updatedAt: now,
      ));

      // Populate Project 2 (should survive)
      await db.into(db.entities).insert(EntitiesCompanion.insert(
        id: 'ent-p2-1',
        projectId: Value(p2Id),
        name: 'Sherlock Holmes',
        entityType: 'character',
        iconColor: 0xFF999999,
        createdAt: now,
        updatedAt: now,
      ));
      await db.into(db.tags).insert(TagsCompanion.insert(
        id: 'tag-p2-1',
        projectId: Value(p2Id),
        name: 'Detective',
        color: 0xFF00FF00,
      ));
      await db.into(db.worldMaps).insert(WorldMapsCompanion.insert(
        id: 'map-p2-1',
        projectId: Value(p2Id),
        name: 'London Map',
        imagePath: '/maps/london.png',
      ));
      await db.into(db.timelineEntries).insert(TimelineEntriesCompanion.insert(
        id: 'timeline-p2-1',
        projectId: Value(p2Id),
        title: 'A Study in Scarlet',
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
      ));
      await db.into(db.manuscriptChapters).insert(ManuscriptChaptersCompanion.insert(
        id: '22222222-2222-2222-2222-222222222222',
        projectId: Value(p2Id),
        title: 'Chapter 1: Mr. Sherlock Holmes',
        createdAt: now,
        updatedAt: now,
      ));
      await db.into(db.plotCards).insert(PlotCardsCompanion.insert(
        id: '55555555-5555-5555-5555-555555555555',
        projectId: Value(p2Id),
        title: 'Plot A: The Lauriston Garden House',
        xPosition: 50.0,
        yPosition: 50.0,
        createdAt: now,
        updatedAt: now,
      ));
      await db.into(db.setupPayoffs).insert(SetupPayoffsCompanion.insert(
        id: '88888888-8888-8888-8888-888888888888',
        projectId: Value(p2Id),
        setupChapterId: '22222222-2222-2222-2222-222222222222',
        setupDescription: 'RACHE written on the wall',
        createdAt: now,
        updatedAt: now,
      ));

      // Verify P1 exists
      expect((await (db.select(db.projects)..where((t) => t.id.equals(p1Id))).get()).length, 1);
      expect((await (db.select(db.entities)..where((t) => t.projectId.equals(p1Id))).get()).length, 2);
      expect((await (db.select(db.tags)..where((t) => t.projectId.equals(p1Id))).get()).length, 1);
      expect((await (db.select(db.worldMaps)..where((t) => t.projectId.equals(p1Id))).get()).length, 1);
      expect((await (db.select(db.timelineEntries)..where((t) => t.projectId.equals(p1Id))).get()).length, 1);
      expect((await (db.select(db.manuscriptChapters)..where((t) => t.projectId.equals(p1Id))).get()).length, 1);
      expect((await (db.select(db.plotCards)..where((t) => t.projectId.equals(p1Id))).get()).length, 1);
      expect((await (db.select(db.plotConnections)..where((t) => t.projectId.equals(p1Id))).get()).length, 1);
      expect((await (db.select(db.setupPayoffs)..where((t) => t.projectId.equals(p1Id))).get()).length, 1);

      final ftsPre = await db.customSelect('SELECT * FROM entity_fts WHERE entity_id = ?', readsFrom: {}, variables: [Variable<String>('ent-p1-1')]).get();
      expect(ftsPre.length, 1);

      // Delete Project 1
      final deletedCount = await projectDao.deleteProject(p1Id);
      expect(deletedCount, 1);

      // Verify P1 data wiped
      expect((await (db.select(db.projects)..where((t) => t.id.equals(p1Id))).get()), isEmpty);
      expect((await (db.select(db.entities)..where((t) => t.projectId.equals(p1Id))).get()), isEmpty);
      expect((await (db.select(db.tags)..where((t) => t.projectId.equals(p1Id))).get()), isEmpty);
      expect((await (db.select(db.worldMaps)..where((t) => t.projectId.equals(p1Id))).get()), isEmpty);
      expect((await (db.select(db.timelineEntries)..where((t) => t.projectId.equals(p1Id))).get()), isEmpty);
      expect((await (db.select(db.manuscriptChapters)..where((t) => t.projectId.equals(p1Id))).get()), isEmpty);
      expect((await (db.select(db.plotCards)..where((t) => t.projectId.equals(p1Id))).get()), isEmpty);
      expect((await (db.select(db.plotConnections)..where((t) => t.projectId.equals(p1Id))).get()), isEmpty);
      expect((await (db.select(db.setupPayoffs)..where((t) => t.projectId.equals(p1Id))).get()), isEmpty);

      expect((await (db.select(db.entityTags)..where((t) => t.entityId.equals('ent-p1-1'))).get()), isEmpty);
      expect((await (db.select(db.mapPins)..where((t) => t.id.equals('pin-p1-1'))).get()), isEmpty);
      expect((await (db.select(db.chapterSnapshots)..where((t) => t.id.equals('33333333-3333-3333-3333-333333333333'))).get()), isEmpty);
      expect((await (db.select(db.relationships)..where((t) => t.id.equals('rel-p1-1'))).get()), isEmpty);
      expect((await (db.select(db.entityVersions)..where((t) => t.id.equals('ver-p1-1'))).get()), isEmpty);

      final ftsPost = await db.customSelect('SELECT * FROM entity_fts WHERE entity_id = ?', readsFrom: {}, variables: [Variable<String>('ent-p1-1')]).get();
      expect(ftsPost, isEmpty);

      // Verify P2 untouched
      expect((await (db.select(db.projects)..where((t) => t.id.equals(p2Id))).get()).length, 1);
      expect((await (db.select(db.entities)..where((t) => t.projectId.equals(p2Id))).get()).length, 1);
      expect((await (db.select(db.tags)..where((t) => t.projectId.equals(p2Id))).get()).length, 1);
      expect((await (db.select(db.worldMaps)..where((t) => t.projectId.equals(p2Id))).get()).length, 1);
      expect((await (db.select(db.timelineEntries)..where((t) => t.projectId.equals(p2Id))).get()).length, 1);
      expect((await (db.select(db.manuscriptChapters)..where((t) => t.projectId.equals(p2Id))).get()).length, 1);
      expect((await (db.select(db.plotCards)..where((t) => t.projectId.equals(p2Id))).get()).length, 1);
      expect((await (db.select(db.setupPayoffs)..where((t) => t.projectId.equals(p2Id))).get()).length, 1);
    });
  });
}
