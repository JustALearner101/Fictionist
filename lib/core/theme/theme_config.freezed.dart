// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThemeConfig {
  String get name;
  ThemeMode get themeMode; // ── Core Palette (11 colors) ──
  int get background;
  int get surface;
  int get surfaceVariant;
  int get primary;
  int get secondary;
  int get textPrimary;
  int get textSecondary;
  int get border;
  int get success;
  int get warning;
  int get error; // ── Typography ──
  String get displayFont;
  String get headingFont;
  String get bodyFont;
  double get headingLineHeight;
  double get bodyLineHeight; // ── Shape ──
  double get cardRadius;
  double get inputRadius;
  double get sheetRadius;
  double get borderWidth;

  /// Create a copy of ThemeConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThemeConfigCopyWith<ThemeConfig> get copyWith =>
      _$ThemeConfigCopyWithImpl<ThemeConfig>(this as ThemeConfig, _$identity);

  /// Serializes this ThemeConfig to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThemeConfig &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.background, background) ||
                other.background == background) &&
            (identical(other.surface, surface) || other.surface == surface) &&
            (identical(other.surfaceVariant, surfaceVariant) ||
                other.surfaceVariant == surfaceVariant) &&
            (identical(other.primary, primary) || other.primary == primary) &&
            (identical(other.secondary, secondary) ||
                other.secondary == secondary) &&
            (identical(other.textPrimary, textPrimary) ||
                other.textPrimary == textPrimary) &&
            (identical(other.textSecondary, textSecondary) ||
                other.textSecondary == textSecondary) &&
            (identical(other.border, border) || other.border == border) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.warning, warning) || other.warning == warning) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.displayFont, displayFont) ||
                other.displayFont == displayFont) &&
            (identical(other.headingFont, headingFont) ||
                other.headingFont == headingFont) &&
            (identical(other.bodyFont, bodyFont) ||
                other.bodyFont == bodyFont) &&
            (identical(other.headingLineHeight, headingLineHeight) ||
                other.headingLineHeight == headingLineHeight) &&
            (identical(other.bodyLineHeight, bodyLineHeight) ||
                other.bodyLineHeight == bodyLineHeight) &&
            (identical(other.cardRadius, cardRadius) ||
                other.cardRadius == cardRadius) &&
            (identical(other.inputRadius, inputRadius) ||
                other.inputRadius == inputRadius) &&
            (identical(other.sheetRadius, sheetRadius) ||
                other.sheetRadius == sheetRadius) &&
            (identical(other.borderWidth, borderWidth) ||
                other.borderWidth == borderWidth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        name,
        themeMode,
        background,
        surface,
        surfaceVariant,
        primary,
        secondary,
        textPrimary,
        textSecondary,
        border,
        success,
        warning,
        error,
        displayFont,
        headingFont,
        bodyFont,
        headingLineHeight,
        bodyLineHeight,
        cardRadius,
        inputRadius,
        sheetRadius,
        borderWidth
      ]);

  @override
  String toString() {
    return 'ThemeConfig(name: $name, themeMode: $themeMode, background: $background, surface: $surface, surfaceVariant: $surfaceVariant, primary: $primary, secondary: $secondary, textPrimary: $textPrimary, textSecondary: $textSecondary, border: $border, success: $success, warning: $warning, error: $error, displayFont: $displayFont, headingFont: $headingFont, bodyFont: $bodyFont, headingLineHeight: $headingLineHeight, bodyLineHeight: $bodyLineHeight, cardRadius: $cardRadius, inputRadius: $inputRadius, sheetRadius: $sheetRadius, borderWidth: $borderWidth)';
  }
}

/// @nodoc
abstract mixin class $ThemeConfigCopyWith<$Res> {
  factory $ThemeConfigCopyWith(
          ThemeConfig value, $Res Function(ThemeConfig) _then) =
      _$ThemeConfigCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      ThemeMode themeMode,
      int background,
      int surface,
      int surfaceVariant,
      int primary,
      int secondary,
      int textPrimary,
      int textSecondary,
      int border,
      int success,
      int warning,
      int error,
      String displayFont,
      String headingFont,
      String bodyFont,
      double headingLineHeight,
      double bodyLineHeight,
      double cardRadius,
      double inputRadius,
      double sheetRadius,
      double borderWidth});
}

