// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plot_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlotCard {
  String get id;
  String get title;
  String? get summary;
  double get xPosition;
  double get yPosition;
  int get colorHex;
  bool get isDeleted;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of PlotCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlotCardCopyWith<PlotCard> get copyWith =>
      _$PlotCardCopyWithImpl<PlotCard>(this as PlotCard, _$identity);

  /// Serializes this PlotCard to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlotCard &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.xPosition, xPosition) ||
                other.xPosition == xPosition) &&
            (identical(other.yPosition, yPosition) ||
                other.yPosition == yPosition) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, summary, xPosition,
      yPosition, colorHex, isDeleted, createdAt, updatedAt);

  @override
  String toString() {
    return 'PlotCard(id: $id, title: $title, summary: $summary, xPosition: $xPosition, yPosition: $yPosition, colorHex: $colorHex, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $PlotCardCopyWith<$Res> {
  factory $PlotCardCopyWith(PlotCard value, $Res Function(PlotCard) _then) =
      _$PlotCardCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      String? summary,
      double xPosition,
      double yPosition,
      int colorHex,
      bool isDeleted,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$PlotCardCopyWithImpl<$Res> implements $PlotCardCopyWith<$Res> {
  _$PlotCardCopyWithImpl(this._self, this._then);

  final PlotCard _self;
  final $Res Function(PlotCard) _then;

  /// Create a copy of PlotCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? summary = freezed,
    Object? xPosition = null,
    Object? yPosition = null,
    Object? colorHex = null,
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
      summary: freezed == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      xPosition: null == xPosition
          ? _self.xPosition
          : xPosition // ignore: cast_nullable_to_non_nullable
              as double,
      yPosition: null == yPosition
          ? _self.yPosition
          : yPosition // ignore: cast_nullable_to_non_nullable
              as double,
      colorHex: null == colorHex
          ? _self.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as int,
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

/// Adds pattern-matching-related methods to [PlotCard].
extension PlotCardPatterns on PlotCard {
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
    TResult Function(_PlotCard value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlotCard() when $default != null:
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
    TResult Function(_PlotCard value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlotCard():
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
    TResult? Function(_PlotCard value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlotCard() when $default != null:
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
            String? summary,
            double xPosition,
            double yPosition,
            int colorHex,
            bool isDeleted,
            DateTime createdAt,
            DateTime updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlotCard() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.summary,
            _that.xPosition,
            _that.yPosition,
            _that.colorHex,
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
            String? summary,
            double xPosition,
            double yPosition,
            int colorHex,
            bool isDeleted,
            DateTime createdAt,
            DateTime updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlotCard():
        return $default(
            _that.id,
            _that.title,
            _that.summary,
            _that.xPosition,
            _that.yPosition,
            _that.colorHex,
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
            String? summary,
            double xPosition,
            double yPosition,
            int colorHex,
            bool isDeleted,
            DateTime createdAt,
            DateTime updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlotCard() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.summary,
            _that.xPosition,
            _that.yPosition,
            _that.colorHex,
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
class _PlotCard implements PlotCard {
  const _PlotCard(
      {required this.id,
      required this.title,
      this.summary,
      required this.xPosition,
      required this.yPosition,
      this.colorHex = 0xFFA78BFA,
      this.isDeleted = false,
      required this.createdAt,
      required this.updatedAt});
  factory _PlotCard.fromJson(Map<String, dynamic> json) =>
      _$PlotCardFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? summary;
  @override
  final double xPosition;
  @override
  final double yPosition;
  @override
  @JsonKey()
  final int colorHex;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of PlotCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlotCardCopyWith<_PlotCard> get copyWith =>
      __$PlotCardCopyWithImpl<_PlotCard>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PlotCardToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlotCard &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.xPosition, xPosition) ||
                other.xPosition == xPosition) &&
            (identical(other.yPosition, yPosition) ||
                other.yPosition == yPosition) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, summary, xPosition,
      yPosition, colorHex, isDeleted, createdAt, updatedAt);

  @override
  String toString() {
    return 'PlotCard(id: $id, title: $title, summary: $summary, xPosition: $xPosition, yPosition: $yPosition, colorHex: $colorHex, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$PlotCardCopyWith<$Res>
    implements $PlotCardCopyWith<$Res> {
  factory _$PlotCardCopyWith(_PlotCard value, $Res Function(_PlotCard) _then) =
      __$PlotCardCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? summary,
      double xPosition,
      double yPosition,
      int colorHex,
      bool isDeleted,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$PlotCardCopyWithImpl<$Res> implements _$PlotCardCopyWith<$Res> {
  __$PlotCardCopyWithImpl(this._self, this._then);

  final _PlotCard _self;
  final $Res Function(_PlotCard) _then;

  /// Create a copy of PlotCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? summary = freezed,
    Object? xPosition = null,
    Object? yPosition = null,
    Object? colorHex = null,
    Object? isDeleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_PlotCard(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      summary: freezed == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      xPosition: null == xPosition
          ? _self.xPosition
          : xPosition // ignore: cast_nullable_to_non_nullable
              as double,
      yPosition: null == yPosition
          ? _self.yPosition
          : yPosition // ignore: cast_nullable_to_non_nullable
              as double,
      colorHex: null == colorHex
          ? _self.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as int,
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

/// @nodoc
mixin _$PlotConnection {
  String get id;
  String get sourceId;
  String get targetId;
  String? get label;
  bool get isDeleted;
  DateTime get createdAt;

  /// Create a copy of PlotConnection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlotConnectionCopyWith<PlotConnection> get copyWith =>
      _$PlotConnectionCopyWithImpl<PlotConnection>(
          this as PlotConnection, _$identity);

  /// Serializes this PlotConnection to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlotConnection &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceId, sourceId) ||
                other.sourceId == sourceId) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, sourceId, targetId, label, isDeleted, createdAt);

  @override
  String toString() {
    return 'PlotConnection(id: $id, sourceId: $sourceId, targetId: $targetId, label: $label, isDeleted: $isDeleted, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $PlotConnectionCopyWith<$Res> {
  factory $PlotConnectionCopyWith(
          PlotConnection value, $Res Function(PlotConnection) _then) =
      _$PlotConnectionCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String sourceId,
      String targetId,
      String? label,
      bool isDeleted,
      DateTime createdAt});
}

/// @nodoc
class _$PlotConnectionCopyWithImpl<$Res>
    implements $PlotConnectionCopyWith<$Res> {
  _$PlotConnectionCopyWithImpl(this._self, this._then);

  final PlotConnection _self;
  final $Res Function(PlotConnection) _then;

  /// Create a copy of PlotConnection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceId = null,
    Object? targetId = null,
    Object? label = freezed,
    Object? isDeleted = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sourceId: null == sourceId
          ? _self.sourceId
          : sourceId // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _self.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
      label: freezed == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [PlotConnection].
extension PlotConnectionPatterns on PlotConnection {
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
    TResult Function(_PlotConnection value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlotConnection() when $default != null:
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
    TResult Function(_PlotConnection value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlotConnection():
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
    TResult? Function(_PlotConnection value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlotConnection() when $default != null:
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
    TResult Function(String id, String sourceId, String targetId, String? label,
            bool isDeleted, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlotConnection() when $default != null:
        return $default(_that.id, _that.sourceId, _that.targetId, _that.label,
            _that.isDeleted, _that.createdAt);
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
    TResult Function(String id, String sourceId, String targetId, String? label,
            bool isDeleted, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlotConnection():
        return $default(_that.id, _that.sourceId, _that.targetId, _that.label,
            _that.isDeleted, _that.createdAt);
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
    TResult? Function(String id, String sourceId, String targetId,
            String? label, bool isDeleted, DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlotConnection() when $default != null:
        return $default(_that.id, _that.sourceId, _that.targetId, _that.label,
            _that.isDeleted, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PlotConnection implements PlotConnection {
  const _PlotConnection(
      {required this.id,
      required this.sourceId,
      required this.targetId,
      this.label,
      this.isDeleted = false,
      required this.createdAt});
  factory _PlotConnection.fromJson(Map<String, dynamic> json) =>
      _$PlotConnectionFromJson(json);

  @override
  final String id;
  @override
  final String sourceId;
  @override
  final String targetId;
  @override
  final String? label;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  final DateTime createdAt;

  /// Create a copy of PlotConnection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlotConnectionCopyWith<_PlotConnection> get copyWith =>
      __$PlotConnectionCopyWithImpl<_PlotConnection>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PlotConnectionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlotConnection &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceId, sourceId) ||
                other.sourceId == sourceId) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, sourceId, targetId, label, isDeleted, createdAt);

  @override
  String toString() {
    return 'PlotConnection(id: $id, sourceId: $sourceId, targetId: $targetId, label: $label, isDeleted: $isDeleted, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$PlotConnectionCopyWith<$Res>
    implements $PlotConnectionCopyWith<$Res> {
  factory _$PlotConnectionCopyWith(
          _PlotConnection value, $Res Function(_PlotConnection) _then) =
      __$PlotConnectionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String sourceId,
      String targetId,
      String? label,
      bool isDeleted,
      DateTime createdAt});
}

/// @nodoc
class __$PlotConnectionCopyWithImpl<$Res>
    implements _$PlotConnectionCopyWith<$Res> {
  __$PlotConnectionCopyWithImpl(this._self, this._then);

  final _PlotConnection _self;
  final $Res Function(_PlotConnection) _then;

  /// Create a copy of PlotConnection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? sourceId = null,
    Object? targetId = null,
    Object? label = freezed,
    Object? isDeleted = null,
    Object? createdAt = null,
  }) {
    return _then(_PlotConnection(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sourceId: null == sourceId
          ? _self.sourceId
          : sourceId // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _self.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
      label: freezed == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
