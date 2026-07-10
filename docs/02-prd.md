# Product Requirements Document

> Fictionist V1 — MVP scope for a local-only, offline-first worldbuilding knowledge graph on Android.

*See [Product Overview](./01-overview.md) for problem statement, vision, and competitive context.*

---

## 1. User Stories

### Entity Management

| ID | Story | Priority | Feature Doc |
|----|-------|----------|-------------|
| US-01 | As a writer, I want to create a new entity by choosing a type (Character, Faction, Location, etc.) so that my world elements are categorized from the start. | P0 | [Entity CRUD](./features/entity-crud.md) |
| US-02 | As a writer, I want each entity type to have sensible default fields (e.g., Character has "Age", "Role", "Appearance") so I don't start from a blank slate. | P0 | [Entity CRUD](./features/entity-crud.md) |
| US-03 | As a writer, I want to add custom fields to any entity so I can capture world-specific attributes (e.g., "Mana Affinity" on a Character). | P0 | [Custom Fields](./features/custom-fields.md) |
| US-04 | As a writer, I want to save and reuse entity templates so I can quickly create entities with consistent structure (e.g., a "Noble House" template for Factions). | P1 | [Templates](./features/templates.md) |
| US-05 | As a writer, I want soft-delete with an undo/restore option so I never accidentally lose worldbuilding work. | P0 | [Entity CRUD](./features/entity-crud.md) |

### Relationships & Linking

| ID | Story | Priority | Feature Doc |
|----|-------|----------|-------------|
| US-06 | As a writer, I want to create typed, bidirectional relationships between entities (e.g., "Kael — *leads* → Iron Pact") so I can model how my world connects. | P0 | [Relationships](./features/relationships.md) |
| US-07 | As a writer, I want the app to suggest reciprocal relationships when I create a link (e.g., creating "Kael leads Iron Pact" suggests "Iron Pact is led by Kael") so both sides stay consistent. | P0 | [Relationships](./features/relationships.md) |
| US-08 | As a writer, I want to see all backlinks on an entity detail page so I can discover implicit connections I didn't manually create. | P0 | [Relationships](./features/relationships.md) |
| US-09 | As a writer, I want an orphan detection view that lists entities with zero relationships so I can find forgotten or disconnected world elements. | P1 | [Relationships](./features/relationships.md) |

### Search & Navigation

| ID | Story | Priority | Feature Doc |
|----|-------|----------|-------------|
| US-10 | As a writer, I want full-text search across all entity names and field values so I can find anything in my world instantly. | P0 | [Search](./features/search.md) |
| US-11 | As a writer, I want a quick-switcher (Cmd+K / swipe gesture) that lets me jump to any entity by typing a few characters so navigation never breaks my flow. | P0 | [Search](./features/search.md) |
| US-12 | As a writer, I want to filter entity lists by type, tags, and custom field values so I can slice my world in different ways. | P1 | [Search](./features/search.md) |

### Timeline

| ID | Story | Priority | Feature Doc |
|----|-------|----------|-------------|
| US-13 | As a writer, I want to assign events to a timeline with relative ordering so I can visualize the chronology of my story world. | P1 | [Timeline](./features/timeline.md) |
| US-14 | As a writer, I want to link events to characters, factions, and locations so I can see who was involved in what and where. | P1 | [Timeline](./features/timeline.md) |

### Quick Capture

| ID | Story | Priority | Feature Doc |
|----|-------|----------|-------------|
| US-15 | As a writer, I want a quick-capture button that lets me create a named entity in under 5 seconds (name + type, everything else optional) so I can capture ideas without friction during a writing session. | P0 | [Quick Capture](./features/quick-capture.md) |

### Export & Data

| ID | Story | Priority | Feature Doc |
|----|-------|----------|-------------|
| US-16 | As a writer, I want to export my entire world as a structured JSON file so I own my data and can back it up or migrate. | P0 | [Export](./features/export.md) |
| US-17 | As a writer, I want a world stats dashboard (entity counts by type, relationship counts, most-connected entities) so I can gauge the scope and completeness of my worldbuilding. | P1 | [Stats](./features/stats.md) |

### Personalization

| ID | Story | Priority | Feature Doc |
|----|-------|----------|-------------|
| US-18 | As a writer, I want to tag entities with freeform tags so I can create cross-cutting categories beyond entity types (e.g., "Book 1", "Antagonist", "Needs Revision"). | P0 | [Tags](./features/tags.md) |
| US-19 | As a writer, I want a dark mode so I can worldbuild at night without eye strain. | P1 | [Theming](./features/theming.md) |

---

## 2. Non-Functional Requirements

### Performance

