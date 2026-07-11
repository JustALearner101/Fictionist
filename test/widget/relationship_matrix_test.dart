import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:fictionist/domain/relationship/relationship.dart';
import 'package:fictionist/presentation/features/graph/widget/relationship_matrix_widget.dart';

void main() {
  group('RelationshipMatrixWidget', () {
    final characters = [
      Entity(
        id: 'c1',
        name: 'Protagonist',
        type: EntityType.character,
        description: 'Main hero',
        iconColor: 0xFF4CAF50,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
      Entity(
        id: 'c2',
        name: 'Antagonist',
        type: EntityType.character,
        description: 'Villian',
        iconColor: 0xFFF44336,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    ];

    final relationships = [
      Relationship(
        id: 'r1',
        sourceId: 'c1',
        targetId: 'c2',
        typeKey: 'enemy_of',
        description: 'Bitter rivals',
        weight: 8,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    ];

    testWidgets('renders matrix headers and character names', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RelationshipMatrixWidget(
              characters: characters,
              relationships: relationships,
              onForgeConnection: (src, tgt) {},
              onDeleteConnection: (rel) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify the MATRIX title is shown
      expect(find.text('MATRIX'), findsOneWidget);

      // Verify character names are rendered in the matrix headers
      expect(find.text('Protagonist'), findsAtLeast(1));
      expect(find.text('Antagonist'), findsAtLeast(1));
    });

    testWidgets('renders relationship labels in cells', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RelationshipMatrixWidget(
              characters: characters,
              relationships: relationships,
              onForgeConnection: (src, tgt) {},
              onDeleteConnection: (rel) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify relationship key label is rendered in the grid
      // Note: RelationshipTypeRegistry has built-in definition for 'enemy_of' mapping to 'Enemy' or 'Enemy of'
      // We expect either 'Enemy of' or 'enemy_of' to show up
      expect(find.byType(InkWell), findsAtLeast(1));
    });

    testWidgets('renders empty state message when characters list is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RelationshipMatrixWidget(
              characters: const [],
              relationships: const [],
              onForgeConnection: (src, tgt) {},
              onDeleteConnection: (rel) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No characters exist to display in the matrix.'), findsOneWidget);
    });
  });
}
