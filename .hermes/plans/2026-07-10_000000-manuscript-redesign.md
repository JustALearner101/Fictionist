# Fictionist Manuscript — Professional Redesign Plan

> **For Hermes:** Use `subagent-driven-development` skill to implement this plan task-by-task.

**Goal:** Transform the Fictionist manuscript screen from a basic split-pane editor into a professional-grade writing environment — distraction-free mode, collapsible sidebar, writing stats, and polished typography.

**Architecture:** Keep existing Clean Architecture (presentation→domain→data) and Riverpod state management. All changes are in the `presentation` layer only — zero domain/data changes needed. Add a `WritingPreferences` state class to track UI preferences (sidebar collapsed, distraction-free mode, word count goal).

**Tech Stack:** Flutter, flutter_riverpod, flutter_quill, flutter_markdown, freezed

---

## Current State vs Target

| Area | Current | Target |
|---|---|---|
| Sidebar | Fixed 200px, basic ListTile | Collapsible (60px icons ↔ 240px full), rich cards with word count/chapter number |
| Editor | QuillEditor + bare title field | Padded book-like layout, sticky toolbar, serif typography |
| Distraction-free | None | Fullscreen mode: sidebar + appbar auto-hide, centered content |
| Stats | Word count only | Word count goal bar, reading time, character count, last edited |
| Mobile | Separate chapter list → push to editor | Bottom sheet chapter picker OR inline switcher |
| Codex drawer | 280px right panel, manual toggle | Slide-over panel, entity chip insertion |
| Preview | Basic markdown | Book-page simulation with proper typography |
| Theme | Generic Material | Writer-focused: warm paper tones, reduced visual noise |

---

## Task 1: Add WritingPreferences state

**Objective:** Create a `WritingPreferences` class and Riverpod provider to track UI preferences across the manuscript screen (sidebar collapsed, distraction-free, word count goal). This prevents state loss when switching chapters.

**Files:**
- Create: `lib/presentation/features/manuscript/provider/writing_preferences_provider.dart`
- The provider will NOT use code generation — simple `StateProvider` is enough.

**Step 1: Create preferences provider**

```dart
// File: lib/presentation/features/manuscript/provider/writing_preferences_provider.dart
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
```

**Step 2: Verify**

Run: `dart analyze lib/presentation/features/manuscript/provider/`

Expected: No errors.

**Step 3: Commit**

```bash
git add lib/presentation/features/manuscript/provider/writing_preferences_provider.dart
git commit -m "feat: add WritingPreferences provider for manuscript UI state"
```

---

## Task 2: Build collapsible chapter sidebar

**Objective:** Replace the fixed 200px chapter list with a collapsible sidebar. When expanded (240px), show rich chapter cards with title, word count, and delete button. When collapsed (60px), show numbered icon buttons.

**Files:**
- Create: `lib/presentation/features/manuscript/widget/chapter_sidebar.dart`
- Modify: `lib/presentation/features/manuscript/screen/manuscript_screen.dart` (replace sidebar section)

**Step 1: Create ChapterSidebar widget**