| Metric | Target | Measurement |
|--------|--------|-------------|
| Entity list load (1000+ entities) | < 500ms | Time from screen entry to full list render, measured with Flutter DevTools timeline |
| Full-text search results | < 300ms | Time from keystroke to results displayed, debounced at 250ms |
| Entity detail page load | < 200ms | Time from tap to full detail render including relationships |
| Cold start to interactive | < 3s | Time from app launch to home screen interactive, on mid-range Android (Snapdragon 6-series) |
| Relationship creation | < 100ms | Time from confirm to UI update, including reciprocal link |
| JSON export (1000 entities) | < 10s | Wall clock time to generate and write complete export file |

### Data Integrity

- **Soft deletes only.** No entity is ever physically deleted in V1. Soft-deleted entities are hidden from UI but retained in the database with a `deletedAt` timestamp.
- **SQLite transactions.** All multi-step writes (entity + relationships, bulk operations) are wrapped in transactions. A failed write rolls back completely — no partial state.
- **Referential integrity.** Foreign key constraints enforced at the database level. Deleting an entity soft-deletes its relationships (not orphans them).
- **Export always available.** JSON export works regardless of app state. If the database is readable, export works.
- **No silent data loss.** Destructive actions (delete, bulk edit) require explicit confirmation with undo window (minimum 5 seconds).

### Storage & Scale

| Metric | Target |
|--------|--------|
| Entity capacity | 5,000+ entities with full custom fields |
| Relationship capacity | 10,000+ relationships |
| Database size ceiling | < 100MB for max-scale world |
| Search index (FTS5) | Rebuild in < 30s for full corpus |
| App install size | < 50MB |

### Offline Guarantee

- **Zero network permissions.** The app does not declare `INTERNET` permission in the Android manifest.
- **Zero network calls.** No analytics, no crash reporting, no update checks, no telemetry. Nothing.
- **No degraded mode.** There is no "offline mode" because there is no "online mode." The app is fully functional without network access, always.

### Accessibility

| Requirement | Standard |
|-------------|----------|
| Color contrast | WCAG 2.1 AA (minimum 4.5:1 for normal text, 3:1 for large text) |
| Screen reader | All interactive elements have semantic labels via `Semantics` widget |
| Touch targets | Minimum 48x48dp per Material Design guidelines |
| Text scaling | Supports system font scaling up to 200% without layout breakage |
| Motion | Respects `Reduce Motion` system setting |

### Platform Requirements

| Requirement | Value |
|-------------|-------|
| Primary platform | Android |
| Minimum API level | API 26 (Android 8.0 Oreo) |
| Target API level | Latest stable (API 34+) |
| Framework | Flutter 3.x stable channel |
| Language | Dart 3.x with null safety |
| iOS | Not targeted for V1 (Flutter enables future port) |

---

## 3. Success Criteria for V1

V1 succeeds if the developer (target user) **actually uses it daily** for worldbuilding on an active novel project. Measurable criteria:

| Criterion | Target | How to Validate |
|-----------|--------|-----------------|
| Daily active use | 5+ days/week for 4+ consecutive weeks | Self-reported usage log |
| Entity count | 100+ entities created organically | Database query |
| Relationship density | Average 3+ relationships per entity | Database query |
| Search adoption | Quick-switcher used more than manual browsing | Usage pattern observation |
| Export reliability | Successful full export at 100+ entities, verified JSON parseable | Manual test |
| Zero data loss | No unintended data loss incidents | Incident log |
| Replaces existing tool | Stops using Notion/Obsidian for worldbuilding within 2 weeks | Self-reported |
| Cold start performance | Consistently < 3s on target device | Measured |
| No show-stopping bugs | Zero P0 bugs in 4-week validation period | Bug tracker |

> [!IMPORTANT]
> V1 success is binary: **does the developer use this instead of Notion for worldbuilding?** If yes, the concept is validated and worth investing in V1.x. If no, something fundamental is wrong.

---

## 4. MVP vs. Backlog

### Tier 1: MVP (V1.0)

Core worldbuilding loop — create, connect, find, export.

| Feature | Description | Stories |
|---------|-------------|---------|
| Entity CRUD | Create, read, update, soft-delete for all 8 entity types | US-01, US-02, US-05 |
| Custom fields | Add/edit/remove custom fields on any entity | US-03 |
| Templates | Save and apply entity templates | US-04 |
| Typed relationships | Bidirectional, typed links between any entities | US-06, US-07 |
| Backlinks | View all incoming relationships on entity detail | US-08 |
| Full-text search | FTS5-powered search across all entity content | US-10 |
| Quick-switcher | Fast entity navigation overlay | US-11 |
| Quick capture | Minimal-friction entity creation (name + type) | US-15 |
| Tags | Freeform tagging system | US-18 |
| JSON export | Full world export as structured JSON | US-16 |
| Dark mode | System-aware dark/light theming | US-19 |

### Tier 2: V1.x (Post-Validation)

Specialized views and richer content. Built only after V1 is validated.

