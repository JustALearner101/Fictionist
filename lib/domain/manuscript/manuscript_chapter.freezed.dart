// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manuscript_chapter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ManuscriptChapter {
  String get id;
  String get title;
  String get content;
  int get sortOrder;
  String? get dateLabel;
  String? get eraLabel;
  bool get isDeleted;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of ManuscriptChapter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ManuscriptChapterCopyWith<ManuscriptChapter> get copyWith =>
      _$ManuscriptChapterCopyWithImpl<ManuscriptChapter>(
          this as ManuscriptChapter, _$identity);

  /// Serializes this ManuscriptChapter to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ManuscriptChapter &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.dateLabel, dateLabel) ||
                other.dateLabel == dateLabel) &&
            (identical(other.eraLabel, eraLabel) ||
                other.eraLabel == eraLabel) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, content, sortOrder,
      dateLabel, eraLabel, isDeleted, createdAt, updatedAt);

  @override
  String toString() {
    return 'ManuscriptChapter(id: $id, title: $title, content: $content, sortOrder: $sortOrder, dateLabel: $dateLabel, eraLabel: $eraLabel, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ManuscriptChapterCopyWith<$Res> {
  factory $ManuscriptChapterCopyWith(
          ManuscriptChapter value, $Res Function(ManuscriptChapter) _then) =
      _$ManuscriptChapterCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      String content,
      int sortOrder,
      String? dateLabel,
      String? eraLabel,
      bool isDeleted,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ManuscriptChapterCopyWithImpl<$Res>
    implements $ManuscriptChapterCopyWith<$Res> {
  _$ManuscriptChapterCopyWithImpl(this._self, this._then);

  final ManuscriptChapter _self;
  final $Res Function(ManuscriptChapter) _then;

  /// Create a copy of ManuscriptChapter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? sortOrder = null,
    Object? dateLabel = freezed,
    Object? eraLabel = freezed,
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
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      dateLabel: freezed == dateLabel
          ? _self.dateLabel
          : dateLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      eraLabel: freezed == eraLabel
          ? _self.eraLabel
          : eraLabel // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [ManuscriptChapter].
extension ManuscriptChapterPatterns on ManuscriptChapter {
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
    TResult Function(_ManuscriptChapter value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ManuscriptChapter() when $default != null:
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
    TResult Function(_ManuscriptChapter value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ManuscriptChapter():
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
    TResult? Function(_ManuscriptChapter value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ManuscriptChapter() when $default != null:
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
            String content,
            int sortOrder,
            String? dateLabel,
            String? eraLabel,
            bool isDeleted,
            DateTime createdAt,
            DateTime updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ManuscriptChapter() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.content,
            _that.sortOrder,
            _that.dateLabel,
            _that.eraLabel,
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
            String content,
            int sortOrder,
            String? dateLabel,
            String? eraLabel,
            bool isDeleted,
            DateTime createdAt,
            DateTime updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ManuscriptChapter():
        return $default(
            _that.id,
            _that.title,
            _that.content,
            _that.sortOrder,
            _that.dateLabel,
            _that.eraLabel,
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
            String content,
            int sortOrder,
            String? dateLabel,
            String? eraLabel,
            bool isDeleted,
            DateTime createdAt,
            DateTime updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ManuscriptChapter() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.content,
            _that.sortOrder,
            _that.dateLabel,
            _that.eraLabel,
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
class _ManuscriptChapter implements ManuscriptChapter {
  const _ManuscriptChapter(
      {required this.id,
      required this.title,
      required this.content,
      this.sortOrder = 0,
      this.dateLabel,
      this.eraLabel,
      this.isDeleted = false,
      required this.createdAt,
      required this.updatedAt});
  factory _ManuscriptChapter.fromJson(Map<String, dynamic> json) =>
      _$ManuscriptChapterFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  final String? dateLabel;
  @override
  final String? eraLabel;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of ManuscriptChapter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ManuscriptChapterCopyWith<_ManuscriptChapter> get copyWith =>
      __$ManuscriptChapterCopyWithImpl<_ManuscriptChapter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ManuscriptChapterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ManuscriptChapter &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.dateLabel, dateLabel) ||
                other.dateLabel == dateLabel) &&
            (identical(other.eraLabel, eraLabel) ||
                other.eraLabel == eraLabel) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, content, sortOrder,
      dateLabel, eraLabel, isDeleted, createdAt, updatedAt);

  @override
  String toString() {
    return 'ManuscriptChapter(id: $id, title: $title, content: $content, sortOrder: $sortOrder, dateLabel: $dateLabel, eraLabel: $eraLabel, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$ManuscriptChapterCopyWith<$Res>
    implements $ManuscriptChapterCopyWith<$Res> {
  factory _$ManuscriptChapterCopyWith(
          _ManuscriptChapter value, $Res Function(_ManuscriptChapter) _then) =
      __$ManuscriptChapterCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String content,
      int sortOrder,
      String? dateLabel,
      String? eraLabel,
      bool isDeleted,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$ManuscriptChapterCopyWithImpl<$Res>
    implements _$ManuscriptChapterCopyWith<$Res> {
  __$ManuscriptChapterCopyWithImpl(this._self, this._then);

  final _ManuscriptChapter _self;
  final $Res Function(_ManuscriptChapter) _then;

  /// Create a copy of ManuscriptChapter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? sortOrder = null,
    Object? dateLabel = freezed,
    Object? eraLabel = freezed,
    Object? isDeleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_ManuscriptChapter(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      dateLabel: freezed == dateLabel
          ? _self.dateLabel
          : dateLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      eraLabel: freezed == eraLabel
          ? _self.eraLabel
          : eraLabel // ignore: cast_nullable_to_non_nullable
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
