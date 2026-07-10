import 'dart:convert';
import 'package:fictionist/data/dao/entity_dao.dart';
import 'package:fictionist/data/dao/entity_version_dao.dart';
import 'package:fictionist/data/dao/map_dao.dart';
import 'package:fictionist/data/dao/quick_capture_dao.dart';
import 'package:fictionist/data/dao/relationship_dao.dart';
import 'package:fictionist/data/dao/tag_dao.dart';
import 'package:fictionist/data/dao/template_dao.dart';
import 'package:fictionist/data/dao/timeline_dao.dart';
import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/data/repository/entity_repository_impl.dart';
import 'package:fictionist/data/repository/entity_version_repository_impl.dart';
import 'package:fictionist/data/repository/map_repository_impl.dart';
import 'package:fictionist/data/repository/quick_capture_repository_impl.dart';
import 'package:fictionist/data/repository/relationship_repository_impl.dart';
import 'package:fictionist/data/repository/tag_repository_impl.dart';
import 'package:fictionist/data/repository/template_repository_impl.dart';
import 'package:fictionist/data/repository/timeline_repository_impl.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_status.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:fictionist/domain/use_case/export/export_database_use_case.dart';
import 'package:fictionist/domain/use_case/export/import_database_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_database.dart';

Entity _makeEntity(String id, String name) {
  final now = DateTime.now();
  return Entity(
    id: id,
    name: name,
    type: EntityType.character,
    status: EntityStatus.draft,
    customFields: [],
    iconColor: 0,
    isDeleted: false,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  late AppDatabase db;

  setUp(() async {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  ExportDatabaseUseCase _makeExport() {
    return ExportDatabaseUseCase(
      EntityRepositoryImpl(db.entityDao),
      RelationshipRepositoryImpl(db.relationshipDao),
      TagRepositoryImpl(db.tagDao),
      TimelineRepositoryImpl(db.timelineDao),
      TemplateRepositoryImpl(db.templateDao),
      QuickCaptureRepositoryImpl(db.quickCaptureDao),
      EntityVersionRepositoryImpl(db.entityVersionDao),
      MapRepositoryImpl(db.mapDao),
    );
  }

  ImportDatabaseUseCase _makeImport() {
    return ImportDatabaseUseCase(
      EntityRepositoryImpl(db.entityDao),
      RelationshipRepositoryImpl(db.relationshipDao),
      TagRepositoryImpl(db.tagDao),
      TimelineRepositoryImpl(db.timelineDao),
      TemplateRepositoryImpl(db.templateDao),
      QuickCaptureRepositoryImpl(db.quickCaptureDao),
      MapRepositoryImpl(db.mapDao),
    );
  }

  group('Export/Import round-trip', () {
    test('export produces valid JSON string', () async {
      final entity = _makeEntity('e-1', 'Gandalf');
      await EntityRepositoryImpl(db.entityDao).create(entity);

      final exportUseCase = _makeExport();
      final result = await exportUseCase();
      expect(result.isRight(), true);

      result.fold(
        (_) => fail('should succeed'),
        (json) {
          expect(json, isNotEmpty);
          // Should be valid JSON
          final parsed = jsonDecode(json);
          expect(parsed, isA<Map>());
          expect(parsed['data'], isA<Map>());
          expect(parsed['data']['entities'], isA<List>());
        },
      );
    });

    test('export → import round-trip preserves entity count', () async {
      // Create entities
      final entityRepo = EntityRepositoryImpl(db.entityDao);
      await entityRepo.create(_makeEntity('e-1', 'Frodo'));
      await entityRepo.create(_makeEntity('e-2', 'Sam'));
      await entityRepo.create(_makeEntity('e-3', 'Merry'));

      // Export
      final exportJson = (await _makeExport()())
          .getOrElse((l) => fail('export failed'));

      // Close and reopen with fresh DB
      await db.close();
      db = createTestDatabase();

      // Import with replace mode
      final importResult = await _makeImport()(ImportDatabaseParams(
        jsonContent: exportJson,
        isReplace: true,
      ));
      expect(importResult.isRight(), true);

      // Verify all 3 entities exist
      final entities = await EntityRepositoryImpl(db.entityDao).getAllActive();
      entities.fold(
        (_) => fail('getAllActive failed'),
        (list) {
          expect(list.length, 3);
          expect(list.map((e) => e.name), containsAll(['Frodo', 'Sam', 'Merry']));
        },
      );
    });

    test('import with merge mode does not lose existing data', () async {
      // Create entity before export
      final entityRepo = EntityRepositoryImpl(db.entityDao);
      await entityRepo.create(_makeEntity('e-1', 'Original'));

      // Export
      final exportJson = (await _makeExport()())
          .getOrElse((l) => fail('export failed'));

      // Add another entity after export
      await entityRepo.create(_makeEntity('e-2', 'Post-Export'));

      // Add entity to export JSON manually
      final decoded = jsonDecode(exportJson) as Map<String, dynamic>;
      final entities = decoded['data']['entities'] as List;
      entities.add({
        'id': 'e-3',
        'name': 'From Import',
        'type': 'character',
        'status': 'draft',
        'description': null,
        'customFields': [],
        'iconColor': 0,
        'isDeleted': false,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      final modifiedJson = jsonEncode(decoded);

      // Import with merge (not replace)
      await _makeImport()(ImportDatabaseParams(
        jsonContent: modifiedJson,
        isReplace: false,
      ));

      final result = await entityRepo.getAllActive();
      result.fold(
        (_) => fail('should succeed'),
        (list) {
          // All 3 should exist
          expect(list.length, 3);
          expect(list.map((e) => e.name),
              containsAll(['Original', 'Post-Export', 'From Import']));
        },
      );
    });

    test('import invalid JSON returns failure', () async {
      final result = await _makeImport()(ImportDatabaseParams(
        jsonContent: 'not valid json {{',
        isReplace: false,
      ));
      expect(result.isLeft(), true);
    });

    test('export empty database produces valid export', () async {
      final result = await _makeExport()();
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('should succeed'),
        (json) {
          final parsed = jsonDecode(json);
          expect(parsed['data']['entities'], isEmpty);
        },
      );
    });
  });
}
