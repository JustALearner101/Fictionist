enum DiffType { insertion, deletion, equal }

class DiffSegment {
  final String text;
  final DiffType type;

  const DiffSegment(this.text, this.type);
}

/// Computes a word-level diff between two strings.
///
/// Optimizes performance by pre-trimming common prefixes and suffixes
/// to reduce the Dynamic Programming matrix size.
List<DiffSegment> computeWordDiff(String oldText, String newText) {
  if (oldText == newText) {
    return [DiffSegment(oldText, DiffType.equal)];
  }

  final oldWords = oldText.split(RegExp(r'(?<=\s)|(?=\s)')).where((w) => w.isNotEmpty).toList();
  final newWords = newText.split(RegExp(r'(?<=\s)|(?=\s)')).where((w) => w.isNotEmpty).toList();

  int start = 0;
  while (start < oldWords.length &&
      start < newWords.length &&
      oldWords[start] == newWords[start]) {
    start++;
  }

  int oldEnd = oldWords.length - 1;
  int newEnd = newWords.length - 1;
  while (oldEnd >= start &&
      newEnd >= start &&
      oldWords[oldEnd] == newWords[newEnd]) {
    oldEnd--;
    newEnd--;
  }

  // Prefix
  final prefix = oldWords.sublist(0, start).map((w) => DiffSegment(w, DiffType.equal)).toList();

  // Suffix
  final suffix = oldWords.sublist(oldEnd + 1).map((w) => DiffSegment(w, DiffType.equal)).toList();

  // Mid region (diff)
  final midOld = oldWords.sublist(start, oldEnd + 1);
  final midNew = newWords.sublist(start, newEnd + 1);

  final m = midOld.length;
  final n = midNew.length;

  final midDiff = <DiffSegment>[];
  if (m > 0 || n > 0) {
    final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        if (midOld[i - 1] == midNew[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1] + 1;
        } else {
          dp[i][j] = dp[i - 1][j] > dp[i][j - 1] ? dp[i - 1][j] : dp[i][j - 1];
        }
      }
    }

    int i = m;
    int j = n;
    while (i > 0 || j > 0) {
      if (i > 0 && j > 0 && midOld[i - 1] == midNew[j - 1]) {
        midDiff.add(DiffSegment(midOld[i - 1], DiffType.equal));
        i--;
        j--;
      } else if (j > 0 && (i == 0 || dp[i][j - 1] >= dp[i - 1][j])) {
        midDiff.add(DiffSegment(midNew[j - 1], DiffType.insertion));
        j--;
      } else if (i > 0 && (j == 0 || dp[i - 1][j] >= dp[i][j - 1])) {
        midDiff.add(DiffSegment(midOld[i - 1], DiffType.deletion));
        i--;
      }
    }
  }

  return [
    ...prefix,
    ...midDiff.reversed,
    ...suffix,
  ];
}
