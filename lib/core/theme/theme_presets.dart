import 'package:flutter/material.dart';

import 'package:fictionist/core/theme/theme_config.dart';

/// Pre-built theme configurations for Fictionist.
///
/// Each preset defines a complete color palette, font set, and shape
/// configuration. Use [ThemeNotifier.applyPreset] to switch.
class ThemePresets {
  ThemePresets._();

  /// The default dark grimoire theme — purple + amber, elegant.
  static final ThemeConfig grimoire = ThemeConfig(
    name: 'Grimoire',
    themeMode: ThemeMode.dark,
    background: 0xFF120E16,
    surface: 0xFF1E1A24,
    surfaceVariant: 0xFF2D2836,
    primary: 0xFFA78BFA,
    secondary: 0xFFD4A373,
    textPrimary: 0xFFE2E0E6,
    textSecondary: 0xFF9E9AA6,
    border: 0xFF3A3445,
    success: 0xFF34D399,
    warning: 0xFFFBBF24,
    error: 0xFFF87171,
    displayFont: 'Lora',
    headingFont: 'Outfit',
    bodyFont: 'Inter',
  );

  /// Warm gold + cream tones with dark background.
  static final ThemeConfig solar = ThemeConfig(
    name: 'Solar',
    themeMode: ThemeMode.dark,
    background: 0xFF1A1410,
    surface: 0xFF26201A,
    surfaceVariant: 0xFF3D3528,
    primary: 0xFFD4A44C,
    secondary: 0xFFE8B870,
    textPrimary: 0xFFF5E6D0,
    textSecondary: 0xFFB8A890,
    border: 0xFF4A4030,
    success: 0xFF4CAF50,
    warning: 0xFFFFB74D,
    error: 0xFFE57373,
    displayFont: 'Playfair Display',
    headingFont: 'Poppins',
    bodyFont: 'Nunito',
  );

  /// Deep green + wood tones, inspired by forests.
  static final ThemeConfig forest = ThemeConfig(
    name: 'Forest',
    themeMode: ThemeMode.dark,
    background: 0xFF0F1A14,
    surface: 0xFF16261E,
    surfaceVariant: 0xFF243D30,
    primary: 0xFF34D399,
    secondary: 0xFF8B6914,
    textPrimary: 0xFFD4EDDA,
    textSecondary: 0xFF8BA894,
    border: 0xFF2D4A38,
    success: 0xFF34D399,
    warning: 0xFFFBBF24,
    error: 0xFFF87171,
    displayFont: 'Cormorant Garamond',
    headingFont: 'Montserrat',
    bodyFont: 'Source Serif 4',
  );

  /// Blue + teal tones with deep navy background.
  static final ThemeConfig ocean = ThemeConfig(
    name: 'Ocean',
    themeMode: ThemeMode.dark,
    background: 0xFF0A1628,
    surface: 0xFF101E36,
    surfaceVariant: 0xFF1C3054,
    primary: 0xFF60A5FA,
    secondary: 0xFF2DD4BF,
    textPrimary: 0xFFD8E8FF,
    textSecondary: 0xFF8AA4CC,
    border: 0xFF284478,
    success: 0xFF34D399,
    warning: 0xFFFBBF24,
    error: 0xFFF87171,
    displayFont: 'Merriweather',
    headingFont: 'Raleway',
    bodyFont: 'Lato',
  );

  /// Pure black + white — minimal and high contrast.
  static final ThemeConfig obsidian = ThemeConfig(
    name: 'Obsidian',
    themeMode: ThemeMode.dark,
    background: 0xFF000000,
    surface: 0xFF0D0D0D,
    surfaceVariant: 0xFF1A1A1A,
    primary: 0xFFFFFFFF,
    secondary: 0xFFA0A0A0,
    textPrimary: 0xFFF0F0F0,
    textSecondary: 0xFF808080,
    border: 0xFF333333,
    success: 0xFF34D399,
    warning: 0xFFFBBF24,
    error: 0xFFF87171,
    displayFont: 'Cinzel',
    headingFont: 'Outfit',
    bodyFont: 'Inter',
  );

  /// Warm paper tones for a light reading mode.
  static final ThemeConfig parchment = ThemeConfig(
    name: 'Parchment',
    themeMode: ThemeMode.light,
    background: 0xFFF5F0E8,
    surface: 0xFFFFFFFF,
    surfaceVariant: 0xFFEDE4D4,
    primary: 0xFF8B6914,
    secondary: 0xFF3B5998,
    textPrimary: 0xFF2D2416,
    textSecondary: 0xFF6B5E4A,
    border: 0xFFD4C4A8,
    success: 0xFF4CAF50,
    warning: 0xFFF59E0B,
    error: 0xFFDC2626,
    displayFont: 'Lora',
    headingFont: 'Outfit',
    bodyFont: 'Inter',
  );

  /// Cyberpunk-inspired neon colors on deep purple.
  static final ThemeConfig neon = ThemeConfig(
    name: 'Neon',
    themeMode: ThemeMode.dark,
    background: 0xFF0D0221,
    surface: 0xFF150530,
    surfaceVariant: 0xFF250A4A,
    primary: 0xFFFF00FF,
    secondary: 0xFF00FFFF,
    textPrimary: 0xFFF0E0FF,
    textSecondary: 0xFFAA80CC,
    border: 0xFF3D1A6E,
    success: 0xFF00FF88,
    warning: 0xFFFFFF00,
    error: 0xFFFF0044,
    displayFont: 'Cinzel',
    headingFont: 'Montserrat',
    bodyFont: 'Inter',
  );

  /// Grayscale tones for a distraction-free workspace.
  static final ThemeConfig monochrome = ThemeConfig(
    name: 'Monochrome',
    themeMode: ThemeMode.dark,
    background: 0xFF121212,
    surface: 0xFF1E1E1E,
    surfaceVariant: 0xFF2D2D2D,
    primary: 0xFFBDBDBD,
    secondary: 0xFF9E9E9E,
    textPrimary: 0xFFE0E0E0,
    textSecondary: 0xFF888888,
    border: 0xFF404040,
    success: 0xFF81C784,
    warning: 0xFFFFD54F,
    error: 0xFFE57373,
    displayFont: 'Inter',
    headingFont: 'Inter',
    bodyFont: 'Inter',
  );

  /// All available presets in display order.
  static List<ThemeConfig> get all => [
        grimoire,
        solar,
        forest,
        ocean,
        obsidian,
        parchment,
        neon,
        monochrome,
      ];
}
