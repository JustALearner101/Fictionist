import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:fictionist/core/theme/theme_config.dart';

/// Persists and loads [ThemeConfig] from the local filesystem.
///
/// Theme data is stored as JSON in the application documents directory.
/// Uses `path_provider` (already in pubspec) and `dart:convert` —
/// no additional dependencies needed.
class ThemePersistence {
  static const _fileName = 'fictionist_theme.json';

  /// Save a [ThemeConfig] to disk.
  Future<void> save(ThemeConfig config) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, _fileName));
    await file.writeAsString(jsonEncode(config.toJson()));
  }

  /// Load a previously saved [ThemeConfig] from disk.
  ///
  /// Returns `null` if no saved configuration exists.
  Future<ThemeConfig?> load() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, _fileName));
    if (!await file.exists()) return null;
    try {
      final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      return ThemeConfig.fromJson(json);
    } on Exception {
      return null;
    }
  }
}
