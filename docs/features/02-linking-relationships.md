# 02 — Linking & Relationships

> **Status:** MVP | **Owner:** TBD | **Last updated:** 2026-07-05

## Overview

Relationships are the graph backbone of Fictionist. Every entity can link to any other entity via a typed, directed or bidirectional edge. This system turns a flat list of worldbuilding entries into an interconnected knowledge graph that powers graph views, family trees, faction maps, and contextual discovery.

Relationships live in a single `relationships` table. Bidirectional relationships are stored as **one record** and are surfaced from both sides. Directional relationships store a source → target direction and auto-suggest the reciprocal (e.g., creating `parent_of` prompts creation of `child_of` on the target).

---

## Functional Requirements

### Core CRUD

| ID | Requirement | MVP |
|----|-------------|-----|
| **FR-LR-01** | Users can create a relationship between any two entities by selecting a source entity, a target entity, and a relationship type. | ✅ |
| **FR-LR-02** | The system maintains a **relationship type registry** — a table of built-in types with metadata: `type_key`, `label`, `inverse_label`, applicable source/target entity types, and a `bidirectional` flag. | ✅ |
| **FR-LR-03** | When a user creates a **directional** relationship (e.g., `parent_of`), the system auto-suggests creating the inverse relationship (`child_of`) on the target entity. The user may accept or dismiss the suggestion. | ✅ |
| **FR-LR-04** | **Bidirectional** relationships (e.g., `sibling_of`, `ally_of`, `married_to`) are stored as a **single record** and appear in the relationships list of both the source and target entities. | ✅ |
| **FR-LR-05** | Each relationship supports an optional free-text `description` field for context (e.g., "Betrayed them during the Siege of Aelnar"). | ✅ |

### Display & Navigation

| ID | Requirement | MVP |
|----|-------------|-----|
| **FR-LR-06** | The entity detail screen includes a **Relationships** section listing all relationships where the entity is the source (or either side, for bidirectional types). | ✅ |
| **FR-LR-07** | The entity detail screen includes a **Backlinks** section listing all directional relationships where the entity is the target (i.e., other entities pointing *to* this one). | ✅ |
| **FR-LR-08** | Users can **filter** the relationships list by relationship type via a dropdown/chip selector. | ✅ |
| **FR-LR-09** | Tapping a related entity navigates directly to that entity's detail screen. | ✅ |

### Lifecycle

| ID | Requirement | MVP |
|----|-------------|-----|
| **FR-LR-10** | When an entity is soft-deleted, all relationships where it is source or target are also soft-deleted. Restoring the entity restores its relationships. | ✅ |

### Custom Types

| ID | Requirement | MVP |
|----|-------------|-----|
| **FR-LR-11** | Users can create **custom relationship types** with a label, optional inverse label, bidirectional flag, and optional source/target type constraints. Custom types are stored in the same registry table with `is_builtin = false`. | ✅ |

### Smart Suggestions

| ID | Requirement | MVP |
|----|-------------|-----|
| **FR-LR-12** | When selecting a relationship type, the picker is **filtered** to show only types whose `source_types` / `target_types` constraints match the selected entity pair. Types with no constraints are always shown. | ✅ |

### Graph Visualization

