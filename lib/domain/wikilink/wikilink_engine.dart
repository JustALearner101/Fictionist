import 'package:injectable/injectable.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/wikilink/trie.dart';

/// Builds and maintains an in-memory Trie of all active entity names
/// for fast wikilink matching in text.
@lazySingleton
class WikilinkEngine {
  TrieNode _trie = TrieNode();

  /// Rebuild the Trie from a list of entities.
  void rebuild(List<Entity> entities) {
    final newTrie = TrieNode();
    for (final entity in entities) {
      if (entity.name.length >= 3) {
        newTrie.insert(entity.name, entity.id, entity.name);
      }
    }
    _trie = newTrie;
  }

  /// Process [text] and convert matching entity names to wikilinks:
  /// `[EntityName](entity://uuid)`
  ///
  /// Only matches whole words (bounded by word boundaries or punctuation).
  /// Each entity name is linked only once (first occurrence).
  String process(String text) {
    if (text.isEmpty) return text;

    final buffer = StringBuffer();
    final linkedIds = <String>{};
    int i = 0;

    while (i < text.length) {
      // Check if at a word boundary
      if (i > 0 && _isWordChar(text[i - 1])) {
        buffer.write(text[i]);
        i++;
        continue;
      }

      final match = _trie.findLongestMatch(text, i);
      if (match != null) {
        final (id, name, len) = match;

        // Verify it's a whole word (next char is boundary or end)
        final endIdx = i + len;
        if (endIdx < text.length && _isWordChar(text[endIdx])) {
          // Not a whole word boundary — skip
          buffer.write(text[i]);
          i++;
          continue;
        }

        if (!linkedIds.contains(id)) {
          buffer.write('[$name](entity://$id)');
          linkedIds.add(id);
        } else {
          buffer.write(name);
        }
        i += len;
      } else {
        buffer.write(text[i]);
        i++;
      }
    }

    return buffer.toString();
  }

  bool _isWordChar(String char) {
    final code = char.codeUnitAt(0);
    return (code >= 65 && code <= 90) || // A-Z
        (code >= 97 && code <= 122) || // a-z
        (code >= 48 && code <= 57) || // 0-9
        code == 95; // _
  }
}