```dart
// File: lib/presentation/features/manuscript/widget/chapter_sidebar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';
import 'package:fictionist/presentation/features/manuscript/provider/writing_preferences_provider.dart';

class ChapterSidebar extends ConsumerWidget {
  final List<ManuscriptChapter> chapters;
  final String? selectedChapterId;
  final void Function(String id) onChapterSelected;
  final void Function(String id, String title) onChapterDeleted;
  final void Function(int oldIndex, int newIndex) onReorder;

  const ChapterSidebar({
    super.key,
    required this.chapters,
    required this.selectedChapterId,
    required this.onChapterSelected,
    required this.onChapterDeleted,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(writingPreferencesProvider);
    final collapsed = prefs.sidebarCollapsed;
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: collapsed ? 60 : 240,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            right: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.15),
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            // Header with collapse toggle
            _SidebarHeader(collapsed: collapsed),
            // Chapter list
            Expanded(child: collapsed ? _CollapsedChapterList(
              chapters: chapters,
              selectedChapterId: selectedChapterId,
              onChapterSelected: onChapterSelected,
            ) : _ExpandedChapterList(
              chapters: chapters,
              selectedChapterId: selectedChapterId,
              onChapterSelected: onChapterSelected,
              onChapterDeleted: onChapterDeleted,
              onReorder: onReorder,
            )),
          ],
        ),
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  final bool collapsed;
  const _SidebarHeader({required this.collapsed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 8, 8),
      child: Row(
        children: [
          if (!collapsed) ...[
            Text('Chapters', style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            )),
            const Spacer(),
          ],
          Consumer(
            builder: (context, ref, _) => IconButton(
              icon: Icon(
                collapsed ? Icons.chevron_right : Icons.chevron_left,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              tooltip: collapsed ? 'Expand sidebar' : 'Collapse sidebar',
              onPressed: () {
                ref.read(writingPreferencesProvider.notifier).update(
                  (p) => p.copyWith(sidebarCollapsed: !p.sidebarCollapsed),
                );
              },
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsedChapterList extends StatelessWidget {
  final List<ManuscriptChapter> chapters;
  final String? selectedChapterId;
  final void Function(String) onChapterSelected;

  const _CollapsedChapterList({
    required this.chapters,
    required this.selectedChapterId,
    required this.onChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: chapters.length,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemBuilder: (context, index) {
        final ch = chapters[index];
        final isSelected = ch.id == selectedChapterId;
        return Tooltip(
          message: ch.title,
          preferBelow: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Material(
              color: isSelected
                  ? theme.colorScheme.primary.withOpacity(0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => onChapterSelected(ch.id),
                child: SizedBox(
                  height: 44,
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExpandedChapterList extends StatelessWidget {
  final List<ManuscriptChapter> chapters;
  final String? selectedChapterId;
  final void Function(String) onChapterSelected;
  final void Function(String, String) onChapterDeleted;
  final void Function(int, int) onReorder;

  const _ExpandedChapterList({
    required this.chapters,
    required this.selectedChapterId,
    required this.onChapterSelected,
    required this.onChapterDeleted,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ReorderableListView.builder(
      itemCount: chapters.length,
      padding: const EdgeInsets.only(bottom: 16),
      onReorder: onReorder,
      proxyDecorator: (child, index, animation) => Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.surface,
        child: child,
      ),
      itemBuilder: (context, index) {
        final ch = chapters[index];
        final isSelected = ch.id == selectedChapterId;
        final wordCount = ch.content
            .split(RegExp(r'\s+'))
            .where((w) => w.isNotEmpty)
            .length;

        return Padding(
          key: ValueKey(ch.id),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Material(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => onChapterSelected(ch.id),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    // Chapter number
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.18)
                          : theme.colorScheme.surfaceContainerHighest,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Title + word count
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ch.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$wordCount words',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Delete + drag handle
                    IconButton(
                      icon: Icon(Icons.delete_outline, size: 16,
                          color: theme.colorScheme.error.withOpacity(0.6)),
                      onPressed: () => onChapterDeleted(ch.id, ch.title),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                    Icon(Icons.drag_handle, size: 14,
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
```

**Step 2: Verify**

Run: `dart analyze lib/presentation/features/manuscript/widget/chapter_sidebar.dart`

Expected: No errors.

**Step 3: Commit**

```bash
git add lib/presentation/features/manuscript/widget/chapter_sidebar.dart
git commit -m "feat: add collapsible chapter sidebar with rich cards"
```

---

## Task 3: Integrate sidebar into manuscript screen

**Objective:** Replace the hardcoded 200px sidebar in `_buildDesktopLayout` with the new `ChapterSidebar` widget. Wire it up to the WritingPreferences provider.

**Files:**
- Modify: `lib/presentation/features/manuscript/screen/manuscript_screen.dart:388-596`

**Step 1: Replace sidebar in _buildDesktopLayout**

In `manuscript_screen.dart`, replace these lines:

```dart
// REMOVE lines 445-515 (the entire "Chapter list sidebar" SizedBox block)
// REPLACE with:
ChapterSidebar(
  chapters: state.chapters,
  selectedChapterId: state.selectedChapterId,
  onChapterSelected: (id) {
    _saveCurrentChapter();
    _selectChapter(id);
  },
  onChapterDeleted: _deleteChapter,
  onReorder: (oldIndex, newIndex) {
    ref.read(manuscriptNotifierProvider.notifier).reorderChapters(oldIndex, newIndex);
  },
),
// Remove the divider Container(width: 1, …) at line 517 — the sidebar now handles its own border
```

**Step 2: Wrap Editor in distraction-free logic**

Add a `Consumer` widget around the Expanded editor area (lines 519-577) to read `writingPreferencesProvider.distractionFree` and conditionally hide title/toolbar when in distraction-free mode.

**Step 3: Verify**

