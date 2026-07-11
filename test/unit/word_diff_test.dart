import 'package:flutter_test/flutter_test.dart';
import 'package:fictionist/core/utils/word_diff.dart';

void main() {
  group('Word Diff Utility', () {
    test('identical strings returns equal segment', () {
      final results = computeWordDiff('Hello world', 'Hello world');
      expect(results.length, 1);
      expect(results.first.text, 'Hello world');
      expect(results.first.type, DiffType.equal);
    });

    test('detects simple insertion', () {
      final results = computeWordDiff('Hello world', 'Hello brave world');
      
      // Expected: Hello (equal), " " (equal), brave (insertion), " " (insertion), world (equal)
      final insertions = results.where((d) => d.type == DiffType.insertion).map((d) => d.text).join();
      expect(insertions, 'brave ');
    });

    test('detects simple deletion', () {
      final results = computeWordDiff('Hello brave world', 'Hello world');
      
      final deletions = results.where((d) => d.type == DiffType.deletion).map((d) => d.text).join();
      expect(deletions, 'brave ');
    });

    test('preserves common prefix and suffix', () {
      final results = computeWordDiff(
        'The quick brown fox jumps over the lazy dog',
        'The quick red fox jumps over the lazy dog',
      );
      
      // Prefix: "The quick "
      // Suffix: " fox jumps over the lazy dog"
      // Mid: deletion of "brown", insertion of "red"
      final first = results.first;
      final last = results.last;
      
      expect(first.type, DiffType.equal);
      expect(first.text, 'The');
      
      expect(last.type, DiffType.equal);
      expect(last.text, 'dog');
      
      final deletion = results.firstWhere((d) => d.type == DiffType.deletion);
      final insertion = results.firstWhere((d) => d.type == DiffType.insertion);
      
      expect(deletion.text, 'brown');
      expect(insertion.text, 'red');
    });

    test('handles empty strings', () {
      final results = computeWordDiff('', 'Hello');
      expect(results.length, 1);
      expect(results.first.text, 'Hello');
      expect(results.first.type, DiffType.insertion);
    });
  });
}
