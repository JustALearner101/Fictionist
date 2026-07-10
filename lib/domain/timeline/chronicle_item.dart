import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';
import 'package:fictionist/domain/timeline/timeline_entry.dart';

/// A unified timeline item that can be either a [TimelineEntry]
/// or a [ManuscriptChapter] with a date label, for display in the
/// timeline chronicle view.
sealed class ChronicleItem {
  String get title;
  String? get description;
  String? get dateLabel;
  String? get eraLabel;
  String get id;
}

class ChronicleTimelineEntry extends ChronicleItem {
  final TimelineEntry entry;
  ChronicleTimelineEntry(this.entry);

  @override
  String get title => entry.title;
  @override
  String? get description => entry.description;
  @override
  String? get dateLabel => entry.dateLabel;
  @override
  String? get eraLabel => entry.eraLabel;
  @override
  String get id => entry.id;
}

class ChronicleChapter extends ChronicleItem {
  final ManuscriptChapter chapter;
  ChronicleChapter(this.chapter);

  @override
  String get title => '📖 ${chapter.title}';
  @override
  String? get description => chapter.content.length > 200
      ? '${chapter.content.substring(0, 200)}...'
      : chapter.content;
  @override
  String? get dateLabel => chapter.dateLabel;
  @override
  String? get eraLabel => chapter.eraLabel;
  @override
  String get id => chapter.id;
}
