/// @deprecated Use ThemeConfig from theme_provider.dart instead.
/// Kept for backward compatibility during migration to ThemeConfig.
/// Replace AppColors.xxx with Theme.of(context).colorScheme.xxx.
import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF120E16);       // Mystic Velvet
  static const Color surface = Color(0xFF1E1A24);          // Obsidian Ink
  static const Color surfaceVariant = Color(0xFF2D2836);   // Slate Velvet
  static const Color primary = Color(0xFFA78BFA);          // Amethyst
  static const Color secondary = Color(0xFFD4A373);        // Gilded Amber
  static const Color textPrimary = Color(0xFFE2E0E6);      // Parchment
  static const Color textSecondary = Color(0xFF9E9AA6);    // Ink Mist
  static const Color border = Color(0xFF3A3445);           // Iron Filigree
  
  static const Color success = Color(0xFF34D399);          // Canon Green
  static const Color warning = Color(0xFFFBBF24);          // Draft Amber
  static const Color error = Color(0xFFF87171);            // Broken Quill Red
}