| ID | Requirement | MVP |
|----|-------------|-----|
| **FR-LR-13** | A **graph view** renders entities as nodes and relationships as edges. See [03-specialized-views.md](file:///D:/Fictionist/docs/features/03-specialized-views.md) for full spec. | V1.x |

### Constraints

| ID | Requirement | MVP |
|----|-------------|-----|
| **FR-LR-14** | The system **rejects self-referential relationships** (source == target). Show inline validation error: "An entity cannot have a relationship with itself." | ✅ |
| **FR-LR-15** | The system **rejects duplicate relationships** — no two active relationships may share the same `(source_id, target_id, type_key)` triple. For bidirectional types, the check normalizes to `(min(id), max(id), type_key)`. | ✅ |
| **FR-LR-16** | When the user attempts to create a relationship that already exists, surface a toast: "This relationship already exists" and navigate to the existing record for editing. | ✅ |

---

## Relationship Type Registry

All built-in types ship with the app and are immutable. Custom types created by the user follow the same schema.

### Type Key Reference

| Type Key | Label | Inverse Label | Bidirectional | Source Types | Target Types |
|---|---|---|---|---|---|
| `parent_of` | Parent of | Child of | No | Character | Character |
| `child_of` | Child of | Parent of | No | Character | Character |
| `sibling_of` | Sibling of | Sibling of | Yes | Character | Character |
| `ally_of` | Ally of | Ally of | Yes | Character, Faction | Character, Faction |
| `enemy_of` | Enemy of | Enemy of | Yes | Character, Faction | Character, Faction |
| `member_of` | Member of | Has member | No | Character | Faction, Race/Culture |
| `leader_of` | Leader of | Led by | No | Character | Faction, Race/Culture, Location |
| `located_in` | Located in | Contains | No | Character, Faction, Item/Artifact, Event | Location |
| `wields` | Wields | Wielded by | No | Character | Item/Artifact, Power/Magic System |
| `created_by` | Created by | Created | No | Item/Artifact, Power/Magic System, Concept/Glossary | Character, Faction, Race/Culture |
| `belongs_to` | Belongs to | Owns | No | Item/Artifact | Character, Faction, Location |
| `participates_in` | Participates in | Has participant | No | Character, Faction | Event |
| `occurred_at` | Occurred at | Event site of | No | Event | Location |
| `practices` | Practices | Practiced by | No | Character, Race/Culture, Faction | Power/Magic System, Concept/Glossary |
| `rival_of` | Rival of | Rival of | Yes | Character, Faction | Character, Faction |
| `married_to` | Married to | Married to | Yes | Character | Character |
| `mentors` | Mentors | Mentored by | No | Character | Character |
| `rules_over` | Rules over | Ruled by | No | Character, Faction | Location, Faction |
| `worships` | Worships | Worshipped by | No | Character, Race/Culture, Faction | Character, Concept/Glossary |
| `related_to` | Related to | Related to | Yes | *any* | *any* |

> [!NOTE]
> `related_to` is the catch-all. It has no type constraints and is always available. Use it when no specific type fits.

### Custom Type Schema

Custom types follow the same schema:

```dart
// relationship_type_registry table
{
  type_key: String,        // user-provided, slugified, prefixed 'custom_'
  label: String,
  inverse_label: String?,  // null if bidirectional
  bidirectional: bool,
  source_types: List<EntityType>?,  // null = any
  target_types: List<EntityType>?,  // null = any
  is_builtin: bool,        // false for custom
  created_at: DateTime,
  updated_at: DateTime,
}
```

---

## Data Model

### `relationships` Table

```sql
CREATE TABLE relationships (
  id            TEXT PRIMARY KEY,  -- UUID v4
  source_id     TEXT NOT NULL REFERENCES entities(id),
  target_id     TEXT NOT NULL REFERENCES entities(id),
  type_key      TEXT NOT NULL,     -- FK to relationship_type_registry
  description   TEXT,
  is_deleted    INTEGER NOT NULL DEFAULT 0,
  created_at    INTEGER NOT NULL,  -- Unix epoch ms
  updated_at    INTEGER NOT NULL,

  -- Prevent duplicate active relationships
  UNIQUE(source_id, target_id, type_key) WHERE is_deleted = 0
);

CREATE INDEX idx_relationships_source ON relationships(source_id) WHERE is_deleted = 0;
CREATE INDEX idx_relationships_target ON relationships(target_id) WHERE is_deleted = 0;
CREATE INDEX idx_relationships_type   ON relationships(type_key)  WHERE is_deleted = 0;
```

### `relationship_type_registry` Table

```sql
CREATE TABLE relationship_type_registry (
  type_key        TEXT PRIMARY KEY,
  label           TEXT NOT NULL,
  inverse_label   TEXT,
  bidirectional   INTEGER NOT NULL DEFAULT 0,
  source_types    TEXT,    -- JSON array of entity type strings, NULL = any
  target_types    TEXT,    -- JSON array of entity type strings, NULL = any
  is_builtin      INTEGER NOT NULL DEFAULT 1,
  created_at      INTEGER NOT NULL,
  updated_at      INTEGER NOT NULL
);
```

### Storage Strategy: Bidirectional vs. Directional

**Bidirectional** (`sibling_of`, `ally_of`, `married_to`, `enemy_of`, `rival_of`, `related_to`):
- Stored as **one row** with `source_id = min(id_a, id_b)` and `target_id = max(id_a, id_b)` (lexicographic normalization).
- Queries from either side: `WHERE source_id = ? OR target_id = ?`.
- Uniqueness check uses the normalized pair.

**Directional** (`parent_of`, `member_of`, `located_in`, etc.):
- Stored as-is: `source_id` → `target_id`.
- The "Relationships" section shows rows where entity is source.
- The "Backlinks" section shows rows where entity is target, displaying the `inverse_label`.

---

## UI/UX Considerations

### Add Relationship Flow

1. User taps **+ Add Relationship** on entity detail.
2. Bottom sheet opens with:
   - **Type** dropdown (filtered to applicable types for this entity's type).
   - **Target entity** search field with typeahead (filtered by target type constraints of selected relationship type).
   - **Description** text field (optional).
3. On save:
   - If directional and an inverse exists, show snackbar: *"Also create 'Child of' on [Target]?"* with **Yes / No** actions.
   - If duplicate detected, redirect to existing relationship.

### Entity Detail Layout

```
┌─────────────────────────────────┐
│  Entity Detail                  │
│  ┌───────────────────────────┐  │
│  │ Relationships (3)     [+] │  │
│  │ ┌─ Filter: [All Types ▼] │  │
│  │ │                         │  │
│  │ │ → Ally of Kira Voss     │  │
│  │ │ → Member of Iron Guild  │  │
│  │ │ → Wields Stormbreaker   │  │
│  │ └─────────────────────────│  │
│  │ Backlinks (2)             │  │
│  │ │                         │  │
│  │ │ ← Mentored by Eldric    │  │
│  │ │ ← Child of Maren Daal   │  │
│  └───────────────────────────┘  │
└─────────────────────────────────┘
```

- Relationship rows show: **arrow icon** (→ outgoing, ← incoming, ↔ bidirectional) + **label** + **target entity name**.
- Long-press a relationship row to edit description or delete.
- Swipe-to-delete with undo snackbar.

---

## Edge Cases

| Scenario | Behavior |
|---|---|
| Delete entity A that has 5 relationships | All 5 relationships are soft-deleted. Restoring A restores them. |
| Restore entity A, but entity B (the other side) is still deleted | Relationship remains soft-deleted until B is also restored. |
| User creates `parent_of` A → B, then tries `child_of` B → A | System detects semantic duplicate and blocks with message: "A reciprocal relationship already exists." |
| Bidirectional duplicate check: A `ally_of` B already exists, user tries B `ally_of` A | Blocked — normalized pair matches. |
| Target entity search returns 500+ results | Paginate typeahead results; show 20 at a time with "load more." |
| User creates custom type with same key as built-in | Prefix custom keys with `custom_` to avoid collisions. Validate uniqueness at creation. |
| Relationship type registry modified while relationships exist | Built-in types are immutable. Custom types can be renamed (label only); `type_key` is permanent. Deleting a custom type soft-deletes all relationships of that type. |
| Offline conflict: two devices create same relationship | Last-write-wins on sync. Duplicate constraint rejects second insert; sync resolver keeps the one with latest `updated_at`. |

---

## MVP vs. Later

| Scope | Features |
|---|---|
| **MVP** | FR-LR-01 through FR-LR-12, FR-LR-14 through FR-LR-16. Full CRUD, type registry, custom types, filtering, backlinks, duplicate/self-ref prevention. |
| **V1.x** | FR-LR-13 — Graph visualization. See [03-specialized-views.md](file:///D:/Fictionist/docs/features/03-specialized-views.md). |
| **V2+** | Relationship strength/weight attribute. Relationship tags. Bulk relationship creation. Relationship history/timeline integration. |
