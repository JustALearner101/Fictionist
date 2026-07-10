# 03 — Specialized Views

> **Status:** V1.x / V2+ | **Owner:** TBD | **Last updated:** 2026-07-05

## Overview

Specialized views are **read-only visual derivations** of entity and relationship data. They do not own any data — they query the `entities` and `relationships` tables and render interactive visualizations. Users never edit entities or relationships from within these views; tapping a node navigates to the entity detail screen where edits happen.

Four sub-features:

| View | Data Source | Release |
|---|---|---|
| **A. Graph View** | All entities + all relationships | V1.x |
| **B. Family Tree** | Characters + `parent_of` / `child_of` / `sibling_of` / `married_to` | V1.x |
| **C. Faction Map** | Factions + Characters + political relationship types | V1.x |
| **D. World Map** | Locations + user-uploaded map image | V2+ |

---

## A. Graph View

A force-directed graph where nodes are entities and edges are relationships. The primary tool for exploring the interconnected worldbuilding graph.

### Functional Requirements

| ID | Requirement |
|----|-------------|
| **FR-SV-01** | Render a **force-directed graph** with entities as nodes and relationships as edges. Nodes are colored/shaped by entity type. Edge labels show relationship type. |
| **FR-SV-02** | Users can **filter** visible nodes by entity type (toggle chips: Character, Faction, Location, etc.) and edges by relationship type. |
| **FR-SV-03** | Users can **tap a node** to highlight it and its immediate connections (dim unconnected nodes). **Double-tap** navigates to the entity detail screen. |
| **FR-SV-04** | Users can **pinch-to-zoom** and **pan** the graph canvas. Support for two-finger rotation is optional. |
| **FR-SV-05** | Users can **search** for an entity by name within the graph view. Matching node is centered and highlighted. |
| **FR-SV-06** | The graph supports a **depth selector** (1-hop, 2-hop, 3-hop, all) when entered from an entity detail screen, scoping the graph to the entity's neighborhood. |

### Library Recommendations

