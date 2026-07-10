import 'package:flutter_riverpod/flutter_riverpod.dart';

class WritingPreferences {
  final bool sidebarCollapsed;
  final bool distractionFree;
  final int wordCountGoal;
  final double editorFontSize;

  const WritingPreferences({
    this.sidebarCollapsed = false,
    this.distractionFree = false,
    this.wordCountGoal = 0,
    this.editorFontSize = 16.0,
  });

  WritingPreferences copyWith({
    bool? sidebarCollapsed,
    bool? distractionFree,
    int? wordCountGoal,
    double? editorFontSize,
  }) {
    return WritingPreferences(
      sidebarCollapsed: sidebarCollapsed ?? this.sidebarCollapsed,
      distractionFree: distractionFree ?? this.distractionFree,
      wordCountGoal: wordCountGoal ?? this.wordCountGoal,
      editorFontSize: editorFontSize ?? this.editorFontSize,
    );
  }
}

final writingPreferencesProvider =
    StateProvider<WritingPreferences>((ref) => const WritingPreferences());
