// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trait_inheritance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TraitInheritance {
  /// The trait/custom-field key (e.g., 'hair_color', 'eye_color').
  String get traitKey;

  /// The trait label (e.g., 'Hair Color').
  String get traitLabel;

  /// The trait value (e.g., 'Silver', 'Blue').
  String get traitValue;

  /// The character entity ID that exhibits this trait.
  String get entityId;

  /// The character name.
  String get entityName;

  /// IDs of ancestor entities that also carry this trait.
  List<String> get inheritedFromIds;

  /// Names of ancestor entities that also carry this trait.
  List<String> get inheritedFromNames;

  /// Whether this trait was inherited from at least one ancestor.
  bool get isInherited;

  /// A deterministic color index for rendering the trait badge.
  int get colorIndex;

  /// Create a copy of TraitInheritance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TraitInheritanceCopyWith<TraitInheritance> get copyWith =>
      _$TraitInheritanceCopyWithImpl<TraitInheritance>(
          this as TraitInheritance, _$identity);

  /// Serializes this TraitInheritance to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TraitInheritance &&
            (identical(other.traitKey, traitKey) ||
                other.traitKey == traitKey) &&
            (identical(other.traitLabel, traitLabel) ||
                other.traitLabel == traitLabel) &&
            (identical(other.traitValue, traitValue) ||
                other.traitValue == traitValue) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityName, entityName) ||
                other.entityName == entityName) &&
            const DeepCollectionEquality()
                .equals(other.inheritedFromIds, inheritedFromIds) &&
            const DeepCollectionEquality()
                .equals(other.inheritedFromNames, inheritedFromNames) &&
            (identical(other.isInherited, isInherited) ||
                other.isInherited == isInherited) &&
            (identical(other.colorIndex, colorIndex) ||
                other.colorIndex == colorIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      traitKey,
      traitLabel,
      traitValue,
      entityId,
      entityName,
      const DeepCollectionEquality().hash(inheritedFromIds),
      const DeepCollectionEquality().hash(inheritedFromNames),
      isInherited,
      colorIndex);

  @override
  String toString() {
    return 'TraitInheritance(traitKey: $traitKey, traitLabel: $traitLabel, traitValue: $traitValue, entityId: $entityId, entityName: $entityName, inheritedFromIds: $inheritedFromIds, inheritedFromNames: $inheritedFromNames, isInherited: $isInherited, colorIndex: $colorIndex)';
  }
}

/// @nodoc
abstract mixin class $TraitInheritanceCopyWith<$Res> {
  factory $TraitInheritanceCopyWith(
          TraitInheritance value, $Res Function(TraitInheritance) _then) =
      _$TraitInheritanceCopyWithImpl;
  @useResult
  $Res call(
      {String traitKey,
      String traitLabel,
      String traitValue,
      String entityId,
      String entityName,
      List<String> inheritedFromIds,
      List<String> inheritedFromNames,
      bool isInherited,
      int colorIndex});
}

