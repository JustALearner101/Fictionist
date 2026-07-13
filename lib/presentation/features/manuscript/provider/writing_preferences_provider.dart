import 'package:flutter_riverpod/flutter_riverpod.dart';

class WritingPreferences {
  final bool sidebarCollapsed;
  final bool distractionFree;
  final bool typewriterMode;
  final bool corkboardView;
  final int wordCountGoal;
  final double editorFontSize;
  final String layoutMode; // 'normal', 'comfort', 'book'
  final String focusHighlight; // 'none', 'sentence', 'paragraph'

  const WritingPreferences({
    this.sidebarCollapsed = false,
    this.distractionFree = false,
    this.typewriterMode = false,
    this.corkboardView = false,
    this.wordCountGoal = 0,
    this.editorFontSize = 16.0,
    this.layoutMode = 'normal',
    this.focusHighlight = 'none',
  });

  WritingPreferences copyWith({
    bool? sidebarCollapsed,
    bool? distractionFree,
    bool? typewriterMode,
    bool? corkboardView,
    int? wordCountGoal,
    double? editorFontSize,
    String? layoutMode,
    String? focusHighlight,
  }) {
    return WritingPreferences(
      sidebarCollapsed: sidebarCollapsed ?? this.sidebarCollapsed,
      distractionFree: distractionFree ?? this.distractionFree,
      typewriterMode: typewriterMode ?? this.typewriterMode,
      corkboardView: corkboardView ?? this.corkboardView,
      wordCountGoal: wordCountGoal ?? this.wordCountGoal,
      editorFontSize: editorFontSize ?? this.editorFontSize,
      layoutMode: layoutMode ?? this.layoutMode,
      focusHighlight: focusHighlight ?? this.focusHighlight,
    );
  }
}

final writingPreferencesProvider =
    StateProvider<WritingPreferences>((ref) => const WritingPreferences());
