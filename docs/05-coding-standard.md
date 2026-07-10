# 05 — Coding Standards

> Non-negotiable conventions for the Fictionist codebase. Every PR must comply. No exceptions unless documented here.

---

## 1. Dart Conventions

### 1.1 Formatting

- **Use `dart format`** on every file, every commit. No manual formatting.
- Line length: **80 characters** (Dart default).
- Trailing commas on all multi-line argument lists, collections, and parameter lists. This gives clean diffs.

### 1.2 Analysis

Use `very_good_analysis` as the base rule set with project-specific overrides:

```yaml
# analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - '**/*.g.dart'
    - '**/*.freezed.dart'
    - '**/*.config.dart'
  errors:
    invalid_annotation_target: ignore

linter:
  rules:
    public_member_api_docs: false    # Enable later when API stabilizes
    lines_longer_than_80_chars: true
    prefer_single_quotes: true
    always_use_package_imports: true
```

### 1.3 Language Features

- Prefer `final` over `var`. Always.
- Use `const` constructors wherever possible.
- Pattern matching over `if/else` chains for sealed classes and enums.
- Records for lightweight multi-return values (Dart 3+).
- Use `switch` expressions, not `switch` statements, when returning a value.

---

## 2. Naming Conventions

### 2.1 Files

| Element | Convention | Example |
|---|---|---|
| All files | `snake_case.dart` | `entity_repository_impl.dart` |
| Test files | `*_test.dart` | `entity_dao_test.dart` |
| Generated files | `*.g.dart`, `*.freezed.dart` | `entity.freezed.dart` |
| Barrel exports | Feature name | `entity.dart` (avoid unless necessary) |

### 2.2 Classes and Types

| Element | Convention | Example |
|---|---|---|
| Classes | `PascalCase` | `EntityRepository` |
| Enums | `PascalCase` | `EntityType` |
| Enum values | `camelCase` | `EntityType.raceCulture` |
| Extensions | `PascalCase` + `X` suffix | `StringX`, `DateTimeX` |
| Typedefs | `PascalCase` | `EntityMap` |
| Mixins | `PascalCase` | `LoggingMixin` |

### 2.3 Riverpod Provider Naming

| Element | Convention | Example | Rationale |
|---|---|---|---|
| Notifier class | `FeatureNotifier` | `EntityListNotifier` | Manages state for a specific feature |
| Provider instance | `featureNotifierProvider` | `entityListNotifierProvider` | Generated access point (camelCase) |
| Read-only Provider | `featureProvider` | `entityRepositoryProvider` | Injecting dependencies |
| State class | `FeatureState` | `EntityListState` (if custom) or `AsyncValue<T>` | Represents the UI state model |

### 2.4 Architecture Naming

| Element | Convention | Example |
|---|---|---|
| Use case | `VerbNounUseCase` | `CreateEntityUseCase`, `SearchEntitiesUseCase` |
| Repository interface | `NounRepository` | `EntityRepository` |
| Repository impl | `NounRepositoryImpl` | `EntityRepositoryImpl` |
| DAO | `NounDao` | `EntityDao` |
| Mapper | `NounMapper` | `EntityMapper` |
| Domain entity | Singular noun | `Entity`, `Relationship`, `Tag` |
| Drift table | Plural noun | `Entities`, `Relationships`, `Tags` |

### 2.5 Variables and Parameters

| Element | Convention | Example |
|---|---|---|
| Local variables | `camelCase` | `entityList` |
| Private fields | `_camelCase` | `_repository` |
| Constants | `camelCase` (Dart convention) | `maxNameLength` |
| Named parameters | `camelCase` | `{required String entityId}` |
| Boolean variables | `is`/`has`/`should` prefix | `isDeleted`, `hasRelationships` |

---

## 3. Architecture Conventions

### 3.1 File Organization

- **One public class per file.** Private helper classes in the same file are fine.
- File name matches the primary class name: `EntityRepository` → `entity_repository.dart`.
- No barrel files (`index.dart` / feature re-exports) unless a package boundary demands it. Direct imports are explicit and greppable.

### 3.2 Domain Layer Rules

```
✅ DO                                    ❌ DON'T
─────────────────────────────────────    ─────────────────────────────────────
Import dart:core, dart:async, dart:math  Import package:flutter/*
Use freezed for entities                 Use mutable classes
Define abstract repository interfaces    Reference Drift, SQLite, or any DB
Return Either<Failure, T>               Throw exceptions
Keep entities as pure data              Put UI logic in entities
```

### 3.3 Data Layer Rules

- Repositories catch **all** exceptions from DAOs and wrap them in `Failure` types.
- Mappers are **stateless** — pure functions or static methods.
- DAOs use Drift's type-safe query API. Raw SQL only for FTS5 or `json_extract()` queries.
- Database migrations are **versioned and tested**. Never delete a migration step.

