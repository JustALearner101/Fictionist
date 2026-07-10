// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'culture.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Culture {
  String get name;
  String get description;

  /// Consonant sounds available in this language.
  List<String> get consonants;

  /// Vowel sounds available in this language.
  List<String> get vowels;

  /// Syllable patterns: 'CVC' = consonant-vowel-consonant, 'CV' = consonant-vowel, etc.
  List<String> get syllablePatterns;

  /// Forbidden consonant clusters (e.g., ['tk', 'dg', 'bp']).
  List<String> get forbiddenClusters;

  /// Probability weights corresponding to [syllablePatterns] order.
  List<double> get patternWeights;

  /// Minimum syllables per generated name.
  int get minSyllables;

  /// Maximum syllables per generated name.
  int get maxSyllables;

  /// Prefixes used for faction/group name generation.
  List<String> get factionPrefixes;

  /// Suffixes used for faction/group name generation.
  List<String> get factionSuffixes;

  /// Prefixes used for artifact/item name generation.
  List<String> get artifactPrefixes;

  /// Suffixes used for artifact/item name generation.
  List<String> get artifactSuffixes;

  /// Prefixes used for location/place name generation.
  List<String> get locationPrefixes;

  /// Suffixes used for location/place name generation.
  List<String> get locationSuffixes;

  /// Epithets used for legendary title generation.
  List<String> get epithets;

  /// Create a copy of Culture
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CultureCopyWith<Culture> get copyWith =>
      _$CultureCopyWithImpl<Culture>(this as Culture, _$identity);

  /// Serializes this Culture to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Culture &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other.consonants, consonants) &&
            const DeepCollectionEquality().equals(other.vowels, vowels) &&
            const DeepCollectionEquality()
                .equals(other.syllablePatterns, syllablePatterns) &&
            const DeepCollectionEquality()
                .equals(other.forbiddenClusters, forbiddenClusters) &&
            const DeepCollectionEquality()
                .equals(other.patternWeights, patternWeights) &&
            (identical(other.minSyllables, minSyllables) ||
                other.minSyllables == minSyllables) &&
            (identical(other.maxSyllables, maxSyllables) ||
                other.maxSyllables == maxSyllables) &&
            const DeepCollectionEquality()
                .equals(other.factionPrefixes, factionPrefixes) &&
            const DeepCollectionEquality()
                .equals(other.factionSuffixes, factionSuffixes) &&
            const DeepCollectionEquality()
                .equals(other.artifactPrefixes, artifactPrefixes) &&
            const DeepCollectionEquality()
                .equals(other.artifactSuffixes, artifactSuffixes) &&
            const DeepCollectionEquality()
                .equals(other.locationPrefixes, locationPrefixes) &&
            const DeepCollectionEquality()
                .equals(other.locationSuffixes, locationSuffixes) &&
            const DeepCollectionEquality().equals(other.epithets, epithets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      description,
      const DeepCollectionEquality().hash(consonants),
      const DeepCollectionEquality().hash(vowels),
      const DeepCollectionEquality().hash(syllablePatterns),
      const DeepCollectionEquality().hash(forbiddenClusters),
      const DeepCollectionEquality().hash(patternWeights),
      minSyllables,
      maxSyllables,
      const DeepCollectionEquality().hash(factionPrefixes),
      const DeepCollectionEquality().hash(factionSuffixes),
      const DeepCollectionEquality().hash(artifactPrefixes),
      const DeepCollectionEquality().hash(artifactSuffixes),
      const DeepCollectionEquality().hash(locationPrefixes),
      const DeepCollectionEquality().hash(locationSuffixes),
      const DeepCollectionEquality().hash(epithets));

  @override
  String toString() {
    return 'Culture(name: $name, description: $description, consonants: $consonants, vowels: $vowels, syllablePatterns: $syllablePatterns, forbiddenClusters: $forbiddenClusters, patternWeights: $patternWeights, minSyllables: $minSyllables, maxSyllables: $maxSyllables, factionPrefixes: $factionPrefixes, factionSuffixes: $factionSuffixes, artifactPrefixes: $artifactPrefixes, artifactSuffixes: $artifactSuffixes, locationPrefixes: $locationPrefixes, locationSuffixes: $locationSuffixes, epithets: $epithets)';
  }
}

