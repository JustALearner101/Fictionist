# Fictionist Manuscript — Tier 1 Professional Writing Tools

> **For Hermes:** Use `delegate_task` to implement this plan task-by-task.

**Goal:** Elevate the Fictionist manuscript editor from "functional" to "industry-standard writing tool" by adding typewriter scrolling, syntax highlighting, and chapter synopsis — three low-effort, high-impact features inspired by JotterPad, iA Writer, and Ulysses.

**Architecture:** Presentation-layer only. Zero domain/data changes. All features build on the existing `writingPreferencesProvider`, `QuillEditorWidget`, and `ChapterSidebar`.

**Reference:** JotterPad's editor uses: centered typewriter cursor, subtle Markdown syntax highlighting, clean sans-serif typography, minimal toolbar, word count in footer.

---

## Current State vs Target

| Area | Current | Target (After Tier 1) |
|---|---|---|
| Scrolling | Standard top-aligned scroll | Typewriter mode — cursor stays vertically centered |
| Markdown | Raw plain text | Syntax-colored (bold=blue, italic=green, headers=orange, links=purple) |
| Chapter info | Title + word count only | Title + synopsis preview + word count in sidebar |
| Word count | Footer text | Animated counter in status bar |
| Toolbar | Full Quill toolbar | Minimal formatting bar (bold, italic, header, quote only) |

---

## Task 1: Typewriter Scrolling Mode

**Objective:** Add a toggleable typewriter scrolling mode where the cursor stays vertically centered in the editor viewport — the hallmark of professional writing apps.

**Files:**
- Create: `lib/presentation/features/manuscript/widget/typewriter_editor.dart`
- Modify: `lib/presentation/features/manuscript/screen/manuscript_screen.dart`
- Modify: `lib/presentation/features/manuscript/provider/writing_preferences_provider.dart`

### Step 1: Add typewriter preference

```dart
// Add to WritingPreferences class:
final bool typewriterMode;

// Default: true (on by default for writer feel)
this.typewriterMode = true,

// Add to copyWith:
bool? typewriterMode,

// Add toggle in provider
```

### Step 2: Create TypewriterEditor wrapper

