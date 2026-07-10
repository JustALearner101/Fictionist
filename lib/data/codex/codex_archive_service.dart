import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import 'package:fictionist/core/error/failure.dart';

/// Result of importing a `.codex` file.
class CodexImportResult {
  final String jsonContent;
  final int mediaFilesExtracted;

  const CodexImportResult({
    required this.jsonContent,
    required this.mediaFilesExtracted,
  });
}

/// Creates and imports self-contained `.codex` archive files.
///
/// A `.codex` file is a ZIP containing a full JSON database export
/// plus any media assets.
@lazySingleton
class CodexArchiveService {
  /// Export the entire database (as JSON) into a `.codex` ZIP file.
  /// [jsonExport] — the full JSON string of all database tables.
  /// [onProgress] — optional callback receiving progress 0.0..1.0.
  Future<Either<Failure, String>> exportCodex(
    String jsonExport, {
    void Function(double progress)? onProgress,
  }) async {
    try {
      final archive = Archive();
      onProgress?.call(0.05);

      // Collect media files
      final appDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory(p.join(appDir.path, 'media'));
      final mediaFiles = <File>[];
      int totalMediaSize = 0;

      if (await mediaDir.exists()) {
        await for (final entity
            in mediaDir.list(recursive: true, followLinks: false)) {
          if (entity is File) {
            mediaFiles.add(entity);
            totalMediaSize += await entity.length();
          }
        }
      }

      onProgress?.call(0.10);

      // Add metadata (file counts + sizes, no external crypto deps)
      final metadata = jsonEncode({
        'app': 'fictionist',
        'version': '1.0.0',
        'format': 1,
        'exportedAt': DateTime.now().toIso8601String(),
        'dbJsonSize': jsonExport.length,
        'mediaFileCount': mediaFiles.length,
        'mediaTotalSize': totalMediaSize,
      });
      archive.addFile(ArchiveFile(
        'metadata.json',
        metadata.length,
        utf8.encode(metadata),
      ));

      onProgress?.call(0.15);

      // Add database export
      archive.addFile(ArchiveFile(
        'db_export.json',
        jsonExport.length,
        utf8.encode(jsonExport),
      ));

      // Embed media files under /media/
      final totalSteps = mediaFiles.length + 1; // +1 for final encoding
      var completed = 0;
      for (final file in mediaFiles) {
        final relativePath = p.relative(file.path, from: mediaDir.path);
        final archivePath = p.join('media', relativePath).replaceAll('\\', '/');
        final bytes = await file.readAsBytes();
        archive.addFile(ArchiveFile(archivePath, bytes.length, bytes));
        completed++;
        onProgress?.call(0.15 + (0.65 * completed / totalSteps));
      }

      onProgress?.call(0.85);

      // Encode ZIP
      final zipData = ZipEncoder().encode(archive);

      final dir = await getTemporaryDirectory();
      final filePath = p.join(
        dir.path,
        'fictionist_backup_${DateTime.now().millisecondsSinceEpoch}.codex',
      );
      await File(filePath).writeAsBytes(zipData);

      onProgress?.call(0.95);

      // Offer to share
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'Fictionist Codex Backup',
      );

      onProgress?.call(1.0);
      return Right(filePath);
    } on Exception catch (e) {
      return Left(
        Failure.unexpected(message: 'Export failed: $e', originalError: e),
      );
    }
  }

  /// Import a `.codex` file and return the extracted JSON content
  /// plus count of extracted media files.
  /// [onProgress] — optional callback receiving progress 0.0..1.0.
  Future<Either<Failure, CodexImportResult>> importCodex(
    String filePath, {
    void Function(double progress)? onProgress,
  }) async {
    try {
      onProgress?.call(0.05);
      final bytes = await File(filePath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      onProgress?.call(0.15);

      // Find db_export.json
      final dbFile = archive.findFile('db_export.json');
      if (dbFile == null) {
        return Left(const Failure.validation(
          message: 'Invalid .codex file: no db_export.json found',
        ));
      }
      final content = utf8.decode(dbFile.content as List<int>);

      onProgress?.call(0.30);

      // Extract media files from the archive
      final mediaFiles = archive.files.where(
        (f) => f.name.startsWith('media/') && f.isFile,
      ).toList();

      int extracted = 0;
      if (mediaFiles.isNotEmpty) {
        final appDir = await getApplicationDocumentsDirectory();
        final mediaDir = Directory(p.join(appDir.path, 'media'));
        if (!await mediaDir.exists()) {
          await mediaDir.create(recursive: true);
        }

        final totalMedia = mediaFiles.length;
        for (final mediaFile in mediaFiles) {
          final relativePath =
              mediaFile.name.replaceFirst('media/', '');
          final targetPath = p.join(mediaDir.path, relativePath);
          final targetFile = File(targetPath);

          // Ensure parent directory exists
          await targetFile.parent.create(recursive: true);

          await targetFile.writeAsBytes(mediaFile.content as List<int>);
          extracted++;
          onProgress?.call(0.30 + (0.60 * extracted / totalMedia));
        }
      }

      onProgress?.call(0.95);
      onProgress?.call(1.0);

      return Right(CodexImportResult(
        jsonContent: content,
        mediaFilesExtracted: extracted,
      ));
    } on Exception catch (e) {
      return Left(
        Failure.unexpected(message: 'Import failed: $e', originalError: e),
      );
    }
  }
}
