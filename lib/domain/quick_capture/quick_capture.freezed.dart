// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_capture.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuickCapture {
  String get id;
  String get rawText;
  bool get isProcessed;
  DateTime get createdAt;

  /// Create a copy of QuickCapture
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QuickCaptureCopyWith<QuickCapture> get copyWith =>
      _$QuickCaptureCopyWithImpl<QuickCapture>(
          this as QuickCapture, _$identity);

  /// Serializes this QuickCapture to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QuickCapture &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rawText, rawText) || other.rawText == rawText) &&
            (identical(other.isProcessed, isProcessed) ||
                other.isProcessed == isProcessed) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, rawText, isProcessed, createdAt);

  @override
  String toString() {
    return 'QuickCapture(id: $id, rawText: $rawText, isProcessed: $isProcessed, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $QuickCaptureCopyWith<$Res> {
  factory $QuickCaptureCopyWith(
          QuickCapture value, $Res Function(QuickCapture) _then) =
      _$QuickCaptureCopyWithImpl;
  @useResult
  $Res call({String id, String rawText, bool isProcessed, DateTime createdAt});
}

/// @nodoc
class _$QuickCaptureCopyWithImpl<$Res> implements $QuickCaptureCopyWith<$Res> {
  _$QuickCaptureCopyWithImpl(this._self, this._then);

  final QuickCapture _self;
  final $Res Function(QuickCapture) _then;

  /// Create a copy of QuickCapture
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rawText = null,
    Object? isProcessed = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      rawText: null == rawText
          ? _self.rawText
          : rawText // ignore: cast_nullable_to_non_nullable
              as String,
      isProcessed: null == isProcessed
          ? _self.isProcessed
          : isProcessed // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [QuickCapture].
extension QuickCapturePatterns on QuickCapture {
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
    TResult Function(_QuickCapture value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _QuickCapture() when $default != null:
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
    TResult Function(_QuickCapture value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QuickCapture():
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
    TResult? Function(_QuickCapture value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QuickCapture() when $default != null:
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
            String id, String rawText, bool isProcessed, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _QuickCapture() when $default != null:
        return $default(
            _that.id, _that.rawText, _that.isProcessed, _that.createdAt);
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
            String id, String rawText, bool isProcessed, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QuickCapture():
        return $default(
            _that.id, _that.rawText, _that.isProcessed, _that.createdAt);
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
            String id, String rawText, bool isProcessed, DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QuickCapture() when $default != null:
        return $default(
            _that.id, _that.rawText, _that.isProcessed, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _QuickCapture implements QuickCapture {
  const _QuickCapture(
      {required this.id,
      required this.rawText,
      this.isProcessed = false,
      required this.createdAt});
  factory _QuickCapture.fromJson(Map<String, dynamic> json) =>
      _$QuickCaptureFromJson(json);

  @override
  final String id;
  @override
  final String rawText;
  @override
  @JsonKey()
  final bool isProcessed;
  @override
  final DateTime createdAt;

  /// Create a copy of QuickCapture
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$QuickCaptureCopyWith<_QuickCapture> get copyWith =>
      __$QuickCaptureCopyWithImpl<_QuickCapture>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$QuickCaptureToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _QuickCapture &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rawText, rawText) || other.rawText == rawText) &&
            (identical(other.isProcessed, isProcessed) ||
                other.isProcessed == isProcessed) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, rawText, isProcessed, createdAt);

  @override
  String toString() {
    return 'QuickCapture(id: $id, rawText: $rawText, isProcessed: $isProcessed, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$QuickCaptureCopyWith<$Res>
    implements $QuickCaptureCopyWith<$Res> {
  factory _$QuickCaptureCopyWith(
          _QuickCapture value, $Res Function(_QuickCapture) _then) =
      __$QuickCaptureCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String rawText, bool isProcessed, DateTime createdAt});
}

/// @nodoc
class __$QuickCaptureCopyWithImpl<$Res>
    implements _$QuickCaptureCopyWith<$Res> {
  __$QuickCaptureCopyWithImpl(this._self, this._then);

  final _QuickCapture _self;
  final $Res Function(_QuickCapture) _then;

  /// Create a copy of QuickCapture
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? rawText = null,
    Object? isProcessed = null,
    Object? createdAt = null,
  }) {
    return _then(_QuickCapture(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      rawText: null == rawText
          ? _self.rawText
          : rawText // ignore: cast_nullable_to_non_nullable
              as String,
      isProcessed: null == isProcessed
          ? _self.isProcessed
          : isProcessed // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