/// @nodoc
abstract mixin class $CultureCopyWith<$Res> {
  factory $CultureCopyWith(Culture value, $Res Function(Culture) _then) =
      _$CultureCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      String description,
      List<String> consonants,
      List<String> vowels,
      List<String> syllablePatterns,
      List<String> forbiddenClusters,
      List<double> patternWeights,
      int minSyllables,
      int maxSyllables,
      List<String> factionPrefixes,
      List<String> factionSuffixes,
      List<String> artifactPrefixes,
      List<String> artifactSuffixes,
      List<String> locationPrefixes,
      List<String> locationSuffixes,
      List<String> epithets});
}

/// @nodoc
class _$CultureCopyWithImpl<$Res> implements $CultureCopyWith<$Res> {
  _$CultureCopyWithImpl(this._self, this._then);

  final Culture _self;
  final $Res Function(Culture) _then;

  /// Create a copy of Culture
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? consonants = null,
    Object? vowels = null,
    Object? syllablePatterns = null,
    Object? forbiddenClusters = null,
    Object? patternWeights = null,
    Object? minSyllables = null,
    Object? maxSyllables = null,
    Object? factionPrefixes = null,
    Object? factionSuffixes = null,
    Object? artifactPrefixes = null,
    Object? artifactSuffixes = null,
    Object? locationPrefixes = null,
    Object? locationSuffixes = null,
    Object? epithets = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      consonants: null == consonants
          ? _self.consonants
          : consonants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      vowels: null == vowels
          ? _self.vowels
          : vowels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      syllablePatterns: null == syllablePatterns
          ? _self.syllablePatterns
          : syllablePatterns // ignore: cast_nullable_to_non_nullable
              as List<String>,
      forbiddenClusters: null == forbiddenClusters
          ? _self.forbiddenClusters
          : forbiddenClusters // ignore: cast_nullable_to_non_nullable
              as List<String>,
      patternWeights: null == patternWeights
          ? _self.patternWeights
          : patternWeights // ignore: cast_nullable_to_non_nullable
              as List<double>,
      minSyllables: null == minSyllables
          ? _self.minSyllables
          : minSyllables // ignore: cast_nullable_to_non_nullable
              as int,
      maxSyllables: null == maxSyllables
          ? _self.maxSyllables
          : maxSyllables // ignore: cast_nullable_to_non_nullable
              as int,
      factionPrefixes: null == factionPrefixes
          ? _self.factionPrefixes
          : factionPrefixes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      factionSuffixes: null == factionSuffixes
          ? _self.factionSuffixes
          : factionSuffixes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      artifactPrefixes: null == artifactPrefixes
          ? _self.artifactPrefixes
          : artifactPrefixes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      artifactSuffixes: null == artifactSuffixes
          ? _self.artifactSuffixes
          : artifactSuffixes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      locationPrefixes: null == locationPrefixes
          ? _self.locationPrefixes
          : locationPrefixes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      locationSuffixes: null == locationSuffixes
          ? _self.locationSuffixes
          : locationSuffixes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      epithets: null == epithets
          ? _self.epithets
          : epithets // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [Culture].
extension CulturePatterns on Culture {
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
    TResult Function(_Culture value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Culture() when $default != null:
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
    TResult Function(_Culture value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Culture():
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
    TResult? Function(_Culture value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Culture() when $default != null:
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
            String name,
            String description,
            List<String> consonants,
            List<String> vowels,
            List<String> syllablePatterns,
            List<String> forbiddenClusters,
            List<double> patternWeights,
            int minSyllables,
            int maxSyllables,
            List<String> factionPrefixes,
            List<String> factionSuffixes,
            List<String> artifactPrefixes,
            List<String> artifactSuffixes,
            List<String> locationPrefixes,
            List<String> locationSuffixes,
            List<String> epithets)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Culture() when $default != null:
        return $default(
            _that.name,
            _that.description,
            _that.consonants,
            _that.vowels,
            _that.syllablePatterns,
            _that.forbiddenClusters,
            _that.patternWeights,
            _that.minSyllables,
            _that.maxSyllables,
            _that.factionPrefixes,
            _that.factionSuffixes,
            _that.artifactPrefixes,
            _that.artifactSuffixes,
            _that.locationPrefixes,
            _that.locationSuffixes,
            _that.epithets);
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
            String name,
            String description,
            List<String> consonants,
            List<String> vowels,
            List<String> syllablePatterns,
            List<String> forbiddenClusters,
            List<double> patternWeights,
            int minSyllables,
            int maxSyllables,
            List<String> factionPrefixes,
            List<String> factionSuffixes,
            List<String> artifactPrefixes,
            List<String> artifactSuffixes,
            List<String> locationPrefixes,
            List<String> locationSuffixes,
            List<String> epithets)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Culture():
        return $default(
            _that.name,
            _that.description,
            _that.consonants,
            _that.vowels,
            _that.syllablePatterns,
            _that.forbiddenClusters,
            _that.patternWeights,
            _that.minSyllables,
            _that.maxSyllables,
            _that.factionPrefixes,
            _that.factionSuffixes,
            _that.artifactPrefixes,
            _that.artifactSuffixes,
            _that.locationPrefixes,
            _that.locationSuffixes,
            _that.epithets);
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
            String name,
            String description,
            List<String> consonants,
            List<String> vowels,
            List<String> syllablePatterns,
            List<String> forbiddenClusters,
            List<double> patternWeights,
            int minSyllables,
            int maxSyllables,
            List<String> factionPrefixes,
            List<String> factionSuffixes,
            List<String> artifactPrefixes,
            List<String> artifactSuffixes,
            List<String> locationPrefixes,
            List<String> locationSuffixes,
            List<String> epithets)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Culture() when $default != null:
        return $default(
            _that.name,
            _that.description,
            _that.consonants,
            _that.vowels,
            _that.syllablePatterns,
            _that.forbiddenClusters,
            _that.patternWeights,
            _that.minSyllables,
            _that.maxSyllables,
            _that.factionPrefixes,
            _that.factionSuffixes,
            _that.artifactPrefixes,
            _that.artifactSuffixes,
            _that.locationPrefixes,
            _that.locationSuffixes,
            _that.epithets);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Culture implements Culture {
  const _Culture(
      {required this.name,
      required this.description,
      required final List<String> consonants,
      required final List<String> vowels,
      required final List<String> syllablePatterns,
      final List<String> forbiddenClusters = const [],
      final List<double> patternWeights = const [0.4, 0.35, 0.25],
      this.minSyllables = 1,
      this.maxSyllables = 3,
      final List<String> factionPrefixes = const [],
      final List<String> factionSuffixes = const [],
      final List<String> artifactPrefixes = const [],
      final List<String> artifactSuffixes = const [],
      final List<String> locationPrefixes = const [],
      final List<String> locationSuffixes = const [],
      final List<String> epithets = const []})
      : _consonants = consonants,
        _vowels = vowels,
        _syllablePatterns = syllablePatterns,
        _forbiddenClusters = forbiddenClusters,
        _patternWeights = patternWeights,
        _factionPrefixes = factionPrefixes,
        _factionSuffixes = factionSuffixes,
        _artifactPrefixes = artifactPrefixes,
        _artifactSuffixes = artifactSuffixes,
        _locationPrefixes = locationPrefixes,
        _locationSuffixes = locationSuffixes,
        _epithets = epithets;
  factory _Culture.fromJson(Map<String, dynamic> json) =>
      _$CultureFromJson(json);

  @override
  final String name;
  @override
  final String description;

  /// Consonant sounds available in this language.
  final List<String> _consonants;

  /// Consonant sounds available in this language.
  @override
  List<String> get consonants {
    if (_consonants is EqualUnmodifiableListView) return _consonants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_consonants);
  }

