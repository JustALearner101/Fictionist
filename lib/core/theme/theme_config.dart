import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_config.freezed.dart';
part 'theme_config.g.dart';

@freezed
abstract class ThemeConfig with _$ThemeConfig {
  const factory ThemeConfig({
    required String name,
    @Default(ThemeMode.dark) ThemeMode themeMode,

    // ── Core Palette (11 colors) ──
    @Default(0xFF120E16) int background,
    @Default(0xFF1E1A24) int surface,
    @Default(0xFF2D2836) int surfaceVariant,
    @Default(0xFFA78BFA) int primary,
    @Default(0xFFD4A373) int secondary,
    @Default(0xFFE2E0E6) int textPrimary,
    @Default(0xFF9E9AA6) int textSecondary,
    @Default(0xFF3A3445) int border,
    @Default(0xFF34D399) int success,
    @Default(0xFFFBBF24) int warning,
    @Default(0xFFF87171) int error,

    // ── Typography ──
    @Default('Lora') String displayFont,
    @Default('Outfit') String headingFont,
    @Default('Inter') String bodyFont,
    @Default(1.15) double headingLineHeight,
    @Default(1.5) double bodyLineHeight,

    // ── Shape ──
    @Default(8.0) double cardRadius,
    @Default(8.0) double inputRadius,
    @Default(16.0) double sheetRadius,
    @Default(0.5) double borderWidth,
  }) = _ThemeConfig;

  factory ThemeConfig.fromJson(Map<String, dynamic> json) =>
      _$ThemeConfigFromJson(json);
}
