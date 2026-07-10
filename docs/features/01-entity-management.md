# Entity Management

> Feature Spec · Fictionist · Last updated: 2026-07-05

## Overview

Entities are the fundamental building blocks of every Fictionist world. The app ships with **8 pre-defined entity types** — Character, Faction, Race/Culture, Location, Power/Magic System, Item/Artifact, Event, and Concept/Glossary — each backed by a base schema (`name`, `type`, `status`, `description`) plus user-defined custom fields.

**Why it matters:** Every other feature — relationships, timelines, specialized views — operates on entities. If CRUD is clunky, nothing else matters. The entity system must be fast, flexible, and forgiving.

---

## Functional Requirements

| ID | Requirement | MVP / Later |
|---|---|---|
| **FR-EM-01** | User can create an entity by selecting a type and optionally choosing a template. | MVP |
| **FR-EM-02** | Each entity has: `name` (required, non-empty), `type` (required, **immutable after creation**), `status` (default: `draft`), `description` (markdown, optional), and custom fields. | MVP |
| **FR-EM-03** | Custom fields support types: **short text**, **long text**, **number**, **single-select**, **multi-select**, **boolean**, **date-label** (freeform string for in-world dates). | MVP |
| **FR-EM-04** | User can add, edit, reorder, and remove custom fields on any entity. | MVP |
| **FR-EM-05** | User can edit all mutable fields of an existing entity. | MVP |
| **FR-EM-06** | Deleting an entity is a **soft delete** (`is_deleted` flag). Soft-deleted entities don't appear in lists/search but can be restored. | MVP |
| **FR-EM-07** | Entity list views can be filtered by type, status, and tags. | MVP |
| **FR-EM-08** | Entity list views can be sorted by name, created date, and updated date. | MVP |
| **FR-EM-09** | Each entity type ships with at least one built-in template providing sensible default custom fields. | MVP |
| **FR-EM-10** | User can create custom templates for any entity type. | MVP |
| **FR-EM-11** | Entity detail view shows the entity's fields, relationships (with backlinks), and timeline entries. | MVP |
| **FR-EM-12** | Duplicate entity names are **allowed** (with a warning toast). Different characters can share names. | MVP |
| **FR-EM-13** | Entity type icons and colors are visually distinct for quick identification across the app. | MVP |
| **FR-EM-14** | Batch operations: multi-select entities for bulk status change, bulk tag, bulk delete. | V1.x |

---

## Built-in Templates

Each type ships with a default template. These define the starting custom fields when a user picks the template during entity creation. Users can skip templates and start blank.

### Character

| Field | Type |
|---|---|
| Age | Short text |
| Title / Role | Short text |
| Physical Description | Long text |
| Personality Traits | Multi-select |
| Background | Long text |
| Goals | Long text |
| Weaknesses | Long text |

### Faction

| Field | Type |
|---|---|
| Type | Single-select (`political`, `military`, `religious`, `academic`, `guild`) |
| Motto / Creed | Short text |
| Leadership Structure | Long text |
| Territory | Short text |
| Goals | Long text |
| Size | Single-select (`small`, `medium`, `large`, `massive`) |

### Race / Culture

| Field | Type |
|---|---|
| Aesthetic Influences | Short text |
| Lifespan | Short text |
| Physical Traits | Long text |
| Cultural Values | Long text |
| Traditions | Long text |
| Language Notes | Long text |

### Location

| Field | Type |
|---|---|
| Region / Continent | Short text |
| Climate | Short text |
| Population | Short text |
| Notable Features | Long text |
| Controlled By | Short text |

### Power / Magic System

| Field | Type |
|---|---|
| Source | Short text |
| Limitations / Costs | Long text |
| Practitioners | Short text |
| Levels / Tiers | Long text |
| Known Abilities | Long text |

### Item / Artifact

| Field | Type |
|---|---|
| Type | Single-select (`weapon`, `armor`, `relic`, `consumable`, `tool`) |
| Rarity | Single-select (`common`, `uncommon`, `rare`, `legendary`, `unique`) |
| Current Owner | Short text |
| Powers / Effects | Long text |
| History | Long text |

### Event

| Field | Type |
|---|---|
| Date / Era | Date-label |
| Location | Short text |
| Participants | Long text |
| Outcome | Long text |
| Significance | Long text |

### Concept / Glossary

| Field | Type |
|---|---|
| Category | Short text |
| Definition | Long text |
| Related Terms | Short text |
| Usage Notes | Long text |

