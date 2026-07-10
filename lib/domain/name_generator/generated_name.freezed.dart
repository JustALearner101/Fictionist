// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generated_name.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeneratedName {
  /// The generated name string.
  String get name;

  /// The category of name generation.
  GenerationType get type;

  /// The cultural archetype used for generation
  /// (e.g., 'Elven', 'Dwarven').
  String get archetype;

  /// The raw syllable components used, for display or regeneration.
  List<String> get components;

  /// Create a copy of GeneratedName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GeneratedNameCopyWith<GeneratedName> get copyWith =>
      _$GeneratedNameCopyWithImpl<GeneratedName>(
          this as GeneratedName, _$identity);

  /// Serializes this GeneratedName to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GeneratedName &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.archetype, archetype) ||
                other.archetype == archetype) &&
            const DeepCollectionEquality()
                .equals(other.components, components));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, type, archetype,
      const DeepCollectionEquality().hash(components));

  @override
  String toString() {
    return 'GeneratedName(name: $name, type: $type, archetype: $archetype, components: $components)';
  }
}

/// @nodoc
abstract mixin class $GeneratedNameCopyWith<$Res> {
  factory $GeneratedNameCopyWith(
          GeneratedName value, $Res Function(GeneratedName) _then) =
      _$GeneratedNameCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      GenerationType type,
      String archetype,
      List<String> components});
}

/// @nodoc
class _$GeneratedNameCopyWithImpl<$Res>
    implements $GeneratedNameCopyWith<$Res> {
  _$GeneratedNameCopyWithImpl(this._self, this._then);

  final GeneratedName _self;
  final $Res Function(GeneratedName) _then;

  /// Create a copy of GeneratedName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? archetype = null,
    Object? components = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as GenerationType,
      archetype: null == archetype
          ? _self.archetype
          : archetype // ignore: cast_nullable_to_non_nullable
              as String,
      components: null == components
          ? _self.components
          : components // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [GeneratedName].
extension GeneratedNamePatterns on GeneratedName {
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
    TResult Function(_GeneratedName value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GeneratedName() when $default != null:
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
    TResult Function(_GeneratedName value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GeneratedName():
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
    TResult? Function(_GeneratedName value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GeneratedName() when $default != null:
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
    TResult Function(String name, GenerationType type, String archetype,
            List<String> components)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GeneratedName() when $default != null:
        return $default(
            _that.name, _that.type, _that.archetype, _that.components);
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
    TResult Function(String name, GenerationType type, String archetype,
            List<String> components)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GeneratedName():
        return $default(
            _that.name, _that.type, _that.archetype, _that.components);
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
    TResult? Function(String name, GenerationType type, String archetype,
            List<String> components)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GeneratedName() when $default != null:
        return $default(
            _that.name, _that.type, _that.archetype, _that.components);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GeneratedName implements GeneratedName {
  const _GeneratedName(
      {required this.name,
      required this.type,
      required this.archetype,
      final List<String> components = const []})
      : _components = components;
  factory _GeneratedName.fromJson(Map<String, dynamic> json) =>
      _$GeneratedNameFromJson(json);

  /// The generated name string.
  @override
  final String name;

  /// The category of name generation.
  @override
  final GenerationType type;

  /// The cultural archetype used for generation
  /// (e.g., 'Elven', 'Dwarven').
  @override
  final String archetype;

  /// The raw syllable components used, for display or regeneration.
  final List<String> _components;

  /// The raw syllable components used, for display or regeneration.
  @override
  @JsonKey()
  List<String> get components {
    if (_components is EqualUnmodifiableListView) return _components;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_components);
  }

  /// Create a copy of GeneratedName
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GeneratedNameCopyWith<_GeneratedName> get copyWith =>
      __$GeneratedNameCopyWithImpl<_GeneratedName>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GeneratedNameToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GeneratedName &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.archetype, archetype) ||
                other.archetype == archetype) &&
            const DeepCollectionEquality()
                .equals(other._components, _components));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, type, archetype,
      const DeepCollectionEquality().hash(_components));

  @override
  String toString() {
    return 'GeneratedName(name: $name, type: $type, archetype: $archetype, components: $components)';
  }
}

/// @nodoc
abstract mixin class _$GeneratedNameCopyWith<$Res>
    implements $GeneratedNameCopyWith<$Res> {
  factory _$GeneratedNameCopyWith(
          _GeneratedName value, $Res Function(_GeneratedName) _then) =
      __$GeneratedNameCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      GenerationType type,
      String archetype,
      List<String> components});
}

/// @nodoc
class __$GeneratedNameCopyWithImpl<$Res>
    implements _$GeneratedNameCopyWith<$Res> {
  __$GeneratedNameCopyWithImpl(this._self, this._then);

  final _GeneratedName _self;
  final $Res Function(_GeneratedName) _then;

  /// Create a copy of GeneratedName
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? archetype = null,
    Object? components = null,
  }) {
    return _then(_GeneratedName(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as GenerationType,
      archetype: null == archetype
          ? _self.archetype
          : archetype // ignore: cast_nullable_to_non_nullable
              as String,
      components: null == components
          ? _self._components
          : components // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
