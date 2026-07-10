// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Failure {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Failure);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'Failure()';
  }
}

/// @nodoc
class $FailureCopyWith<$Res> {
  $FailureCopyWith(Failure _, $Res Function(Failure) __);
}

/// Adds pattern-matching-related methods to [Failure].
extension FailurePatterns on Failure {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseFailure value)? database,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(FileSystemFailure value)? fileSystem,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case DatabaseFailure() when database != null:
        return database(_that);
      case ValidationFailure() when validation != null:
        return validation(_that);
      case NotFoundFailure() when notFound != null:
        return notFound(_that);
      case FileSystemFailure() when fileSystem != null:
        return fileSystem(_that);
      case UnexpectedFailure() when unexpected != null:
        return unexpected(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(FileSystemFailure value) fileSystem,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    final _that = this;
    switch (_that) {
      case DatabaseFailure():
        return database(_that);
      case ValidationFailure():
        return validation(_that);
      case NotFoundFailure():
        return notFound(_that);
      case FileSystemFailure():
        return fileSystem(_that);
      case UnexpectedFailure():
        return unexpected(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(FileSystemFailure value)? fileSystem,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    final _that = this;
    switch (_that) {
      case DatabaseFailure() when database != null:
        return database(_that);
      case ValidationFailure() when validation != null:
        return validation(_that);
      case NotFoundFailure() when notFound != null:
        return notFound(_that);
      case FileSystemFailure() when fileSystem != null:
        return fileSystem(_that);
      case UnexpectedFailure() when unexpected != null:
        return unexpected(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? originalError)? database,
    TResult Function(String message, String? field)? validation,
    TResult Function(String resourceType, String resourceId)? notFound,
    TResult Function(String message, String path)? fileSystem,
    TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unexpected,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case DatabaseFailure() when database != null:
        return database(_that.message, _that.originalError);
      case ValidationFailure() when validation != null:
        return validation(_that.message, _that.field);
      case NotFoundFailure() when notFound != null:
        return notFound(_that.resourceType, _that.resourceId);
      case FileSystemFailure() when fileSystem != null:
        return fileSystem(_that.message, _that.path);
      case UnexpectedFailure() when unexpected != null:
        return unexpected(_that.message, _that.originalError, _that.stackTrace);
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
  TResult when<TResult extends Object?>({
    required TResult Function(String message, Object? originalError) database,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String resourceType, String resourceId) notFound,
    required TResult Function(String message, String path) fileSystem,
    required TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)
        unexpected,
  }) {
    final _that = this;
    switch (_that) {
      case DatabaseFailure():
        return database(_that.message, _that.originalError);
      case ValidationFailure():
        return validation(_that.message, _that.field);
      case NotFoundFailure():
        return notFound(_that.resourceType, _that.resourceId);
      case FileSystemFailure():
        return fileSystem(_that.message, _that.path);
      case UnexpectedFailure():
        return unexpected(_that.message, _that.originalError, _that.stackTrace);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? originalError)? database,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String resourceType, String resourceId)? notFound,
    TResult? Function(String message, String path)? fileSystem,
    TResult? Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unexpected,
  }) {
    final _that = this;
    switch (_that) {
      case DatabaseFailure() when database != null:
        return database(_that.message, _that.originalError);
      case ValidationFailure() when validation != null:
        return validation(_that.message, _that.field);
      case NotFoundFailure() when notFound != null:
        return notFound(_that.resourceType, _that.resourceId);
      case FileSystemFailure() when fileSystem != null:
        return fileSystem(_that.message, _that.path);
      case UnexpectedFailure() when unexpected != null:
        return unexpected(_that.message, _that.originalError, _that.stackTrace);
      case _:
        return null;
    }
  }
}

/// @nodoc

class DatabaseFailure extends Failure {
  const DatabaseFailure({required this.message, this.originalError})
      : super._();

  final String message;
  final Object? originalError;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DatabaseFailureCopyWith<DatabaseFailure> get copyWith =>
      _$DatabaseFailureCopyWithImpl<DatabaseFailure>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DatabaseFailure &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other.originalError, originalError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(originalError));

  @override
  String toString() {
    return 'Failure.database(message: $message, originalError: $originalError)';
  }
}

/// @nodoc
abstract mixin class $DatabaseFailureCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory $DatabaseFailureCopyWith(
          DatabaseFailure value, $Res Function(DatabaseFailure) _then) =
      _$DatabaseFailureCopyWithImpl;
  @useResult
  $Res call({String message, Object? originalError});
}

/// @nodoc
class _$DatabaseFailureCopyWithImpl<$Res>
    implements $DatabaseFailureCopyWith<$Res> {
  _$DatabaseFailureCopyWithImpl(this._self, this._then);

  final DatabaseFailure _self;
  final $Res Function(DatabaseFailure) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? originalError = freezed,
  }) {
    return _then(DatabaseFailure(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      originalError:
          freezed == originalError ? _self.originalError : originalError,
    ));
  }
}

/// @nodoc

