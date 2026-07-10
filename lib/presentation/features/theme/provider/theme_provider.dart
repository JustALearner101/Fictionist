import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fictionist/core/theme/theme_config.dart';
import 'package:fictionist/core/theme/theme_presets.dart';
import 'package:fictionist/core/theme/theme_persistence.dart';

part 'theme_provider.g.dart';

/// Central theme state for the Fictionist app.
///
/// Loads persisted theme on first read and falls back to [ThemePresets.grimoire].
/// Supports applying presets, updating individual config values, and
/// resetting to the default theme.
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  Future<ThemeConfig> build() async {
    final persistence = ThemePersistence();
    final saved = await persistence.load();
    return saved ?? ThemePresets.grimoire;
  }

  /// Apply a full preset theme configuration.
  Future<void> applyPreset(ThemeConfig preset) async {
    state = AsyncData(preset);
    await ThemePersistence().save(preset);
  }

  /// Update the theme with an arbitrary [ThemeConfig].
  Future<void> updateConfig(ThemeConfig config) async {
    state = AsyncData(config);
    await ThemePersistence().save(config);
  }

  /// Reset the theme to the default Grimoire preset.
  Future<void> resetToDefault() async {
    state = AsyncData(ThemePresets.grimoire);
    await ThemePersistence().save(ThemePresets.grimoire);
  }
}