---

## Data Model

### `entities` table

| Column | Type | Notes |
|---|---|---|
| `id` | `TEXT` (UUID) | PK |
| `name` | `TEXT` | Required, non-empty |
| `type` | `TEXT` | Required, immutable. One of the 8 enum values. |
| `status` | `TEXT` | Default: `draft`. Values: `draft`, `in_progress`, `complete`, `archived` |
| `description` | `TEXT` | Nullable. Markdown content. |
| `custom_fields` | `TEXT` (JSON) | JSON blob storing custom field definitions and values. See schema below. |
| `is_deleted` | `INTEGER` | Boolean. Default: `0`. |
| `created_at` | `INTEGER` | Epoch milliseconds. |
| `updated_at` | `INTEGER` | Epoch milliseconds. |

### `custom_fields` JSON schema

```json
[
  {
    "id": "uuid",
    "label": "Age",
    "type": "short_text",
    "value": "342",
    "sort_order": 0,
    "options": ["warrior", "mage", "scholar"]  // only for single-select / multi-select
  }
]
```

### `templates` table

| Column | Type | Notes |
|---|---|---|
| `id` | `TEXT` (UUID) | PK |
| `name` | `TEXT` | e.g., "Default Character Template" |
| `entity_type` | `TEXT` | Which entity type this template applies to. |
| `is_built_in` | `INTEGER` | Boolean. Built-in templates cannot be deleted. |
| `custom_fields_schema` | `TEXT` (JSON) | JSON blob defining the field definitions (no values). |
| `created_at` | `INTEGER` | Epoch milliseconds. |
| `updated_at` | `INTEGER` | Epoch milliseconds. |

### `entity_tags` junction table

| Column | Type | Notes |
|---|---|---|
| `entity_id` | `TEXT` | FK → `entities.id` |
| `tag` | `TEXT` | Normalized tag string. |

Composite PK on `(entity_id, tag)`.

---

## UI/UX Considerations

- **Entity list** is the app's home screen. Default sort: `updated_at` descending.
- **Filter chips** at the top of the list for type and status. Tag filter via search/dropdown.
- **Create flow**: Bottom sheet or full-screen modal. Step 1: pick type. Step 2: pick template (or "Blank"). Step 3: fill fields.
- **Entity detail** is a scrollable form. Sections: Header (name, type badge, status chip) → Description → Custom Fields → Relationships → Timeline.
- **Custom field editor**: inline editing. Tap a field label to rename. Long-press to reorder (drag handle). Swipe to delete.
- **Soft-delete UX**: Deleted items accessible via a "Trash" screen or a filter toggle. Restore via swipe or context menu.
- **Type icons**: Use distinct Material/custom icons per type. Suggested color palette:
  - Character: `blue`
  - Faction: `red`
  - Race/Culture: `amber`
  - Location: `green`
  - Power/Magic System: `purple`
  - Item/Artifact: `orange`
  - Event: `teal`
  - Concept/Glossary: `grey`

---

## Edge Cases

| Scenario | Decision |
|---|---|
| Very long description | No hard limit. Markdown rendering should handle gracefully. Consider lazy rendering for 10k+ char descriptions. |
| Many custom fields | Cap at **50 custom fields per entity**. Display a warning at 40. |
| Entity name with special characters | Allow any Unicode. Trim leading/trailing whitespace. Reject empty-after-trim. |
| Empty entity (just name + type) | **Valid.** Description, custom fields, tags are all optional. |
| Duplicate entity names | Allowed. Show a non-blocking warning: "Another entity named X already exists." |
| Restoring a soft-deleted entity | Restore the entity and its soft-deleted relationships. If the other end of a relationship was permanently purged, drop the relationship. |
| Type immutability | If the user made a mistake, they must create a new entity and manually migrate. Consider a "clone as different type" feature in V1.x. |

---

## Open Questions

1. **Permanent purge**: Should there be a "permanently delete" action, or do soft-deleted entities accumulate forever? Proposal: add a "Purge Trash" action that hard-deletes all soft-deleted entities older than 30 days.
2. **Custom field types — extensibility**: Should we support `url`, `image`, or `entity_reference` field types in V1.x? Entity references would partly overlap with the relationship system.
3. **Template management**: Should users be able to edit built-in templates, or only clone them? Proposal: built-in templates are read-only; users clone to customize.
4. **Status values**: Are `draft`, `in_progress`, `complete`, `archived` sufficient? Should users be able to define custom statuses?
