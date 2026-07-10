import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_status.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:fictionist/domain/wikilink/trie.dart';
import 'package:fictionist/domain/wikilink/wikilink_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TrieNode', () {
    late TrieNode trie;

    setUp(() {
      trie = TrieNode();
    });

    test('insert single word and findLongestMatch returns match', () {
      trie.insert('Gandalf', 'id-1', 'Gandalf');
      final match = trie.findLongestMatch('Gandalf walks', 0);
      expect(match, isNotNull);
      expect(match!.$1, 'id-1');
      expect(match.$2, 'Gandalf');
      expect(match.$3, 7);
    });

    test('findLongestMatch returns null for unknown word', () {
      trie.insert('Gandalf', 'id-1', 'Gandalf');
      final match = trie.findLongestMatch('Saruman', 0);
      expect(match, isNull);
    });

    test('findLongestMatch returns null when position is beyond text', () {
      trie.insert('Gandalf', 'id-1', 'Gandalf');
      final match = trie.findLongestMatch('hi', 10);
      expect(match, isNull);
    });

    test('finds longest match among overlapping names', () {
      trie.insert('John', 'id-1', 'John');
      trie.insert('John Smith', 'id-2', 'John Smith');
      final match = trie.findLongestMatch('John Smith here', 0);
      expect(match, isNotNull);
      expect(match!.$1, 'id-2');
      expect(match.$2, 'John Smith');
      expect(match.$3, 10);
    });

    test('finds shorter match when longer not present', () {
      trie.insert('John', 'id-1', 'John');
      trie.insert('John Smith', 'id-2', 'John Smith');
      final match = trie.findLongestMatch('John went', 0);
      expect(match, isNotNull);
      expect(match!.$1, 'id-1');
      expect(match.$2, 'John');
      expect(match.$3, 4);
    });

    test('case insensitive matching', () {
      trie.insert('Gandalf', 'id-1', 'Gandalf');
      final match = trie.findLongestMatch('gandalf the grey', 0);
      expect(match, isNotNull);
      expect(match!.$1, 'id-1');
    });
  });

  group('WikilinkEngine', () {
    late WikilinkEngine engine;

    setUp(() {
      engine = WikilinkEngine();
    });

    List<Entity> _makeEntities(List<Map<String, String>> data) {
      final now = DateTime.now();
      return data.map((d) => Entity(
        id: d['id']!,
        name: d['name']!,
        type: EntityType.character,
        status: EntityStatus.draft,
        iconColor: 0,
        createdAt: now,
        updatedAt: now,
      )).toList();
    }

    test('process returns unchanged text when no entities loaded', () {
      final result = engine.process('Hello world');
      expect(result, 'Hello world');
    });

    test('process returns empty string unchanged', () {
      final result = engine.process('');
      expect(result, '');
    });

    test('process converts entity name to wikilink', () {
      engine.rebuild(_makeEntities([
        {'id': 'id-1', 'name': 'Gandalf'},
      ]));
      final result = engine.process('Gandalf walked into the room.');
      expect(result, contains('[Gandalf](entity://id-1)'));
    });

    test('process converts multiple entity names', () {
      engine.rebuild(_makeEntities([
        {'id': 'id-1', 'name': 'Frodo'},
        {'id': 'id-2', 'name': 'Sam'},
      ]));
      final result = engine.process('Frodo and Sam walked together.');
      expect(result, contains('[Frodo](entity://id-1)'));
      expect(result, contains('[Sam](entity://id-2)'));
    });

    test('process links each entity only once', () {
      engine.rebuild(_makeEntities([
        {'id': 'id-1', 'name': 'Gandalf'},
      ]));
      final result = engine.process('Gandalf said Gandalf is here.');
      // Count occurrences of [Gandalf] link
      final linkCount = '[Gandalf](entity://id-1)'.allMatches(result).length;
      expect(linkCount, 1);
    });

    test('process ignores entity names shorter than 3 characters', () {
      engine.rebuild(_makeEntities([
        {'id': 'id-1', 'name': 'Ed'},
      ]));
      final result = engine.process('Ed was there.');
      expect(result, 'Ed was there.');
    });

    test('process matches whole words only (not substrings)', () {
      engine.rebuild(_makeEntities([
        {'id': 'id-1', 'name': 'Elf'},
      ]));
      // "Elf" should NOT match inside "Elfstone" — the 's' after "Elf" is a word char
      final result = engine.process('He held the Elfstone.');
      expect(result, isNot(contains('[Elf](entity://id-1)')));
      expect(result, contains('Elfstone'));
    });

    test('process respects word boundaries after match', () {
      engine.rebuild(_makeEntities([
        {'id': 'id-1', 'name': 'Aragorn'},
      ]));
      final result = engine.process('Aragorn.');
      expect(result, contains('[Aragorn](entity://id-1)'));
      expect(result, contains('.'));
    });

    test('process does not match mid-word prefix', () {
      engine.rebuild(_makeEntities([
        {'id': 'id-1', 'name': 'Elf'},
      ]));
      final result = engine.process('Help the elves.');
      expect(result, contains('elves'));
      expect(result, isNot(contains('[Elf]')));
    });

    test('rebuild replaces previous trie entirely', () {
      engine.rebuild(_makeEntities([
        {'id': 'id-1', 'name': 'Gandalf'},
      ]));
      engine.rebuild(_makeEntities([
        {'id': 'id-2', 'name': 'Saruman'},
      ]));
      final result = engine.process('Gandalf is here.');
      // Gandalf should no longer be in the trie after rebuild
      expect(result, isNot(contains('[Gandalf]')));
      expect(result, 'Gandalf is here.');
    });

    test('process handles entity names mid-text correctly', () {
      engine.rebuild(_makeEntities([
        {'id': 'id-1', 'name': 'Frodo'},
      ]));
      final result = engine.process('And Frodo left the Shire.');
      expect(result, contains('[Frodo](entity://id-1)'));
    });
  });
}
