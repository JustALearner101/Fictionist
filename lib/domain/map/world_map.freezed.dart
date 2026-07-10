// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'world_map.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorldMap {
  String get id;
  String get name;
  String get imagePath;

  /// Create a copy of WorldMap
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorldMapCopyWith<WorldMap> get copyWith =>
      _$WorldMapCopyWithImpl<WorldMap>(this as WorldMap, _$identity);

  /// Serializes this WorldMap to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorldMap &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, imagePath);

  @override
  String toString() {
    return 'WorldMap(id: $id, name: $name, imagePath: $imagePath)';
  }
}

/// @nodoc
abstract mixin class $WorldMapCopyWith<$Res> {
  factory $WorldMapCopyWith(WorldMap value, $Res Function(WorldMap) _then) =
      _$WorldMapCopyWithImpl;
  @useResult
  $Res call({String id, String name, String imagePath});
}

/// @nodoc
class _$WorldMapCopyWithImpl<$Res> implements $WorldMapCopyWith<$Res> {
  _$WorldMapCopyWithImpl(this._self, this._then);

  final WorldMap _self;
  final $Res Function(WorldMap) _then;

  /// Create a copy of WorldMap
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imagePath = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _self.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [WorldMap].
extension WorldMapPatterns on WorldMap {
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
    TResult Function(_WorldMap value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorldMap() when $default != null:
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
    TResult Function(_WorldMap value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorldMap():
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
    TResult? Function(_WorldMap value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorldMap() when $default != null:
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
    TResult Function(String id, String name, String imagePath)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorldMap() when $default != null:
        return $default(_that.id, _that.name, _that.imagePath);
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
    TResult Function(String id, String name, String imagePath) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorldMap():
        return $default(_that.id, _that.name, _that.imagePath);
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
    TResult? Function(String id, String name, String imagePath)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorldMap() when $default != null:
        return $default(_that.id, _that.name, _that.imagePath);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorldMap implements WorldMap {
  const _WorldMap(
      {required this.id, required this.name, required this.imagePath});
  factory _WorldMap.fromJson(Map<String, dynamic> json) =>
      _$WorldMapFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String imagePath;

  /// Create a copy of WorldMap
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorldMapCopyWith<_WorldMap> get copyWith =>
      __$WorldMapCopyWithImpl<_WorldMap>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorldMapToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorldMap &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, imagePath);

  @override
  String toString() {
    return 'WorldMap(id: $id, name: $name, imagePath: $imagePath)';
  }
}

/// @nodoc
abstract mixin class _$WorldMapCopyWith<$Res>
    implements $WorldMapCopyWith<$Res> {
  factory _$WorldMapCopyWith(_WorldMap value, $Res Function(_WorldMap) _then) =
      __$WorldMapCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String name, String imagePath});
}

/// @nodoc
class __$WorldMapCopyWithImpl<$Res> implements _$WorldMapCopyWith<$Res> {
  __$WorldMapCopyWithImpl(this._self, this._then);

  final _WorldMap _self;
  final $Res Function(_WorldMap) _then;

  /// Create a copy of WorldMap
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imagePath = null,
  }) {
    return _then(_WorldMap(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _self.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