  /// Vowel sounds available in this language.
  final List<String> _vowels;

  /// Vowel sounds available in this language.
  @override
  List<String> get vowels {
    if (_vowels is EqualUnmodifiableListView) return _vowels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vowels);
  }

  /// Syllable patterns: 'CVC' = consonant-vowel-consonant, 'CV' = consonant-vowel, etc.
  final List<String> _syllablePatterns;

  /// Syllable patterns: 'CVC' = consonant-vowel-consonant, 'CV' = consonant-vowel, etc.
  @override
  List<String> get syllablePatterns {
    if (_syllablePatterns is EqualUnmodifiableListView)
      return _syllablePatterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_syllablePatterns);
  }

  /// Forbidden consonant clusters (e.g., ['tk', 'dg', 'bp']).
  final List<String> _forbiddenClusters;

  /// Forbidden consonant clusters (e.g., ['tk', 'dg', 'bp']).
  @override
  @JsonKey()
  List<String> get forbiddenClusters {
    if (_forbiddenClusters is EqualUnmodifiableListView)
      return _forbiddenClusters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_forbiddenClusters);
  }

  /// Probability weights corresponding to [syllablePatterns] order.
  final List<double> _patternWeights;

  /// Probability weights corresponding to [syllablePatterns] order.
  @override
  @JsonKey()
  List<double> get patternWeights {
    if (_patternWeights is EqualUnmodifiableListView) return _patternWeights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_patternWeights);
  }

  /// Minimum syllables per generated name.
  @override
  @JsonKey()
  final int minSyllables;

  /// Maximum syllables per generated name.
  @override
  @JsonKey()
  final int maxSyllables;

  /// Prefixes used for faction/group name generation.
  final List<String> _factionPrefixes;

  /// Prefixes used for faction/group name generation.
  @override
  @JsonKey()
  List<String> get factionPrefixes {
    if (_factionPrefixes is EqualUnmodifiableListView) return _factionPrefixes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_factionPrefixes);
  }

  /// Suffixes used for faction/group name generation.
  final List<String> _factionSuffixes;

  /// Suffixes used for faction/group name generation.
  @override
  @JsonKey()
  List<String> get factionSuffixes {
    if (_factionSuffixes is EqualUnmodifiableListView) return _factionSuffixes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_factionSuffixes);
  }

  /// Prefixes used for artifact/item name generation.
  final List<String> _artifactPrefixes;

  /// Prefixes used for artifact/item name generation.
  @override
  @JsonKey()
  List<String> get artifactPrefixes {
    if (_artifactPrefixes is EqualUnmodifiableListView)
      return _artifactPrefixes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artifactPrefixes);
  }

  /// Suffixes used for artifact/item name generation.
  final List<String> _artifactSuffixes;

  /// Suffixes used for artifact/item name generation.
  @override
  @JsonKey()
  List<String> get artifactSuffixes {
    if (_artifactSuffixes is EqualUnmodifiableListView)
      return _artifactSuffixes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artifactSuffixes);
  }

  /// Prefixes used for location/place name generation.
  final List<String> _locationPrefixes;

  /// Prefixes used for location/place name generation.
  @override
  @JsonKey()
  List<String> get locationPrefixes {
    if (_locationPrefixes is EqualUnmodifiableListView)
      return _locationPrefixes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locationPrefixes);
  }

  /// Suffixes used for location/place name generation.
  final List<String> _locationSuffixes;

  /// Suffixes used for location/place name generation.
  @override
  @JsonKey()
  List<String> get locationSuffixes {
    if (_locationSuffixes is EqualUnmodifiableListView)
      return _locationSuffixes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locationSuffixes);
  }

  /// Epithets used for legendary title generation.
  final List<String> _epithets;

  /// Epithets used for legendary title generation.
  @override
  @JsonKey()
  List<String> get epithets {
    if (_epithets is EqualUnmodifiableListView) return _epithets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_epithets);
  }

  /// Create a copy of Culture
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CultureCopyWith<_Culture> get copyWith =>
      __$CultureCopyWithImpl<_Culture>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CultureToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Culture &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._consonants, _consonants) &&
            const DeepCollectionEquality().equals(other._vowels, _vowels) &&
            const DeepCollectionEquality()
                .equals(other._syllablePatterns, _syllablePatterns) &&
            const DeepCollectionEquality()
                .equals(other._forbiddenClusters, _forbiddenClusters) &&
            const DeepCollectionEquality()
                .equals(other._patternWeights, _patternWeights) &&
            (identical(other.minSyllables, minSyllables) ||
                other.minSyllables == minSyllables) &&
            (identical(other.maxSyllables, maxSyllables) ||
                other.maxSyllables == maxSyllables) &&
            const DeepCollectionEquality()
                .equals(other._factionPrefixes, _factionPrefixes) &&
            const DeepCollectionEquality()
                .equals(other._factionSuffixes, _factionSuffixes) &&
            const DeepCollectionEquality()
                .equals(other._artifactPrefixes, _artifactPrefixes) &&
            const DeepCollectionEquality()
                .equals(other._artifactSuffixes, _artifactSuffixes) &&
            const DeepCollectionEquality()
                .equals(other._locationPrefixes, _locationPrefixes) &&
            const DeepCollectionEquality()
                .equals(other._locationSuffixes, _locationSuffixes) &&
            const DeepCollectionEquality().equals(other._epithets, _epithets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      description,
      const DeepCollectionEquality().hash(_consonants),
      const DeepCollectionEquality().hash(_vowels),
      const DeepCollectionEquality().hash(_syllablePatterns),
      const DeepCollectionEquality().hash(_forbiddenClusters),
      const DeepCollectionEquality().hash(_patternWeights),
      minSyllables,
      maxSyllables,
      const DeepCollectionEquality().hash(_factionPrefixes),
      const DeepCollectionEquality().hash(_factionSuffixes),
      const DeepCollectionEquality().hash(_artifactPrefixes),
      const DeepCollectionEquality().hash(_artifactSuffixes),
      const DeepCollectionEquality().hash(_locationPrefixes),
      const DeepCollectionEquality().hash(_locationSuffixes),
      const DeepCollectionEquality().hash(_epithets));

  @override
  String toString() {
    return 'Culture(name: $name, description: $description, consonants: $consonants, vowels: $vowels, syllablePatterns: $syllablePatterns, forbiddenClusters: $forbiddenClusters, patternWeights: $patternWeights, minSyllables: $minSyllables, maxSyllables: $maxSyllables, factionPrefixes: $factionPrefixes, factionSuffixes: $factionSuffixes, artifactPrefixes: $artifactPrefixes, artifactSuffixes: $artifactSuffixes, locationPrefixes: $locationPrefixes, locationSuffixes: $locationSuffixes, epithets: $epithets)';
  }
}

