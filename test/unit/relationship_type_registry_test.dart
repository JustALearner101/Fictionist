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

    test('all 32 relationship types can be looked up via getDef(key) without returning null', () {
      expect(RelationshipTypeRegistry.builtinTypes.length, 32);
      for (final def in RelationshipTypeRegistry.builtinTypes) {
        final lookedUp = RelationshipTypeRegistry.getDef(def.key);
        expect(lookedUp, isNotNull, reason: 'getDef failed for key: ${def.key}');
        expect(lookedUp!.key, equals(def.key));
      }
    });

    test('all 32 relationship types have a valid non-null inverseKey registered', () {
      for (final def in RelationshipTypeRegistry.builtinTypes) {
        final inverseKey = RelationshipTypeRegistry.getInverseKey(def.key);
        expect(inverseKey, isNotNull, reason: 'getInverseKey returned null for key: ${def.key}');
        final inverseDef = RelationshipTypeRegistry.getDef(inverseKey!);
        expect(inverseDef, isNotNull, reason: 'getDef returned null for inverseKey: $inverseKey (from ${def.key})');
      }
    });

    test('reciprocal mapping is strictly symmetric (getInverseKey of inverseKey equals original key)', () {
      for (final def in RelationshipTypeRegistry.builtinTypes) {
        final inverseKey = RelationshipTypeRegistry.getInverseKey(def.key)!;
        final reciprocalKey = RelationshipTypeRegistry.getInverseKey(inverseKey);
        expect(reciprocalKey, equals(def.key),
            reason: 'Reciprocal of inverseKey ($inverseKey) for ${def.key} was $reciprocalKey');
      }
    });

    test('source and target entity types match inversely across reciprocal pairs', () {
      for (final def in RelationshipTypeRegistry.builtinTypes) {
        final inverseKey = RelationshipTypeRegistry.getInverseKey(def.key)!;
        final inverseDef = RelationshipTypeRegistry.getDef(inverseKey)!;

        expect(inverseDef.applicableSourceTypes, equals(def.applicableTargetTypes),
            reason: 'Inverse source types for ${def.key} -> $inverseKey do not match target types');
        expect(inverseDef.applicableTargetTypes, equals(def.applicableSourceTypes),
            reason: 'Inverse target types for ${def.key} -> $inverseKey do not match source types');
      }
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
        expect(def.isBidirectional, isTrue, reason: '$key should have isBidirectional=true');
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
        expect(def.isBidirectional, isFalse, reason: '$key should have isBidirectional=false');
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

