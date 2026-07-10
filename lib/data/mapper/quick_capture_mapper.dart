import 'package:drift/drift.dart';
import '../../domain/quick_capture/quick_capture.dart';
import '../database/app_database.dart';

class QuickCaptureMapper {
  static QuickCapture toDomain(QuickCaptureRow row) {
    return QuickCapture(
      id: row.id,
      rawText: row.rawText,
      isProcessed: row.isProcessed,
      createdAt: row.createdAt,
    );
  }

  static QuickCapturesCompanion toCompanion(QuickCapture capture) {
    return QuickCapturesCompanion(
      id: Value(capture.id),
      rawText: Value(capture.rawText),
      isProcessed: Value(capture.isProcessed),
      createdAt: Value(capture.createdAt),
    );
  }
}