/// @nodoc
class _$ThemeConfigCopyWithImpl<$Res> implements $ThemeConfigCopyWith<$Res> {
  _$ThemeConfigCopyWithImpl(this._self, this._then);

  final ThemeConfig _self;
  final $Res Function(ThemeConfig) _then;

  /// Create a copy of ThemeConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? themeMode = null,
    Object? background = null,
    Object? surface = null,
    Object? surfaceVariant = null,
    Object? primary = null,
    Object? secondary = null,
    Object? textPrimary = null,
    Object? textSecondary = null,
    Object? border = null,
    Object? success = null,
    Object? warning = null,
    Object? error = null,
    Object? displayFont = null,
    Object? headingFont = null,
    Object? bodyFont = null,
    Object? headingLineHeight = null,
    Object? bodyLineHeight = null,
    Object? cardRadius = null,
    Object? inputRadius = null,
    Object? sheetRadius = null,
    Object? borderWidth = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      themeMode: null == themeMode
          ? _self.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      background: null == background
          ? _self.background
          : background // ignore: cast_nullable_to_non_nullable
              as int,
      surface: null == surface
          ? _self.surface
          : surface // ignore: cast_nullable_to_non_nullable
              as int,
      surfaceVariant: null == surfaceVariant
          ? _self.surfaceVariant
          : surfaceVariant // ignore: cast_nullable_to_non_nullable
              as int,
      primary: null == primary
          ? _self.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as int,
      secondary: null == secondary
          ? _self.secondary
          : secondary // ignore: cast_nullable_to_non_nullable
              as int,
      textPrimary: null == textPrimary
          ? _self.textPrimary
          : textPrimary // ignore: cast_nullable_to_non_nullable
              as int,
      textSecondary: null == textSecondary
          ? _self.textSecondary
          : textSecondary // ignore: cast_nullable_to_non_nullable
              as int,
      border: null == border
          ? _self.border
          : border // ignore: cast_nullable_to_non_nullable
              as int,
      success: null == success
          ? _self.success
          : success // ignore: cast_nullable_to_non_nullable
              as int,
      warning: null == warning
          ? _self.warning
          : warning // ignore: cast_nullable_to_non_nullable
              as int,
      error: null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as int,
      displayFont: null == displayFont
          ? _self.displayFont
          : displayFont // ignore: cast_nullable_to_non_nullable
              as String,
      headingFont: null == headingFont
          ? _self.headingFont
          : headingFont // ignore: cast_nullable_to_non_nullable
              as String,
      bodyFont: null == bodyFont
          ? _self.bodyFont
          : bodyFont // ignore: cast_nullable_to_non_nullable
              as String,
      headingLineHeight: null == headingLineHeight
          ? _self.headingLineHeight
          : headingLineHeight // ignore: cast_nullable_to_non_nullable
              as double,
      bodyLineHeight: null == bodyLineHeight
          ? _self.bodyLineHeight
          : bodyLineHeight // ignore: cast_nullable_to_non_nullable
              as double,
      cardRadius: null == cardRadius
          ? _self.cardRadius
          : cardRadius // ignore: cast_nullable_to_non_nullable
              as double,
      inputRadius: null == inputRadius
          ? _self.inputRadius
          : inputRadius // ignore: cast_nullable_to_non_nullable
              as double,
      sheetRadius: null == sheetRadius
          ? _self.sheetRadius
          : sheetRadius // ignore: cast_nullable_to_non_nullable
              as double,
      borderWidth: null == borderWidth
          ? _self.borderWidth
          : borderWidth // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [ThemeConfig].
extension ThemeConfigPatterns on ThemeConfig {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ThemeConfig value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ThemeConfig() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ThemeConfig value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ThemeConfig():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ThemeConfig value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ThemeConfig() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String name,
            ThemeMode themeMode,
            int background,
            int surface,
            int surfaceVariant,
            int primary,
            int secondary,
            int textPrimary,
            int textSecondary,
            int border,
            int success,
            int warning,
            int error,
            String displayFont,
            String headingFont,
            String bodyFont,
            double headingLineHeight,
            double bodyLineHeight,
            double cardRadius,
            double inputRadius,
            double sheetRadius,
            double borderWidth)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ThemeConfig() when $default != null:
        return $default(
            _that.name,
            _that.themeMode,
            _that.background,
            _that.surface,
            _that.surfaceVariant,
            _that.primary,
            _that.secondary,
            _that.textPrimary,
            _that.textSecondary,
            _that.border,
            _that.success,
            _that.warning,
            _that.error,
            _that.displayFont,
            _that.headingFont,
            _that.bodyFont,
            _that.headingLineHeight,
            _that.bodyLineHeight,
            _that.cardRadius,
            _that.inputRadius,
            _that.sheetRadius,
            _that.borderWidth);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String name,
            ThemeMode themeMode,
            int background,
            int surface,
            int surfaceVariant,
            int primary,
            int secondary,
            int textPrimary,
            int textSecondary,
            int border,
            int success,
            int warning,
            int error,
            String displayFont,
            String headingFont,
            String bodyFont,
            double headingLineHeight,
            double bodyLineHeight,
            double cardRadius,
            double inputRadius,
            double sheetRadius,
            double borderWidth)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ThemeConfig():
        return $default(
            _that.name,
            _that.themeMode,
            _that.background,
            _that.surface,
            _that.surfaceVariant,
            _that.primary,
            _that.secondary,
            _that.textPrimary,
            _that.textSecondary,
            _that.border,
            _that.success,
            _that.warning,
            _that.error,
            _that.displayFont,
            _that.headingFont,
            _that.bodyFont,
            _that.headingLineHeight,
            _that.bodyLineHeight,
            _that.cardRadius,
            _that.inputRadius,
            _that.sheetRadius,
            _that.borderWidth);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String name,
            ThemeMode themeMode,
            int background,
            int surface,
            int surfaceVariant,
            int primary,
            int secondary,
            int textPrimary,
            int textSecondary,
            int border,
            int success,
            int warning,
            int error,
            String displayFont,
            String headingFont,
            String bodyFont,
            double headingLineHeight,
            double bodyLineHeight,
            double cardRadius,
            double inputRadius,
            double sheetRadius,
            double borderWidth)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ThemeConfig() when $default != null:
        return $default(
            _that.name,
            _that.themeMode,
            _that.background,
            _that.surface,
            _that.surfaceVariant,
            _that.primary,
            _that.secondary,
            _that.textPrimary,
            _that.textSecondary,
            _that.border,
            _that.success,
            _that.warning,
            _that.error,
            _that.displayFont,
            _that.headingFont,
            _that.bodyFont,
            _that.headingLineHeight,
            _that.bodyLineHeight,
            _that.cardRadius,
            _that.inputRadius,
            _that.sheetRadius,
            _that.borderWidth);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ThemeConfig implements ThemeConfig {
  const _ThemeConfig(
      {required this.name,
      this.themeMode = ThemeMode.dark,
      this.background = 0xFF120E16,
      this.surface = 0xFF1E1A24,
      this.surfaceVariant = 0xFF2D2836,
      this.primary = 0xFFA78BFA,
      this.secondary = 0xFFD4A373,
      this.textPrimary = 0xFFE2E0E6,
      this.textSecondary = 0xFF9E9AA6,
      this.border = 0xFF3A3445,
      this.success = 0xFF34D399,
      this.warning = 0xFFFBBF24,
      this.error = 0xFFF87171,
      this.displayFont = 'Lora',
      this.headingFont = 'Outfit',
      this.bodyFont = 'Inter',
      this.headingLineHeight = 1.15,
      this.bodyLineHeight = 1.5,
      this.cardRadius = 8.0,
      this.inputRadius = 8.0,
      this.sheetRadius = 16.0,
      this.borderWidth = 0.5});
  factory _ThemeConfig.fromJson(Map<String, dynamic> json) =>
      _$ThemeConfigFromJson(json);

  @override
  final String name;
  @override
  @JsonKey()
  final ThemeMode themeMode;
// ── Core Palette (11 colors) ──
  @override
  @JsonKey()
  final int background;
  @override
  @JsonKey()
  final int surface;
  @override
  @JsonKey()
  final int surfaceVariant;
  @override
  @JsonKey()
  final int primary;
  @override
  @JsonKey()
  final int secondary;
  @override
  @JsonKey()
  final int textPrimary;
  @override
  @JsonKey()
  final int textSecondary;
  @override
  @JsonKey()
  final int border;
  @override
  @JsonKey()
  final int success;
  @override
  @JsonKey()
  final int warning;
  @override
  @JsonKey()
  final int error;
// ── Typography ──
  @override
  @JsonKey()
  final String displayFont;
  @override
  @JsonKey()
  final String headingFont;
  @override
  @JsonKey()
  final String bodyFont;
  @override
  @JsonKey()
  final double headingLineHeight;
  @override
  @JsonKey()
  final double bodyLineHeight;
// ── Shape ──
  @override
  @JsonKey()
  final double cardRadius;
  @override
  @JsonKey()
  final double inputRadius;
  @override
  @JsonKey()
  final double sheetRadius;
  @override
  @JsonKey()
  final double borderWidth;

  /// Create a copy of ThemeConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ThemeConfigCopyWith<_ThemeConfig> get copyWith =>
      __$ThemeConfigCopyWithImpl<_ThemeConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ThemeConfigToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ThemeConfig &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.background, background) ||
                other.background == background) &&
            (identical(other.surface, surface) || other.surface == surface) &&
            (identical(other.surfaceVariant, surfaceVariant) ||
                other.surfaceVariant == surfaceVariant) &&
            (identical(other.primary, primary) || other.primary == primary) &&
            (identical(other.secondary, secondary) ||
                other.secondary == secondary) &&
            (identical(other.textPrimary, textPrimary) ||
                other.textPrimary == textPrimary) &&
            (identical(other.textSecondary, textSecondary) ||
                other.textSecondary == textSecondary) &&
            (identical(other.border, border) || other.border == border) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.warning, warning) || other.warning == warning) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.displayFont, displayFont) ||
                other.displayFont == displayFont) &&
            (identical(other.headingFont, headingFont) ||
                other.headingFont == headingFont) &&
            (identical(other.bodyFont, bodyFont) ||
                other.bodyFont == bodyFont) &&
            (identical(other.headingLineHeight, headingLineHeight) ||
                other.headingLineHeight == headingLineHeight) &&
            (identical(other.bodyLineHeight, bodyLineHeight) ||
                other.bodyLineHeight == bodyLineHeight) &&
            (identical(other.cardRadius, cardRadius) ||
                other.cardRadius == cardRadius) &&
            (identical(other.inputRadius, inputRadius) ||
                other.inputRadius == inputRadius) &&
            (identical(other.sheetRadius, sheetRadius) ||
                other.sheetRadius == sheetRadius) &&
            (identical(other.borderWidth, borderWidth) ||
                other.borderWidth == borderWidth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        name,
        themeMode,
        background,
        surface,
        surfaceVariant,
        primary,
        secondary,
        textPrimary,
        textSecondary,
        border,
        success,
        warning,
        error,
        displayFont,
        headingFont,
        bodyFont,
        headingLineHeight,
        bodyLineHeight,
        cardRadius,
        inputRadius,
        sheetRadius,
        borderWidth
      ]);

  @override
  String toString() {
    return 'ThemeConfig(name: $name, themeMode: $themeMode, background: $background, surface: $surface, surfaceVariant: $surfaceVariant, primary: $primary, secondary: $secondary, textPrimary: $textPrimary, textSecondary: $textSecondary, border: $border, success: $success, warning: $warning, error: $error, displayFont: $displayFont, headingFont: $headingFont, bodyFont: $bodyFont, headingLineHeight: $headingLineHeight, bodyLineHeight: $bodyLineHeight, cardRadius: $cardRadius, inputRadius: $inputRadius, sheetRadius: $sheetRadius, borderWidth: $borderWidth)';
  }
}

