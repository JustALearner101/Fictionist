import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fictionist/presentation/features/graph/widget/timeline_scrubber.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('TimelineScrubber', () {
    testWidgets('renders with min/max years', (tester) async {
      int? lastYear;
      await tester.pumpWidget(_wrap(
        TimelineScrubber(
          minYear: 1800,
          maxYear: 2025,
          totalEntityCount: 128,
          visibleEntityCount: 47,
          onYearChanged: (y) => lastYear = y,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Year: 1800'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);

      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pumpAndSettle();
      expect(lastYear, isNotNull);
    });

    testWidgets('shows entity count', (tester) async {
      await tester.pumpWidget(_wrap(
        TimelineScrubber(
          minYear: 100,
          maxYear: 200,
          totalEntityCount: 50,
          visibleEntityCount: 10,
          onYearChanged: (_) {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('10/50'), findsOneWidget);
    });

    testWidgets('shrinks when minYear == maxYear', (tester) async {
      await tester.pumpWidget(_wrap(
        TimelineScrubber(
          minYear: 100,
          maxYear: 100,
          totalEntityCount: 10,
          visibleEntityCount: 10,
          onYearChanged: (_) {},
        ),
      ));
      await tester.pumpAndSettle();

      // Should render SizedBox.shrink — no slider widget
      expect(find.byType(Slider), findsNothing);
    });

    testWidgets('play/pause button exists and toggles', (tester) async {
      await tester.pumpWidget(_wrap(
        TimelineScrubber(
          minYear: 1,
          maxYear: 100,
          totalEntityCount: 10,
          visibleEntityCount: 10,
          onYearChanged: (_) {},
        ),
      ));
      await tester.pumpAndSettle();

      // Play button should be visible
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);

      // Tap play
      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pumpAndSettle();

      // Should now show pause
      expect(find.byIcon(Icons.pause), findsOneWidget);
    });

    testWidgets('close button calls onClose', (tester) async {
      var closed = false;
      await tester.pumpWidget(_wrap(
        TimelineScrubber(
          minYear: 1,
          maxYear: 10,
          totalEntityCount: 5,
          visibleEntityCount: 3,
          onYearChanged: (_) {},
          onClose: () => closed = true,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      expect(closed, true);
    });

    testWidgets('no close button when onClose is null', (tester) async {
      await tester.pumpWidget(_wrap(
        TimelineScrubber(
          minYear: 1,
          maxYear: 10,
          totalEntityCount: 5,
          visibleEntityCount: 3,
          onYearChanged: (_) {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('renders era markers', (tester) async {
      await tester.pumpWidget(_wrap(
        TimelineScrubber(
          minYear: 1800,
          maxYear: 2000,
          totalEntityCount: 10,
          visibleEntityCount: 10,
          onYearChanged: (_) {},
          eras: const [
            EraMarker(
              label: 'Victorian',
              startYear: 1837,
              endYear: 1901,
              color: Colors.brown,
            ),
          ],
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Victorian'), findsOneWidget);
    });
  });
}