| Feature | Description | Depends On |
|---------|-------------|------------|
| Graph view | Interactive, filterable entity relationship graph | Relationships |
| Basic timeline | Visual chronological event ordering | Events, Relationships |
| Timeline–entity linking | Events linked to characters, factions, locations on the timeline | Timeline, Relationships |
| Family tree view | Hierarchical character relationship visualization | Character relationships |
| Faction hierarchy | Nested faction structure view | Faction relationships |
| Orphan detection | Surface entities with zero relationships | Relationships |
| Filtered entity lists | Filter by type, tags, custom field values | Tags, Custom Fields |
| Version history | Per-entity edit history with diff view | Entity CRUD |
| Rich text fields | Markdown/rich text with `@entity` mentions | Entity CRUD |
| JSON import | Import a previously exported world | JSON Export |
| World stats | Dashboard with entity/relationship counts and metrics | Entity CRUD |

### Tier 3: V2+ (Future)

Major platform features. Speculative — built only if V1.x proves the model.

| Feature | Description | Notes |
|---------|-------------|-------|
| World map | Interactive map with pinned locations | Requires map renderer (e.g., Leaflet/custom) |
| Custom calendars | In-world calendar systems for timeline | Complex domain modeling |
| Name generator | Procedural name generation with cultural rules | Could be local ML or rule-based |
| Conflict detection | Flag contradictions across entities (e.g., dead character attending event) | Rule engine or constraint solver |
| Cloud sync | Encrypted, opt-in sync across devices | Requires backend infrastructure |
| AI integration | LLM-assisted worldbuilding suggestions | Opt-in, privacy-preserving, likely local models |
| iOS release | Port to iOS | Flutter makes this low-effort if Android is solid |
| Tablet / desktop | Adaptive layouts for larger screens | Flutter adaptive scaffold |

---

## 5. Risks and Mitigations

| # | Risk | Likelihood | Impact | Mitigation |
|---|------|------------|--------|------------|
| 1 | **Scope creep delays MVP.** Feature ambition expands faster than development velocity. | High | High | Hard-lock MVP scope to Tier 1 table above. No V1.x features leak into V1. Ship a working CRUD + relationships + search first, then iterate. |
| 2 | **Drift/SQLite performance degrades at scale.** Complex queries with 5000+ entities and 10000+ relationships may hit performance walls. | Medium | High | Benchmark early with synthetic data (1000, 5000, 10000 entities). Add database indexes proactively. Use pagination and lazy loading. Profile with `EXPLAIN QUERY PLAN`. |
| 3 | **Relationship modeling complexity.** Typed, bidirectional relationships with reciprocal suggestions are hard to get right — edge cases in deletion, circular references, relationship type validation. | High | Medium | Start with a small, fixed set of relationship types. Invest heavily in integration tests for relationship CRUD. Soft deletes make rollback possible. |
| 4 | **Solo developer bottleneck.** Single developer means no code review, no second pair of eyes, high bus factor. | High | Medium | Write comprehensive tests (unit + integration + widget). Document architecture decisions. Keep the codebase small and conventional — Clean Architecture + Riverpod is well-documented. |
| 5 | **Drift migration complexity.** Schema changes across versions require careful migration management. Drift's migration tooling is good but not foolproof. | Medium | High | Write migration tests from V1. Never modify existing migrations — only add new ones. Test migrations on real device databases. Keep a migration test suite that runs the full chain from V1 → latest. |
| 6 | **App doesn't replace existing workflow.** The developer continues using Notion because Fictionist is missing one critical feature or has too much friction. | Medium | Critical | Identify the minimum feature set that covers 80% of daily worldbuilding actions *before* building. Build quick-capture and search first — those are the high-frequency actions. Dogfood aggressively from week 1. |
| 7 | **Custom fields become a maintenance burden.** Schemaless custom fields stored in SQLite require careful serialization, validation, and FTS indexing. | Medium | Medium | Store custom fields as typed JSON in a dedicated table (not EAV). Limit custom field types to: text, number, date, boolean, single-select, multi-select. No nested objects. Index custom field values in FTS5 alongside default fields. |
| 8 | **Flutter/Android fragmentation.** Different Android versions, screen sizes, and OEM skins may cause UI inconsistencies. | Low | Medium | Target API 26+ (covers 95%+ of active devices). Test on 2-3 physical devices and emulators. Use Material 3 components which handle most fragmentation. Avoid platform-specific code. |
| 9 | **Data loss from no backup mechanism.** Device failure, factory reset, or accidental uninstall destroys the only copy of the world database. | Medium | Critical | JSON export is a manual backup (MVP). Add automatic local backup (daily snapshot to device storage) in V1.x. Cloud sync in V2+ provides off-device redundancy. Prominently remind users to export regularly. |
| 10 | **FTS5 index corruption or staleness.** Full-text search index can become stale if writes bypass the indexing pipeline, or corrupted on crash. | Low | Medium | Rebuild FTS index on app startup if staleness detected (checksum or row count mismatch). Provide manual "Rebuild Search Index" option in settings. Wrap FTS updates in the same transaction as entity writes. |

---

*Previous: [Product Overview](./01-overview.md) · Next: [Architecture](./03-architecture.md)*