/// @nodoc
abstract mixin class _$ThemeConfigCopyWith<$Res>
    implements $ThemeConfigCopyWith<$Res> {
  factory _$ThemeConfigCopyWith(
          _ThemeConfig value, $Res Function(_ThemeConfig) _then) =
      __$ThemeConfigCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      ThemeMode themeMode,
      int background,
      int surface,
      int surfaceVariant,
      int primary,
      int secondary,
      int textPrimary,
      int textSecondary,
      int border,
      int success,
      int warning,
      int error,
      String displayFont,
      String headingFont,
      String bodyFont,
      double headingLineHeight,
      double bodyLineHeight,
      double cardRadius,
      double inputRadius,
      double sheetRadius,
      double borderWidth});
}

/// @nodoc
class __$ThemeConfigCopyWithImpl<$Res> implements _$ThemeConfigCopyWith<$Res> {
  __$ThemeConfigCopyWithImpl(this._self, this._then);

  final _ThemeConfig _self;
  final $Res Function(_ThemeConfig) _then;

  /// Create a copy of ThemeConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? themeMode = null,
    Object? background = null,
    Object? surface = null,
    Object? surfaceVariant = null,
    Object? primary = null,
    Object? secondary = null,
    Object? textPrimary = null,
    Object? textSecondary = null,
    Object? border = null,
    Object? success = null,
    Object? warning = null,
    Object? error = null,
    Object? displayFont = null,
    Object? headingFont = null,
    Object? bodyFont = null,
    Object? headingLineHeight = null,
    Object? bodyLineHeight = null,
    Object? cardRadius = null,
    Object? inputRadius = null,
    Object? sheetRadius = null,
    Object? borderWidth = null,
  }) {
    return _then(_ThemeConfig(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      themeMode: null == themeMode
          ? _self.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      background: null == background
          ? _self.background
          : background // ignore: cast_nullable_to_non_nullable
              as int,
      surface: null == surface
          ? _self.surface
          : surface // ignore: cast_nullable_to_non_nullable
              as int,
      surfaceVariant: null == surfaceVariant
          ? _self.surfaceVariant
          : surfaceVariant // ignore: cast_nullable_to_non_nullable
              as int,
      primary: null == primary
          ? _self.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as int,
      secondary: null == secondary
          ? _self.secondary
          : secondary // ignore: cast_nullable_to_non_nullable
              as int,
      textPrimary: null == textPrimary
          ? _self.textPrimary
          : textPrimary // ignore: cast_nullable_to_non_nullable
              as int,
      textSecondary: null == textSecondary
          ? _self.textSecondary
          : textSecondary // ignore: cast_nullable_to_non_nullable
              as int,
      border: null == border
          ? _self.border
          : border // ignore: cast_nullable_to_non_nullable
              as int,
      success: null == success
          ? _self.success
          : success // ignore: cast_nullable_to_non_nullable
              as int,
      warning: null == warning
          ? _self.warning
          : warning // ignore: cast_nullable_to_non_nullable
              as int,
      error: null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as int,
      displayFont: null == displayFont
          ? _self.displayFont
          : displayFont // ignore: cast_nullable_to_non_nullable
              as String,
      headingFont: null == headingFont
          ? _self.headingFont
          : headingFont // ignore: cast_nullable_to_non_nullable
              as String,
      bodyFont: null == bodyFont
          ? _self.bodyFont
          : bodyFont // ignore: cast_nullable_to_non_nullable
              as String,
      headingLineHeight: null == headingLineHeight
          ? _self.headingLineHeight
          : headingLineHeight // ignore: cast_nullable_to_non_nullable
              as double,
      bodyLineHeight: null == bodyLineHeight
          ? _self.bodyLineHeight
          : bodyLineHeight // ignore: cast_nullable_to_non_nullable
              as double,
      cardRadius: null == cardRadius
          ? _self.cardRadius
          : cardRadius // ignore: cast_nullable_to_non_nullable
              as double,
      inputRadius: null == inputRadius
          ? _self.inputRadius
          : inputRadius // ignore: cast_nullable_to_non_nullable
              as double,
      sheetRadius: null == sheetRadius
          ? _self.sheetRadius
          : sheetRadius // ignore: cast_nullable_to_non_nullable
              as double,
      borderWidth: null == borderWidth
          ? _self.borderWidth
          : borderWidth // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