class ValidationFailure extends Failure {
  const ValidationFailure({required this.message, this.field}) : super._();

  final String message;
  final String? field;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ValidationFailureCopyWith<ValidationFailure> get copyWith =>
      _$ValidationFailureCopyWithImpl<ValidationFailure>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ValidationFailure &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.field, field) || other.field == field));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, field);

  @override
  String toString() {
    return 'Failure.validation(message: $message, field: $field)';
  }
}

/// @nodoc
abstract mixin class $ValidationFailureCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory $ValidationFailureCopyWith(
          ValidationFailure value, $Res Function(ValidationFailure) _then) =
      _$ValidationFailureCopyWithImpl;
  @useResult
  $Res call({String message, String? field});
}

/// @nodoc
class _$ValidationFailureCopyWithImpl<$Res>
    implements $ValidationFailureCopyWith<$Res> {
  _$ValidationFailureCopyWithImpl(this._self, this._then);

  final ValidationFailure _self;
  final $Res Function(ValidationFailure) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? field = freezed,
  }) {
    return _then(ValidationFailure(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      field: freezed == field
          ? _self.field
          : field // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class NotFoundFailure extends Failure {
  const NotFoundFailure({required this.resourceType, required this.resourceId})
      : super._();

  final String resourceType;
  final String resourceId;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotFoundFailureCopyWith<NotFoundFailure> get copyWith =>
      _$NotFoundFailureCopyWithImpl<NotFoundFailure>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotFoundFailure &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType) &&
            (identical(other.resourceId, resourceId) ||
                other.resourceId == resourceId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, resourceType, resourceId);

  @override
  String toString() {
    return 'Failure.notFound(resourceType: $resourceType, resourceId: $resourceId)';
  }
}

/// @nodoc
abstract mixin class $NotFoundFailureCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory $NotFoundFailureCopyWith(
          NotFoundFailure value, $Res Function(NotFoundFailure) _then) =
      _$NotFoundFailureCopyWithImpl;
  @useResult
  $Res call({String resourceType, String resourceId});
}

/// @nodoc
class _$NotFoundFailureCopyWithImpl<$Res>
    implements $NotFoundFailureCopyWith<$Res> {
  _$NotFoundFailureCopyWithImpl(this._self, this._then);

  final NotFoundFailure _self;
  final $Res Function(NotFoundFailure) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? resourceType = null,
    Object? resourceId = null,
  }) {
    return _then(NotFoundFailure(
      resourceType: null == resourceType
          ? _self.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
      resourceId: null == resourceId
          ? _self.resourceId
          : resourceId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class FileSystemFailure extends Failure {
  const FileSystemFailure({required this.message, required this.path})
      : super._();

  final String message;
  final String path;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FileSystemFailureCopyWith<FileSystemFailure> get copyWith =>
      _$FileSystemFailureCopyWithImpl<FileSystemFailure>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FileSystemFailure &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.path, path) || other.path == path));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, path);

  @override
  String toString() {
    return 'Failure.fileSystem(message: $message, path: $path)';
  }
}

/// @nodoc
abstract mixin class $FileSystemFailureCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory $FileSystemFailureCopyWith(
          FileSystemFailure value, $Res Function(FileSystemFailure) _then) =
      _$FileSystemFailureCopyWithImpl;
  @useResult
  $Res call({String message, String path});
}

/// @nodoc
class _$FileSystemFailureCopyWithImpl<$Res>
    implements $FileSystemFailureCopyWith<$Res> {
  _$FileSystemFailureCopyWithImpl(this._self, this._then);

  final FileSystemFailure _self;
  final $Res Function(FileSystemFailure) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? path = null,
  }) {
    return _then(FileSystemFailure(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(
      {required this.message, this.originalError, this.stackTrace})
      : super._();

  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnexpectedFailureCopyWith<UnexpectedFailure> get copyWith =>
      _$UnexpectedFailureCopyWithImpl<UnexpectedFailure>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnexpectedFailure &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other.originalError, originalError) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message,
      const DeepCollectionEquality().hash(originalError), stackTrace);

  @override
  String toString() {
    return 'Failure.unexpected(message: $message, originalError: $originalError, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class $UnexpectedFailureCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory $UnexpectedFailureCopyWith(
          UnexpectedFailure value, $Res Function(UnexpectedFailure) _then) =
      _$UnexpectedFailureCopyWithImpl;
  @useResult
  $Res call({String message, Object? originalError, StackTrace? stackTrace});
}

/// @nodoc
class _$UnexpectedFailureCopyWithImpl<$Res>
    implements $UnexpectedFailureCopyWith<$Res> {
  _$UnexpectedFailureCopyWithImpl(this._self, this._then);

  final UnexpectedFailure _self;
  final $Res Function(UnexpectedFailure) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? originalError = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(UnexpectedFailure(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      originalError:
          freezed == originalError ? _self.originalError : originalError,
      stackTrace: freezed == stackTrace
          ? _self.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

// dart format on
