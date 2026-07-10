// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeline_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimelineEntry {
  String get id;
  String get title;
  String? get description;
  String? get dateLabel;
  String? get eraLabel;
  int get sortOrder;
  String? get entityId;
  bool get isDeleted;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of TimelineEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimelineEntryCopyWith<TimelineEntry> get copyWith =>
      _$TimelineEntryCopyWithImpl<TimelineEntry>(
          this as TimelineEntry, _$identity);

  /// Serializes this TimelineEntry to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimelineEntry &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dateLabel, dateLabel) ||
                other.dateLabel == dateLabel) &&
            (identical(other.eraLabel, eraLabel) ||
                other.eraLabel == eraLabel) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      dateLabel,
      eraLabel,
      sortOrder,
      entityId,
      isDeleted,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'TimelineEntry(id: $id, title: $title, description: $description, dateLabel: $dateLabel, eraLabel: $eraLabel, sortOrder: $sortOrder, entityId: $entityId, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $TimelineEntryCopyWith<$Res> {
  factory $TimelineEntryCopyWith(
          TimelineEntry value, $Res Function(TimelineEntry) _then) =
      _$TimelineEntryCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String? dateLabel,
      String? eraLabel,
      int sortOrder,
      String? entityId,
      bool isDeleted,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$TimelineEntryCopyWithImpl<$Res>
    implements $TimelineEntryCopyWith<$Res> {
  _$TimelineEntryCopyWithImpl(this._self, this._then);

  final TimelineEntry _self;
  final $Res Function(TimelineEntry) _then;

  /// Create a copy of TimelineEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? dateLabel = freezed,
    Object? eraLabel = freezed,
    Object? sortOrder = null,
    Object? entityId = freezed,
    Object? isDeleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      dateLabel: freezed == dateLabel
          ? _self.dateLabel
          : dateLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      eraLabel: freezed == eraLabel
          ? _self.eraLabel
          : eraLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      entityId: freezed == entityId
          ? _self.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [TimelineEntry].
extension TimelineEntryPatterns on TimelineEntry {
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
    TResult Function(_TimelineEntry value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TimelineEntry() when $default != null:
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
    TResult Function(_TimelineEntry value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimelineEntry():
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
    TResult? Function(_TimelineEntry value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimelineEntry() when $default != null:
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
            String id,
            String title,
            String? description,
            String? dateLabel,
            String? eraLabel,
            int sortOrder,
            String? entityId,
            bool isDeleted,
            DateTime createdAt,
            DateTime updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TimelineEntry() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.description,
            _that.dateLabel,
            _that.eraLabel,
            _that.sortOrder,
            _that.entityId,
            _that.isDeleted,
            _that.createdAt,
            _that.updatedAt);
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
            String id,
            String title,
            String? description,
            String? dateLabel,
            String? eraLabel,
            int sortOrder,
            String? entityId,
            bool isDeleted,
            DateTime createdAt,
            DateTime updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimelineEntry():
        return $default(
            _that.id,
            _that.title,
            _that.description,
            _that.dateLabel,
            _that.eraLabel,
            _that.sortOrder,
            _that.entityId,
            _that.isDeleted,
            _that.createdAt,
            _that.updatedAt);
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
            String id,
            String title,
            String? description,
            String? dateLabel,
            String? eraLabel,
            int sortOrder,
            String? entityId,
            bool isDeleted,
            DateTime createdAt,
            DateTime updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimelineEntry() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.description,
            _that.dateLabel,
            _that.eraLabel,
            _that.sortOrder,
            _that.entityId,
            _that.isDeleted,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TimelineEntry implements TimelineEntry {
  const _TimelineEntry(
      {required this.id,
      required this.title,
      this.description,
      this.dateLabel,
      this.eraLabel,
      required this.sortOrder,
      this.entityId,
      this.isDeleted = false,
      required this.createdAt,
      required this.updatedAt});
  factory _TimelineEntry.fromJson(Map<String, dynamic> json) =>
      _$TimelineEntryFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? dateLabel;
  @override
  final String? eraLabel;
  @override
  final int sortOrder;
  @override
  final String? entityId;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of TimelineEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TimelineEntryCopyWith<_TimelineEntry> get copyWith =>
      __$TimelineEntryCopyWithImpl<_TimelineEntry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TimelineEntryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TimelineEntry &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dateLabel, dateLabel) ||
                other.dateLabel == dateLabel) &&
            (identical(other.eraLabel, eraLabel) ||
                other.eraLabel == eraLabel) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      dateLabel,
      eraLabel,
      sortOrder,
      entityId,
      isDeleted,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'TimelineEntry(id: $id, title: $title, description: $description, dateLabel: $dateLabel, eraLabel: $eraLabel, sortOrder: $sortOrder, entityId: $entityId, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$TimelineEntryCopyWith<$Res>
    implements $TimelineEntryCopyWith<$Res> {
  factory _$TimelineEntryCopyWith(
          _TimelineEntry value, $Res Function(_TimelineEntry) _then) =
      __$TimelineEntryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String? dateLabel,
      String? eraLabel,
      int sortOrder,
      String? entityId,
      bool isDeleted,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$TimelineEntryCopyWithImpl<$Res>
    implements _$TimelineEntryCopyWith<$Res> {
  __$TimelineEntryCopyWithImpl(this._self, this._then);

  final _TimelineEntry _self;
  final $Res Function(_TimelineEntry) _then;

  /// Create a copy of TimelineEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? dateLabel = freezed,
    Object? eraLabel = freezed,
    Object? sortOrder = null,
    Object? entityId = freezed,
    Object? isDeleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_TimelineEntry(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      dateLabel: freezed == dateLabel
          ? _self.dateLabel
          : dateLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      eraLabel: freezed == eraLabel
          ? _self.eraLabel
          : eraLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      entityId: freezed == entityId
          ? _self.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
