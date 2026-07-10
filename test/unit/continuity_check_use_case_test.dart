import 'package:fictionist/domain/entity/custom_field.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_status.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:fictionist/domain/relationship/relationship.dart';
import 'package:fictionist/domain/timeline/timeline_entry.dart';
import 'package:fictionist/domain/use_case/continuity_check_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

Entity _makeCharacter({
  String id = 'char-1',
  String name = 'Test Character',
  List<CustomField> customFields = const [],
  EntityStatus status = EntityStatus.draft,
}) {
  final now = DateTime.now();
  return Entity(
    id: id,
    name: name,
    type: EntityType.character,
    status: status,
    customFields: customFields,
    iconColor: 0,
    createdAt: now,
    updatedAt: now,
  );
}

Entity _makeFaction({
  String id = 'faction-1',
  String name = 'Test Faction',
  List<CustomField> customFields = const [],
}) {
  final now = DateTime.now();
  return Entity(
    id: id,
    name: name,
    type: EntityType.faction,
    status: EntityStatus.draft,
    customFields: customFields,
    iconColor: 0,
    createdAt: now,
    updatedAt: now,
  );
}

TimelineEntry _makeTimelineEntry({
  String id = 'te-1',
  String title = 'Test Event',
  String? entityId = 'char-1',
  String? dateLabel,
}) {
  final now = DateTime.now();
  return TimelineEntry(
    id: id,
    title: title,
    entityId: entityId,
    dateLabel: dateLabel,
    sortOrder: 0,
    createdAt: now,
    updatedAt: now,
  );
}

Relationship _makeRelationship({
  String id = 'rel-1',
  String sourceId = 'char-1',
  String targetId = 'faction-1',
  String typeKey = 'member_of',
}) {
  final now = DateTime.now();
  return Relationship(
    id: id,
    sourceId: sourceId,
    targetId: targetId,
    typeKey: typeKey,
    createdAt: now,
    updatedAt: now,
  );
}

CustomField _makeField({
  String key = 'birth_date',
  String label = 'Birth Date',
  String value = '1000',
}) {
  return CustomField(
    id: 'cf-${key}',
    key: key,
    label: label,
    fieldType: 'text',
    value: value,
  );
}

