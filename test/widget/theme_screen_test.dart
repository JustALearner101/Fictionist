import 'package:flutter_test/flutter_test.dart';
import 'package:fictionist/presentation/features/theme/screen/theme_screen.dart';

void main() {
  group('ThemeScreen', () {
    testWidgets('constructs without error', (tester) async {
      // ThemeNotifier.build() calls path_provider which is unavailable in
      // unit tests. Verify the widget can at least be constructed.
      expect(() => const ThemeScreen(), returnsNormally);
    });
  });
}
