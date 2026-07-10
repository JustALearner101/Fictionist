// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_field.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomField {
  String get id;
  String get key;
  String get label;
  String
      get fieldType; // short_text, long_text, number, toggle, select, multi_select, date_label
  dynamic get value;
  List<String>? get options;
  int get sortOrder;

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CustomFieldCopyWith<CustomField> get copyWith =>
      _$CustomFieldCopyWithImpl<CustomField>(this as CustomField, _$identity);

  /// Serializes this CustomField to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CustomField &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.fieldType, fieldType) ||
                other.fieldType == fieldType) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            const DeepCollectionEquality().equals(other.options, options) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      key,
      label,
      fieldType,
      const DeepCollectionEquality().hash(value),
      const DeepCollectionEquality().hash(options),
      sortOrder);

  @override
  String toString() {
    return 'CustomField(id: $id, key: $key, label: $label, fieldType: $fieldType, value: $value, options: $options, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class $CustomFieldCopyWith<$Res> {
  factory $CustomFieldCopyWith(
          CustomField value, $Res Function(CustomField) _then) =
      _$CustomFieldCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String key,
      String label,
      String fieldType,
      dynamic value,
      List<String>? options,
      int sortOrder});
}

/// @nodoc
class _$CustomFieldCopyWithImpl<$Res> implements $CustomFieldCopyWith<$Res> {
  _$CustomFieldCopyWithImpl(this._self, this._then);

  final CustomField _self;
  final $Res Function(CustomField) _then;

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? label = null,
    Object? fieldType = null,
    Object? value = freezed,
    Object? options = freezed,
    Object? sortOrder = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      fieldType: null == fieldType
          ? _self.fieldType
          : fieldType // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      options: freezed == options
          ? _self.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [CustomField].
extension CustomFieldPatterns on CustomField {
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
    TResult Function(_CustomField value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CustomField() when $default != null:
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
    TResult Function(_CustomField value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CustomField():
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
    TResult? Function(_CustomField value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CustomField() when $default != null:
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
    TResult Function(String id, String key, String label, String fieldType,
            dynamic value, List<String>? options, int sortOrder)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CustomField() when $default != null:
        return $default(_that.id, _that.key, _that.label, _that.fieldType,
            _that.value, _that.options, _that.sortOrder);
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
    TResult Function(String id, String key, String label, String fieldType,
            dynamic value, List<String>? options, int sortOrder)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CustomField():
        return $default(_that.id, _that.key, _that.label, _that.fieldType,
            _that.value, _that.options, _that.sortOrder);
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
    TResult? Function(String id, String key, String label, String fieldType,
            dynamic value, List<String>? options, int sortOrder)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CustomField() when $default != null:
        return $default(_that.id, _that.key, _that.label, _that.fieldType,
            _that.value, _that.options, _that.sortOrder);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CustomField implements CustomField {
  const _CustomField(
      {required this.id,
      required this.key,
      required this.label,
      required this.fieldType,
      required this.value,
      final List<String>? options,
      this.sortOrder = 0})
      : _options = options;
  factory _CustomField.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldFromJson(json);

  @override
  final String id;
  @override
  final String key;
  @override
  final String label;
  @override
  final String fieldType;
// short_text, long_text, number, toggle, select, multi_select, date_label
  @override
  final dynamic value;
  final List<String>? _options;
  @override
  List<String>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final int sortOrder;

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CustomFieldCopyWith<_CustomField> get copyWith =>
      __$CustomFieldCopyWithImpl<_CustomField>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CustomFieldToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CustomField &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.fieldType, fieldType) ||
                other.fieldType == fieldType) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      key,
      label,
      fieldType,
      const DeepCollectionEquality().hash(value),
      const DeepCollectionEquality().hash(_options),
      sortOrder);

  @override
  String toString() {
    return 'CustomField(id: $id, key: $key, label: $label, fieldType: $fieldType, value: $value, options: $options, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class _$CustomFieldCopyWith<$Res>
    implements $CustomFieldCopyWith<$Res> {
  factory _$CustomFieldCopyWith(
          _CustomField value, $Res Function(_CustomField) _then) =
      __$CustomFieldCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String key,
      String label,
      String fieldType,
      dynamic value,
      List<String>? options,
      int sortOrder});
}

/// @nodoc
class __$CustomFieldCopyWithImpl<$Res> implements _$CustomFieldCopyWith<$Res> {
  __$CustomFieldCopyWithImpl(this._self, this._then);

  final _CustomField _self;
  final $Res Function(_CustomField) _then;

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? label = null,
    Object? fieldType = null,
    Object? value = freezed,
    Object? options = freezed,
    Object? sortOrder = null,
  }) {
    return _then(_CustomField(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      fieldType: null == fieldType
          ? _self.fieldType
          : fieldType // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      options: freezed == options
          ? _self._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
