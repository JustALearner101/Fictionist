// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ThemeConfig _$ThemeConfigFromJson(Map<String, dynamic> json) => _ThemeConfig(
      name: json['name'] as String,
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.dark,
      background: (json['background'] as num?)?.toInt() ?? 0xFF120E16,
      surface: (json['surface'] as num?)?.toInt() ?? 0xFF1E1A24,
      surfaceVariant: (json['surfaceVariant'] as num?)?.toInt() ?? 0xFF2D2836,
      primary: (json['primary'] as num?)?.toInt() ?? 0xFFA78BFA,
      secondary: (json['secondary'] as num?)?.toInt() ?? 0xFFD4A373,
      textPrimary: (json['textPrimary'] as num?)?.toInt() ?? 0xFFE2E0E6,
      textSecondary: (json['textSecondary'] as num?)?.toInt() ?? 0xFF9E9AA6,
      border: (json['border'] as num?)?.toInt() ?? 0xFF3A3445,
      success: (json['success'] as num?)?.toInt() ?? 0xFF34D399,
      warning: (json['warning'] as num?)?.toInt() ?? 0xFFFBBF24,
      error: (json['error'] as num?)?.toInt() ?? 0xFFF87171,
      displayFont: json['displayFont'] as String? ?? 'Lora',
      headingFont: json['headingFont'] as String? ?? 'Outfit',
      bodyFont: json['bodyFont'] as String? ?? 'Inter',
      headingLineHeight:
          (json['headingLineHeight'] as num?)?.toDouble() ?? 1.15,
      bodyLineHeight: (json['bodyLineHeight'] as num?)?.toDouble() ?? 1.5,
      cardRadius: (json['cardRadius'] as num?)?.toDouble() ?? 8.0,
      inputRadius: (json['inputRadius'] as num?)?.toDouble() ?? 8.0,
      sheetRadius: (json['sheetRadius'] as num?)?.toDouble() ?? 16.0,
      borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 0.5,
    );

Map<String, dynamic> _$ThemeConfigToJson(_ThemeConfig instance) =>
    <String, dynamic>{
      'name': instance.name,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'background': instance.background,
      'surface': instance.surface,
      'surfaceVariant': instance.surfaceVariant,
      'primary': instance.primary,
      'secondary': instance.secondary,
      'textPrimary': instance.textPrimary,
      'textSecondary': instance.textSecondary,
      'border': instance.border,
      'success': instance.success,
      'warning': instance.warning,
      'error': instance.error,
      'displayFont': instance.displayFont,
      'headingFont': instance.headingFont,
      'bodyFont': instance.bodyFont,
      'headingLineHeight': instance.headingLineHeight,
      'bodyLineHeight': instance.bodyLineHeight,
      'cardRadius': instance.cardRadius,
      'inputRadius': instance.inputRadius,
      'sheetRadius': instance.sheetRadius,
      'borderWidth': instance.borderWidth,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