Run: `dart analyze lib/presentation/features/manuscript/screen/manuscript_screen.dart`

Expected: No errors.

**Step 4: Commit**

```bash
git add lib/presentation/features/manuscript/screen/manuscript_screen.dart
git commit -m "refactor: integrate ChapterSidebar into manuscript desktop layout"
```

---

## Task 4: Add distraction-free mode

**Objective:** When activated, the AppBar fades out, the sidebar collapses, and the editor centers with a comfortable max-width (~700px) like a book page. Hovering near the top reveals the toolbar.

**Files:**
- Create: `lib/presentation/features/manuscript/widget/distraction_free_shell.dart`
- Modify: `lib/presentation/features/manuscript/screen/manuscript_screen.dart`

**Step 1: Add distraction-free toggle button to AppBar**

Add to the AppBar actions in `_buildDesktopLayout`:

```dart
IconButton(
  icon: Icon(
    prefs.distractionFree ? Icons.fullscreen_exit : Icons.fullscreen,
    color: theme.colorScheme.onSurfaceVariant,
  ),
  tooltip: prefs.distractionFree ? 'Exit Focus Mode' : 'Focus Mode',
  onPressed: () {
    ref.read(writingPreferencesProvider.notifier).update(
      (p) => p.copyWith(distractionFree: !p.distractionFree),
    );
  },
),
```

**Step 2: Conditionally show AppBar**

```dart
appBar: prefs.distractionFree ? null : AppBar(/* existing */),
```

**Step 3: Center editor with max-width in distraction-free mode**

```dart
// In the editor Expanded area:
child: prefs.distractionFree
    ? Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: /* existing editor content */,
        ),
      )
    : /* existing editor content */,
```

**Step 4: Verify**

Run: `dart analyze lib/presentation/features/manuscript/`

Expected: No errors.

**Step 5: Commit**

```bash
git add lib/presentation/features/manuscript/
git commit -m "feat: add distraction-free writing mode"
```

---

## Task 5: Add word count goal & writing stats bar

**Objective:** Show a thin progress bar under the chapter title indicating progress toward a configurable word count goal. Add reading time estimate and last-edited timestamp.

**Files:**
- Create: `lib/presentation/features/manuscript/widget/writing_stats_bar.dart`

**Step 1: Create WritingStatsBar widget**

```dart
// File: lib/presentation/features/manuscript/widget/writing_stats_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fictionist/presentation/features/manuscript/provider/writing_preferences_provider.dart';

class WritingStatsBar extends ConsumerWidget {
  final int wordCount;
  final int charCount;
  final DateTime? lastEdited;

  const WritingStatsBar({
    super.key,
    required this.wordCount,
    required this.charCount,
    this.lastEdited,
  });

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(writingPreferencesProvider);
    final theme = Theme.of(context);
    final hasGoal = prefs.wordCountGoal > 0;
    final progress = hasGoal ? (wordCount / prefs.wordCountGoal).clamp(0.0, 1.0) : 0.0;
    final readingTime = (wordCount / 200).ceil(); // 200 wpm

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        if (hasGoal) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 3,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(
                progress >= 1.0
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
        // Stats row
        Row(
          children: [
            _StatChip(label: '$wordCount words', icon: Icons.text_fields),
            const SizedBox(width: 12),
            _StatChip(label: '$charCount chars', icon: Icons.abc),
            const SizedBox(width: 12),
            _StatChip(label: '${readingTime}m read', icon: Icons.timer_outlined),
            if (lastEdited != null) ...[
              const Spacer(),
              Text(
                'Edited ${_formatTime(lastEdited!)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _StatChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
          fontSize: 11,
        )),
      ],
    );
  }
}
```

**Step 2: Add stats bar to editor layout**

Insert `WritingStatsBar` between the title TextField and the QuillEditor in the desktop editor Column. Provide word count from `_currentContent`.

**Step 3: Verify**

Run: `dart analyze lib/presentation/features/manuscript/widget/writing_stats_bar.dart`

Expected: No errors.

**Step 4: Commit**

```bash
git add lib/presentation/features/manuscript/widget/writing_stats_bar.dart
git add lib/presentation/features/manuscript/screen/manuscript_screen.dart
git commit -m "feat: add word count goal, reading time, and stats bar"
```

---

## Task 6: Polish typography & editor feel

**Objective:** Make the editor feel like a proper writing app — comfortable line height (1.6), wider padding (40px horizontal on desktop), serif font hint, and a warm paper-like background option.

