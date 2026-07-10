// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_pin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MapPin {
  String get id;
  String get mapId;
  String get entityId;
  double get xPercent;
  double get yPercent;
  String? get label;

  /// Create a copy of MapPin
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MapPinCopyWith<MapPin> get copyWith =>
      _$MapPinCopyWithImpl<MapPin>(this as MapPin, _$identity);

  /// Serializes this MapPin to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MapPin &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mapId, mapId) || other.mapId == mapId) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.xPercent, xPercent) ||
                other.xPercent == xPercent) &&
            (identical(other.yPercent, yPercent) ||
                other.yPercent == yPercent) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, mapId, entityId, xPercent, yPercent, label);

  @override
  String toString() {
    return 'MapPin(id: $id, mapId: $mapId, entityId: $entityId, xPercent: $xPercent, yPercent: $yPercent, label: $label)';
  }
}

/// @nodoc
abstract mixin class $MapPinCopyWith<$Res> {
  factory $MapPinCopyWith(MapPin value, $Res Function(MapPin) _then) =
      _$MapPinCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String mapId,
      String entityId,
      double xPercent,
      double yPercent,
      String? label});
}

/// @nodoc
class _$MapPinCopyWithImpl<$Res> implements $MapPinCopyWith<$Res> {
  _$MapPinCopyWithImpl(this._self, this._then);

  final MapPin _self;
  final $Res Function(MapPin) _then;

  /// Create a copy of MapPin
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mapId = null,
    Object? entityId = null,
    Object? xPercent = null,
    Object? yPercent = null,
    Object? label = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mapId: null == mapId
          ? _self.mapId
          : mapId // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _self.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      xPercent: null == xPercent
          ? _self.xPercent
          : xPercent // ignore: cast_nullable_to_non_nullable
              as double,
      yPercent: null == yPercent
          ? _self.yPercent
          : yPercent // ignore: cast_nullable_to_non_nullable
              as double,
      label: freezed == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MapPin].
extension MapPinPatterns on MapPin {
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
    TResult Function(_MapPin value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MapPin() when $default != null:
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
    TResult Function(_MapPin value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapPin():
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
    TResult? Function(_MapPin value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapPin() when $default != null:
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
    TResult Function(String id, String mapId, String entityId, double xPercent,
            double yPercent, String? label)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MapPin() when $default != null:
        return $default(_that.id, _that.mapId, _that.entityId, _that.xPercent,
            _that.yPercent, _that.label);
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
    TResult Function(String id, String mapId, String entityId, double xPercent,
            double yPercent, String? label)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapPin():
        return $default(_that.id, _that.mapId, _that.entityId, _that.xPercent,
            _that.yPercent, _that.label);
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
    TResult? Function(String id, String mapId, String entityId, double xPercent,
            double yPercent, String? label)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapPin() when $default != null:
        return $default(_that.id, _that.mapId, _that.entityId, _that.xPercent,
            _that.yPercent, _that.label);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MapPin implements MapPin {
  const _MapPin(
      {required this.id,
      required this.mapId,
      required this.entityId,
      required this.xPercent,
      required this.yPercent,
      this.label});
  factory _MapPin.fromJson(Map<String, dynamic> json) => _$MapPinFromJson(json);

  @override
  final String id;
  @override
  final String mapId;
  @override
  final String entityId;
  @override
  final double xPercent;
  @override
  final double yPercent;
  @override
  final String? label;

  /// Create a copy of MapPin
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MapPinCopyWith<_MapPin> get copyWith =>
      __$MapPinCopyWithImpl<_MapPin>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MapPinToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MapPin &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mapId, mapId) || other.mapId == mapId) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.xPercent, xPercent) ||
                other.xPercent == xPercent) &&
            (identical(other.yPercent, yPercent) ||
                other.yPercent == yPercent) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, mapId, entityId, xPercent, yPercent, label);

  @override
  String toString() {
    return 'MapPin(id: $id, mapId: $mapId, entityId: $entityId, xPercent: $xPercent, yPercent: $yPercent, label: $label)';
  }
}

/// @nodoc
abstract mixin class _$MapPinCopyWith<$Res> implements $MapPinCopyWith<$Res> {
  factory _$MapPinCopyWith(_MapPin value, $Res Function(_MapPin) _then) =
      __$MapPinCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String mapId,
      String entityId,
      double xPercent,
      double yPercent,
      String? label});
}

/// @nodoc
class __$MapPinCopyWithImpl<$Res> implements _$MapPinCopyWith<$Res> {
  __$MapPinCopyWithImpl(this._self, this._then);

  final _MapPin _self;
  final $Res Function(_MapPin) _then;

  /// Create a copy of MapPin
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? mapId = null,
    Object? entityId = null,
    Object? xPercent = null,
    Object? yPercent = null,
    Object? label = freezed,
  }) {
    return _then(_MapPin(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mapId: null == mapId
          ? _self.mapId
          : mapId // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _self.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      xPercent: null == xPercent
          ? _self.xPercent
          : xPercent // ignore: cast_nullable_to_non_nullable
              as double,
      yPercent: null == yPercent
          ? _self.yPercent
          : yPercent // ignore: cast_nullable_to_non_nullable
              as double,
      label: freezed == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
