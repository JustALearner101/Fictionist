import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart' show rootBundle;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/domain/name_generator/culture.dart';
import 'package:fictionist/domain/name_generator/generated_name.dart';
import 'package:fictionist/domain/name_generator/generation_type.dart';
import 'package:fictionist/domain/name_generator/name_generator_params.dart';
import 'package:fictionist/domain/repository/name_generator_repository.dart';

@LazySingleton(as: NameGeneratorRepository)
class NameGeneratorRepositoryImpl implements NameGeneratorRepository {
  final _random = math.Random();

  /// In-memory culture cache.
  List<Culture>? _cultures;

  static const _cultureFiles = [
    'assets/name_generator/cultures/elven.json',
    'assets/name_generator/cultures/dwarven.json',
    'assets/name_generator/cultures/nordic.json',
    'assets/name_generator/cultures/draconic.json',
    'assets/name_generator/cultures/fae.json',
    'assets/name_generator/cultures/elemental.json',
  ];

  @override
  List<String> getArchetypesForType(GenerationType type) {
    switch (type) {
      case GenerationType.characterName:
        return ['Elven', 'Dwarven', 'Nordic', 'Draconic', 'Fae'];
      case GenerationType.factionName:
      case GenerationType.artifactName:
      case GenerationType.locationName:
      case GenerationType.legendaryTitle:
        return ['Elven', 'Dwarven', 'Nordic', 'Draconic', 'Fae', 'Elemental'];
    }
  }

  @override
  Future<Either<Failure, List<GeneratedName>>> generate(
    NameGeneratorParams params,
  ) async {
    try {
      final cultures = await _loadCultures();
      final culture = _pickCulture(cultures, params.archetype);

      switch (params.type) {
        case GenerationType.characterName:
          return Right(_generateCharacterNames(params, culture));
        case GenerationType.factionName:
          return Right(_generateCompoundNames(
            params, culture,
            prefixes: culture.factionPrefixes,
            suffixes: culture.factionSuffixes,
            defaultPrefix: 'The ',
            type: GenerationType.factionName,
          ));
        case GenerationType.artifactName:
          return Right(_generateCompoundNames(
            params, culture,
            prefixes: culture.artifactPrefixes,
            suffixes: culture.artifactSuffixes,
            type: GenerationType.artifactName,
          ));
        case GenerationType.locationName:
          return Right(_generateCompoundNames(
            params, culture,
            prefixes: culture.locationPrefixes,
            suffixes: culture.locationSuffixes,
            type: GenerationType.locationName,
          ));
        case GenerationType.legendaryTitle:
          return Right(_generateLegendaryTitles(params, culture));
      }
    } on Exception catch (e) {
      return Left(Failure.unexpected(
        message: 'Failed to generate names: $e',
        originalError: e,
      ));
    }
  }

  // ── generation workers ──

  List<GeneratedName> _generateCharacterNames(
    NameGeneratorParams params,
    Culture culture,
  ) {
    final names = <GeneratedName>[];
    for (int i = 0; i < params.count; i++) {
      final syllableCount = culture.minSyllables +
          _random.nextInt(culture.maxSyllables - culture.minSyllables + 1);
      final syllables = <String>[];
      for (int s = 0; s < syllableCount; s++) {
        syllables.add(_generateSyllable(culture));
      }
      final raw = syllables.join();
      final capitalized =
          raw[0].toUpperCase() + raw.substring(1).toLowerCase();
      names.add(GeneratedName(
        name: capitalized,
        type: GenerationType.characterName,
        archetype: culture.name,
        components: syllables,
      ));
    }
    return names;
  }

