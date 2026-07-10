import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:archive/archive.dart' as arch;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as p;

import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/manuscript/compile_format.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';
import 'package:fictionist/domain/repository/entity_repository.dart';
import 'package:fictionist/domain/repository/manuscript_repository.dart';

/// Compiles manuscript chapters into EPUB, PDF, or plain text book formats.
///
/// Automatically strips wikilinks and optionally generates an appendix
/// of referenced worldbuilding entities.
@lazySingleton
class ManuscriptCompiler {
  final ManuscriptRepository _manuscriptRepo;
  final EntityRepository _entityRepo;

  ManuscriptCompiler(this._manuscriptRepo, this._entityRepo);

  /// Compile chapters into the given [format] and write to a temp file.
  /// Returns the file path on success.
  Future<Either<Failure, String>> compile(
    CompileManuscriptParams params,
  ) async {
    // Load chapters
    final chaptersResult = await _loadChapters(params.chapterIds);
    if (chaptersResult.isLeft()) {
      return chaptersResult.fold(
        (f) => Left(f),
        (_) => Left(const Failure.unexpected(message: 'Chapter load failed')),
      );
    }
    final chapters = chaptersResult.fold(
      (_) => <ManuscriptChapter>[],
      (list) => list,
    );

    // Load all entities for appendix
    List<Entity> allEntities = [];
    if (params.includeAppendix) {
      final entitiesResult = await _entityRepo.getAllActive();
      entitiesResult.fold(
        (_) {},
        (list) => allEntities = list,
      );
    }

    // Strip wikilinks from content: [Name](entity://id) → Name
    final strippedChapters = chapters.map((ch) {
      return ch.copyWith(
        content: _stripEntityLinks(ch.content),
      );
    }).toList();

    // Collect referenced entities from stripped content
    final referencedIds = <String>{};
    for (final ch in strippedChapters) {
      referencedIds.addAll(_extractEntityIds(ch.content));
    }

    try {
      switch (params.format) {
        case CompileFormat.epub:
          return _buildEpub(params, strippedChapters, allEntities, referencedIds);
        case CompileFormat.pdf:
          return _buildPdf(params, strippedChapters, allEntities, referencedIds);
        case CompileFormat.plainText:
          return _buildPlainText(params, strippedChapters, allEntities);
      }
    } on Exception catch (e) {
      return Left(Failure.unexpected(
        message: 'Compilation failed: $e',
        originalError: e,
      ));
    }
  }

  // ── EPUB ──

