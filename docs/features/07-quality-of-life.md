# 07 — Quality of Life

> Polish that makes daily use pleasant. These features aren't core to the data model but make the difference between an app you tolerate and one you enjoy using daily.

---

## Functional Requirements

### A. Quick-Capture Inbox (MVP)

| ID | Requirement |
|---|---|
| FR-QL-01 | A floating action button (or swipe gesture) available **globally** to open a quick-capture form. |
| FR-QL-02 | Quick-capture form is minimal: just a text field and a save button. No type selection, no categories. |
| FR-QL-03 | Captured ideas are saved to the `QuickCapture` table with timestamp. |
| FR-QL-04 | Inbox screen lists all unprocessed quick-captures, sorted by most recent first. |
| FR-QL-05 | User can "process" a quick-capture by: **(a)** converting it to a new entity (pre-fills the description), **(b)** linking it to an existing entity (appends to description or adds as a note), or **(c)** dismissing/deleting it. |
| FR-QL-06 | Processed quick-captures are hidden from the inbox (`is_processed = true`). |
| FR-QL-07 | Inbox badge count on the dashboard shows unprocessed capture count. |

### B. Stats Dashboard (MVP)

| ID | Requirement |
|---|---|
| FR-QL-08 | Dashboard shows: total entity count, entity count per type (with icons), total relationship count, orphan count, timeline entry count, unprocessed quick-capture count. |
| FR-QL-09 | Stats are computed **on-demand** — not cached. Queries should be fast enough with proper indexing. |
| FR-QL-10 | Visual: use cards or tiles with counts and mini-icons. Not a text list. |
| FR-QL-11 | Tapping a stat **navigates** to the relevant list (e.g., tap Character count → Character list). |

### C. Dark Mode (MVP)

| ID | Requirement |
|---|---|
| FR-QL-12 | Dark mode is the **default** theme. |
| FR-QL-13 | Light mode is available as an alternative. |
| FR-QL-14 | Theme selection persisted in `SharedPreferences`. |
| FR-QL-15 | Theme uses **Material 3** (Material You) with a curated color scheme. |

### D. Random Name Generator (V2+)

| ID | Requirement |
|---|---|
| FR-QL-16 | Generates names based on **phoneme patterns** configurable per Race/Culture entity. |
| FR-QL-17 | User can define name patterns for each Race/Culture (e.g., Elvish: consonant clusters `th`, `nd`, `l`; syllable patterns like `CV-CVC`). |
| FR-QL-18 | Generator accessible from entity creation screen for Character names. |
| FR-QL-19 | Generated names can be saved directly to a new Character entity. |

### E. Data Export & Backup (MVP)

| ID | Requirement |
|---|---|
| FR-QL-20 | "Export All Data" button in Settings. |
| FR-QL-21 | Exports entire database as a single structured **JSON file**. |
| FR-QL-22 | Export includes: format version, export timestamp, all entities (including soft-deleted), all relationships, all tags, all timeline entries, all templates, all quick-captures. |
| FR-QL-23 | File is saved to device Downloads folder or user-selected location (via `file_picker` or `share_plus`). |
| FR-QL-24 | **JSON import (V1.x):** read exported JSON, create/update entities. Handle merge conflicts — skip duplicates by ID, or overwrite (user chooses). |

### F. Onboarding (MVP)

| ID | Requirement |
|---|---|
| FR-QL-25 | First-launch onboarding: 3–4 screens explaining core concepts (entities, relationships, quick-capture). |
| FR-QL-26 | Option to start with a **sample world** — pre-populated entities and relationships demonstrating the app's capabilities. |
| FR-QL-27 | Onboarding can be re-accessed from Settings. |

---

## Data Model

### QuickCapture Table

| Column | Type | Notes |
|---|---|---|
| `id` | `TEXT (PK)` | UUID |
| `raw_text` | `TEXT` | The captured idea |
| `created_at` | `INTEGER` | Unix epoch ms |
| `is_processed` | `INTEGER` | Boolean (0/1). Default `0`. |

```sql
CREATE TABLE quick_captures (
  id TEXT PRIMARY KEY NOT NULL,
  raw_text TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  is_processed INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_quick_captures_unprocessed
  ON quick_captures(is_processed, created_at DESC)
  WHERE is_processed = 0;
```

### Theme Preference

Stored in `SharedPreferences`:

```dart
// Key: 'theme_mode'
// Values: 'dark' (default), 'light', 'system'
```

---

## Color Palette — Fantasy Manuscript Dark Theme

The default dark theme evokes a fantasy manuscript aesthetic — deep blue-grays with gold accents.

