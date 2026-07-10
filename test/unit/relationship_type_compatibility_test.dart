import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:fictionist/domain/relationship/relationship_type_registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RelationshipTypeRegistry & Compatibility Tests', () {
    test('should retrieve valid type definitions by key', () {
      final parentDef = RelationshipTypeRegistry.getDef('parent_of');
      expect(parentDef, isNotNull);
      expect(parentDef!.key, 'parent_of');
      expect(parentDef.applicableSourceTypes, contains(EntityType.character));
      expect(parentDef.applicableTargetTypes, contains(EntityType.character));

      final invalidDef = RelationshipTypeRegistry.getDef('non_existent_key');
      expect(invalidDef, isNull);
    });

    test('should map inverse relationship keys correctly', () {
      expect(RelationshipTypeRegistry.getInverseKey('parent_of'), 'child_of');
      expect(RelationshipTypeRegistry.getInverseKey('child_of'), 'parent_of');
      expect(RelationshipTypeRegistry.getInverseKey('ally_of'), 'ally_of');
      expect(RelationshipTypeRegistry.getInverseKey('located_in'), 'contains');
    });

    test('should validate source and target type compatibility correctly', () {
      final memberOfDef = RelationshipTypeRegistry.getDef('member_of');
      expect(memberOfDef, isNotNull);

      // Character -> Faction should be compatible
      expect(memberOfDef!.applicableSourceTypes.contains(EntityType.character), true);
      expect(memberOfDef.applicableTargetTypes.contains(EntityType.faction), true);

      // Character -> Character should be incompatible for member_of
      expect(memberOfDef.applicableTargetTypes.contains(EntityType.character), false);

      final locatedInDef = RelationshipTypeRegistry.getDef('located_in');
      expect(locatedInDef, isNotNull);

      // Location -> Location should be incompatible source for located_in
      expect(locatedInDef!.applicableSourceTypes.contains(EntityType.location), false);
      expect(locatedInDef.applicableTargetTypes.contains(EntityType.location), true);
    });
  });
}