### 3.4 Presentation Layer Rules

- Providers/Notifiers depend on use cases. Never inject a repository directly into a Notifier.
- Widgets are dumb — they watch state via `ref.watch` and invoke methods on notifiers via `ref.read`. No business logic.
- Pages compose widgets, wrap feature scopes, and consume providers.
- Navigation uses `go_router` exclusively. No `Navigator.push` calls.

---

## 4. State Management Conventions

### 4.1 Riverpod Code Generation

All Riverpod notifiers and providers must use `riverpod_annotation` and the `build_runner` generator. This guarantees type safety, automatic dependency tracking, and automatic provider cleanup.

```dart
// entity_list_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/entity.dart';
import '../../domain/usecases/list_entities_use_case.dart';

part 'entity_list_provider.g.dart';

@riverpod
class EntityListNotifier extends _$EntityListNotifier {
  @override
  FutureOr<List<Entity>> build() async {
    // Read use case using standard dependency injection / provider
    final listEntities = ref.watch(listEntitiesUseCaseProvider);
    final result = await listEntities(const ListEntitiesParams());
    return result.fold(
      (failure) => throw failure, // Caught by AsyncValue.error
      (entities) => entities,
    );
  }

  Future<void> searchEntities(String query) async {
    state = const AsyncLoading();
    final searchEntities = ref.read(searchEntitiesUseCaseProvider);
    final result = await searchEntities(SearchEntitiesParams(query: query));
    
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (entities) => AsyncValue.data(entities),
    );
  }
}
```

### 4.2 State Emission Rules

| Rule | Rationale |
|---|---|
| Use `AsyncValue` for asynchronous operations | Standardizes loading/error/data states across all UI |
| Use `autoDispose` for page-specific providers | Releases memory immediately when user exits the page |
| Keep providers scoped to a single feature concern | Avoids massive god-notifiers |
| Read dependencies inside `build()` using `ref.watch()` | Ensures the provider automatically rebuilds when dependencies change |

---

## 5. Error Handling

### 5.1 The `Either` Pattern

All use cases and repositories return `Future<Either<Failure, T>>` using `fpdart`.

```dart
// Use case signature
abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

// No-params variant
abstract class UseCaseNoParams<T> {
  Future<Either<Failure, T>> call();
}
```

### 5.2 Failure Hierarchy

```dart
@freezed
sealed class Failure with _$Failure {
  /// Database read/write errors.
  const factory Failure.database({
    required String message,
    Object? originalError,
  }) = DatabaseFailure;

  /// Input validation errors (e.g., empty name, duplicate tag).
  const factory Failure.validation({
    required String message,
    String? field,
  }) = ValidationFailure;

  /// Entity/resource not found.
  const factory Failure.notFound({
    required String resourceType,
    required String resourceId,
  }) = NotFoundFailure;

  /// File system errors (map images, export files).
  const factory Failure.fileSystem({
    required String message,
    required String path,
  }) = FileSystemFailure;

  /// Anything else.
  const factory Failure.unexpected({
    required String message,
    Object? originalError,
    StackTrace? stackTrace,
  }) = UnexpectedFailure;
}
```

### 5.3 Error Handling Rules

| Layer | Rule |
|---|---|
| **DAO** | Let exceptions propagate. Don't catch here. |
| **Repository** | `try/catch` everything. Map exceptions to `Failure`. Return `Left(failure)`. |
| **Use case** | Compose repository calls. Add business validation (return `Left(ValidationFailure(...))` on invalid input). |
| **Notifier** | Fold `Either` — set state to `AsyncValue.data` on `Right`, `AsyncValue.error` on `Left`. |
| **Widget** | Use `state.when` or pattern matching on `AsyncValue` to show loading, error, and data UIs. Never catch exceptions. |

### 5.4 Exception to Failure Mapping (Repository)

```dart
@Injectable(as: EntityRepository)
class EntityRepositoryImpl implements EntityRepository {
  EntityRepositoryImpl(this._dao, this._mapper);

  final EntityDao _dao;
  final EntityMapper _mapper;

  @override
  Future<Either<Failure, Entity>> getById(String id) async {
    try {
      final row = await _dao.getById(id);
      if (row == null) {
        return Left(Failure.notFound(
          resourceType: 'Entity',
          resourceId: id,
        ));
      }
      return Right(_mapper.toDomain(row));
    } on DriftWrappedException catch (e) {
      return Left(Failure.database(
        message: 'Failed to fetch entity: ${e.message}',
        originalError: e,
      ));
    } catch (e, st) {
      return Left(Failure.unexpected(
        message: 'Unexpected error fetching entity',
        originalError: e,
        stackTrace: st,
      ));
    }
  }
}
```

