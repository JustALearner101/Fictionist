# AI Agent Guide & Codebase Map (AGENTS.md)

> Welcome, fellow AI. This document serves as your cognitive anchor and map for the Fictionist codebase. Read this first before writing code, modifying database schemas, or introducing state changes.

---

## 1. Core Mandates (Strict Constraints)

1.  **State Management is Riverpod:** The codebase uses `flutter_riverpod` + `riverpod_annotation` with `build_runner` code generation. **Do NOT write BLoC or Cubit classes.**
2.  **Strict Offline-First (Airplane Mode):** The app runs 100% locally. Zero network permissions, zero analytics, zero external API integrations. Do not add `http`, `dio`, or cloud service dependencies.
3.  **Strict Clean Architecture:** 
    *   `presentation` → `domain` ← `data`.
    *   `domain` layer has **zero Flutter imports** and depends on nothing.
    *   `presentation` layer must communicate with the database **only** via Use Cases defined in `domain`. Never inject repositories or DAOs directly into widgets or providers.
4.  **Error Handling (No Silent Swallowing):** All repositories and use cases must return `Either<Failure, T>` from `fpdart`. Throwing exceptions is restricted to the data source layer; they must be caught and mapped in the repository implementations.

---

## 2. Codebase Sitemap & Reading List

Before you edit a specific feature, check these core documentation files:

### 2.1 Technical Foundation (Read First)
*   [Project Rules & Decision Log (ADR)](docs/00-project-rules.md): Scope limits, approved dependencies list, and ADR decision history.
*   [System Architecture Guide](docs/03-architecture.md): Visual layouts, entity ER-diagram, Riverpod patterns, and future sync layers.
*   [Folder Directory Tree](docs/04-repository-structure.md): Layout blueprint, file locations, layer rules, and exact `pubspec.yaml` dependency rules.
*   [Coding Standards & Styles](docs/05-coding-standard.md): Naming rules, code style guidelines, error mapping conventions, and code-generation syntax templates.
*   [Testing Standards](docs/06-testing-standard.md): Testing guidelines, mocking templates (`mocktail`), and unit tests for notifiers.

### 2.2 Feature Specifications
*   [Entity CRUD Spec](docs/features/01-entity-management.md): Entity structures, built-in templates, custom fields, and soft deletion rules.
*   [Typed Relationships Spec](docs/features/02-linking-relationships.md): Linking rules, bidirectional storage strategy, and reciprocal auto-suggestion flows.
*   [Specialized Views Spec](docs/features/03-specialized-views.md): Force-directed graphs, character family trees, and interactive world map specs.
*   [timeline Spec](docs/features/04-timeline.md): String-based chronological event tracks, manual sort orders, and era grouping.
*   [Search & Switcher Spec](docs/features/05-search-navigation.md): Fuzzy quick-switcher, SQLite FTS5 index configurations, and orphan detection.
*   [Consistency Helpers Spec](docs/features/06-consistency-helpers.md): Reciprocal suggestion logic, version history snapshots, and duplicate warnings.
*   [Quality of Life Spec](docs/features/07-quality-of-life.md): Quick-capture inbox, dark theme color schemes, name generator, and JSON export schema.

---

## 3. Mandatory Development Workflow

Whenever you modify models, providers, or database schemas:

1.  **Define the Domain Model:** Create or edit pure Dart classes in `lib/domain/entities/` using `@freezed` if they require value equality or copying.
2.  **Define Repository Interface:** Expose actions in `lib/domain/repository/` with `Either<Failure, T>` return values.
3.  **Define Use Case:** Write a single-responsibility use case class extending `UseCase<Type, Params>` under `lib/domain/usecases/`.
4.  **Implement in Data Layer:**
    *   Create or edit Drift table definitions in `lib/data/database/tables/`.
    *   Expose Drift-specific queries in a dedicated DAO under `lib/data/database/daos/`.
    *   Write the repository implementation under `lib/data/repositories/` catching database exceptions.
5.  **Expose Presentation via Riverpod:**
    *   Write code-generated notifier classes using `@riverpod` annotations under `lib/presentation/features/<feature>/provider/`.
    *   Use `AsyncValue` to represent loading, error, and loaded states.
6.  **Run Code Gen:** Execute the builder to output generated code:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
7.  **Write Tests:** Mirror the directory structure under `test/` and write tests using the mock templates defined in the [Testing Standard](docs/06-testing-standard.md).
