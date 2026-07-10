/// A Trie (prefix tree) data structure for efficient entity name lookups.
///
/// Used by the wikilink engine to match entity names in text
/// and convert them to clickable markdown links.
class TrieNode {
  final Map<String, TrieNode> children = {};
  String? entityId;
  String? entityName;

  void insert(String word, String id, String name) {
    var current = this;
    for (int i = 0; i < word.length; i++) {
      final char = word[i].toLowerCase();
      current.children.putIfAbsent(char, () => TrieNode());
      current = current.children[char]!;
    }
    current.entityId = id;
    current.entityName = name;
  }

  /// Finds the longest entity name match starting at [position] in [text].
  /// Returns (entityId, entityName, matchLength) or null if no match.
  (String, String, int)? findLongestMatch(String text, int position) {
    var current = this;
    (String, String)? lastMatch;
    int lastMatchLen = 0;

    for (int i = position; i < text.length; i++) {
      final char = text[i].toLowerCase();
      final child = current.children[char];
      if (child == null) break;

      current = child;
      if (current.entityId != null) {
        lastMatch = (current.entityId!, current.entityName!);
        lastMatchLen = i - position + 1;
      }
    }

    if (lastMatch != null) {
      return (lastMatch.$1, lastMatch.$2, lastMatchLen);
    }
    return null;
  }
}
