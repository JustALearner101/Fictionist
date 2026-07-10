import 'package:fictionist/domain/relationship/relationship_type_registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RelationshipTypeRegistry contains preset types', () {
    expect(RelationshipTypeRegistry.builtinTypes.isNotEmpty, true);
    final inverse = RelationshipTypeRegistry.getInverseKey('parent_of');
    expect(inverse, 'child_of');
  });
}
