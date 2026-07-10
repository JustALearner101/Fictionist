# Project Rules & Conventions

Ground rules for building Fictionist. Written for a solo developer, structured so a team can pick it up without archaeology.

---

## Scope Discipline

**V1 is offline-only. No AI. No server. No exceptions.**

Any feature that requires a network call is out of scope for V1. This is non-negotiable — the app must launch, operate, and store data with airplane mode on, permanently.

### Handling Scope Creep

1. If a feature idea requires network → write it up in the [Roadmap Backlog](#) with a `v2+` label. Do not prototype it, do not add "just the interface for later."
2. If a feature feels like it *might* fit V1 but isn't in the [PRD](02-prd.md) → add it to the backlog with rationale. Don't sneak it in.
3. The question to ask: *"Does this help a novelist organize their world offline, today?"* If no, it waits.

---

## Architecture Discipline

Clean Architecture with strict layer boundaries:

```
presentation → domain → data
```

- **Presentation** (Riverpod, pages, widgets) depends on **Domain** only.
- **Domain** (entities, use cases, repository interfaces) depends on nothing.
- **Data** (Drift DB, repository implementations, data sources) implements **Domain** interfaces.
- Presentation **never** imports from `data/`. No shortcuts. No "just this once."
- All cross-layer communication goes through repository interfaces defined in `domain/`.

Dependency injection via `get_it` + `injectable` enforces this at wiring time.

---

## Data Integrity

**User worldbuilding data is sacred. Never lose data.**

- **Soft deletes only.** Every entity has `is_deleted`. Hard deletes happen only via explicit "purge" actions (V2+).
- **SQLite transactions** wrap all multi-step writes. A crash mid-operation must not leave corrupted state.
- **Export/backup is always available.** The user can export their entire world to JSON at any time. This is a V1 feature, not a nice-to-have.
- **Defensive coding.** Validate inputs at the domain layer. Never trust raw user input to hit the database unvalidated.
- **Migrations are forward-only.** Drift schema migrations must be additive. Never drop columns with data. Test migrations against populated databases.

---

## Offline-First Is Not Optional

The app must never assume network connectivity. Concretely:

- Zero `http` / `dio` / network packages in `pubspec.yaml` for V1.
- No analytics, crash reporting, or telemetry that phones home.
- No remote config, feature flags from a server, or OTA updates outside Play Store.
- All assets (icons, fonts) are bundled locally.
- If a future feature needs network (sync, AI), it must be behind a feature gate and fully gracefully degraded when offline.

---

## Dependency Policy

Minimize third-party dependencies. Every `pub add` is a liability.

| Criteria | Threshold |
| -------- | --------- |
| pub.dev score | ≥85% (likes + pub points + popularity combined health) |
| Maintenance | Updated within last 6 months, or stable with no open critical issues |
| Null safety | Required (sound null safety) |
| License | MIT, BSD, or Apache 2.0 only |
| Platform support | Must support Android; no web-only or iOS-only packages |

Before adding a dependency, ask: *"Can I write this in <100 lines without it?"* If yes, write it yourself.

### Approved Core Dependencies

| Package | Purpose | Justification |
| ------- | ------- | ------------- |
| `flutter_riverpod` + `riverpod_annotation` | State management | Declarative, reactive, compile-time safe, and highly testable state management |
| `drift` + `sqlite3_flutter_libs` | Database | Type-safe SQLite, FTS5, migrations, code generation |
| `get_it` + `injectable` | DI | Compile-time safe DI with code generation |
| `go_router` | Navigation | Declarative routing, deep linking support |
| `uuid` | ID generation | Client-generated UUID v4 for offline-first entity IDs |
| `build_runner` | Code gen | Required by Drift, Riverpod generator, and injectable |
| `riverpod_generator` | Code gen | Generates type-safe providers automatically |
| `json_annotation` + `json_serializable` | JSON | Export/import serialization |
| `intl` | Date formatting | Locale-aware date display |

---

## Quality Bar

- **Every feature ships with tests.** Unit tests for use cases and Riverpod notifier logic. Widget tests for critical UI flows. Integration tests for database operations.
- **No merge without passing CI.** Set up GitHub Actions for `flutter analyze`, `flutter test`, and `dart format --set-exit-if-changed`.
- **Zero `dart analyze` warnings.** Treat warnings as errors in CI.
- **Consistent formatting.** `dart format` with default line length (80). No debates.
- **Linting.** Use `flutter_lints` (or `very_good_analysis`) with no rule overrides unless documented here.

---

## Code Ownership

Single developer today. Write code as if a team inherits it tomorrow.

- Every public class and non-obvious function gets a doc comment.
- Feature directories are self-contained: `presentation/features/entity_editor/` contains its providers, pages, and widgets.
- No god classes. If a file exceeds ~300 lines, it's time to decompose.
- Name things for what they *are*, not what they *do to the UI*. `EntityRepository`, not `EntityDataHelper`.

---

## Decision Log (ADR-Lite)

Major technical and product decisions, recorded for posterity.

| # | Date | Decision | Status | Rationale |
|---|------|----------|--------|-----------|
| ADR-001 | 2025-07 | **Entity types are pre-defined, not user-customizable (V1)** | Accepted | 8 core types (Character, Faction, Race/Culture, Location, Power/Magic System, Item/Artifact, Event, Concept/Glossary) cover the target use case. Custom types add significant UX and schema complexity. Custom *fields* per type provide flexibility without the cost. Revisit if validated users demand it. |
| ADR-002 | 2025-07 | **Drift (SQLite) as database** | Accepted | Typed relationships are inherently relational. Drift provides type-safe Dart queries, FTS5 for full-text search, migration support, and code generation. Isar is sunsetting. ObjectBox is NoSQL (wrong fit for relational entity graphs). Raw `sqflite` is too low-level for complex queries. |
| ADR-003 | 2025-07 | **Riverpod for state management** | Accepted | Declarative state, compile-time safety, and reactive dependency updates fit the personal knowledge graph paradigm well. `flutter_riverpod` provides excellent provider tracking and testability without BLoC's verbose boilerplate. |
| ADR-004 | 2025-07 | **Clean Architecture + Repository pattern** | Accepted | Strict layer separation enables future backend swaps (local → cloud sync) without rewriting business logic. Repository interfaces in domain layer abstract storage. Over-engineering risk is low given the app's data complexity. |
| ADR-005 | 2025-07 | **Client-generated UUID v4 for entity IDs** | Accepted | Offline-first means no server to issue IDs. UUIDs avoid collision without coordination. V4 is random, no timestamp leakage. Stored as TEXT in SQLite (36 chars). |
| ADR-006 | 2025-07 | **V1 targets Android only** | Accepted | Developer uses Android. iOS adds signing, provisioning, and App Store overhead with zero immediate users. Flutter's cross-platform means iOS is a build-flag away when needed. |
| ADR-007 | 2025-07 | **Dark mode as default theme** | Accepted | Target user (the developer) prefers dark mode. Light mode is a V1.x addition. Material 3 dynamic theming makes this straightforward. |
| ADR-008 | 2025-07 | **Markdown for entity descriptions** | Accepted | Rich enough for formatted lore text, simple enough to store as plain text in SQLite. Render with a markdown widget. No WYSIWYG editor complexity in V1 — raw markdown input with preview toggle. |

### Adding New Decisions

When making a significant technical or product decision:

1. Add a row to the table above with the next ADR number.
2. Set status to `Proposed`, `Accepted`, or `Superseded`.
3. Write rationale that explains *why*, not just *what*. Future-you will thank present-you.
