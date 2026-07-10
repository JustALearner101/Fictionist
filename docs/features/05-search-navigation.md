# 05 — Search & Navigation

> Fast, frictionless navigation is critical for a knowledge-management app. Fictionist provides a quick-switcher for instant entity access, full-text search across all content, and orphan detection to surface worldbuilding gaps.

---

## Functional Requirements

### A. Quick-Switcher (MVP)

| ID | Requirement |
|---|---|
| FR-SN-01 | User can invoke a quick-switcher overlay from any screen (floating action button or persistent search icon in app bar). |
| FR-SN-02 | Quick-switcher performs **fuzzy search** on entity names as the user types. |
| FR-SN-03 | Results appear in real-time (debounced at ~300ms) showing entity name, type icon, and status. |
| FR-SN-04 | Selecting a result navigates directly to that entity's detail view. |
| FR-SN-05 | Quick-switcher shows **recent entities** when the search field is empty (last 10 viewed). |
| FR-SN-06 | Results are ranked by: **exact match → starts-with → contains → fuzzy match**. |

### B. Full-Text Search (MVP)

| ID | Requirement |
|---|---|
| FR-SN-07 | Full-text search indexes: entity names, descriptions, custom field text values, relationship descriptions, and timeline entry titles/descriptions. |
| FR-SN-08 | Search results show matching entities with **highlighted snippets** of the matching text. |
| FR-SN-09 | Results can be filtered by entity type, status, and tags. |
| FR-SN-10 | FTS is powered by **SQLite FTS5** (via Drift). |
| FR-SN-11 | Search index is maintained automatically on entity create/update/delete. |
| FR-SN-12 | **Performance target:** results in <300ms for databases with 5,000+ entities. |

### C. Orphan Detection (MVP)

| ID | Requirement |
|---|---|
| FR-SN-13 | "Orphan" view lists all entities with **zero relationships**. |
| FR-SN-14 | Orphan list is filterable by entity type. |
| FR-SN-15 | Orphan count is shown on the stats dashboard. |
| FR-SN-16 | Tapping an orphan entity navigates to its detail view (encouraging the user to add relationships). |

### D. Navigation Structure

| ID | Requirement |
|---|---|
| FR-SN-17 | Bottom navigation bar with: **Home** (dashboard), **Entities** (list/browse), **Timeline**, **Search**, **Settings**. |
| FR-SN-18 | Entity list screen has tabs or chips for filtering by entity type. |
| FR-SN-19 | Breadcrumb-style back navigation for entity → relationship → entity chains. |
| FR-SN-20 | Deep linking: each entity has a unique route (`/entity/{id}`) for `go_router`. |

---

## Data Model Notes

### FTS5 Virtual Table

```sql
CREATE VIRTUAL TABLE entity_fts USING fts5(
  entity_id UNINDEXED,
  name,
  description,
  custom_fields_text,  -- extracted text values from JSON custom fields
  content='entities',
  content_rowid='id'
);
```

- Separate FTS entries for **relationship descriptions** and **timeline entries**, linked back to the source entity via `entity_id`.
- Triggers on `entities` table (INSERT, UPDATE, DELETE) keep the FTS index in sync automatically.

### Recent Entities

Stored as a simple ordered list in `SharedPreferences` or a small `recent_entities` DB table:

| Column | Type | Notes |
|---|---|---|
| `entity_id` | `TEXT (FK)` | References `entities.id` |
| `viewed_at` | `INTEGER` | Unix epoch ms |

Cap at 10 entries. On each entity view, upsert the record and prune the oldest if count > 10.

---

## Implementation Notes

### Quick-Switcher

- Use a `BottomSheet` or `OverlayEntry` with a `TextField` + `ListView.builder`.
- Debounce input at 300ms using `rxdart` or a simple `Timer`.
- For small datasets (<500 entities): Dart-side fuzzy matching (Levenshtein distance or trigram similarity).
- For larger datasets: delegate to FTS5 with prefix queries (`name : "query"*`).

### FTS5 in Drift

Drift doesn't have first-class FTS5 support. Use `customStatement()` for:

1. Virtual table creation (in migration).
2. `MATCH` queries with `snippet()` for highlighted results.
3. Sync triggers (or manage sync in Dart DAOs on write).

```dart
// Example Drift custom query
Future<List<SearchResult>> search(String query) {
  final escapedQuery = _escapeFts5Query(query);
  return customSelect(
    'SELECT entity_id, snippet(entity_fts, 1, "<b>", "</b>", "...", 32) as snippet '
    'FROM entity_fts WHERE entity_fts MATCH ? ORDER BY rank LIMIT 50',
    variables: [Variable.withString(escapedQuery)],
    readsFrom: {entityFts},
  ).map((row) => SearchResult(
    entityId: row.read<String>('entity_id'),
    snippet: row.read<String>('snippet'),
  )).get();
}
```

### Navigation

- `go_router` with `ShellRoute` for the bottom nav bar.
- Entity routes: `/entity/:id`, `/entity/:id/relationships`, `/entity/:id/timeline`.
- Breadcrumb state managed via `go_router`'s navigation stack — no custom state needed.

---

## Edge Cases

| Scenario | Handling |
|---|---|
| Search with special characters (`"`, `*`, `AND`, `OR`) | Escape/quote user input before passing to FTS5 `MATCH`. Strip FTS5 operators. |
| Entity with no description | Still searchable by name. FTS5 handles empty columns gracefully. |
| Very long results list | Cap at **50 results**. Show "more results available" prompt. User can refine query. |
| Concurrent search while entity is being edited | Search uses latest **committed** data. Uncommitted edits are invisible to FTS. |
| Deleted entities in FTS index | Soft-deleted entities are excluded from search results via a filter on `deleted_at IS NULL`. FTS triggers must handle soft-delete updates. |
| Empty search query | Return nothing (full-text) or recent entities (quick-switcher). Never return all entities. |

---

## Cross-References

- Orphan detection also appears in [06-consistency-helpers.md](file:///D:/Fictionist/docs/features/06-consistency-helpers.md) (consistency angle).
- Stats dashboard in [07-quality-of-life.md](file:///D:/Fictionist/docs/features/07-quality-of-life.md) consumes orphan count and entity counts.
- Entity data model defined in [02-entity-system.md](file:///D:/Fictionist/docs/features/02-entity-system.md).
- Relationship model defined in [03-relationships.md](file:///D:/Fictionist/docs/features/03-relationships.md).