---

## 6. Documentation

### 6.1 Dartdoc

- **Public APIs**: Every public class, method, and property gets a `///` dartdoc comment.
- **Private internals**: Skip unless the logic is non-obvious.
- **Use cases**: Document the business rule enforced, not the implementation.

```dart
/// Creates a new [Entity] with the given [params].
///
/// Returns [ValidationFailure] if:
/// - [CreateEntityParams.name] is empty or exceeds 200 characters.
/// - [CreateEntityParams.entityType] is null.
///
/// Automatically sets [Entity.status] to [EntityStatus.draft]
/// and generates a UUID v4 for the ID.
class CreateEntityUseCase implements UseCase<Entity, CreateEntityParams> {
  // ...
}
```

### 6.2 Code Comments

- **Don't** comment *what* the code does — the code should be self-explanatory.
- **Do** comment *why* — business decisions, tradeoffs, workarounds.

```dart
// BAD:
// Loop through entities and filter deleted ones
final active = entities.where((e) => !e.isDeleted).toList();

// GOOD:
// Soft-deleted entities stay in the DB for sync tombstones
// but are excluded from all user-facing queries.
final active = entities.where((e) => !e.isDeleted).toList();
```

### 6.3 TODO Convention

```dart
// TODO(username): Brief description — #issue-number
// TODO(alex): Add FTS5 indexing for custom field values — #42
```

Always include the author and a tracking reference. Orphan TODOs rot.

---

## 7. Git Conventions

### 7.1 Conventional Commits

Every commit message follows [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### 7.2 Types

| Type | Use when... |
|---|---|
| `feat` | Adding a new feature |
| `fix` | Fixing a bug |
| `refactor` | Restructuring code without changing behavior |
| `docs` | Documentation only |
| `test` | Adding or fixing tests |
| `chore` | Build, CI, dependency updates |
| `style` | Formatting, whitespace (no logic change) |
| `perf` | Performance improvement |

### 7.3 Scopes

Use the feature area as scope:

```
feat(entity): add custom field validation
fix(relationship): handle bidirectional query deduplication
refactor(dao): extract common query builder
test(provider): add entity list provider tests
docs(architecture): update ER diagram
chore(deps): bump drift to 2.23.0
```

### 7.4 Branch Strategy

| Branch | Purpose |
|---|---|
| `main` | Stable, releasable code |
| `develop` | Integration branch for features |
| `feat/<name>` | Feature branches off `develop` |
| `fix/<name>` | Bug fixes off `develop` (or `main` for hotfixes) |
| `refactor/<name>` | Refactoring branches |

### 7.5 PR Rules

- One feature per PR. No mega-PRs.
- All tests pass. No exceptions.
- `dart format` and `dart analyze` must be clean.
- Squash-merge to `develop`. Linear history.

---

## 8. Testing Conventions

### 8.1 Test Structure

```dart
void main() {
  group('EntityListNotifier', () {
    late ProviderContainer container;
    late MockListEntitiesUseCase mockListEntities;

    setUp(() {
      mockListEntities = MockListEntitiesUseCase();
      container = ProviderContainer(
        overrides: [
          // Override the dependency injected use case provider with our mock
          listEntitiesUseCaseProvider.overrideWithValue(mockListEntities),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('loads entities successfully and emits AsyncData', () async {
      when(() => mockListEntities(any()))
          .thenAnswer((_) async => Right(testEntities));

      // Read initial future to trigger execution
      final list = await container.read(entityListNotifierProvider.future);
      expect(list, equals(testEntities));
      
      // Verify use case was invoked
      verify(() => mockListEntities(any())).called(1);
    });
  });
}
```

### 8.2 What to Test

| Layer | Test type | Tool |
|---|---|---|
| **DAO** | Integration test with in-memory Drift DB | `flutter_test` + Drift's `NativeDatabase.memory()` |
| **Mapper** | Unit test | `flutter_test` |
| **Repository** | Unit test with mocked DAO | `mocktail` |
| **Use case** | Unit test with mocked repository | `mocktail` |
| **Provider** | Unit test using `ProviderContainer` overrides | `flutter_test` + `mocktail` |
| **Widget** | Widget test overriding providers on `ProviderScope` | `flutter_test` + `mocktail` |

### 8.3 Test File Location

Mirror the `lib/` structure under `test/`:

```
lib/domain/use_case/entity/create_entity_use_case.dart
→ test/domain/use_case/entity/create_entity_use_case_test.dart
```

---

## References

- [Architecture](file:///D:/Fictionist/docs/03-architecture.md)
- [Repository Structure](file:///D:/Fictionist/docs/04-repository-structure.md)
- [Effective Dart](https://dart.dev/effective-dart)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Riverpod Testing Guide](https://riverpod.dev/docs/essentials/testing)
