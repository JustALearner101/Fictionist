import 'package:flutter_riverpod/flutter_riverpod.dart';

class WritingPreferences {
  final bool sidebarCollapsed;
  final bool distractionFree;
  final bool typewriterMode;
  final bool corkboardView;
  final int wordCountGoal;
  final double editorFontSize;

  const WritingPreferences({
    this.sidebarCollapsed = false,
    this.distractionFree = false,
    this.typewriterMode = true,
    this.corkboardView = false,
    this.wordCountGoal = 0,
    this.editorFontSize = 16.0,
  });

  WritingPreferences copyWith({
    bool? sidebarCollapsed,
    bool? distractionFree,
    bool? typewriterMode,
    bool? corkboardView,
    int? wordCountGoal,
    double? editorFontSize,
  }) {
    return WritingPreferences(
      sidebarCollapsed: sidebarCollapsed ?? this.sidebarCollapsed,
      distractionFree: distractionFree ?? this.distractionFree,
      typewriterMode: typewriterMode ?? this.typewriterMode,
      corkboardView: corkboardView ?? this.corkboardView,
      wordCountGoal: wordCountGoal ?? this.wordCountGoal,
      editorFontSize: editorFontSize ?? this.editorFontSize,
    );
  }
}

final writingPreferencesProvider =
    StateProvider<WritingPreferences>((ref) => const WritingPreferences());
