# 06 — Consistency Helpers

> Rule-based assistance — **no AI**. Worldbuilding over months or years leads to inconsistencies. Fictionist provides lightweight, rule-based tools to catch common issues. These are assistive, not authoritative — they surface potential issues for the novelist to review.

---

## Functional Requirements

### A. Reciprocal Relationship Suggestions (MVP)

| ID | Requirement |
|---|---|
| FR-CH-01 | When a user creates a directional relationship (e.g., `parent_of`), the app **auto-suggests** creating the reciprocal (`child_of`) on the target entity. |
| FR-CH-02 | Suggestion appears as a dismissable prompt/snackbar: _"Also add 'Child of [Source]' to [Target]?"_ |
| FR-CH-03 | If the user accepts, the reciprocal relationship is created automatically with the inverse type. |
| FR-CH-04 | If a reciprocal already exists, **no suggestion is shown**. |
| FR-CH-05 | The relationship type registry defines which types have inverses (see [03-relationships.md](file:///D:/Fictionist/docs/features/03-relationships.md)). |

### B. Orphan Detection & Worldbuilding Gaps (MVP)

| ID | Requirement |
|---|---|
| FR-CH-06 | The stats dashboard highlights the orphan count with a **warning indicator** if > 0. |
| FR-CH-07 | A dedicated "Worldbuilding Gaps" section on the dashboard shows: orphan entities, entities with only 1 relationship (weakly connected), entity types with 0 entries. |

> [!NOTE]
> Orphan detection overlaps with [05-search-navigation.md](file:///D:/Fictionist/docs/features/05-search-navigation.md) FR-SN-13 through FR-SN-16. The Search spec covers the orphan *listing*. This spec covers the *dashboard integration* and gap analysis.

### C. Duplicate Name Warning (MVP)

| ID | Requirement |
|---|---|
| FR-CH-08 | When creating or renaming an entity, if another entity with the same name (case-insensitive) exists, show a **warning** — not a block. Duplicates ARE allowed for legitimate reasons (e.g., common names across cultures). |
| FR-CH-09 | Warning shows the existing entity's type and a link to navigate to it. |

### D. Version History (V1.x)

| ID | Requirement |
|---|---|
| FR-CH-10 | Each time an entity is saved, a version snapshot (full JSON) is stored in `EntityVersion` table. |
| FR-CH-11 | Entity detail view has a **"History" tab** showing version timeline. |
| FR-CH-12 | User can view any past version (read-only) and compare with current. |
| FR-CH-13 | User can **restore** a past version (creates a new version with the old data — never destructive). |
| FR-CH-14 | Version limit: keep last **50 versions** per entity. Auto-prune older ones on each new save. |

### E. Structured Conflict Detection (V2+)

| ID | Requirement |
|---|---|
| FR-CH-15 | Detect **overlapping timeline entries** for the same entity (e.g., character "in Location A" and "in Location B" at the same `sort_order` position). Requires structured date comparison — depends on custom calendar system. |
| FR-CH-16 | Detect **circular relationships** (e.g., A is parent of B, B is parent of A). Flag as warnings. |
| FR-CH-17 | Detect **broken relationship chains** (e.g., faction leader is not a member of the faction). |

---

## Data Model

### EntityVersion Table

| Column | Type | Notes |
|---|---|---|
| `id` | `TEXT (PK)` | UUID |
| `entity_id` | `TEXT (FK)` | References `entities.id` |
| `snapshot_json` | `TEXT` | Full JSON blob of entity state at time of save |
| `changed_at` | `INTEGER` | Unix epoch ms |
| `change_note` | `TEXT?` | Optional user-provided note (nullable) |

```sql
CREATE TABLE entity_versions (
  id TEXT PRIMARY KEY NOT NULL,
  entity_id TEXT NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
  snapshot_json TEXT NOT NULL,
  changed_at INTEGER NOT NULL,
  change_note TEXT,
  FOREIGN KEY (entity_id) REFERENCES entities(id)
);

CREATE INDEX idx_entity_versions_entity_id ON entity_versions(entity_id);
CREATE INDEX idx_entity_versions_changed_at ON entity_versions(changed_at);
```

### What the Snapshot Includes

- All entity fields (name, description, type, status, icon, color, `created_at`, `updated_at`).
- All custom field values.
- Does **NOT** include relationships — those have independent lifecycle. Relationship history can be added later if needed.

### Reciprocal Type Registry

The relationship type registry (defined in [03-relationships.md](file:///D:/Fictionist/docs/features/03-relationships.md)) maps inverse pairs:

```dart
const Map<String, String> inverseRelationshipTypes = {
  'parent_of': 'child_of',
  'child_of': 'parent_of',
  'leader_of': 'led_by',
  'led_by': 'leader_of',
  'member_of': 'has_member',
  'has_member': 'member_of',
  'located_in': 'contains',
  'contains': 'located_in',
  'created_by': 'creator_of',
  'creator_of': 'created_by',
  // Symmetric types map to themselves
  'ally_of': 'ally_of',
  'enemy_of': 'enemy_of',
  'sibling_of': 'sibling_of',
};
```

---

## Implementation Notes

### Reciprocal Suggestions

The suggestion logic lives in the **domain layer** (use case), not in the UI or Notifier:

```
CreateRelationshipUseCase
  1. Create the primary relationship.
  2. Look up inverse type in the registry.
  3. If inverse exists AND reciprocal relationship doesn't already exist:
     → Return a ReciprocalSuggestion in the result.
  4. Notifier surfaces the suggestion to the UI.
  5. UI shows snackbar/prompt.
  6. On accept → call CreateRelationshipUseCase again with swapped source/target and inverse type.
```

> [!IMPORTANT]
> The use case returns the suggestion — it does NOT auto-create the reciprocal. The user always has the final say.

### Duplicate Name Check

- Query: `SELECT id, name, type FROM entities WHERE LOWER(name) = LOWER(?) AND id != ? AND deleted_at IS NULL`
- Run on every keystroke in the name field (debounced at 500ms).
- Show an inline warning below the text field, not a dialog.

### Version Pruning

On each new version save:

```sql
DELETE FROM entity_versions
WHERE entity_id = ?
AND id NOT IN (
  SELECT id FROM entity_versions
  WHERE entity_id = ?
  ORDER BY changed_at DESC
  LIMIT 50
);
```

### Version Comparison (V1.x)

- Deserialize both `snapshot_json` blobs into maps.
- Diff the maps field-by-field.
- Display changes in a simple before/after view (not a full diff engine — just highlight changed fields).

---

## Edge Cases

| Scenario | Handling |
|---|---|
| Rapid saves (user hits save 5 times in 10 seconds) | **Debounce version creation**: skip snapshot if the last version for this entity is <1 minute old, UNLESS this is the very first save. |
| Very large entities with many custom fields | Snapshot JSON could be large. Accept this — on-device storage is cheap. A typical entity snapshot is <10 KB. Even 50 versions × 5,000 entities = ~2.5 GB worst case, which is unrealistic in practice. |
| Circular relationship detection (V2+) | Keep it simple: detect **direct cycles only** (A→B→A), not transitive cycles (A→B→C→A). Transitive detection is expensive and rarely useful. |
| Reciprocal suggestion for symmetric relationships | If the type is symmetric (e.g., `sibling_of`), still suggest the reciprocal. The logic is identical — just the inverse type equals itself. |
| Entity renamed — does the reciprocal update? | Reciprocal relationships store `entity_id`, not name. Display name is resolved at render time. No update needed. |
| Deleting a relationship — prompt to delete reciprocal? | Yes (V1.x). If a reciprocal exists, prompt: _"Also remove 'Child of [Source]' from [Target]?"_ Same pattern as creation. |

---

## Cross-References

- Relationship type registry: [03-relationships.md](file:///D:/Fictionist/docs/features/03-relationships.md)
- Orphan listing UI: [05-search-navigation.md](file:///D:/Fictionist/docs/features/05-search-navigation.md) (FR-SN-13 – FR-SN-16)
- Stats dashboard: [07-quality-of-life.md](file:///D:/Fictionist/docs/features/07-quality-of-life.md) (FR-QL-08 – FR-QL-11)
- Timeline model (for conflict detection): [04-timeline.md](file:///D:/Fictionist/docs/features/04-timeline.md)