/// @nodoc
class _$TraitInheritanceCopyWithImpl<$Res>
    implements $TraitInheritanceCopyWith<$Res> {
  _$TraitInheritanceCopyWithImpl(this._self, this._then);

  final TraitInheritance _self;
  final $Res Function(TraitInheritance) _then;

  /// Create a copy of TraitInheritance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? traitKey = null,
    Object? traitLabel = null,
    Object? traitValue = null,
    Object? entityId = null,
    Object? entityName = null,
    Object? inheritedFromIds = null,
    Object? inheritedFromNames = null,
    Object? isInherited = null,
    Object? colorIndex = null,
  }) {
    return _then(_self.copyWith(
      traitKey: null == traitKey
          ? _self.traitKey
          : traitKey // ignore: cast_nullable_to_non_nullable
              as String,
      traitLabel: null == traitLabel
          ? _self.traitLabel
          : traitLabel // ignore: cast_nullable_to_non_nullable
              as String,
      traitValue: null == traitValue
          ? _self.traitValue
          : traitValue // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _self.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      entityName: null == entityName
          ? _self.entityName
          : entityName // ignore: cast_nullable_to_non_nullable
              as String,
      inheritedFromIds: null == inheritedFromIds
          ? _self.inheritedFromIds
          : inheritedFromIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inheritedFromNames: null == inheritedFromNames
          ? _self.inheritedFromNames
          : inheritedFromNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isInherited: null == isInherited
          ? _self.isInherited
          : isInherited // ignore: cast_nullable_to_non_nullable
              as bool,
      colorIndex: null == colorIndex
          ? _self.colorIndex
          : colorIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [TraitInheritance].
extension TraitInheritancePatterns on TraitInheritance {
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
    TResult Function(_TraitInheritance value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TraitInheritance() when $default != null:
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
    TResult Function(_TraitInheritance value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TraitInheritance():
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
    TResult? Function(_TraitInheritance value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TraitInheritance() when $default != null:
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
            String traitKey,
            String traitLabel,
            String traitValue,
            String entityId,
            String entityName,
            List<String> inheritedFromIds,
            List<String> inheritedFromNames,
            bool isInherited,
            int colorIndex)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TraitInheritance() when $default != null:
        return $default(
            _that.traitKey,
            _that.traitLabel,
            _that.traitValue,
            _that.entityId,
            _that.entityName,
            _that.inheritedFromIds,
            _that.inheritedFromNames,
            _that.isInherited,
            _that.colorIndex);
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
            String traitKey,
            String traitLabel,
            String traitValue,
            String entityId,
            String entityName,
            List<String> inheritedFromIds,
            List<String> inheritedFromNames,
            bool isInherited,
            int colorIndex)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TraitInheritance():
        return $default(
            _that.traitKey,
            _that.traitLabel,
            _that.traitValue,
            _that.entityId,
            _that.entityName,
            _that.inheritedFromIds,
            _that.inheritedFromNames,
            _that.isInherited,
            _that.colorIndex);
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
            String traitKey,
            String traitLabel,
            String traitValue,
            String entityId,
            String entityName,
            List<String> inheritedFromIds,
            List<String> inheritedFromNames,
            bool isInherited,
            int colorIndex)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TraitInheritance() when $default != null:
        return $default(
            _that.traitKey,
            _that.traitLabel,
            _that.traitValue,
            _that.entityId,
            _that.entityName,
            _that.inheritedFromIds,
            _that.inheritedFromNames,
            _that.isInherited,
            _that.colorIndex);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TraitInheritance implements TraitInheritance {
  const _TraitInheritance(
      {required this.traitKey,
      required this.traitLabel,
      required this.traitValue,
      required this.entityId,
      required this.entityName,
      final List<String> inheritedFromIds = const [],
      final List<String> inheritedFromNames = const [],
      this.isInherited = false,
      this.colorIndex = 0})
      : _inheritedFromIds = inheritedFromIds,
        _inheritedFromNames = inheritedFromNames;
  factory _TraitInheritance.fromJson(Map<String, dynamic> json) =>
      _$TraitInheritanceFromJson(json);

  /// The trait/custom-field key (e.g., 'hair_color', 'eye_color').
  @override
  final String traitKey;

  /// The trait label (e.g., 'Hair Color').
  @override
  final String traitLabel;

  /// The trait value (e.g., 'Silver', 'Blue').
  @override
  final String traitValue;

  /// The character entity ID that exhibits this trait.
  @override
  final String entityId;

  /// The character name.
  @override
  final String entityName;

  /// IDs of ancestor entities that also carry this trait.
  final List<String> _inheritedFromIds;

  /// IDs of ancestor entities that also carry this trait.
  @override
  @JsonKey()
  List<String> get inheritedFromIds {
    if (_inheritedFromIds is EqualUnmodifiableListView)
      return _inheritedFromIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inheritedFromIds);
  }

  /// Names of ancestor entities that also carry this trait.
  final List<String> _inheritedFromNames;

  /// Names of ancestor entities that also carry this trait.
  @override
  @JsonKey()
  List<String> get inheritedFromNames {
    if (_inheritedFromNames is EqualUnmodifiableListView)
      return _inheritedFromNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inheritedFromNames);
  }

  /// Whether this trait was inherited from at least one ancestor.
  @override
  @JsonKey()
  final bool isInherited;

  /// A deterministic color index for rendering the trait badge.
  @override
  @JsonKey()
  final int colorIndex;

  /// Create a copy of TraitInheritance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TraitInheritanceCopyWith<_TraitInheritance> get copyWith =>
      __$TraitInheritanceCopyWithImpl<_TraitInheritance>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TraitInheritanceToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TraitInheritance &&
            (identical(other.traitKey, traitKey) ||
                other.traitKey == traitKey) &&
            (identical(other.traitLabel, traitLabel) ||
                other.traitLabel == traitLabel) &&
            (identical(other.traitValue, traitValue) ||
                other.traitValue == traitValue) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityName, entityName) ||
                other.entityName == entityName) &&
            const DeepCollectionEquality()
                .equals(other._inheritedFromIds, _inheritedFromIds) &&
            const DeepCollectionEquality()
                .equals(other._inheritedFromNames, _inheritedFromNames) &&
            (identical(other.isInherited, isInherited) ||
                other.isInherited == isInherited) &&
            (identical(other.colorIndex, colorIndex) ||
                other.colorIndex == colorIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      traitKey,
      traitLabel,
      traitValue,
      entityId,
      entityName,
      const DeepCollectionEquality().hash(_inheritedFromIds),
      const DeepCollectionEquality().hash(_inheritedFromNames),
      isInherited,
      colorIndex);

  @override
  String toString() {
    return 'TraitInheritance(traitKey: $traitKey, traitLabel: $traitLabel, traitValue: $traitValue, entityId: $entityId, entityName: $entityName, inheritedFromIds: $inheritedFromIds, inheritedFromNames: $inheritedFromNames, isInherited: $isInherited, colorIndex: $colorIndex)';
  }
}