void main() {
  late ContinuityCheckUseCase useCase;

  setUp(() {
    useCase = ContinuityCheckUseCase();
  });

  group('ContinuityCheckUseCase', () {
    test('clean input produces no violations', () async {
      final result = await useCase(ContinuityCheckParams(
        entities: [_makeCharacter()],
        relationships: [],
        timelineEntries: [],
      ));

      final checkResult = result.getOrElse(
        (l) => fail('should succeed'),
      );
      expect(checkResult.isClean, true);
      expect(checkResult.violations, isEmpty);
    });

    group('Life Bounds check', () {
      test('event after character death produces violation', () async {
        final character = _makeCharacter(
          id: 'char-1',
          name: 'Aragorn',
          customFields: [
            _makeField(key: 'death_date', label: 'Death Date', value: '3000'),
          ],
        );
        final entry = _makeTimelineEntry(
          id: 'te-1',
          title: 'Battle',
          entityId: 'char-1',
          dateLabel: '3100',
        );

        final result = await useCase(ContinuityCheckParams(
          entities: [character],
          relationships: [],
          timelineEntries: [entry],
        ));

        final checkResult = result.getOrElse((l) => fail('should succeed'));
        expect(checkResult.violations.length, 1);
        expect(checkResult.violations.first.severity, 'error');
        expect(checkResult.violations.first.message, contains('death'));
      });

      test('event before death produces no violation', () async {
        final character = _makeCharacter(
          id: 'char-1',
          customFields: [
            _makeField(key: 'death_date', value: '3000'),
          ],
        );
        final entry = _makeTimelineEntry(
          dateLabel: '2900',
        );

        final result = await useCase(ContinuityCheckParams(
          entities: [character],
          relationships: [],
          timelineEntries: [entry],
        ));

        final checkResult = result.getOrElse((l) => fail('should succeed'));
        expect(checkResult.violations, isEmpty);
      });

      test('entity without birth/death fields produces no violations', () async {
        final character = _makeCharacter();
        final entry = _makeTimelineEntry(dateLabel: '2000');

        final result = await useCase(ContinuityCheckParams(
          entities: [character],
          relationships: [],
          timelineEntries: [entry],
        ));

        final checkResult = result.getOrElse((l) => fail('should succeed'));
        expect(checkResult.violations, isEmpty);
      });

      test('deprecated entities are skipped', () async {
        final character = _makeCharacter(
          status: EntityStatus.deprecated,
          customFields: [
            _makeField(key: 'death_date', value: '1000'),
          ],
        );
        final entry = _makeTimelineEntry(dateLabel: '2000');

        final result = await useCase(ContinuityCheckParams(
          entities: [character],
          relationships: [],
          timelineEntries: [entry],
        ));

        final checkResult = result.getOrElse((l) => fail('should succeed'));
        expect(checkResult.violations, isEmpty);
      });

      test('event without dateLabel is skipped', () async {
        final character = _makeCharacter(
          customFields: [
            _makeField(key: 'death_date', value: '2000'),
          ],
        );
        final entry = _makeTimelineEntry(dateLabel: null);

        final result = await useCase(ContinuityCheckParams(
          entities: [character],
          relationships: [],
          timelineEntries: [entry],
        ));

        final checkResult = result.getOrElse((l) => fail('should succeed'));
        expect(checkResult.violations, isEmpty);
      });
    });

    group('Faction Activity check', () {
      test('member born before faction founded produces warning', () async {
        final member = _makeCharacter(
          id: 'char-1',
          name: 'Gimli',
          customFields: [
            _makeField(key: 'birth_date', value: '1000'),
          ],
        );
        final faction = _makeFaction(
          id: 'faction-1',
          name: 'Dwarven Guild',
          customFields: [
            _makeField(key: 'founded', label: 'Founded', value: '1500'),
          ],
        );
        final relationship = _makeRelationship(
          sourceId: 'char-1',
          targetId: 'faction-1',
          typeKey: 'member_of',
        );

        final result = await useCase(ContinuityCheckParams(
          entities: [member, faction],
          relationships: [relationship],
          timelineEntries: [],
        ));

        final checkResult = result.getOrElse((l) => fail('should succeed'));
        expect(checkResult.violations.length, 1);
        expect(checkResult.violations.first.severity, 'warning');
        expect(checkResult.violations.first.message, contains('born'));
      });

      test('member born after faction founded produces no warning', () async {
        final member = _makeCharacter(
          id: 'char-1',
          customFields: [
            _makeField(key: 'birth_date', value: '2000'),
          ],
        );
        final faction = _makeFaction(
          id: 'faction-1',
          customFields: [
            _makeField(key: 'founded', value: '1000'),
          ],
        );
        final relationship = _makeRelationship();

        final result = await useCase(ContinuityCheckParams(
          entities: [member, faction],
          relationships: [relationship],
          timelineEntries: [],
        ));

        final checkResult = result.getOrElse((l) => fail('should succeed'));
        expect(checkResult.violations, isEmpty);
      });

      test('non-member_of relationships are ignored', () async {
        final member = _makeCharacter(id: 'char-1');
        final faction = _makeFaction();
        final relationship = _makeRelationship(typeKey: 'ally_of');

        final result = await useCase(ContinuityCheckParams(
          entities: [member, faction],
          relationships: [relationship],
          timelineEntries: [],
        ));

        final checkResult = result.getOrElse((l) => fail('should succeed'));
        expect(checkResult.violations, isEmpty);
      });
    });

    group('Orphan Entry check', () {
      test('timeline entry referencing missing entity produces warning', () async {
        final entry = _makeTimelineEntry(
          title: 'Lost Event',
          entityId: 'non-existent-id',
        );

        final result = await useCase(ContinuityCheckParams(
          entities: [],
          relationships: [],
          timelineEntries: [entry],
        ));

        final checkResult = result.getOrElse((l) => fail('should succeed'));
        expect(checkResult.violations.length, 1);
        expect(checkResult.violations.first.severity, 'warning');
        expect(checkResult.violations.first.message, contains('references a deleted'));
      });

      test('timeline entry with valid entity reference produces no warning', () async {
        final entity = _makeCharacter(id: 'char-1');
        final entry = _makeTimelineEntry(entityId: 'char-1');

        final result = await useCase(ContinuityCheckParams(
          entities: [entity],
          relationships: [],
          timelineEntries: [entry],
        ));

        final checkResult = result.getOrElse((l) => fail('should succeed'));
        expect(checkResult.violations, isEmpty);
      });

      test('timeline entry with null entityId is skipped', () async {
        final entry = _makeTimelineEntry(entityId: null);

        final result = await useCase(ContinuityCheckParams(
          entities: [],
          relationships: [],
          timelineEntries: [entry],
        ));

        final checkResult = result.getOrElse((l) => fail('should succeed'));
        expect(checkResult.violations, isEmpty);
      });
    });

    test('multiple violations aggregated', () async {
      final character = _makeCharacter(
        id: 'char-1',
        name: 'Elrond',
        customFields: [
          _makeField(key: 'death_date', value: '3000'),
        ],
      );
      final entry1 = _makeTimelineEntry(
        id: 'te-1',
        entityId: 'char-1',
        dateLabel: '3100',
      );
      final entry2 = _makeTimelineEntry(
        id: 'te-2',
        entityId: 'char-1',
        dateLabel: '3101',
      );
      final orphan = _makeTimelineEntry(
        id: 'te-3',
        title: 'Orphan Event',
        entityId: 'missing-id',
      );

      final result = await useCase(ContinuityCheckParams(
        entities: [character],
        relationships: [],
        timelineEntries: [entry1, entry2, orphan],
      ));

      final checkResult = result.getOrElse((l) => fail('should succeed'));
      expect(checkResult.violations.length, 3);
    });
  });
}