**Files:**
- Modify: `lib/presentation/features/manuscript/widget/quill_editor_widget.dart`
- Modify: `lib/presentation/features/manuscript/screen/manuscript_screen.dart`

**Step 1: Update QuillEditor config**

In `QuillEditorWidget`, update the `QuillEditorConfig`:

```dart
config: QuillEditorConfig(
  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
  placeholder: 'Start writing your chapter...',
  scrollable: true,
  autoFocus: false,
),
```

**Step 2: Add custom scroll behavior**

Wrap `QuillEditor.basic` in a `Theme` override to set the scrollbar style:

```dart
Theme(
  data: theme.copyWith(
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(
        theme.colorScheme.onSurfaceVariant.withOpacity(0.2),
      ),
      thickness: WidgetStateProperty.all(6),
      radius: const Radius.circular(3),
    ),
  ),
  child: QuillEditor.basic(…),
)
```

**Step 3: Add editor background tint**

Wrap the editor Expanded area in a `Container` with a subtle warm tint for the "paper" feel:

```dart
Container(
  color: theme.brightness == Brightness.dark
      ? theme.colorScheme.surface
      : const Color(0xFFFAF9F6), // warm paper
  child: /* QuillEditor */,
),
```

**Step 4: Add font size adjustment**

Read `writingPreferencesProvider.editorFontSize` and pass it to the QuillEditor:

```dart
// In QuillEditorConfig
customStyles: DefaultStyles(
  // Quill doesn't directly support fontSize config easily;
  // Instead, wrap QuillEditor in a DefaultTextStyle with the font size
),
```

Alternative: wrap the QuillEditor in `DefaultTextStyle.merge` with the preferred fontSize.

**Step 5: Verify**

Run: `dart analyze lib/presentation/features/manuscript/`

Test manually: Check that padding, line height, and warm background feel right.

**Step 6: Commit**

```bash
git add lib/presentation/features/manuscript/
git commit -m "style: polish manuscript editor typography and spacing"
```

---

## Task 7: Improve mobile experience

**Objective:** Replace the clunky "push to new screen" mobile flow with a bottom sheet chapter picker and inline editor switcher. On mobile, the chapter list lives in a draggable bottom sheet; the editor takes the full screen.

**Files:**
- Modify: `lib/presentation/features/manuscript/screen/manuscript_screen.dart` (`_buildMobileChapterList` method)

**Step 1: Rewrite _buildMobileChapterList**

Instead of navigating to `ManuscriptEditorScreen` on tap, embed the editor directly:

```dart
Widget _buildMobileLayout(BuildContext context, ManuscriptState state) {
  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    appBar: AppBar(
      // ...existing appbar...
      actions: [
        // Chapter switcher button
        IconButton(
          icon: const Icon(Icons.list_alt),
          tooltip: 'Chapters',
          onPressed: () => _showChapterSheet(context),
        ),
        // ...compile button, etc...
      ],
    ),
    body: _editingChapterId != null
        ? _buildEditorArea(context)  // Full-screen editor for mobile
        : _buildChapterSelectorPrompt(context),
  );
}
```

**Step 2: Create _showChapterSheet**

```dart
void _showChapterSheet(BuildContext context) {
  final state = ref.read(manuscriptNotifierProvider);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (ctx, scrollController) => ListView.builder(
        controller: scrollController,
        itemCount: state.chapters.length + 1,
        itemBuilder: (ctx, index) {
          if (index == 0) {
            return ListTile(
              leading: const Icon(Icons.add),
              title: const Text('New Chapter'),
              onTap: () {
                Navigator.pop(ctx);
                _createChapter();
              },
            );
          }
          final ch = state.chapters[index - 1];
          return ListTile(
            title: Text(ch.title),
            subtitle: Text('${ch.content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length} words'),
            trailing: ch.id == _editingChapterId ? const Icon(Icons.check, color: Colors.green) : null,
            onTap: () {
              _saveCurrentChapter();
              _selectChapter(ch.id);
              Navigator.pop(ctx);
            },
          );
        },
      ),
    ),
  );
}
```

**Step 3: Extract _buildEditorArea helper**

Extract the editor Column (title + stats + quill editor) into a reusable `_buildEditorArea` method that both desktop and mobile layouts can use.

**Step 4: Verify**

Run: `dart analyze lib/presentation/features/manuscript/`

Test manually on a small screen width.

**Step 5: Commit**

