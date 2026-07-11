import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:drift/drift.dart';
import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/data/dao/snapshot_dao.dart';
import 'package:fictionist/domain/manuscript/chapter_snapshot.dart';
import 'package:fictionist/injection.dart';

final snapshotProvider = StateProvider<List<ChapterSnapshot>>((ref) => []);

/// Loads snapshots for a given chapter from the database.
Future<List<ChapterSnapshot>> loadSnapshots(String chapterId) async {
  final dao = getIt<SnapshotDao>();
  final rows = await dao.getSnapshotsForChapter(chapterId);
  return rows
      .map((r) => ChapterSnapshot(
            id: r.id,
            chapterId: r.chapterId,
            content: r.content,
            createdAt: r.createdAt,
          ))
      .toList();
}

/// Creates a new snapshot for a chapter and prunes old ones.
Future<void> createSnapshot({
  required String chapterId,
  required String content,
  int keepCount = 10,
}) async {
  final dao = getIt<SnapshotDao>();

  final snapshot = _toCompanion(
    ChapterSnapshot(
      id: const Uuid().v4(),
      chapterId: chapterId,
      content: content,
      createdAt: DateTime.now(),
    ),
  );

  await dao.createSnapshot(snapshot);
  // Don't await pruning — fire and forget
  unawaited(dao.deleteOldSnapshots(chapterId, keepCount: keepCount));
}

ChapterSnapshotsCompanion _toCompanion(ChapterSnapshot snapshot) {
  return ChapterSnapshotsCompanion(
    id: Value(snapshot.id),
    chapterId: Value(snapshot.chapterId),
    content: Value(snapshot.content),
    createdAt: Value(snapshot.createdAt),
  );
}
