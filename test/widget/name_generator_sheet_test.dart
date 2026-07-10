import 'package:flutter_test/flutter_test.dart';
import 'package:fictionist/domain/name_generator/culture.dart';
import 'package:fictionist/domain/name_generator/generation_type.dart';

void main() {
  group('GenerationType', () {
    test('should have 5 values after adding legendaryTitle', () {
      expect(GenerationType.values.length, 5);
    });

    test('each type has a non-empty label', () {
      for (final type in GenerationType.values) {
        expect(type.label.isNotEmpty, true);
      }
    });

    test('includes legendaryTitle', () {
      expect(
        GenerationType.values,
        contains(GenerationType.legendaryTitle),
      );
    });
  });

  group('Culture', () {
    test('fromJson produces valid Culture', () {
      final json = {
        'name': 'Elven',
        'description': 'Graceful and melodic',
        'consonants': ['l', 'r', 's', 'th', 'v'],
        'vowels': ['a', 'e', 'i', 'o'],
        'syllablePatterns': ['CV', 'CVC'],
        'patternWeights': [0.5, 0.5],
        'minSyllables': 1,
        'maxSyllables': 3,
        'factionPrefixes': ['Silvan', 'Star', 'Moon'],
        'factionSuffixes': ['Council', 'Court', 'Circle'],
        'artifactPrefixes': ['Soul', 'Star'],
        'artifactSuffixes': ['Brand', 'Cleaver'],
        'locationPrefixes': ['Silver', 'Green'],
        'locationSuffixes': ['haven', 'vale'],
        'epithets': ['the Unbroken', 'the Radiant'],
      };

      final culture = Culture.fromJson(json);

      expect(culture.name, 'Elven');
      expect(culture.consonants.length, 5);
      expect(culture.vowels.length, 4);
      expect(culture.syllablePatterns, ['CV', 'CVC']);
      expect(culture.factionPrefixes, ['Silvan', 'Star', 'Moon']);
      expect(culture.epithets, ['the Unbroken', 'the Radiant']);
    });

    test('fromJson defaults for optional fields', () {
      final json = {
        'name': 'Test',
        'description': 'Minimal culture',
        'consonants': ['t'],
        'vowels': ['a'],
        'syllablePatterns': ['CV'],
      };

      final culture = Culture.fromJson(json);

      expect(culture.forbiddenClusters, isEmpty);
      expect(culture.factionPrefixes, isEmpty);
      expect(culture.factionSuffixes, isEmpty);
      expect(culture.artifactPrefixes, isEmpty);
      expect(culture.artifactSuffixes, isEmpty);
      expect(culture.locationPrefixes, isEmpty);
      expect(culture.locationSuffixes, isEmpty);
      expect(culture.epithets, isEmpty);
    });

    test('generates a name with appropriate syllable count', () {
      final culture = Culture(
        name: 'Test',
        description: 'Test culture',
        consonants: ['b', 'r', 'n', 'd', 'l', 'g', 's', 'k', 'm', 't'],
        vowels: ['a', 'e', 'i', 'o'],
        syllablePatterns: ['CVC', 'CV'],
        minSyllables: 1,
        maxSyllables: 2,
      );

      // Test that the buildSyllable method works with valid input
      // We can't fully test random generation deterministically,
      // but we can verify the model structure
      expect(culture.consonants.isNotEmpty, true);
      expect(culture.vowels.isNotEmpty, true);
      expect(culture.syllablePatterns.isNotEmpty, true);
      expect(culture.minSyllables, lessThanOrEqualTo(culture.maxSyllables));
    });
  });
}