Create `lib/presentation/features/manuscript/widget/typewriter_editor.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class TypewriterEditor extends StatelessWidget {
  final QuillController controller;
  final bool enabled;
  final QuillEditorConfig config;

  const TypewriterEditor({
    super.key,
    required this.controller,
    required this.enabled,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return QuillEditor.basic(controller: controller, config: config);
    }

    // Typewriter mode: add top padding = half viewport height
    // so the cursor naturally sits in the center
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              children: [
                // Top padding: pushes cursor to center
                SizedBox(height: constraints.maxHeight * 0.4),
                // Actual editor content
                QuillEditor.basic(
                  controller: controller,
                  config: config.copyWith(
                    padding: config.padding,
                    // Disable internal scroll — parent handles it
                    scrollable: false,
                  ),
                ),
                // Bottom padding: allows scrolling past end
                SizedBox(height: constraints.maxHeight * 0.6),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

**Note:** `flutter_quill` may not expose `copyWith` on `QuillEditorConfig`. Fallback: build config from scratch. If `scrollable: false` causes issues, use a `NotificationListener<ScrollNotification>` to center the viewport on cursor changes.

### Step 3: Integrate into _buildEditorArea

Replace the `QuillEditorWidget` call in `_buildEditorArea` with the new `TypewriterEditor` when typewriter mode is on.

Read `writingPreferencesProvider.typewriterMode` and pass to `TypewriterEditor(enabled: prefs.typewriterMode)`.

### Step 4: Add toggle to AppBar

```dart
IconButton(
  icon: Icon(
    prefs.typewriterMode ? Icons.format_align_center : Icons.format_align_left,
    color: theme.colorScheme.onSurfaceVariant,
  ),
  tooltip: prefs.typewriterMode ? 'Typewriter Mode: ON' : 'Typewriter Mode: OFF',
  onPressed: () {
    ref.read(writingPreferencesProvider.notifier).update(
      (p) => p.copyWith(typewriterMode: !p.typewriterMode),
    );
  },
),
```

### Step 5: Verification

Run: `dart analyze lib/presentation/features/manuscript/`

Manual test: Open a chapter, type text, verify cursor stays centered vertically.

### Step 6: Commit

```bash
git add lib/presentation/features/manuscript/
git commit -m "feat: add typewriter scrolling mode — centered cursor"
```

---

## Task 2: Markdown Syntax Highlighting in Editor

**Objective:** Give the Quill editor syntax-aware coloring — bold markers (**) in subtle blue, italic (*) in subtle green, headers (#) in subtle orange, wiki-links ([[ ]]) in purple — exactly like JotterPad and iA Writer.

**Files:**
- Create: `lib/presentation/features/manuscript/widget/syntax_highlighter.dart`
- Modify: `lib/presentation/features/manuscript/screen/manuscript_screen.dart`

### Step 1: Create SyntaxHighlighter

```dart
// File: lib/presentation/features/manuscript/widget/syntax_highlighter.dart
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Applies syntax-aware text coloring to Quill document.
/// Called on every content change to re-color Markdown syntax.
class SyntaxHighlighter {
  static final _patterns = [
    // Bold: **text** or __text__
    _Pattern(
      regex: RegExp(r'\*\*(.+?)\*\*|__(.+?)__'),
      color: const Color(0xFF4A90D9), // subtle blue
    ),
    // Italic: *text* or _text_ (but not **)
    _Pattern(
      regex: RegExp(r'(?<!\*)\*(?!\*)(.+?)(?<!\*)\*(?!\*)|(?<!_)_(?!_)(.+?)(?<!_)_(?!_)'),
      color: const Color(0xFF50A85A), // subtle green
    ),
    // Headers: # ## ### at line start
    _Pattern(
      regex: RegExp(r'^(#{1,6})\s.*$', multiLine: true),
      color: const Color(0xFFE8853B), // warm orange
      matchGroup: 1, // only color the # marks
    ),
    // Wiki links: [[Entity]]
    _Pattern(
      regex: RegExp(r'\[\[(.+?)\]\]'),
      color: const Color(0xFF9B59B6), // purple
    ),
    // Inline code: `code`
    _Pattern(
      regex: RegExp(r'`(.+?)`'),
      color: const Color(0xFFE74C3C), // red
    ),
  ];

  /// Apply syntax highlighting to a plain text string.
  /// Returns a list of TextSpan with colored segments.
  static List<TextSpan> highlight(String text, {TextStyle? baseStyle}) {
    // Build colored segments by finding all pattern matches,
    // sorting by position, and filling gaps with base style.
    // (Full implementation ~60 lines — see plan for details)
    return [TextSpan(text: text, style: baseStyle)];
  }
}

