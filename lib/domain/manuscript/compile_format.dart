/// Output format for the prose compiler.
enum CompileFormat {
  /// EPUB book format (ZIP archive with HTML + metadata).
  epub,

  /// PDF document.
  pdf,

  /// Plain markdown text.
  plainText;

  String get label {
    switch (this) {
      case CompileFormat.epub:
        return 'EPUB';
      case CompileFormat.pdf:
        return 'PDF';
      case CompileFormat.plainText:
        return 'Plain Text';
    }
  }

  String get fileExtension {
    switch (this) {
      case CompileFormat.epub:
        return '.epub';
      case CompileFormat.pdf:
        return '.pdf';
      case CompileFormat.plainText:
        return '.txt';
    }
  }
}

/// Parameters for compiling a manuscript into a book format.
class CompileManuscriptParams {
  /// Chapter IDs in order.
  final List<String> chapterIds;

  /// Book title.
  final String bookTitle;

  /// Author name.
  final String authorName;

  /// Output format.
  final CompileFormat format;

  /// Whether to include a generated appendix of referenced entities.
  final bool includeAppendix;

  const CompileManuscriptParams({
    required this.chapterIds,
    required this.bookTitle,
    this.authorName = '',
    this.format = CompileFormat.pdf,
    this.includeAppendix = true,
  });
}