  List<GeneratedName> _generateCompoundNames(
    NameGeneratorParams params,
    Culture culture, {
    required List<String> prefixes,
    required List<String> suffixes,
    String defaultPrefix = '',
    required GenerationType type,
  }) {
    final names = <GeneratedName>[];
    for (int i = 0; i < params.count; i++) {
      String name;
      if (prefixes.isNotEmpty && suffixes.isNotEmpty) {
        // 60% prefix+suffix, 40% generated word + suffix
        if (_random.nextDouble() < 0.6) {
          name = '${prefixes[_random.nextInt(prefixes.length)]}'
              '${suffixes[_random.nextInt(suffixes.length)]}';
        } else {
          final word = _generateWord(culture);
          name = _capitalize(word) +
              suffixes[_random.nextInt(suffixes.length)];
        }
      } else {
        name = '${defaultPrefix}${_generateWord(culture)}';
      }
      final capped =
          name[0].toUpperCase() + name.substring(1).toLowerCase();
      names.add(GeneratedName(
        name: capped,
        type: type,
        archetype: culture.name,
        components: [name],
      ));
    }
    return names;
  }

  List<GeneratedName> _generateLegendaryTitles(
    NameGeneratorParams params,
    Culture culture,
  ) {
    final prefixPool = culture.artifactPrefixes.isNotEmpty
        ? culture.artifactPrefixes
        : culture.factionPrefixes;
    final suffixPool = culture.artifactSuffixes.isNotEmpty
        ? culture.artifactSuffixes
        : ['blade', 'brand', 'edge', 'fang', 'shard', 'soul'];

    final names = <GeneratedName>[];
    for (int i = 0; i < params.count; i++) {
      final prefix = prefixPool[_random.nextInt(prefixPool.length)];
      final suffix = suffixPool[_random.nextInt(suffixPool.length)];
      final titleWord = _capitalize('$prefix$suffix');

      final epithet = culture.epithets.isNotEmpty
          ? ', ${culture.epithets[_random.nextInt(culture.epithets.length)]}'
          : '';
      final name = '$titleWord$epithet';

      names.add(GeneratedName(
        name: name,
        type: GenerationType.legendaryTitle,
        archetype: culture.name,
        components: [prefix, suffix],
      ));
    }
    return names;
  }

  // ── phoneme helpers ──

  String _generateWord(Culture culture) {
    final syllableCount = culture.minSyllables +
        _random.nextInt(culture.maxSyllables - culture.minSyllables + 1);
    final parts = <String>[];
    for (int i = 0; i < syllableCount; i++) {
      parts.add(_generateSyllable(culture));
    }
    final raw = parts.join();
    return '${raw[0].toUpperCase()}${raw.substring(1).toLowerCase()}';
  }

  String _generateSyllable(Culture culture) {
    final pattern = _weightedChoice(
      culture.syllablePatterns,
      culture.patternWeights,
    );
    final parts = <String>[];
    for (int i = 0; i < pattern.length; i++) {
      final ch = pattern[i];
      if (ch == 'C') {
        parts.add(_pick(culture.consonants));
      } else if (ch == 'V') {
        parts.add(_pick(culture.vowels));
      }
    }
    // Reject if it creates a forbidden cluster
    final raw = parts.join();
    if (culture.forbiddenClusters.any((c) => raw.contains(c))) {
      return _generateSyllable(culture); // retry
    }
    return raw;
  }

  // ── utilities ──

  Culture _pickCulture(List<Culture> cultures, String? archetype) {
    if (archetype != null) {
      final match = cultures.where((c) => c.name == archetype).toList();
      if (match.isNotEmpty) return match[_random.nextInt(match.length)];
    }
    return cultures[_random.nextInt(cultures.length)];
  }

  String _pick(List<String> list) =>
      list[_random.nextInt(list.length)];

  T _weightedChoice<T>(List<T> items, List<double> weights) {
    double total = 0;
    for (final w in weights) {
      total += w;
    }
    double r = _random.nextDouble() * total;
    for (int i = 0; i < items.length; i++) {
      r -= i < weights.length ? weights[i] : 1;
      if (r <= 0) return items[i];
    }
    return items.last;
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  // ── JSON loading ──

  Future<List<Culture>> _loadCultures() async {
    if (_cultures != null) return _cultures!;
    final result = <Culture>[];
    for (final path in _cultureFiles) {
      final jsonStr = await rootBundle.loadString(path);
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      result.add(Culture.fromJson(map));
    }
    _cultures = result;
    return result;
  }
}