/// @nodoc
abstract mixin class _$TraitInheritanceCopyWith<$Res>
    implements $TraitInheritanceCopyWith<$Res> {
  factory _$TraitInheritanceCopyWith(
          _TraitInheritance value, $Res Function(_TraitInheritance) _then) =
      __$TraitInheritanceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String traitKey,
      String traitLabel,
      String traitValue,
      String entityId,
      String entityName,
      List<String> inheritedFromIds,
      List<String> inheritedFromNames,
      bool isInherited,
      int colorIndex});
}

/// @nodoc
class __$TraitInheritanceCopyWithImpl<$Res>
    implements _$TraitInheritanceCopyWith<$Res> {
  __$TraitInheritanceCopyWithImpl(this._self, this._then);

  final _TraitInheritance _self;
  final $Res Function(_TraitInheritance) _then;

  /// Create a copy of TraitInheritance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? traitKey = null,
    Object? traitLabel = null,
    Object? traitValue = null,
    Object? entityId = null,
    Object? entityName = null,
    Object? inheritedFromIds = null,
    Object? inheritedFromNames = null,
    Object? isInherited = null,
    Object? colorIndex = null,
  }) {
    return _then(_TraitInheritance(
      traitKey: null == traitKey
          ? _self.traitKey
          : traitKey // ignore: cast_nullable_to_non_nullable
              as String,
      traitLabel: null == traitLabel
          ? _self.traitLabel
          : traitLabel // ignore: cast_nullable_to_non_nullable
              as String,
      traitValue: null == traitValue
          ? _self.traitValue
          : traitValue // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _self.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      entityName: null == entityName
          ? _self.entityName
          : entityName // ignore: cast_nullable_to_non_nullable
              as String,
      inheritedFromIds: null == inheritedFromIds
          ? _self._inheritedFromIds
          : inheritedFromIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inheritedFromNames: null == inheritedFromNames
          ? _self._inheritedFromNames
          : inheritedFromNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isInherited: null == isInherited
          ? _self.isInherited
          : isInherited // ignore: cast_nullable_to_non_nullable
              as bool,
      colorIndex: null == colorIndex
          ? _self.colorIndex
          : colorIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
