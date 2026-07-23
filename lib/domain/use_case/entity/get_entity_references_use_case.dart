import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../entity/entity.dart';
import '../../manuscript/manuscript_chapter.dart';
import '../../relationship/relationship.dart';
import '../../../data/repository/manuscript_repository_impl.dart';
import '../../../data/repository/relationship_repository_impl.dart';
import '../../../data/repository/timeline_repository_impl.dart';
import '../../timeline/timeline_entry.dart';

class ChapterReference {
  final String chapterId;
  final String chapterTitle;
  final int mentionCount;
  final int dialogueCount;
  final int narrationCount;
  final List<String> snippets;

  const ChapterReference({
    required this.chapterId,
    required this.chapterTitle,
    required this.mentionCount,
    required this.dialogueCount,
    required this.narrationCount,
    required this.snippets,
  });
}

class TimelineReference {
  final String entryId;
  final String entryTitle;
  final String? dateLabel;

  const TimelineReference({
    required this.entryId,
    required this.entryTitle,
    this.dateLabel,
  });
}

class RelationshipReference {
  final String relationshipId;
  final String typeKey;
  final String otherEntityId;
  final String otherEntityName;
  final int otherEntityColor;

  const RelationshipReference({
    required this.relationshipId,
    required this.typeKey,
    required this.otherEntityId,
    required this.otherEntityName,
    required this.otherEntityColor,
  });
}

class EntityReferences {
  final List<ChapterReference> chapters;
  final List<TimelineReference> timelineEntries;
  final List<RelationshipReference> relationships;
  final int totalMentions;
  final int dialogueMentions;
  final int narrationMentions;

  const EntityReferences({
    required this.chapters,
    required this.timelineEntries,
    required this.relationships,
    required this.totalMentions,
    required this.dialogueMentions,
    required this.narrationMentions,
  });
}

@lazySingleton
class GetEntityReferencesUseCase {
  final ManuscriptRepositoryImpl _manuscriptRepo;
  final TimelineRepositoryImpl _timelineRepo;
  final RelationshipRepositoryImpl _relationshipRepo;

  GetEntityReferencesUseCase(
    this._manuscriptRepo,
    this._timelineRepo,
    this._relationshipRepo,
  );

  Future<Either<Failure, EntityReferences>> call(Entity entity) async {
    try {
      final chaptersResult = await _manuscriptRepo.getAllActive();
      final timelineResult = await _timelineRepo.getAllActiveOrdered();
      final relsResult = await _relationshipRepo.getAllActive();

      if (chaptersResult.isLeft() && timelineResult.isLeft()) {
        return Left(chaptersResult.fold((f) => f, (_) =>
            Failure.unexpected(message: 'Failed to load references')));
      }

      final chapters =
          chaptersResult.fold((_) => <ManuscriptChapter>[], (list) => list);
      final timeline =
          timelineResult.fold((_) => <TimelineEntry>[], (list) => list);
      final relationships =
          relsResult.fold((_) => <Relationship>[], (list) => list);

      final chapterRefs = <ChapterReference>[];
      int totalDialogue = 0;
      int totalNarration = 0;
      final name = entity.name.toLowerCase();

      for (final ch in chapters) {
        final content = ch.content;
        final (dialogue, narration, snippets) =
            _scanText(content, entity.name);
        final count = dialogue + narration;
        if (count > 0) {
          chapterRefs.add(ChapterReference(
            chapterId: ch.id,
            chapterTitle: ch.title,
            mentionCount: count,
            dialogueCount: dialogue,
            narrationCount: narration,
            snippets: snippets,
          ));
        }
        totalDialogue += dialogue;
        totalNarration += narration;
      }

      final timelineRefs = <TimelineReference>[];
      for (final entry in timeline) {
        final entryEntityId = entry.entityId;
        if (entryEntityId == entity.id) {
          timelineRefs.add(TimelineReference(
            entryId: entry.id,
            entryTitle: entry.title,
            dateLabel: entry.dateLabel,
          ));
        }
      }

      final relRefs = <RelationshipReference>[];
      for (final rel in relationships) {
        final sourceId = rel.sourceId;
        final targetId = rel.targetId;
        if (sourceId == entity.id || targetId == entity.id) {
          relRefs.add(RelationshipReference(
            relationshipId: rel.id,
            typeKey: rel.typeKey,
            otherEntityId: sourceId == entity.id ? targetId : sourceId,
            otherEntityName: '',
            otherEntityColor: 0xFF888888,
          ));
        }
      }

      return Right(EntityReferences(
        chapters: chapterRefs..sort((a, b) => b.mentionCount.compareTo(a.mentionCount)),
        timelineEntries: timelineRefs,
        relationships: relRefs,
        totalMentions: totalDialogue + totalNarration,
        dialogueMentions: totalDialogue,
        narrationMentions: totalNarration,
      ));
    } catch (e) {
      return Left(Failure.unexpected(
        message: 'Failed to scan entity references: $e',
        originalError: e,
      ));
    }
  }

  (int, int, List<String>) _scanText(String text, String entityName) {
    int dialogue = 0;
    int narration = 0;
    final snippets = <String>[];
    final name = entityName.toLowerCase();

    final segments = <_TextSegment>[];
    final dialogueRegex = RegExp(r'"[^"]*"|"[^"]*"|"[^"]*"');

    int lastEnd = 0;
    for (final match in dialogueRegex.allMatches(text)) {
      if (match.start > lastEnd) {
        segments.add(_TextSegment(text.substring(lastEnd, match.start), false));
      }
      segments.add(_TextSegment(match.group(0)!, true));
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      segments.add(_TextSegment(text.substring(lastEnd), false));
    }

    final wordBoundary = RegExp('\\b$name\\b', caseSensitive: false);
    for (final seg in segments) {
      final matches = wordBoundary.allMatches(seg.text);
      final count = matches.length;
      if (count == 0) continue;

      if (seg.isDialogue) {
        dialogue += count;
      } else {
        narration += count;
      }

      for (final m in matches.take(3 - snippets.length)) {
        final start = (m.start - 20).clamp(0, seg.text.length);
        final end = (m.end + 30).clamp(0, seg.text.length);
        var snippet = seg.text.substring(start, end).replaceAll('\n', ' ');
        if (start > 0) snippet = '…$snippet';
        if (end < seg.text.length) snippet = '$snippet…';
        snippets.add(snippet);
      }
    }

    return (dialogue, narration, snippets);
  }
}

class _TextSegment {
  final String text;
  final bool isDialogue;
  const _TextSegment(this.text, this.isDialogue);
}