  Future<Either<Failure, String>> _buildEpub(
    CompileManuscriptParams params,
    List<ManuscriptChapter> chapters,
    List<Entity> allEntities,
    Set<String> referencedIds,
  ) async {
    final archive = arch.Archive();

    // mimetype (must be first, uncompressed)
    archive.addFile(arch.ArchiveFile(
      'mimetype',
      0,
      utf8.encode('application/epub+zip'),
    ));

    // container.xml
    final containerXml = '''<?xml version="1.0" encoding="UTF-8"?>
<container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
  <rootfiles>
    <rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/>
  </rootfiles>
</container>''';
    archive.addFile(arch.ArchiveFile(
      'META-INF/container.xml',
      utf8.encode(containerXml).length,
      utf8.encode(containerXml),
    ));

    // Build HTML for each chapter
    final htmlChapters = <String>[];
    for (final ch in chapters) {
      final htmlContent = _markdownToHtml(ch.content);
      htmlChapters.add('''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>${_escapeXml(ch.title)}</title>
<link rel="stylesheet" type="text/css" href="style.css"/>
</head>
<body>
<h1>${_escapeXml(ch.title)}</h1>
$htmlContent
</body>
</html>''');
    }

    // Appendix HTML
    String appendixHtml = '';
    if (params.includeAppendix && referencedIds.isNotEmpty) {
      final refEntities = allEntities
          .where((e) => referencedIds.contains(e.id))
          .toList();
      appendixHtml = _buildAppendixHtml(refEntities);
      htmlChapters.add('''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>Appendix</title>
<link rel="stylesheet" type="text/css" href="style.css"/>
</head>
<body>
<h1>World Codex Appendix</h1>
$appendixHtml
</body>
</html>''');
    }

    // Build chapter manifest and spine items
    final manifestItems = <String>[];
    final spineItems = <String>[];

    // Add CSS stylesheet
    final cssContent = '''body { font-family: Georgia, serif; margin: 5%; line-height: 1.6; color: #1a1a1a; }
    h1 { font-family: 'Palatino Linotype', serif; font-size: 2em; margin-bottom: 0.5em; page-break-before: always; }
    h2 { font-family: 'Palatino Linotype', serif; font-size: 1.5em; margin-top: 1.5em; }
    p { text-indent: 1.5em; margin: 0.3em 0; }
    strong { font-weight: bold; }
    em { font-style: italic; }''';
    archive.addFile(arch.ArchiveFile(
      'OEBPS/style.css',
      utf8.encode(cssContent).length,
      utf8.encode(cssContent),
    ));
    manifestItems.add(
      '<item id="css" href="style.css" media-type="text/css"/>',
    );
    // Add chapter files
    for (int i = 0; i < htmlChapters.length; i++) {
      final id = i < chapters.length ? 'chapter_$i' : 'appendix';
      final filename = '$id.xhtml';
      archive.addFile(arch.ArchiveFile(
        'OEBPS/$filename',
        utf8.encode(htmlChapters[i]).length,
        utf8.encode(htmlChapters[i]),
      ));
      manifestItems.add(
        '<item id="$id" href="$filename" media-type="application/xhtml+xml"/>',
      );
      spineItems.add('<itemref idref="$id"/>');
    }

    // content.opf
    final opf = '''<?xml version="1.0" encoding="UTF-8"?>
<package xmlns="http://www.idpf.org/2007/opf" version="2.0" unique-identifier="bookid">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
    <dc:title>${_escapeXml(params.bookTitle)}</dc:title>
    <dc:creator>${_escapeXml(params.authorName)}</dc:creator>
    <dc:language>en</dc:language>
    <dc:identifier id="bookid">urn:uuid:${_generateUuid()}</dc:identifier>
  </metadata>
  <manifest>
    ${manifestItems.join('\n    ')}
  </manifest>
  <spine toc="ncx">
    ${spineItems.join('\n    ')}
  </spine>
</package>''';
    archive.addFile(arch.ArchiveFile(
      'OEBPS/content.opf',
      utf8.encode(opf).length,
      utf8.encode(opf),
    ));

    // Write to temp file
    final dir = await getTemporaryDirectory();
    final filePath =
        p.join(dir.path, '${params.bookTitle}_compiled.epub');
    final bytes = arch.ZipEncoder().encode(archive);
    await File(filePath).writeAsBytes(bytes);
    return Right(filePath);
  }

  // ── PDF ──

