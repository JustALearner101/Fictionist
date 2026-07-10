import 'package:drift/native.dart';
import 'package:fictionist/data/database/app_database.dart';

/// Creates an in-memory AppDatabase for integration tests.
/// This uses real SQLite via `NativeDatabase.memory()`, so FTS5, triggers,
/// and foreign keys all work exactly as they do on device.
AppDatabase createTestDatabase() {
  return AppDatabase.forTesting(NativeDatabase.memory());
}
