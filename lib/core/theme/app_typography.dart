import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_config.dart';
import 'theme_presets.dart';

class AppTypography {
  // ── New: ThemeConfig-aware builders ──

  /// Build a full [TextTheme] from a [ThemeConfig].
  static TextTheme buildTextTheme(ThemeConfig config) {
    final textColor = Color(config.textPrimary);
    final secondaryColor = Color(config.textSecondary);

    return TextTheme(
      displayLarge: getTextStyle(
        config.displayFont,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      headlineMedium: getTextStyle(
        config.headingFont,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      titleMedium: getTextStyle(
        config.headingFont,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: getTextStyle(
        config.bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: config.bodyLineHeight,
        color: textColor,
      ),
      labelMedium: getTextStyle(
        config.bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
      ),
    );
  }

  /// Dynamic helper that loads system fonts locally (offline-first) or GoogleFonts fallback.
  static TextStyle getTextStyle(
    String family, {
    required double fontSize,
    required FontWeight fontWeight,
    double? height,
    required Color color,
  }) {
    const systemFonts = {
      'Georgia',
      'Times New Roman',
      'Garamond',
      'Segoe UI',
      'Arial',
      'Calibri',
      'Courier New',
      'Consolas',
    };

    if (systemFonts.contains(family)) {
      return TextStyle(
        fontFamily: family,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        color: color,
      );
    }

    try {
      return GoogleFonts.getFont(
        family,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        color: color,
      );
    } catch (_) {
      return TextStyle(
        fontFamily: family,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        color: color,
      );
    }
  }

  /// Convenience: displayLarge from a [ThemeConfig].
  static TextStyle displayLargeFrom(ThemeConfig config) =>
      buildTextTheme(config).displayLarge!;

  /// Convenience: headlineMedium from a [ThemeConfig].
  static TextStyle headlineMediumFrom(ThemeConfig config) =>
      buildTextTheme(config).headlineMedium!;

  /// Convenience: titleMedium from a [ThemeConfig].
  static TextStyle titleMediumFrom(ThemeConfig config) =>
      buildTextTheme(config).titleMedium!;

  /// Convenience: bodyLarge from a [ThemeConfig].
  static TextStyle bodyLargeFrom(ThemeConfig config) =>
      buildTextTheme(config).bodyLarge!;

  /// Convenience: labelMedium from a [ThemeConfig].
  static TextStyle labelMediumFrom(ThemeConfig config) =>
      buildTextTheme(config).labelMedium!;

  // ── Deprecated: static getters (use ThemeConfig-aware methods instead) ──

  /// @deprecated Use [buildTextTheme] with a ThemeConfig instead.
  static TextStyle get displayLarge =>
      displayLargeFrom(ThemePresets.grimoire);

  /// @deprecated Use [buildTextTheme] with a ThemeConfig instead.
  static TextStyle get headlineMedium =>
      headlineMediumFrom(ThemePresets.grimoire);

  /// @deprecated Use [buildTextTheme] with a ThemeConfig instead.
  static TextStyle get titleMedium =>
      titleMediumFrom(ThemePresets.grimoire);

  /// @deprecated Use [buildTextTheme] with a ThemeConfig instead.
  static TextStyle get bodyLarge =>
      bodyLargeFrom(ThemePresets.grimoire);

  /// @deprecated Use [buildTextTheme] with a ThemeConfig instead.
  static TextStyle get labelMedium =>
      labelMediumFrom(ThemePresets.grimoire);
}
