import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'theme_config.dart';
import 'theme_presets.dart';

class AppTheme {
  /// Build a [ThemeData] from a [ThemeConfig].
  ///
  /// This is the primary entry point for theme-aware widgets.
  /// The theme system reads the current config from [ThemeNotifier]
  /// and passes it here.
  static ThemeData build(ThemeConfig config) {
    final brightness = config.themeMode == ThemeMode.light
        ? Brightness.light
        : Brightness.dark;

    final colors = brightness == Brightness.light
        ? ColorScheme.light(
            primary: Color(config.primary),
            secondary: Color(config.secondary),
            surface: Color(config.surface),
            onPrimary: Color(config.textPrimary),
            onSecondary: Color(config.textPrimary),
            onSurface: Color(config.textPrimary),
            error: Color(config.error),
            outline: Color(config.border),
            surfaceContainerHighest: Color(config.surfaceVariant),
          )
        : ColorScheme.dark(
            primary: Color(config.primary),
            secondary: Color(config.secondary),
            surface: Color(config.surface),
            onPrimary: Color(config.textPrimary),
            onSecondary: Color(config.textPrimary),
            onSurface: Color(config.textPrimary),
            error: Color(config.error),
            outline: Color(config.border),
            surfaceContainerHighest: Color(config.surfaceVariant),
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: Color(config.background),
      colorScheme: colors,
      textTheme: AppTypography.buildTextTheme(config),
      cardTheme: CardThemeData(
        color: Color(config.surface),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.cardRadius),
          side: BorderSide(
            color: Color(config.border),
            width: config.borderWidth,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(config.surface),
        foregroundColor: Color(config.textPrimary),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(config.surface),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.inputRadius),
          borderSide: BorderSide(color: Color(config.border)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.inputRadius),
          borderSide: BorderSide(color: Color(config.border)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.inputRadius),
          borderSide: BorderSide(
            color: Color(config.primary),
            width: 2,
          ),
        ),
        labelStyle: AppTypography.labelMediumFrom(config),
        hintStyle: AppTypography.labelMediumFrom(config),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(config.primary),
        foregroundColor: Color(config.background),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(config.surface),
        selectedItemColor: Color(config.primary),
        unselectedItemColor: Color(config.textSecondary),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  /// @deprecated Use [build] with a [ThemeConfig] instead.
  /// Kept for backward compatibility during migration.
  static ThemeData get darkTheme => build(ThemePresets.grimoire);

  /// @deprecated Use [build] with a light [ThemeConfig] (e.g. [ThemePresets.parchment]) instead.
  /// Kept for backward compatibility during migration.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
    );
  }
}
