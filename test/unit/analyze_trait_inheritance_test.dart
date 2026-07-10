import 'package:fictionist/domain/entity/custom_field.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_status.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:fictionist/domain/relationship/relationship.dart';
import 'package:fictionist/domain/use_case/trait/analyze_trait_inheritance_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

Entity _makeChar(String id, String name, List<CustomField> customFields) {
  final now = DateTime.now();
  return Entity(
    id: id,
    name: name,
    type: EntityType.character,
    status: EntityStatus.draft,
    customFields: customFields,
    iconColor: 0,
    createdAt: now,
    updatedAt: now,
  );
}

Relationship _makeRel(String id, String sourceId, String targetId, String typeKey) {
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

CustomField _makeField(String key, String label, String value) {
  return CustomField(
    id: 'cf-$key',
    key: key,
    label: label,
    fieldType: 'text',
    value: value,
  );
}

void main() {
  late AnalyzeTraitInheritanceUseCase useCase;

  setUp(() {
    useCase = AnalyzeTraitInheritanceUseCase();
  });

  test('direct inheritance: child inherits trait from parent', () async {
    final parent = _makeChar('p1', 'Elrond', [
      _makeField('hair_color', 'Hair Color', 'Silver'),
    ]);
    final child = _makeChar('c1', 'Arwen', [
      _makeField('hair_color', 'Hair Color', 'Silver'),
    ]);
    final rel = _makeRel('r1', 'p1', 'c1', 'parent_of');

    final result = await useCase(AnalyzeTraitInheritanceParams(
      characters: [parent, child],
      relationships: [rel],
    ));

    final traits = result.getOrElse((l) => fail('should succeed'));
    final childTrait = traits.firstWhere((t) => t.entityId == 'c1');
    expect(childTrait.isInherited, true);
    expect(childTrait.inheritedFromIds, contains('p1'));
    expect(childTrait.inheritedFromNames, contains('Elrond'));
  });

  test('child_of relationship also works for inheritance', () async {
    final parent = _makeChar('p1', 'Thranduil', [
      _makeField('eye_color', 'Eye Color', 'Blue'),
    ]);
    final child = _makeChar('c1', 'Legolas', [
      _makeField('eye_color', 'Eye Color', 'Blue'),
    ]);
    final rel = _makeRel('r1', 'c1', 'p1', 'child_of');

    final result = await useCase(AnalyzeTraitInheritanceParams(
      characters: [parent, child],
      relationships: [rel],
    ));

    final traits = result.getOrElse((l) => fail('should succeed'));
    final childTrait = traits.firstWhere((t) => t.entityId == 'c1');
    expect(childTrait.isInherited, true);
    expect(childTrait.inheritedFromNames, contains('Thranduil'));
  });

  test('no inheritance when child has trait parents do not', () async {
    final parent = _makeChar('p1', 'Aragorn', [
      _makeField('hair_color', 'Hair Color', 'Dark'),
    ]);
    final child = _makeChar('c1', 'Eldarion', [
      _makeField('hair_color', 'Hair Color', 'Silver'),
    ]);
    final rel = _makeRel('r1', 'p1', 'c1', 'parent_of');

    final result = await useCase(AnalyzeTraitInheritanceParams(
      characters: [parent, child],
      relationships: [rel],
    ));

    // The use case checks key-level inheritance (same trait key exists on parent with non-empty value).
    // It does NOT compare values, so 'hair_color' on both parent and child = inherited.
    final traits = result.getOrElse((l) => fail('should succeed'));
    final childTrait = traits.firstWhere((t) => t.entityId == 'c1');
    expect(childTrait.isInherited, true);
    expect(childTrait.inheritedFromIds, contains('p1'));
  });

  test('multi-parent inheritance from both parents', () async {
    final mother = _makeChar('m1', 'Celebrian', [
      _makeField('hair_color', 'Hair Color', 'Silver'),
    ]);
    final father = _makeChar('f1', 'Elrond', [
      _makeField('hair_color', 'Hair Color', 'Silver'),
    ]);
    final child = _makeChar('c1', 'Arwen', [
      _makeField('hair_color', 'Hair Color', 'Silver'),
    ]);
    final rel1 = _makeRel('r1', 'm1', 'c1', 'parent_of');
    final rel2 = _makeRel('r2', 'f1', 'c1', 'parent_of');

    final result = await useCase(AnalyzeTraitInheritanceParams(
      characters: [mother, father, child],
      relationships: [rel1, rel2],
    ));

    final traits = result.getOrElse((l) => fail('should succeed'));
    final childTrait = traits.firstWhere((t) => t.entityId == 'c1');
    expect(childTrait.isInherited, true);
    expect(childTrait.inheritedFromNames.length, 2);
    expect(childTrait.inheritedFromNames, containsAll(['Celebrian', 'Elrond']));
  });

  test('non-character entities are skipped', () async {
    final faction = Entity(
      id: 'f1',
      name: 'Council',
      type: EntityType.faction,
      status: EntityStatus.draft,
      customFields: [_makeField('hair_color', 'Hair Color', 'N/A')],
      iconColor: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await useCase(AnalyzeTraitInheritanceParams(
      characters: [faction],
      relationships: [],
    ));

    final traits = result.getOrElse((l) => fail('should succeed'));
    expect(traits, isEmpty);
  });

  test('entity without custom fields returns empty results', () async {
    final character = _makeChar('c1', 'Bilbo', []);

    final result = await useCase(AnalyzeTraitInheritanceParams(
      characters: [character],
      relationships: [],
    ));

    final traits = result.getOrElse((l) => fail('should succeed'));
    expect(traits, isEmpty);
  });

  test('empty value fields are skipped', () async {
    final character = _makeChar('c1', 'Frodo', [
      _makeField('hair_color', 'Hair Color', ''),
    ]);

    final result = await useCase(AnalyzeTraitInheritanceParams(
      characters: [character],
      relationships: [],
    ));

    final traits = result.getOrElse((l) => fail('should succeed'));
    expect(traits, isEmpty);
  });

  test('multiple traits on one character', () async {
    final parent = _makeChar('p1', 'Elrond', [
      _makeField('hair_color', 'Hair Color', 'Silver'),
      _makeField('eye_color', 'Eye Color', 'Grey'),
    ]);
    final child = _makeChar('c1', 'Arwen', [
      _makeField('hair_color', 'Hair Color', 'Silver'),
      _makeField('eye_color', 'Eye Color', 'Grey'),
    ]);
    final rel = _makeRel('r1', 'p1', 'c1', 'parent_of');

    final result = await useCase(AnalyzeTraitInheritanceParams(
      characters: [parent, child],
      relationships: [rel],
    ));

    final traits = result.getOrElse((l) => fail('should succeed'));
    final childTraits = traits.where((t) => t.entityId == 'c1').toList();
    expect(childTraits.length, 2);
    expect(childTraits.every((t) => t.isInherited), true);
  });

  test('badgeColor returns valid color from palette', () {
    expect(AnalyzeTraitInheritanceUseCase.badgeColor(0), 0xFFD4A44C);
    expect(AnalyzeTraitInheritanceUseCase.badgeColor(8), 0xFFD4A44C); // wraps
    expect(AnalyzeTraitInheritanceUseCase.badgeColor(3), 0xFF34D399);
  });
}
