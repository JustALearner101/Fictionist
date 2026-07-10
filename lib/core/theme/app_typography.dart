import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_config.dart';
import 'theme_presets.dart';

class AppTypography {
  // ── New: ThemeConfig-aware builders ──

  /// Build a full [TextTheme] from a [ThemeConfig].
  static TextTheme buildTextTheme(ThemeConfig config) {
    return TextTheme(
      displayLarge: GoogleFonts.getFont(
        config.displayFont,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(config.textPrimary),
      ),
      headlineMedium: GoogleFonts.getFont(
        config.headingFont,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(config.textPrimary),
      ),
      titleMedium: GoogleFonts.getFont(
        config.headingFont,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(config.textPrimary),
      ),
      bodyLarge: GoogleFonts.getFont(
        config.bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: config.bodyLineHeight,
        color: Color(config.textPrimary),
      ),
      labelMedium: GoogleFonts.getFont(
        config.bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(config.textSecondary),
      ),
    );
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