| Role | Hex | Swatch |
|---|---|---|
| Background | `#0F1923` | Near-black navy |
| Surface | `#1A2634` | Dark blue-gray |
| Surface Variant | `#243040` | Slightly lighter |
| Primary (gold) | `#D4A44C` | Warm gold |
| Primary Container | `#3D2E14` | Muted gold bg |
| Secondary (steel) | `#6B8FA3` | Steel blue |
| Secondary Container | `#1E3340` | Muted steel bg |
| Tertiary | `#A38B6B` | Parchment tan |
| Error | `#CF6679` | Material error pink |
| On Background | `#E8E8E8` | Off-white text |
| On Surface | `#D0D0D0` | Slightly muted text |
| Outline | `#3A4A5A` | Subtle borders |

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      surface: Color(0xFF0F1923),
      surfaceContainerHighest: Color(0xFF1A2634),
      primary: Color(0xFFD4A44C),
      primaryContainer: Color(0xFF3D2E14),
      secondary: Color(0xFF6B8FA3),
      secondaryContainer: Color(0xFF1E3340),
      tertiary: Color(0xFFA38B6B),
      error: Color(0xFFCF6679),
      onSurface: Color(0xFFE8E8E8),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F1923),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A2634),
      foregroundColor: Color(0xFFE8E8E8),
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF1A2634),
      elevation: 2,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFD4A44C),
      foregroundColor: Color(0xFF0F1923),
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFD4A44C),
      brightness: Brightness.light,
    ),
  );
}
```

---

## Implementation Notes

### Quick-Capture

- The FAB should use `Hero` animation or `showModalBottomSheet` for instant feel.
- No loading state. Write to DB and dismiss. Fire-and-forget from the user's perspective.
- The inbox processes captures asynchronously — no rush.

```
User flow:
  Tap FAB → BottomSheet opens → Type idea → Tap Save → Sheet dismisses → Done
  
Processing flow (later):
  Open Inbox → Tap capture → Choose action:
    → "Create Entity" → Opens entity creation form with description pre-filled
    → "Link to Entity" → Opens entity picker → Appends text to chosen entity
    → "Dismiss" → Marks as processed
```

### Stats Dashboard Queries

All stats are single aggregate queries. With proper indexes, each runs in <10ms:

```sql
-- Total entities
SELECT COUNT(*) FROM entities WHERE deleted_at IS NULL;

-- Per-type counts
SELECT type, COUNT(*) FROM entities WHERE deleted_at IS NULL GROUP BY type;

-- Orphan count
SELECT COUNT(*) FROM entities e
WHERE e.deleted_at IS NULL
AND NOT EXISTS (
  SELECT 1 FROM relationships r
  WHERE r.source_entity_id = e.id OR r.target_entity_id = e.id
);

-- Unprocessed captures
SELECT COUNT(*) FROM quick_captures WHERE is_processed = 0;
```

### Export Format

```json
{
  "format_version": 1,
  "exported_at": "2025-01-15T10:30:00Z",
  "app_version": "1.0.0",
  "data": {
    "entities": [ ... ],
    "relationships": [ ... ],
    "tags": [ ... ],
    "entity_tags": [ ... ],
    "timeline_entries": [ ... ],
    "templates": [ ... ],
    "quick_captures": [ ... ],
    "entity_versions": [ ... ]
  }
}
```

- Use `dart:convert` with `JsonEncoder.withIndent` for human-readable output.
- For large exports, use `StreamedJsonWriter` or write chunks to avoid holding the entire JSON string in memory.

### Onboarding

- Use `introduction_screen` or `smooth_page_indicator` packages.
- Store `has_completed_onboarding` in `SharedPreferences`.
- Sample world: ship a `sample_world.json` in assets, import using the same import logic as FR-QL-24.

---

## Edge Cases

| Scenario | Handling |
|---|---|
| Quick-capture with very long text | Allow unlimited length in DB (`TEXT` has no practical limit in SQLite). UI should scroll the text field. |
| Export of very large database (5,000+ entities) | May take a few seconds. Show a **progress indicator** (indeterminate spinner is fine — calculating precise progress adds complexity for little value). Run export in an isolate. |
| Name generator with empty phoneme patterns | Show a helpful message: _"Define name patterns on a Race/Culture entity first."_ Don't crash or generate empty strings. |
| Theme change while on a screen with custom colors | All screens must use `Theme.of(context)` — no hardcoded colors. Theme switch is instant via `MaterialApp`'s `themeMode`. |
| Import with conflicting IDs | Present three options: **Skip** (keep existing), **Overwrite** (replace with imported), **Duplicate** (assign new IDs to imported entities). Default to Skip. |
| First launch — no entities, empty dashboard | Dashboard shows a welcome card with a CTA: _"Create your first entity"_ or _"Start with a sample world."_ Stats section shows zeros gracefully. |
| Export while entities are being edited | Export reads committed DB state. In-progress edits are not included. This is correct behavior. |

---

## Cross-References

- Stats dashboard consumes orphan count from [05-search-navigation.md](file:///D:/Fictionist/docs/features/05-search-navigation.md) (FR-SN-15) and gap analysis from [06-consistency-helpers.md](file:///D:/Fictionist/docs/features/06-consistency-helpers.md) (FR-CH-06, FR-CH-07).
- Entity data model: [02-entity-system.md](file:///D:/Fictionist/docs/features/02-entity-system.md).
- Template system (referenced in export): [02-entity-system.md](file:///D:/Fictionist/docs/features/02-entity-system.md).
- Timeline entries (referenced in export): [04-timeline.md](file:///D:/Fictionist/docs/features/04-timeline.md).
