// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EntityVersion {
  String get id;
  String get entityId;
  String get snapshotJson;
  DateTime get changedAt;
  String? get changeNote;

  /// Create a copy of EntityVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EntityVersionCopyWith<EntityVersion> get copyWith =>
      _$EntityVersionCopyWithImpl<EntityVersion>(
          this as EntityVersion, _$identity);

  /// Serializes this EntityVersion to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EntityVersion &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.snapshotJson, snapshotJson) ||
                other.snapshotJson == snapshotJson) &&
            (identical(other.changedAt, changedAt) ||
                other.changedAt == changedAt) &&
            (identical(other.changeNote, changeNote) ||
                other.changeNote == changeNote));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, entityId, snapshotJson, changedAt, changeNote);

  @override
  String toString() {
    return 'EntityVersion(id: $id, entityId: $entityId, snapshotJson: $snapshotJson, changedAt: $changedAt, changeNote: $changeNote)';
  }
}

/// @nodoc
abstract mixin class $EntityVersionCopyWith<$Res> {
  factory $EntityVersionCopyWith(
          EntityVersion value, $Res Function(EntityVersion) _then) =
      _$EntityVersionCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String entityId,
      String snapshotJson,
      DateTime changedAt,
      String? changeNote});
}

/// @nodoc
class _$EntityVersionCopyWithImpl<$Res>
    implements $EntityVersionCopyWith<$Res> {
  _$EntityVersionCopyWithImpl(this._self, this._then);

  final EntityVersion _self;
  final $Res Function(EntityVersion) _then;

  /// Create a copy of EntityVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityId = null,
    Object? snapshotJson = null,
    Object? changedAt = null,
    Object? changeNote = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _self.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      snapshotJson: null == snapshotJson
          ? _self.snapshotJson
          : snapshotJson // ignore: cast_nullable_to_non_nullable
              as String,
      changedAt: null == changedAt
          ? _self.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      changeNote: freezed == changeNote
          ? _self.changeNote
          : changeNote // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [EntityVersion].
extension EntityVersionPatterns on EntityVersion {
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
    TResult Function(_EntityVersion value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EntityVersion() when $default != null:
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
    TResult Function(_EntityVersion value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EntityVersion():
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
    TResult? Function(_EntityVersion value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EntityVersion() when $default != null:
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
    TResult Function(String id, String entityId, String snapshotJson,
            DateTime changedAt, String? changeNote)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EntityVersion() when $default != null:
        return $default(_that.id, _that.entityId, _that.snapshotJson,
            _that.changedAt, _that.changeNote);
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
    TResult Function(String id, String entityId, String snapshotJson,
            DateTime changedAt, String? changeNote)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EntityVersion():
        return $default(_that.id, _that.entityId, _that.snapshotJson,
            _that.changedAt, _that.changeNote);
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
    TResult? Function(String id, String entityId, String snapshotJson,
            DateTime changedAt, String? changeNote)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EntityVersion() when $default != null:
        return $default(_that.id, _that.entityId, _that.snapshotJson,
            _that.changedAt, _that.changeNote);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _EntityVersion implements EntityVersion {
  const _EntityVersion(
      {required this.id,
      required this.entityId,
      required this.snapshotJson,
      required this.changedAt,
      this.changeNote});
  factory _EntityVersion.fromJson(Map<String, dynamic> json) =>
      _$EntityVersionFromJson(json);

  @override
  final String id;
  @override
  final String entityId;
  @override
  final String snapshotJson;
  @override
  final DateTime changedAt;
  @override
  final String? changeNote;

  /// Create a copy of EntityVersion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EntityVersionCopyWith<_EntityVersion> get copyWith =>
      __$EntityVersionCopyWithImpl<_EntityVersion>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EntityVersionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EntityVersion &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.snapshotJson, snapshotJson) ||
                other.snapshotJson == snapshotJson) &&
            (identical(other.changedAt, changedAt) ||
                other.changedAt == changedAt) &&
            (identical(other.changeNote, changeNote) ||
                other.changeNote == changeNote));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, entityId, snapshotJson, changedAt, changeNote);

  @override
  String toString() {
    return 'EntityVersion(id: $id, entityId: $entityId, snapshotJson: $snapshotJson, changedAt: $changedAt, changeNote: $changeNote)';
  }
}

/// @nodoc
abstract mixin class _$EntityVersionCopyWith<$Res>
    implements $EntityVersionCopyWith<$Res> {
  factory _$EntityVersionCopyWith(
          _EntityVersion value, $Res Function(_EntityVersion) _then) =
      __$EntityVersionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String entityId,
      String snapshotJson,
      DateTime changedAt,
      String? changeNote});
}

/// @nodoc
class __$EntityVersionCopyWithImpl<$Res>
    implements _$EntityVersionCopyWith<$Res> {
  __$EntityVersionCopyWithImpl(this._self, this._then);

  final _EntityVersion _self;
  final $Res Function(_EntityVersion) _then;

  /// Create a copy of EntityVersion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? entityId = null,
    Object? snapshotJson = null,
    Object? changedAt = null,
    Object? changeNote = freezed,
  }) {
    return _then(_EntityVersion(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _self.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      snapshotJson: null == snapshotJson
          ? _self.snapshotJson
          : snapshotJson // ignore: cast_nullable_to_non_nullable
              as String,
      changedAt: null == changedAt
          ? _self.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      changeNote: freezed == changeNote
          ? _self.changeNote
          : changeNote // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
