# 04 — Timeline

> **Status:** MVP | **Owner:** TBD | **Last updated:** 2026-07-05

## Overview

The timeline is a chronological backbone for the fictional world. It tracks events — both world-level and entity-specific — in a user-defined order using freeform date labels and era groupings. Fictionist does **not** assume a real-world calendar; dates are opaque strings that the user controls, and ordering is explicit via a `sort_order` integer.

Timeline entries are **not** the same as Event entities, though they can optionally link to one. A timeline entry is a lightweight chronological marker; an Event entity is a full worldbuilding record with relationships, descriptions, and metadata. The two are complementary.

---

## Functional Requirements

### Core CRUD

| ID | Requirement | MVP |
|----|-------------|-----|
| **FR-TL-01** | Users can create a **timeline entry** with: `title` (required), `description` (optional, rich text), `date_label` (freeform string, e.g., "Year 342, Third Moon"), `era_label` (freeform string, e.g., "Age of Ruin"), and `sort_order` (integer). | ✅ |
| **FR-TL-02** | Each timeline entry has an optional **entity foreign key** (`entity_id`). When null, the entry is a **world event**. When set, the entry appears on both the master timeline and the linked entity's timeline. | ✅ |
| **FR-TL-03** | The app provides a **master timeline** screen that shows all timeline entries across all entities, sorted by `sort_order`, grouped by `era_label`. | ✅ |
| **FR-TL-04** | Each entity detail screen includes a **per-entity timeline** tab/section showing only entries linked to that entity, sorted by `sort_order`. | ✅ |

### Era Grouping

| ID | Requirement | MVP |
|----|-------------|-----|
| **FR-TL-05** | Timeline entries are grouped by `era_label`. Each era renders as a **section header** with a **sticky header** that persists at the top of the scroll view as the user scrolls through entries within that era. | ✅ |
| **FR-TL-06** | Entries with a null or empty `era_label` are grouped under a default section labeled **"Undated"** at the bottom of the timeline. | ✅ |

### Ordering

| ID | Requirement | MVP |
|----|-------------|-----|
| **FR-TL-07** | Users can **drag-and-drop** to reorder timeline entries within and across eras. Reordering updates the `sort_order` values of affected entries. | ✅ |

### Filtering

| ID | Requirement | MVP |
|----|-------------|-----|
| **FR-TL-08** | The master timeline supports **filtering** by: era (dropdown of existing era labels), entity type (chip toggles), and specific entities (search picker, multi-select). Filters are composable (AND logic). | ✅ |

### Entity Linkage

| ID | Requirement | MVP |
|----|-------------|-----|
| **FR-TL-09** | Timeline entries can reference **participants** by leveraging the existing relationship system. If the timeline entry is linked to an Event entity, that Event's `participates_in` relationships are displayed as participant chips on the timeline entry card. | ✅ |

### Future Enhancements

| ID | Requirement | MVP |
|----|-------------|-----|
| **FR-TL-10** | **Custom calendar system** — Users define named months/seasons, year numbering, and era boundaries. `date_label` becomes structured data with computed sort order. | V2+ |
| **FR-TL-11** | **Visual timeline** — A horizontal or vertical graphical timeline with zoomable scale, era color bands, and entity swim lanes. | V2+ |

---

## Data Model

### `timeline_entries` Table

```sql
CREATE TABLE timeline_entries (
  id          TEXT PRIMARY KEY,       -- UUID v4
  title       TEXT NOT NULL,
  description TEXT,                   -- rich text / markdown
  date_label  TEXT,                   -- freeform, e.g. "3rd Era, Year 47"
  era_label   TEXT,                   -- grouping key, e.g. "The Sundering"
  sort_order  INTEGER NOT NULL,       -- global ordering
  entity_id   TEXT REFERENCES entities(id),  -- NULL = world event
  is_deleted  INTEGER NOT NULL DEFAULT 0,
  created_at  INTEGER NOT NULL,       -- Unix epoch ms
  updated_at  INTEGER NOT NULL
);

CREATE INDEX idx_timeline_sort ON timeline_entries(sort_order) WHERE is_deleted = 0;
CREATE INDEX idx_timeline_era ON timeline_entries(era_label) WHERE is_deleted = 0;
CREATE INDEX idx_timeline_entity ON timeline_entries(entity_id) WHERE is_deleted = 0;
```

### Drift Table Definition

