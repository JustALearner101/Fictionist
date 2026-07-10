import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

/// Test configuration for Fictionist.
///
/// This file is automatically loaded by `flutter test` before any tests run.
/// It disables Google Fonts runtime fetching so that widget tests don't
/// attempt HTTP calls to fonts.gstatic.com.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  await testMain();
}