```bash
git add lib/presentation/features/manuscript/screen/manuscript_screen.dart
git commit -m "feat: improve mobile manuscript UX with bottom sheet chapter picker"
```

---

## Task 8: Write UI tests

**Objective:** Add widget tests for the new manuscript components to prevent regressions.

**Files:**
- Modify: `test/widget/manuscript_screen_test.dart`
- Create: `test/widget/chapter_sidebar_test.dart`

**Step 1: Write sidebar test**

```dart
// File: test/widget/chapter_sidebar_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fictionist/presentation/features/manuscript/widget/chapter_sidebar.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';

void main() {
  final testChapters = [
    ManuscriptChapter(id: '1', title: 'Chapter One', content: 'hello world', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    ManuscriptChapter(id: '2', title: 'Chapter Two', content: 'foo bar baz qux', createdAt: DateTime.now(), updatedAt: DateTime.now()),
  ];

  testWidgets('renders chapter list with titles', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ChapterSidebar(
              chapters: testChapters,
              selectedChapterId: '1',
              onChapterSelected: (_) {},
              onChapterDeleted: (_, __) {},
              onReorder: (_, __) {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Chapter One'), findsOneWidget);
    expect(find.text('Chapter Two'), findsOneWidget);
    expect(find.text('2 words'), findsOneWidget); // "hello world"
    expect(find.text('4 words'), findsOneWidget); // "foo bar baz qux"
  });

  testWidgets('collapses to icon mode', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ChapterSidebar(
              chapters: testChapters,
              selectedChapterId: null,
              onChapterSelected: (_) {},
              onChapterDeleted: (_, __) {},
              onReorder: (_, __) {},
            ),
          ),
        ),
      ),
    );

    // Tap collapse button
    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();

    // Should show numbered icons, not titles
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Chapter One'), findsNothing);
  });
}
```

**Step 2: Run test**

```bash
flutter test test/widget/chapter_sidebar_test.dart
```

Expected: 2 tests pass.

**Step 3: Update existing manuscript screen tests**

Review `test/widget/manuscript_screen_test.dart` and update any assertions that reference the old sidebar structure (e.g., old `ListTile` patterns).

**Step 4: Commit**

```bash
git add test/widget/chapter_sidebar_test.dart test/widget/manuscript_screen_test.dart
git commit -m "test: add sidebar collapse test, update manuscript screen tests"
```

---

## Files Changed Summary

| File | Action | Lines |
|---|---|---|
| `lib/presentation/features/manuscript/provider/writing_preferences_provider.dart` | Create | ~40 |
| `lib/presentation/features/manuscript/widget/chapter_sidebar.dart` | Create | ~220 |
| `lib/presentation/features/manuscript/widget/writing_stats_bar.dart` | Create | ~120 |
| `lib/presentation/features/manuscript/screen/manuscript_screen.dart` | Modify | ~100 changed |
| `lib/presentation/features/manuscript/widget/quill_editor_widget.dart` | Modify | ~20 changed |
| `test/widget/chapter_sidebar_test.dart` | Create | ~80 |
| `test/widget/manuscript_screen_test.dart` | Modify | ~30 changed |

**Total: ~610 lines added, ~150 modified. Zero domain/data changes.**

---

## Verification Checklist

- [ ] Sidebar collapses/expands smoothly with animated transition
- [ ] Collapsed sidebar shows numbered icons, tooltips show chapter names
- [ ] Expanded sidebar shows title + word count + delete button
- [ ] Drag-to-reorder still works in expanded sidebar
- [ ] Distraction-free mode hides AppBar, collapses sidebar, centers editor
- [ ] Word count progress bar fills toward goal
- [ ] Stats bar shows word count, char count, reading time, last edited
- [ ] Mobile bottom sheet chapter picker opens/closes properly
- [ ] Create new chapter from mobile bottom sheet works
- [ ] Editor typography is comfortable (40px padding, proper line height)
- [ ] Existing compile/export and wiki-link features still work
- [ ] All widget tests pass

---

## Risks & Tradeoffs

| Risk | Mitigation |
|---|---|
| `flutter_quill` doesn't support custom font size easily | Wrap in `DefaultTextStyle.merge` as workaround |
| Chapter reorder in mobile bottom sheet | Keep bottom sheet read-only; use desktop layout for reordering |
| Performance with many chapters (100+) | List is already lazy-loaded; no additional concern |
| `WritingPreferences` state reset on app restart | Acceptable — these are session-only preferences. Future: persist via SharedPreferences |
