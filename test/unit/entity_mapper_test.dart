import 'dart:convert';
import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/data/mapper/entity_mapper.dart';
import 'package:fictionist/domain/entity/custom_field.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_status.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EntityMapper', () {
    final now = DateTime(2025, 7, 6, 12, 0);

    test('toDomain maps all fields from EntityRow', () {
      final row = EntityRow(
        id: 'test-id',
        name: 'Gandalf',
        entityType: 'character',
        status: 'canon',
        description: 'The Grey Wizard',
        customFields: jsonEncode([
          {
            'id': 'cf-1',
            'key': 'staff_name',
            'label': 'Staff Name',
            'fieldType': 'text',
            'value': 'Glamdring',
          },
        ]),
        iconColor: 0xFF8B5CF6,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final domain = EntityMapper.toDomain(row);

      expect(domain.id, 'test-id');
      expect(domain.name, 'Gandalf');
      expect(domain.type, EntityType.character);
      expect(domain.status, EntityStatus.canon);
      expect(domain.description, 'The Grey Wizard');
      expect(domain.iconColor, 0xFF8B5CF6);
      expect(domain.isDeleted, false);
      expect(domain.createdAt, now);
      expect(domain.updatedAt, now);
      expect(domain.customFields.length, 1);
      expect(domain.customFields.first.key, 'staff_name');
      expect(domain.customFields.first.value, 'Glamdring');
    });

    test('toDomain handles null description', () {
      final row = EntityRow(
        id: 'test-id',
        name: 'Ringwraith',
        entityType: 'character',
        status: 'draft',
        description: null,
        customFields: '[]',
        iconColor: 0,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final domain = EntityMapper.toDomain(row);
      expect(domain.description, isNull);
    });

    test('toDomain handles empty custom fields', () {
      final row = EntityRow(
        id: 'test-id',
        name: 'Bilbo',
        entityType: 'character',
        status: 'draft',
        description: null,
        customFields: '[]',
        iconColor: 0,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final domain = EntityMapper.toDomain(row);
      expect(domain.customFields, isEmpty);
    });

    test('toDomain handles soft-deleted entity', () {
      final row = EntityRow(
        id: 'test-id',
        name: 'Deleted',
        entityType: 'character',
        status: 'draft',
        description: null,
        customFields: '[]',
        iconColor: 0,
        isDeleted: true,
        createdAt: now,
        updatedAt: now,
      );

      final domain = EntityMapper.toDomain(row);
      expect(domain.isDeleted, true);
    });

    test('toCompanion maps all Entity fields to EntitiesCompanion', () {
      final entity = Entity(
        id: 'test-id',
        name: 'Saruman',
        type: EntityType.character,
        status: EntityStatus.canon,
        description: 'The White Wizard',
        customFields: [
          CustomField(
            id: 'cf-1',
            key: 'staff_type',
            label: 'Staff Type',
            fieldType: 'text',
            value: 'Black',
          ),
        ],
        iconColor: 0xFFFFFFFF,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final companion = EntityMapper.toCompanion(entity);

      expect(companion.id.value, 'test-id');
      expect(companion.name.value, 'Saruman');
      expect(companion.entityType.value, 'character');
      expect(companion.status.value, 'canon');
      expect(companion.description.value, 'The White Wizard');
      expect(companion.iconColor.value, 0x00FFFFFF);
      expect(companion.isDeleted.value, false);
      expect(companion.createdAt.value, now);
      expect(companion.updatedAt.value, now);

      // Custom fields round-trip
      final decoded =
          jsonDecode(companion.customFields.value) as List;
      expect(decoded.length, 1);
      expect(decoded[0]['key'], 'staff_type');
    });

    test('domain -> EntityRow -> domain round-trip preserves identity', () {
      final original = Entity(
        id: 'round-trip-id',
        name: 'Thranduil',
        type: EntityType.character,
        status: EntityStatus.canon,
        description: 'King of the Woodland Realm',
        customFields: [
          CustomField(
            id: 'cf-a',
            key: 'crown_type',
            label: 'Crown Type',
            fieldType: 'text',
            value: 'Woodland Crown',
          ),
          CustomField(
            id: 'cf-b',
            key: 'reign_start',
            label: 'Reign Start',
            fieldType: 'number',
            value: '1000',
          ),
        ],
        iconColor: 0xFF3B82F6,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final companion = EntityMapper.toCompanion(original);
      final row = EntityRow(
        id: companion.id.value,
        name: companion.name.value,
        entityType: companion.entityType.value,
        status: companion.status.value,
        description: companion.description.value,
        customFields: companion.customFields.value,
        iconColor: companion.iconColor.value,
        isDeleted: companion.isDeleted.value,
        createdAt: companion.createdAt.value,
        updatedAt: companion.updatedAt.value,
      );
      final roundTrip = EntityMapper.toDomain(row);

      expect(roundTrip.id, original.id);
      expect(roundTrip.name, original.name);
      expect(roundTrip.type, original.type);
      expect(roundTrip.status, original.status);
      expect(roundTrip.description, original.description);
      expect(roundTrip.iconColor, original.iconColor);
      expect(roundTrip.isDeleted, original.isDeleted);
      expect(roundTrip.createdAt, original.createdAt);
      expect(roundTrip.updatedAt, original.updatedAt);
      expect(roundTrip.customFields.length, original.customFields.length);
      expect(roundTrip.customFields[0].key, original.customFields[0].key);
      expect(roundTrip.customFields[0].value, original.customFields[0].value);
      expect(roundTrip.customFields[1].key, original.customFields[1].key);
    });
  });
}