class _Pattern {
  final RegExp regex;
  final Color color;
  final int? matchGroup;
  const _Pattern({required this.regex, required this.color, this.matchGroup});
}
```

### Step 2: Alternative — Quill Custom Styles

If full regex highlighting is too complex for Quill's document model, a simpler approach: configure `QuillEditorConfig` with custom styles that make the editor *feel* more writerly without real-time regex parsing:

```dart
config: QuillEditorConfig(
  customStyles: DefaultStyles(
    h1: DefaultTextBlockStyle(
      Theme.of(context).textTheme.headlineLarge!.copyWith(
        color: const Color(0xFFE8853B),
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
      const VerticalSpacing(24, 12),
      const VerticalSpacing(0, 0),
      null,
    ),
    bold: const TextStyle(
      color: Color(0xFF4A90D9),
      fontWeight: FontWeight.bold,
    ),
    italic: const TextStyle(
      color: Color(0xFF50A85A),
      fontStyle: FontStyle.italic,
    ),
    link: const TextStyle(
      color: Color(0xFF9B59B6),
      decoration: TextDecoration.underline,
    ),
  ),
),
```

This approach is **simpler and more reliable** — it colors actual formatted text rather than parsing raw Markdown. JotterPad uses WYSIWYG (you see bold as bold, not as `**`), so this is actually closer to the reference.

### Step 3: Apply to QuillEditorWidget

Update `QuillEditorWidget` to accept an optional `QuillEditorConfig` and merge syntax highlighting styles.

### Step 4: Verification

Run: `dart analyze lib/presentation/features/manuscript/`

Manual test: Type bold, italic, headers — verify they render with subtle colors instead of default black.

### Step 5: Commit

```bash
git add lib/presentation/features/manuscript/
git commit -m "feat: add syntax highlighting — colored bold/italic/headers/wiki-links"
```

---

## Task 3: Chapter Synopsis in Sidebar

**Objective:** Add a short synopsis/note field to each chapter, visible as a preview in the expanded sidebar — like Scrivener's chapter cards.

**Files:**
- Modify: `lib/domain/manuscript/manuscript_chapter.dart`
- Modify: `lib/data/database/tables/manuscript_chapter_table.dart`
- Modify: `lib/data/dao/manuscript_dao.dart`
- Modify: `lib/presentation/features/manuscript/widget/chapter_sidebar.dart`
- Modify: `lib/presentation/features/manuscript/screen/manuscript_screen.dart`

### Step 1: Add synopsis field to domain model

```dart
// In manuscript_chapter.dart, add:
String? synopsis,

// Default: null
@Default(null) String? synopsis,
```

### Step 2: Add synopsis column to DB table

```dart
// In manuscript_chapter_table.dart, add column:
TextColumn get synopsis => text().nullable()();
```

### Step 3: Update DAO queries

In `manuscript_dao.dart`, ensure the synopsis column is included in SELECT and INSERT/UPDATE queries.

### Step 4: Run code generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Step 5: Update ChapterSidebar cards

In `_ExpandedChapterList`, add a synopsis preview line under the word count:

```dart
if (ch.synopsis != null && ch.synopsis!.isNotEmpty)
  Text(
    ch.synopsis!,
    style: theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
      fontSize: 10,
    ),
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  ),
```

### Step 6: Add synopsis editor

In the editor area (`_buildEditorArea`), add a small TextField for synopsis below the chapter title:

```dart
TextField(
  controller: _synopsisController,
  style: theme.textTheme.bodySmall?.copyWith(
    color: theme.colorScheme.onSurfaceVariant,
    fontStyle: FontStyle.italic,
  ),
  decoration: InputDecoration(
    hintText: 'Add a brief synopsis...',
    hintStyle: theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
      fontStyle: FontStyle.italic,
    ),
    border: InputBorder.none,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 4),
  ),
  onChanged: (_) => _saveSynopsis(),
),
```

### Step 7: Wire synopsis save to provider

Add `updateChapterSynopsis(String id, String? synopsis)` to `ManuscriptNotifier`.

### Step 8: Verification

Run: `dart analyze lib/` (domain + data + presentation)

Manual test: Create chapter, add synopsis, verify it shows in sidebar and persists after restart.

### Step 9: Commit

```bash
git add lib/domain/ lib/data/ lib/presentation/
git commit -m "feat: add chapter synopsis field — sidebar preview + inline editor"
```

---

## Task 4: Minimal Toolbar

**Objective:** Replace the full QuillSimpleToolbar with a minimal writer-focused toolbar — only bold, italic, header levels, blockquote, and wiki-link insert. Like JotterPad's "less is more" philosophy.

**Files:**
- Modify: `lib/presentation/features/manuscript/widget/quill_editor_widget.dart`
- Create: `lib/presentation/features/manuscript/widget/minimal_toolbar.dart`

### Step 1: Create MinimalToolbar

```dart
// File: lib/presentation/features/manuscript/widget/minimal_toolbar.dart
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MinimalToolbar extends StatelessWidget {
  final QuillController controller;

  const MinimalToolbar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = (Attribute attribute) {
      return controller.getSelectionStyle().attributes.containsKey(attribute.key);
    };

    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 40),
          _ToolbarButton(
            icon: Icons.format_bold,
            tooltip: 'Bold',
            isActive: isActive(Attribute.bold),
            onPressed: () => _toggleAttribute(Attribute.bold),
          ),
          _ToolbarButton(
            icon: Icons.format_italic,
            tooltip: 'Italic',
            isActive: isActive(Attribute.italic),
            onPressed: () => _toggleAttribute(Attribute.italic),
          ),
          _ToolbarButton(
            icon: Icons.format_underlined,
            tooltip: 'Underline',
            isActive: isActive(Attribute.underline),
            onPressed: () => _toggleAttribute(Attribute.underline),
          ),
          const SizedBox(width: 8),
          // Header buttons
          for (final level in [1, 2, 3])
            _ToolbarButton(
              icon: level == 1 ? Icons.format_h1 : (level == 2 ? Icons.format_h2 : Icons.format_h3),
              tooltip: 'H$level',
              isActive: isActive(Attribute.header),
              onPressed: () => _toggleAttribute(Attribute.header),
            ),
          const SizedBox(width: 8),
          _ToolbarButton(
            icon: Icons.format_quote,
            tooltip: 'Quote',
            isActive: isActive(Attribute.blockQuote),
            onPressed: () => _toggleAttribute(Attribute.blockQuote),
          ),
          const Spacer(),
          _ToolbarButton(
            icon: Icons.link,
            tooltip: 'Insert Wiki Link [[ ]]',
            onPressed: () {
              // Insert [[ at cursor
              final index = controller.selection.baseOffset;
              controller.document.insert(index, '[[');
              controller.updateSelection(
                TextSelection.collapsed(offset: index + 2),
                ChangeSource.local,
              );
            },
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  void _toggleAttribute(Attribute attribute) {
    final style = controller.getSelectionStyle();
    final hasAttribute = style.attributes.containsKey(attribute.key);
    if (hasAttribute) {
      controller.formatSelection(Attribute.clone(attribute, null));
    } else {
      controller.formatSelection(attribute);
    }
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool isActive;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 36,
        height: 36,
        child: IconButton(
          icon: Icon(icon, size: 18),
          color: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
          onPressed: onPressed,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
```

### Step 2: Replace QuillSimpleToolbar

In `QuillEditorWidget`, replace `QuillSimpleToolbar` with `MinimalToolbar(controller: _controller)`.

### Step 3: Verification

Run: `dart analyze lib/presentation/features/manuscript/`

Manual test: Verify toolbar shows only bold/italic/underline/H1/H2/H3/quote/link buttons.

### Step 4: Commit

```bash
git add lib/presentation/features/manuscript/
git commit -m "feat: add minimal writer toolbar — bold, italic, headers, quote, wiki-link"
```

---

## Task 5: Wiring & Polish — Editor Status Bar

**Objective:** Add a thin status bar at the bottom of the editor showing: word count (animated), typewriter mode indicator, reading time, cursor position (line:col). Like JotterPad's footer.

**Files:**
- Create: `lib/presentation/features/manuscript/widget/editor_status_bar.dart`
- Modify: `lib/presentation/features/manuscript/screen/manuscript_screen.dart`

### Step 1: Create EditorStatusBar

```dart
// File: lib/presentation/features/manuscript/widget/editor_status_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fictionist/presentation/features/manuscript/provider/writing_preferences_provider.dart';

class EditorStatusBar extends ConsumerWidget {
  final int wordCount;
  final int charCount;
  final String? chapterTitle;

  const EditorStatusBar({
    super.key,
    required this.wordCount,
    required this.charCount,
    this.chapterTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(writingPreferencesProvider);
    final theme = Theme.of(context);
    final readingTime = (wordCount / 200).ceil();

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          // Chapter title (truncated)
          if (chapterTitle != null) ...[
            Text(
              chapterTitle!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 12),
            Container(
              width: 1, height: 12,
              color: theme.colorScheme.outline.withOpacity(0.15),
            ),
            const SizedBox(width: 12),
          ],
          // Word count
          Icon(Icons.text_fields, size: 10,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4)),
          const SizedBox(width: 4),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: wordCount),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, _) => Text(
              '$value words',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Reading time
          Icon(Icons.timer_outlined, size: 10,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4)),
          const SizedBox(width: 4),
          Text(
            '${readingTime}m read',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              fontSize: 10,
            ),
          ),
          const Spacer(),
          // Typewriter indicator
          if (prefs.typewriterMode)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.format_align_center, size: 10,
                    color: theme.colorScheme.primary.withOpacity(0.6)),
                const SizedBox(width: 4),
                Text(
                  'Typewriter',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary.withOpacity(0.6),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
```

### Step 2: Add to _buildEditorArea

Insert `EditorStatusBar` at the bottom of the editor Column, after the Quill editor area. Pass `wordCount`, `charCount`, and current chapter title.

### Step 3: Remove old word count footer

Remove the existing word count Row (the one showing "Words: X | Characters: Y") since the status bar replaces it.

### Step 4: Verification

Run: `dart analyze lib/presentation/features/manuscript/`

Manual test: Verify animated word count transitions, typewriter indicator shows when mode is on.

### Step 5: Commit

```bash
git add lib/presentation/features/manuscript/
git commit -m "feat: add editor status bar — animated word count, reading time, typewriter indicator"
```

---

## Files Changed Summary (Tier 1)

| File | Action | Type | Lines |
|---|---|---|---|
| `provider/writing_preferences_provider.dart` | Modify | Add typewriterMode field | +5 |
| `widget/typewriter_editor.dart` | Create | Presentation | ~70 |
| `widget/syntax_highlighter.dart` | Create | Presentation | ~80 |
| `widget/minimal_toolbar.dart` | Create | Presentation | ~120 |
| `widget/editor_status_bar.dart` | Create | Presentation | ~100 |
| `widget/quill_editor_widget.dart` | Modify | Minimal toolbar, syntax styles | ~30 chg |
| `screen/manuscript_screen.dart` | Modify | Wire new widgets | ~50 chg |
| `domain/manuscript/manuscript_chapter.dart` | Modify | Add synopsis field | +2 |
| `data/database/tables/manuscript_chapter_table.dart` | Modify | Add synopsis column | +1 |
| `data/dao/manuscript_dao.dart` | Modify | Include synopsis in queries | +5 |
| `widget/chapter_sidebar.dart` | Modify | Show synopsis preview | +8 |

**Total: ~470 lines added, ~85 modified. Light domain/data touch for synopsis field.**

---

## Result — What the User Sees After Tier 1

```
┌──────────────────────────────────────────────────────┐
│  ☰ Fictionist          📖 Chapters  [🌙] [⛶] [+]    │  ← AppBar
├────────┬─────────────────────────────────────────────┤
│ Chptr ▶│                                             │
│        │  Chapter 1: The Beginning                   │  ← Title
│  1 📝  │  A young hero discovers...  ← synopsis       │  ← Synopsis
│  2     │  ─────────────────────────────────────────── │
│  3     │  [B] [I] [U] | [H1] [H2] [H3] | [❝]  🔗  │  ← Minimal toolbar
│  +     │                                             │
│        │     The rain fell in sheets as Kael          │  ← Typewriter mode
│        │     stepped through the ancient gate.        │     (cursor centered)
│        │     **She knew** this was the moment.        │     (bold = blue)
│        │     *If only* she had listened to [[Elder]]  │     (italic = green,
│        │                                             │      link = purple)
│        │                                             │
│        │                                             │
│        │                                             │
│        │                                             │
├────────┴─────────────────────────────────────────────┤
│ Chapter 1     │  247 words  │  2m read  │ Typewriter  │  ← Status bar
└──────────────────────────────────────────────────────┘
```

---

## Verification Checklist

- [ ] Typewriter mode centers cursor vertically while typing
- [ ] Typewriter toggle in AppBar switches mode on/off
- [ ] Bold text renders in subtle blue, italic in subtle green
- [ ] Wiki-links render in purple with underline
- [ ] Headers render in warm orange
- [ ] Minimal toolbar has exactly 8 buttons (B, I, U, H1, H2, H3, Quote, Wiki-link)
- [ ] Toolbar buttons show active state when formatting is applied
- [ ] Chapter synopsis field saves and persists
- [ ] Synopsis preview shows in sidebar (max 2 lines)
- [ ] Editor status bar shows animated word count
- [ ] Reading time and typewriter indicator in status bar
- [ ] Old word count footer removed (replaced by status bar)
- [ ] Dart analyze passes with zero errors
- [ ] Existing features (distraction-free, sidebar collapse, compile) still work