/// @nodoc
abstract mixin class _$CultureCopyWith<$Res> implements $CultureCopyWith<$Res> {
  factory _$CultureCopyWith(_Culture value, $Res Function(_Culture) _then) =
      __$CultureCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      String description,
      List<String> consonants,
      List<String> vowels,
      List<String> syllablePatterns,
      List<String> forbiddenClusters,
      List<double> patternWeights,
      int minSyllables,
      int maxSyllables,
      List<String> factionPrefixes,
      List<String> factionSuffixes,
      List<String> artifactPrefixes,
      List<String> artifactSuffixes,
      List<String> locationPrefixes,
      List<String> locationSuffixes,
      List<String> epithets});
}

/// @nodoc
class __$CultureCopyWithImpl<$Res> implements _$CultureCopyWith<$Res> {
  __$CultureCopyWithImpl(this._self, this._then);

  final _Culture _self;
  final $Res Function(_Culture) _then;

  /// Create a copy of Culture
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? consonants = null,
    Object? vowels = null,
    Object? syllablePatterns = null,
    Object? forbiddenClusters = null,
    Object? patternWeights = null,
    Object? minSyllables = null,
    Object? maxSyllables = null,
    Object? factionPrefixes = null,
    Object? factionSuffixes = null,
    Object? artifactPrefixes = null,
    Object? artifactSuffixes = null,
    Object? locationPrefixes = null,
    Object? locationSuffixes = null,
    Object? epithets = null,
  }) {
    return _then(_Culture(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      consonants: null == consonants
          ? _self._consonants
          : consonants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      vowels: null == vowels
          ? _self._vowels
          : vowels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      syllablePatterns: null == syllablePatterns
          ? _self._syllablePatterns
          : syllablePatterns // ignore: cast_nullable_to_non_nullable
              as List<String>,
      forbiddenClusters: null == forbiddenClusters
          ? _self._forbiddenClusters
          : forbiddenClusters // ignore: cast_nullable_to_non_nullable
              as List<String>,
      patternWeights: null == patternWeights
          ? _self._patternWeights
          : patternWeights // ignore: cast_nullable_to_non_nullable
              as List<double>,
      minSyllables: null == minSyllables
          ? _self.minSyllables
          : minSyllables // ignore: cast_nullable_to_non_nullable
              as int,
      maxSyllables: null == maxSyllables
          ? _self.maxSyllables
          : maxSyllables // ignore: cast_nullable_to_non_nullable
              as int,
      factionPrefixes: null == factionPrefixes
          ? _self._factionPrefixes
          : factionPrefixes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      factionSuffixes: null == factionSuffixes
          ? _self._factionSuffixes
          : factionSuffixes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      artifactPrefixes: null == artifactPrefixes
          ? _self._artifactPrefixes
          : artifactPrefixes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      artifactSuffixes: null == artifactSuffixes
          ? _self._artifactSuffixes
          : artifactSuffixes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      locationPrefixes: null == locationPrefixes
          ? _self._locationPrefixes
          : locationPrefixes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      locationSuffixes: null == locationSuffixes
          ? _self._locationSuffixes
          : locationSuffixes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      epithets: null == epithets
          ? _self._epithets
          : epithets // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