| Library | Notes |
|---|---|
| [`graphview`](https://pub.dev/packages/graphview) | Pure Dart/Flutter. Supports force-directed, tree, and layered layouts. Good starting point. |
| [`flutter_force_directed_graph`](https://pub.dev/packages/flutter_force_directed_graph) | Lightweight force-directed layout. Less mature. |
| Custom `CustomPainter` + simulation | Full control. Use a Fruchterman-Reingold or Barnes-Hut algorithm. More work, best long-term. |

> [!TIP]
> Start with `graphview` for the MVP graph. Migrate to a custom `CustomPainter` implementation if performance or layout flexibility becomes a bottleneck beyond ~200 nodes.

### Performance Notes

- **Lazy loading:** For worlds with 500+ entities, only load the subgraph within the viewport plus a buffer zone. Use spatial indexing (quadtree) for hit testing.
- **Level of detail:** Below a zoom threshold, replace node labels with colored dots. Re-render labels on zoom-in.
- **Frame budget:** Target 60fps. Run force simulation on an isolate; push position updates to the UI thread via `SendPort`.
- **Cap default render** at 200 nodes. Show "Showing 200 of 847 entities — use filters to narrow" with a chip bar.

---

## B. Family Tree

A hierarchical tree visualization for Character entities based on familial relationships.

### Functional Requirements

| ID | Requirement |
|----|-------------|
| **FR-SV-07** | Render a **hierarchical family tree** from Character entities linked by `parent_of`, `child_of`, `sibling_of`, and `married_to` relationships. |
| **FR-SV-08** | Married/partnered characters are displayed as **paired nodes** on the same horizontal level, connected by a horizontal double-line. |
| **FR-SV-09** | Users can **select a root character** to anchor the tree. The tree expands downward (descendants) and upward (ancestors) from the root. Default root: the character with the most familial connections. |
| **FR-SV-10** | Tap a character node to navigate to their entity detail screen. Long-press shows a context tooltip with name, faction, and relationship count. |

### Layout Strategy

```
         ┌─────────┐
         │ Grandpa  │
         └────┬─────┘
              │
    ┌─────────┴─────────┐
    │                    │
┌───┴───┐ ═══ ┌────────┐│
│  Dad  │     │  Mom   ││
└───┬───┘     └────────┘│
    │                    │
  ┌─┴──┐   ┌────┐       │
  │ Me │   │ Sis│     ┌──┴──┐
  └────┘   └────┘     │Uncle│
                       └─────┘
```

- Use a layered/Sugiyama layout algorithm for clean hierarchical rendering.
- `graphview`'s `SugiyamaConfiguration` handles this out of the box.
- Siblings share a horizontal level; generations are vertical layers.
- Handle edge cases: single parents, multiple marriages (multiple paired nodes per character), orphan characters (no parents — shown as standalone roots).

### Data Derivation

The tree is derived entirely from existing relationships:
- `parent_of` / `child_of` → vertical parent-child edges
- `sibling_of` → horizontal same-level grouping
- `married_to` → horizontal paired nodes with marriage connector

No additional data model needed.

---

## C. Faction Map

A network diagram showing political and organizational relationships between factions, and optionally the key characters within them.

### Functional Requirements

| ID | Requirement |
|----|-------------|
| **FR-SV-11** | Render a **network diagram** with Faction entities as primary nodes. Edges represent: `ally_of`, `enemy_of`, `rival_of`, `rules_over`, `member_of`, `leader_of`. |
| **FR-SV-12** | Edge styling encodes relationship type: **green** for `ally_of`, **red** for `enemy_of`, **orange** for `rival_of`, **gray dashed** for `rules_over`. Edge labels optional (toggle). |
| **FR-SV-13** | Users can **expand a faction node** to reveal its member/leader Characters as child nodes clustered around the faction. Collapse to hide. |

### Layout

- Use a force-directed layout with faction nodes as heavy attractors.
- Allied factions cluster closer; enemy factions repel.
- Encode this in the force simulation weights:
  - `ally_of` → attractive spring (short rest length)
  - `enemy_of` → repulsive spring (long rest length)
  - `rival_of` → medium repulsion
  - `rules_over` → moderate attraction (hierarchy)

### Visual Design

```
  ┌───────────┐   ally (green)   ┌──────────┐
  │  Ironclad │ ────────────── │  Sunborn  │
  │  Compact  │                 │  Enclave  │
  └─────┬─────┘                 └──────────┘
        │ enemy (red)
        │
  ┌─────┴─────┐   rival (orange)  ┌──────────┐
  │  Obsidian │ ═══════════════ │  Ashveil  │
  │  Throne   │                  │  Pact     │
  └───────────┘                  └──────────┘
```

---

## D. World Map

A custom map view where users upload a world map image and pin Location entities onto it.

### Functional Requirements

| ID | Requirement |
|----|-------------|
| **FR-SV-14** | Users can **upload a map image** (PNG, JPG, WebP; max 20MB) that serves as the background canvas. |
| **FR-SV-15** | Users can **place pins** on the map by long-pressing a location, then selecting an existing Location entity from a search picker. The pin's `(x, y)` coordinates (normalized 0.0–1.0) are stored on the Location entity. |
| **FR-SV-16** | Pins are styled by location sub-type if available (city, region, landmark, etc.) using distinct icons. |
| **FR-SV-17** | Users can **pinch-to-zoom** and **pan** the map. At high zoom levels, pin labels become visible. At low zoom, only icons are shown. |
| **FR-SV-18** | Tapping a pin opens a **bottom sheet** with the location name, description preview, and a "View Details" button that navigates to the entity detail screen. |

### Data Model Extension

The world map feature requires extending the `entities` table or adding a dedicated table:

```sql
CREATE TABLE world_maps (
  id          TEXT PRIMARY KEY,
  name        TEXT NOT NULL,
  image_path  TEXT NOT NULL,  -- relative path in app's document directory
  created_at  INTEGER NOT NULL,
  updated_at  INTEGER NOT NULL,
  is_deleted  INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE map_pins (
  id          TEXT PRIMARY KEY,
  map_id      TEXT NOT NULL REFERENCES world_maps(id),
  entity_id   TEXT NOT NULL REFERENCES entities(id),  -- must be a Location
  x           REAL NOT NULL,  -- 0.0 to 1.0, normalized
  y           REAL NOT NULL,  -- 0.0 to 1.0, normalized
  created_at  INTEGER NOT NULL,
  updated_at  INTEGER NOT NULL,
  is_deleted  INTEGER NOT NULL DEFAULT 0,

  UNIQUE(map_id, entity_id) WHERE is_deleted = 0
);
```

> [!IMPORTANT]
> Map images are stored locally in the app's document directory, not in SQLite. The DB stores a relative path. On export/backup, images must be included in the archive.

### Library Recommendations

| Library | Notes |
|---|---|
| [`photo_view`](https://pub.dev/packages/photo_view) | Zoomable image viewer. Layer pin widgets on top using a `Stack`. |
| [`flutter_map`](https://pub.dev/packages/flutter_map) | Full map widget with custom tile providers. Could use a single-tile custom provider for the uploaded image. Overkill for MVP. |
| Custom `InteractiveViewer` + `Stack` | Simplest approach. `InteractiveViewer` handles pan/zoom. Overlay pin `Positioned` widgets. |

---

## Shared UI/UX Considerations

- **Entry point:** All specialized views are accessible from a dedicated **"Views"** tab in the bottom navigation, or from entity detail screens (e.g., "View Family Tree" button on a Character).
- **Empty states:** Each view shows a meaningful empty state when there's insufficient data (e.g., "Add parent/child relationships to characters to build a family tree").
- **Read-only principle:** These views are read-only projections. Edits happen in entity detail. Reinforce this with visual cues — no FABs, no edit icons within the view.
- **Refresh:** Views rebuild from the latest DB state each time they are opened. No caching of graph layout between sessions (positions are ephemeral).
- **Accessibility:** Nodes must have semantic labels for screen readers. Provide a list-based alternative for each graph view.

---

## Edge Cases

| Scenario | Behavior |
|---|---|
| Graph has 1,000+ entities | Cap visible nodes at 200. Show filter prompt. Run simulation on isolate. |
| Character has no familial relationships | Excluded from family tree. If user opens tree from this character, show empty state: "No family connections found." |
| Circular parentage (A parent_of B, B parent_of A) | Should be blocked by [02-linking-relationships.md](file:///D:/Fictionist/docs/features/02-linking-relationships.md) reciprocal duplicate detection. If data is corrupted, tree renderer breaks the cycle at the repeated node and shows a warning icon. |
| Multiple disconnected family clusters | Render each cluster independently. Provide a cluster picker dropdown to switch between them. |
| User uploads 50MB map image | Reject with error: "Map image must be under 20MB." |
| Location entity deleted after pin placed | Pin is hidden (soft-deleted cascade). If location is restored, pin reappears. |
| User has no map uploaded | Show upload prompt as the empty state for World Map. |
| Faction with 50+ members expanded | Paginate or cluster member nodes in a circular arrangement around the faction node. Cap visible members at 20 with a "+30 more" badge. |

---

## MVP vs. Later

| Scope | Features |
|---|---|
| **V1.x** | Graph View (FR-SV-01–06), Family Tree (FR-SV-07–10), Faction Map (FR-SV-11–13). All read-only, derived from existing entity/relationship data. |
| **V2+** | World Map (FR-SV-14–18). Requires image storage, new tables, pin management UI. |
| **V2+** | Export graph/tree as PNG/SVG. Share world map as image. |
| **V2+** | Animated timeline overlay on graph view — scrub through events and see relationships appear/disappear over time. |
