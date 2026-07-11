// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChapterSnapshot {
  String get id;
  String get chapterId;
  String get content;
  DateTime get createdAt;

  /// Create a copy of ChapterSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChapterSnapshotCopyWith<ChapterSnapshot> get copyWith =>
      _$ChapterSnapshotCopyWithImpl<ChapterSnapshot>(
          this as ChapterSnapshot, _$identity);

  /// Serializes this ChapterSnapshot to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChapterSnapshot &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, chapterId, content, createdAt);

  @override
  String toString() {
    return 'ChapterSnapshot(id: $id, chapterId: $chapterId, content: $content, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ChapterSnapshotCopyWith<$Res> {
  factory $ChapterSnapshotCopyWith(
          ChapterSnapshot value, $Res Function(ChapterSnapshot) _then) =
      _$ChapterSnapshotCopyWithImpl;
  @useResult
  $Res call({String id, String chapterId, String content, DateTime createdAt});
}

/// @nodoc
class _$ChapterSnapshotCopyWithImpl<$Res>
    implements $ChapterSnapshotCopyWith<$Res> {
  _$ChapterSnapshotCopyWithImpl(this._self, this._then);

  final ChapterSnapshot _self;
  final $Res Function(ChapterSnapshot) _then;

  /// Create a copy of ChapterSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chapterId = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chapterId: null == chapterId
          ? _self.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChapterSnapshot].
extension ChapterSnapshotPatterns on ChapterSnapshot {
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
    TResult Function(_ChapterSnapshot value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChapterSnapshot() when $default != null:
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
    TResult Function(_ChapterSnapshot value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChapterSnapshot():
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
    TResult? Function(_ChapterSnapshot value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChapterSnapshot() when $default != null:
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
            String id, String chapterId, String content, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChapterSnapshot() when $default != null:
        return $default(
            _that.id, _that.chapterId, _that.content, _that.createdAt);
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
            String id, String chapterId, String content, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChapterSnapshot():
        return $default(
            _that.id, _that.chapterId, _that.content, _that.createdAt);
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
            String id, String chapterId, String content, DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChapterSnapshot() when $default != null:
        return $default(
            _that.id, _that.chapterId, _that.content, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChapterSnapshot implements ChapterSnapshot {
  const _ChapterSnapshot(
      {required this.id,
      required this.chapterId,
      required this.content,
      required this.createdAt});
  factory _ChapterSnapshot.fromJson(Map<String, dynamic> json) =>
      _$ChapterSnapshotFromJson(json);

  @override
  final String id;
  @override
  final String chapterId;
  @override
  final String content;
  @override
  final DateTime createdAt;

  /// Create a copy of ChapterSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChapterSnapshotCopyWith<_ChapterSnapshot> get copyWith =>
      __$ChapterSnapshotCopyWithImpl<_ChapterSnapshot>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChapterSnapshotToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChapterSnapshot &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, chapterId, content, createdAt);

  @override
  String toString() {
    return 'ChapterSnapshot(id: $id, chapterId: $chapterId, content: $content, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ChapterSnapshotCopyWith<$Res>
    implements $ChapterSnapshotCopyWith<$Res> {
  factory _$ChapterSnapshotCopyWith(
          _ChapterSnapshot value, $Res Function(_ChapterSnapshot) _then) =
      __$ChapterSnapshotCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String chapterId, String content, DateTime createdAt});
}

/// @nodoc
class __$ChapterSnapshotCopyWithImpl<$Res>
    implements _$ChapterSnapshotCopyWith<$Res> {
  __$ChapterSnapshotCopyWithImpl(this._self, this._then);

  final _ChapterSnapshot _self;
  final $Res Function(_ChapterSnapshot) _then;

  /// Create a copy of ChapterSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? chapterId = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_ChapterSnapshot(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chapterId: null == chapterId
          ? _self.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