  Future<Either<Failure, String>> _buildPdf(
    CompileManuscriptParams params,
    List<ManuscriptChapter> chapters,
    List<Entity> allEntities,
    Set<String> referencedIds,
  ) async {
    final pdf = pw.Document();

    // Title page
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a5,
      build: (ctx) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                params.bookTitle,
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              if (params.authorName.isNotEmpty) ...[
                pw.SizedBox(height: 16),
                pw.Text(
                  'by ${params.authorName}',
                  style: const pw.TextStyle(fontSize: 16),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ],
          ),
        );
      },
    ));

    // Chapters
    for (final ch in chapters) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a5,
        header: (ctx) => pw.Text(
          params.bookTitle,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
          textAlign: pw.TextAlign.center,
        ),
        build: (ctx) {
          return [
            pw.Text(
              ch.title,
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              ch.content,
              style: const pw.TextStyle(fontSize: 11, height: 1.6),
            ),
          ];
        },
      ));
    }

    // Appendix
    if (params.includeAppendix && referencedIds.isNotEmpty) {
      final refEntities = allEntities
          .where((e) => referencedIds.contains(e.id))
          .toList();
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a5,
        build: (ctx) {
          final items = <pw.Widget>[
            pw.Text(
              'World Codex Appendix',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 16),
          ];
          for (final entity in refEntities) {
            items.add(pw.Text(
              '${entity.name} (${entity.type.label})',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ));
            if (entity.description != null &&
                entity.description!.isNotEmpty) {
              items.add(pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Text(
                  entity.description!,
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ));
            }
          }
          return items;
        },
      ));
    }

    final dir = await getTemporaryDirectory();
    final filePath = p.join(dir.path, '${params.bookTitle}_compiled.pdf');
    final bytes = await pdf.save();
    await File(filePath).writeAsBytes(bytes);
    return Right(filePath);
  }

  // ── Plain Text ──

  Future<Either<Failure, String>> _buildPlainText(
    CompileManuscriptParams params,
    List<ManuscriptChapter> chapters,
    List<Entity> allEntities,
  ) async {
    final buffer = StringBuffer();
    buffer.writeln(params.bookTitle.toUpperCase());
    buffer.writeln('=' * params.bookTitle.length);
    buffer.writeln();
    if (params.authorName.isNotEmpty) {
      buffer.writeln('by ${params.authorName}');
      buffer.writeln();
    }

    for (final ch in chapters) {
      buffer.writeln(ch.title);
      buffer.writeln('-' * ch.title.length);
      buffer.writeln();
      buffer.writeln(ch.content);
      buffer.writeln();
      buffer.writeln();
    }

    if (params.includeAppendix) {
      buffer.writeln('WORLD CODEX APPENDIX');
      buffer.writeln('=' * 20);
      buffer.writeln();
      for (final entity in allEntities) {
        buffer.writeln('${entity.name} (${entity.type.label})');
        if (entity.description != null) {
          buffer.writeln(entity.description!);
        }
        buffer.writeln();
      }
    }

    final dir = await getTemporaryDirectory();
    final filePath = p.join(dir.path, '${params.bookTitle}_compiled.txt');
    await File(filePath).writeAsString(buffer.toString());
    return Right(filePath);
  }

  // ── Helpers ──

  Future<Either<Failure, List<ManuscriptChapter>>> _loadChapters(
    List<String> ids,
  ) async {
    final chapters = <ManuscriptChapter>[];
    for (final id in ids) {
      final result = await _manuscriptRepo.getById(id);
      final chapter = result.fold(
        (f) => null,
        (ch) => ch,
      );
      if (chapter == null) {
        return Left(Failure.notFound(
          resourceType: 'ManuscriptChapter',
          resourceId: id,
        ));
      }
      chapters.add(chapter);
    }
    return Right(chapters);
  }

  /// Strip entity wikilinks: [Name](entity://id) → Name
  String _stripEntityLinks(String text) {
    return text.replaceAll(RegExp(r'\[([^\]]*)\]\(entity://[^\)]*\)'), r'$1');
  }

  /// Extract entity UUIDs from wikilinks in text.
  Set<String> _extractEntityIds(String text) {
    final ids = <String>{};
    final regex = RegExp(r'\[([^\]]*)\]\(entity://([^\)]*)\)');
    for (final match in regex.allMatches(text)) {
      ids.add(match.group(2)!);
    }
    return ids;
  }

  /// Very basic markdown → HTML conversion.
  String _markdownToHtml(String md) {
    return md
        .replaceAll(RegExp(r'\*\*(.+?)\*\*'), r'<strong>$1</strong>')
        .replaceAll(RegExp(r'\*(.+?)\*'), r'<em>$1</em>')
        .replaceAll(RegExp(r'`(.+?)`'), r'<code>$1</code>')
        .replaceAll('\n\n', '</p><p>')
        .replaceAll('\n', '<br/>');
  }

  String _escapeXml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  String _buildAppendixHtml(List<Entity> entities) {
    final buffer = StringBuffer();
    for (final entity in entities) {
      buffer.writeln('<h2>${_escapeXml(entity.name)} '
          '(${_escapeXml(entity.type.label)})</h2>');
      if (entity.description != null && entity.description!.isNotEmpty) {
        buffer.writeln('<p>${_escapeXml(entity.description!)}</p>');
      }
      if (entity.customFields.isNotEmpty) {
        buffer.writeln('<ul>');
        for (final field in entity.customFields) {
          final value = field.value?.toString() ?? '';
          if (value.isNotEmpty) {
            buffer.writeln('<li><strong>${_escapeXml(field.label)}:</strong> '
                '${_escapeXml(value)}</li>');
          }
        }
        buffer.writeln('</ul>');
      }
    }
    return buffer.toString();
  }

  String _generateUuid() {
    final r = math.Random();
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
        .replaceAllMapped(RegExp('[xy]'), (match) {
      final c = match.group(0) == 'x'
          ? r.nextInt(16)
          : (r.nextInt(4) + 8);
      return c.toRadixString(16);
    });
  }
}
