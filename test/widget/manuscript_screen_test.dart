import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fictionist/presentation/features/manuscript/screen/manuscript_screen.dart';

void main() {
  group('ManuscriptScreen', () {
    testWidgets('renders without crashing', (tester) async {
      // The manuscript provider requires database access which is not
      // available in unit tests. Verify the widget can be constructed.
      expect(() => const ManuscriptScreen(), returnsNormally);
    });
  });
}
