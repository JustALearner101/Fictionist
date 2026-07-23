import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fictionist/presentation/features/settings/screen/settings_screen.dart';

Widget _wrap(Widget child) {
  return ProviderScope(
    child: MaterialApp(home: child),
  );
}

void main() {
  group('SettingsScreen', () {
    testWidgets('renders with export/import/purge buttons', (tester) async {
      await tester.pumpWidget(_wrap(const SettingsScreen()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should have a Scaffold
      expect(find.byType(Scaffold), findsOneWidget);

      // Should have the settings title
      expect(find.text('Archivist Settings'), findsOneWidget);

      // Should have section header
      expect(find.text('Codex Management'), findsOneWidget);

      // Should have action tiles (ListTile or custom tile widgets)
      expect(find.text('Export Full Codex'), findsOneWidget);
      expect(find.text('Import Codex JSON'), findsOneWidget);
      expect(find.text('Purge Soft-Deleted Entities'), findsOneWidget);
    });

    testWidgets('shows About section', (tester) async {
      await tester.pumpWidget(_wrap(const SettingsScreen()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('About'), findsOneWidget);
      expect(find.text('Fictionist v1.1.0'), findsOneWidget);
    });
  });
}