```dart
class TimelineEntries extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 500)();
  TextColumn get description => text().nullable()();
  TextColumn get dateLabel => text().nullable()();
  TextColumn get eraLabel => text().nullable()();
  IntColumn get sortOrder => integer()();
  TextColumn get entityId => text().nullable().references(Entities, #id)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Sort Order Strategy

`sort_order` is a global integer that defines the total ordering of all timeline entries. Strategy:

- **New entries** default to `sort_order = max(sort_order) + 1000`. The 1000-gap allows insertions between entries without reindexing.
- **Drag-and-drop reorder** sets `sort_order` to the midpoint between the two adjacent entries. When the gap between two entries reaches 1, trigger a **reindex** that reassigns `sort_order` values in increments of 1000 across all entries.
- **Fractional-index alternative (V2+):** Replace integer sort with a string-based fractional index (e.g., `"a0"`, `"a0V"`) for unlimited insertions without reindexing. Libraries like `fractional_indexing` exist.

---

## UI/UX Considerations

### Master Timeline Screen

```
┌──────────────────────────────────┐
│  Timeline                  [⊞]  │
│  ┌────────────────────────────┐  │
│  │ Filter: [Era ▼] [Type ▼]  │  │
│  │         [+ Entity]         │  │
│  └────────────────────────────┘  │
│                                  │
│  ══ Age of Creation ══ (sticky)  │
│  ┌────────────────────────────┐  │
│  │ ● The First Awakening      │  │
│  │   Year 0, Day of Dawn      │  │
│  │   World Event              │  │
│  └────────────────────────────┘  │
│  ┌────────────────────────────┐  │
│  │ ● Founding of the Compact  │  │
│  │   Year 12                  │  │
│  │   🏰 Ironclad Compact      │  │
│  │   👤 Aldric, Maren, Kira   │  │
│  └────────────────────────────┘  │
│                                  │
│  ══ Age of Ruin ══ (sticky)      │
│  ┌────────────────────────────┐  │
│  │ ● The Betrayal at Aelnar   │  │
│  │   Year 342, Third Moon     │  │
│  │   👤 Eldric  ⚔️  Obsidian  │  │
│  └────────────────────────────┘  │
│                                  │
│  ══ Undated ══                   │
│  ┌────────────────────────────┐  │
│  │ ● Prophecy of the Three    │  │
│  │   (no date)                │  │
│  └────────────────────────────┘  │
│                          [+ FAB] │
└──────────────────────────────────┘
```

### Timeline Entry Card

Each card shows:
- **Title** (bold, primary text)
- **Date label** (secondary text, muted)
- **Entity badge** (icon + name if linked to an entity, or "World Event" pill)
- **Participant chips** (if linked to an Event entity with `participates_in` relationships)
- **Drag handle** (☰) on the left edge for reordering

### Add/Edit Entry Flow

1. Tap FAB → bottom sheet with fields: Title, Description, Date Label, Era Label.
2. **Era autocomplete:** As the user types in the Era Label field, suggest existing era labels from the database.
3. **Entity link:** Optional entity picker. Searching filters by entity name. The user can leave it null for a world event.
4. **Sort position:** By default, the new entry is appended to the end. The user can drag it into position after creation. Alternatively, if created from within an era section, insert at the end of that era's group.

### Per-Entity Timeline

- Accessed from the entity detail screen as a tab or collapsible section.
- Shows only entries where `entity_id` matches.
- Same card design as the master timeline, minus the entity badge (redundant).
- Includes a link to "View in Master Timeline" that scrolls the master timeline to the entry.

### Drag-and-Drop

- Use `ReorderableListView` or `flutter_reorderable_list`.
- Haptic feedback on grab.
- Visual indicator: lifted card casts a shadow, placeholder gap shown at drop position.
- Reordering across era boundaries is allowed — the entry's `era_label` is **not** auto-updated. The user must manually edit the era if they want it to match the new group. This prevents accidental era reassignment.

---

## Edge Cases

| Scenario | Behavior |
|---|---|
| Two entries with the same `sort_order` | Tie-break by `created_at` (older first). Trigger a background reindex to eliminate the tie. |
| User deletes the linked entity | Timeline entry remains but `entity_id` is set to null (becomes a world event). Show a one-time notice: "The linked entity was deleted. This entry is now a world event." |
| User restores a deleted entity that had timeline entries | Re-link timeline entries by restoring `entity_id` (stored in soft-delete state, not nulled). |
| Era label with leading/trailing whitespace | Trim on save. `" Age of Ruin "` → `"Age of Ruin"`. |
| User creates 1,000+ timeline entries | Virtualize the list with `ListView.builder`. Lazy-load entries by era section. |
| Drag entry from "Age of Ruin" to "Age of Creation" section | `sort_order` updates. `era_label` is **not** changed. User sees the entry in the new visual position but under the old era header until they edit it. Show a subtle prompt: "Update era to 'Age of Creation'?" |
| Empty era (all entries deleted or moved out) | Era header is hidden. If all entries in an era are filtered out, the header is still hidden. |
| Master timeline with filters active during reorder | Reordering operates on the filtered subset. `sort_order` values are recalculated relative to the full unfiltered list to maintain global consistency. |

---

## MVP vs. Later

| Scope | Features |
|---|---|
| **MVP** | FR-TL-01 through FR-TL-09. Full CRUD, freeform dates, era grouping with sticky headers, drag-and-drop reorder, filtering, entity linkage, master + per-entity timelines. |
| **V2+** | FR-TL-10 — Custom calendar system with structured dates and computed sort order. |
| **V2+** | FR-TL-11 — Visual timeline rendering (horizontal/vertical graphical view with zoom, era bands, swim lanes). |
| **V2+** | Bulk import of timeline entries from CSV/JSON. |
| **V2+** | Timeline comparison mode — overlay two entity timelines side by side. |
