import 'package:fictionist/domain/relationship/relationship_type_registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RelationshipTypeRegistry', () {
    test('getDef returns definition for valid key', () {
      final def = RelationshipTypeRegistry.getDef('parent_of');
      expect(def, isNotNull);
      expect(def!.key, 'parent_of');
      expect(def.label, 'Parent of');
      expect(def.inverseLabel, 'Child of');
    });

    test('getDef returns null for invalid key', () {
      final def = RelationshipTypeRegistry.getDef('nonexistent_type');
      expect(def, isNull);
    });

    test('builtinTypes contains all expected definitions', () {
      expect(RelationshipTypeRegistry.builtinTypes.length, 20);
    });

    test('all definitions have non-empty keys and labels', () {
      for (final def in RelationshipTypeRegistry.builtinTypes) {
        expect(def.key.isNotEmpty, true, reason: 'empty key found');
        expect(def.label.isNotEmpty, true, reason: '${def.key} has empty label');
        expect(def.inverseLabel?.isNotEmpty, true,
            reason: '${def.key} has empty inverseLabel');
      }
    });

    test('symmetric types have same label as inverse', () {
      final symmetricTypes = ['ally_of', 'enemy_of', 'sibling_of', 'rival_of',
          'married_to', 'related_to'];
      for (final key in symmetricTypes) {
        final def = RelationshipTypeRegistry.getDef(key);
        expect(def, isNotNull, reason: '$key not found');
        expect(def!.label, def.inverseLabel,
            reason: '$key should be symmetric');
      }
    });

    test('asymmetric types have different label and inverse', () {
      final asymmetricTypes = ['parent_of', 'member_of', 'leader_of',
          'located_in', 'wields', 'created_by', 'belongs_to', 'participates_in',
          'occurred_at', 'practices', 'mentors', 'rules_over', 'worships'];
      for (final key in asymmetricTypes) {
        final def = RelationshipTypeRegistry.getDef(key);
        expect(def, isNotNull, reason: '$key not found');
        expect(def!.label, isNot(def.inverseLabel),
            reason: '$key should be asymmetric');
      }
    });

    test('getInverseKey returns correct inverse for known keys', () {
      expect(RelationshipTypeRegistry.getInverseKey('parent_of'), 'child_of');
      expect(RelationshipTypeRegistry.getInverseKey('child_of'), 'parent_of');
      expect(RelationshipTypeRegistry.getInverseKey('leader_of'), 'led_by');
      expect(RelationshipTypeRegistry.getInverseKey('ally_of'), 'ally_of');
      expect(RelationshipTypeRegistry.getInverseKey('married_to'), 'married_to');
    });

    test('getInverseKey returns null for unknown key', () {
      expect(RelationshipTypeRegistry.getInverseKey('unknown'), isNull);
    });

    test('parent_of targets only characters', () {
      final def = RelationshipTypeRegistry.getDef('parent_of')!;
      expect(def.applicableSourceTypes.length, 1);
      expect(def.applicableTargetTypes.length, 1);
    });

    test('located_in allows character sources and location targets', () {
      final def = RelationshipTypeRegistry.getDef('located_in')!;
      expect(def.applicableSourceTypes.length, greaterThan(1));
      expect(def.applicableTargetTypes.length, 1);
    });

    test('related_to allows all entity types', () {
      final def = RelationshipTypeRegistry.getDef('related_to')!;
      expect(def.applicableSourceTypes.length, 8);
      expect(def.applicableTargetTypes.length, 8);
    });
  });
}
