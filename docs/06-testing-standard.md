# 06 — Testing Standards

> Testing strategy for Fictionist. Behavior-first, high coverage on domain/data, pragmatic on UI.

---

## 1. Testing Philosophy

**Test behavior, not implementation.** Tests assert *what* the system does, not *how* it does it internally. If you refactor a repository from one query strategy to another and the output is identical, zero tests should break.

Coverage targets:

| Layer | Target | Rationale |
|---|---|---|
| Domain (entities, value objects, use cases) | >90% | Pure logic, easy to test, highest ROI |
| Data (repositories, DAOs, mappers) | >80% | Critical persistence logic, complex queries |
| Presentation (Providers) | >80% | Provider state emissions and logic are deterministic |
| Presentation (Widgets) | Critical flows only | Diminishing returns; cover happy paths and error states |
| Integration | Key journeys | End-to-end confidence on real (in-memory) DB |

**Non-negotiable rules:**
- Every use case has a corresponding test file.
- Every mapper has input→output coverage for all branches.
- Every Riverpod provider/notifier has unit tests covering its actions.
- No test should depend on execution order or shared mutable state.

---

## 2. Testing Pyramid

```
         ╱╲
        ╱  ╲         Golden tests (optional)
       ╱────╲
      ╱      ╲       Widget tests (critical screens)
     ╱────────╲
    ╱          ╲      Integration tests (DB, repos)
   ╱────────────╲
  ╱              ╲    Unit tests (use cases, mappers, validators, domain logic)
 ╱────────────────╲
```

### Unit Tests (70% of test volume)
- Use cases, domain entities, value objects
- Mappers (model ↔ entity conversions)
- Validators (entity name rules, custom field constraints)
- Utility functions (slug generation, date formatting, search tokenization)

### Integration Tests (20%)
- Database operations using Drift's in-memory SQLite (`NativeDatabase.memory()`)
- Repository implementations with real DB — test CRUD, FTS, relationships, soft deletes
- Multi-table operations (cascade behaviors, relationship consistency)

### Widget Tests (8%)
- Key screens with mocked Providers/Notifiers overridden in the `ProviderScope`
- Form validation feedback
- Navigation flows (create → detail, search → result)

### Golden Tests (2%, optional)
- Complex custom widgets only (graph nodes, timeline bars)
- Skip unless you build custom paint widgets

---

## 3. Test Organization

Mirror `lib/` structure exactly under `test/`:

```
test/
├── fixtures/                          # Shared test data
│   ├── entity_fixtures.dart           # Factory functions for test entities
│   ├── relationship_fixtures.dart
│   └── builders/                      # Builder pattern for complex objects
│       ├── character_builder.dart
│       └── location_builder.dart
│
├── core/
│   └── utils/
│       └── slug_generator_test.dart
│
├── features/
│   └── entity_manager/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── entity_test.dart
│       │   └── usecases/
│       │       ├── create_entity_test.dart
│       │       ├── update_entity_test.dart
│       │       └── get_entities_by_type_test.dart
│       ├── data/
│       │   ├── mappers/
│       │   │   └── entity_mapper_test.dart
│       │   ├── datasources/
│       │   │   └── entity_local_datasource_test.dart
│       │   └── repositories/
│       │       └── entity_repository_impl_test.dart
│       └── presentation/
│           ├── provider/
│           │   └── entity_list_provider_test.dart
│           └── pages/
│               └── entity_list_page_test.dart
│
├── integration/
│   ├── database/
│   │   ├── entity_dao_integration_test.dart
│   │   ├── relationship_dao_integration_test.dart
│   │   ├── fts_integration_test.dart
│   │   └── migration_test.dart
│   └── workflows/
│       ├── create_entity_workflow_test.dart
│       └── export_import_roundtrip_test.dart
│
└── helpers/
    ├── test_database.dart             # In-memory DB setup/teardown
    ├── mock_repositories.dart         # Shared mocktail mocks
    └── pump_app.dart                  # Widget test helper (MaterialApp wrapper)
```

### Test File Conventions

- File name: `<source_file_name>_test.dart`
- Group tests by behavior using `group()`:

```dart
group('CreateEntity', () {
  group('when input is valid', () {
    test('should return the created entity', () { ... });
    test('should persist to repository', () { ... });
  });

  group('when entity name is empty', () {
    test('should return a validation failure', () { ... });
  });
});
```

### Test Data Factories

Use factory functions over raw constructors. Provide sensible defaults, override what matters:

```dart
// test/fixtures/entity_fixtures.dart
Entity makeEntity({
  String? id,
  String? name,
  EntityType type = EntityType.character,
  EntityStatus status = EntityStatus.draft,
  DateTime? createdAt,
}) {
  return Entity(
    id: id ?? const Uuid().v4(),
    name: name ?? faker.person.name(),
    type: type,
    status: status,
    description: faker.lorem.sentences(3).join(' '),
    createdAt: createdAt ?? DateTime.now(),
    updatedAt: DateTime.now(),
    isDeleted: false,
  );
}

List<Entity> makeEntities(int count, {EntityType? type}) {
  return List.generate(count, (_) => makeEntity(type: type));
}
```

---

## 4. Key Testing Patterns

### Riverpod Provider Testing

Use `ProviderContainer` to instantiate providers and mock their use case dependencies using container overrides. Never test widget bindings in pure unit tests.

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

class MockGetEntitiesByType extends Mock implements GetEntitiesByType {}

void main() {
  late ProviderContainer container;
  late MockGetEntitiesByType mockGetEntities;

  setUp(() {
    mockGetEntities = MockGetEntitiesByType();
    container = ProviderContainer(
      overrides: [
        getEntitiesByTypeUseCaseProvider.overrideWithValue(mockGetEntities),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('EntityListNotifier', () {
    final entities = makeEntities(3, type: EntityType.character);

    test('initializes and emits AsyncData when loading succeeds', () async {
      when(() => mockGetEntities(EntityType.character))
          .thenAnswer((_) async => Right(entities));

      // Read future to run initialization
      final state = await container.read(entityListNotifierProvider(EntityType.character).future);
      expect(state, equals(entities));
      verify(() => mockGetEntities(EntityType.character)).called(1);
    });

    test('emits AsyncError when loading fails', () async {
      final failure = Failure.database(message: 'DB error');
      when(() => mockGetEntities(EntityType.character))
          .thenAnswer((_) async => Left(failure));

      // Assert that reading the future throws the failure
      expect(
        () => container.read(entityListNotifierProvider(EntityType.character).future),
        throwsA(equals(failure)),
      );
    });
  });
}
```

### Repository Testing (Integration)

Use Drift's in-memory database. Real SQL, real queries, no mocking.

```dart
import 'package:drift/native.dart';

void main() {
  late AppDatabase db;
  late EntityRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = EntityRepositoryImpl(db);
  });

  tearDown(() => db.close());

  group('EntityRepositoryImpl', () {
    test('should insert and retrieve an entity', () async {
      final entity = makeEntity(name: 'Aldric');
      await repository.create(entity);

      final result = await repository.getById(entity.id);

      expect(result.name, equals('Aldric'));
    });

    test('soft delete should exclude from default queries', () async {
      final entity = makeEntity();
      await repository.create(entity);
      await repository.softDelete(entity.id);

      final results = await repository.getAll();
      expect(results, isEmpty);
    });

    test('FTS should match partial names', () async {
      await repository.create(makeEntity(name: 'Kingdom of Aldara'));
      await repository.create(makeEntity(name: 'Aldric the Bold'));

      final results = await repository.search('Ald*');
      expect(results, hasLength(2));
    });
  });
}
```

### Use Case Testing

Mock the repository interface. Verify correct delegation and return values.

```dart
class MockEntityRepository extends Mock implements EntityRepository {}

void main() {
  late CreateEntity useCase;
  late MockEntityRepository mockRepo;

  setUp(() {
    mockRepo = MockEntityRepository();
    useCase = CreateEntity(mockRepo);
  });

  test('should call repository.create with the entity', () async {
    final entity = makeEntity();
    when(() => mockRepo.create(entity)).thenAnswer((_) async => entity);

    final result = await useCase(entity);

    expect(result, Right(entity));
    verify(() => mockRepo.create(entity)).called(1);
  });
}
```

### Mapper Testing

Pure functions. No mocking. Feed input, assert output.

```dart
void main() {
  group('EntityMapper', () {
    test('should map EntityModel to Entity', () {
      final model = EntityModel(
        id: 'abc-123',
        name: 'Eldara',
        type: 'location',
        status: 'canon',
        description: 'A lost city',
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 6, 1),
        isDeleted: false,
      );

      final entity = EntityMapper.toEntity(model);

      expect(entity.id, 'abc-123');
      expect(entity.name, 'Eldara');
      expect(entity.type, EntityType.location);
      expect(entity.status, EntityStatus.canon);
    });

    test('should handle unknown type gracefully', () {
      final model = EntityModel(/* ... type: 'unknown_type' */);
      expect(
        () => EntityMapper.toEntity(model),
        throwsA(isA<MappingException>()),
      );
    });
  });
}
```

---

## 5. Specific Test Scenarios

### Entity CRUD

| Scenario | What to Assert |
|---|---|
| Create entity with valid data | Returns created entity, persisted in DB |
| Create entity with empty name | Returns validation failure |
| Create entity with duplicate name (same type) | Succeeds (names aren't unique) OR warns — decide and test |
| Read entity by ID | Returns correct entity |
| Read non-existent entity | Returns `NotFoundFailure` |
| Update entity fields | Updated fields persist, `updatedAt` changes |
| Soft-delete entity | Excluded from `getAll()`, retrievable via `getDeleted()` |
| List entities by type | Returns only matching type |
| List entities by status | Filters correctly on `draft`, `canon`, `archived`, `deprecated` |
| List entities with pagination | Offset/limit works correctly |

### Relationships

| Scenario | What to Assert |
|---|---|
| Create relationship A→B | Persisted, queryable from A's relationships |
| Auto-create reciprocal B→A | Reciprocal exists with correct inverse type |
| Delete relationship A→B | Also deletes reciprocal B→A |
| Query backlinks for entity B | Returns all entities pointing to B |
| Filter relationships by type | Returns only matching relationship type |
| Self-referencing relationship | A→A should be allowed (e.g., "alias_of" self) or rejected — test the decision |
| Relationship to soft-deleted entity | Should be excluded from active queries |

### Search (FTS)

| Scenario | What to Assert |
|---|---|
| Exact name match | Returns entity |
| Partial match (prefix) | `Ald*` matches "Aldric" |
| Match in description field | Found when searching description text |
| No results | Returns empty list, no error |
| Special characters in query | Doesn't crash, handles gracefully (escape or strip) |
| Search after soft-delete | Soft-deleted entities excluded from results |

### Quick-Capture

| Scenario | What to Assert |
|---|---|
| Create quick-capture note | Persisted with timestamp |
| List unprocessed notes | Returns only items not yet converted |
| Process note → entity | Creates entity, marks note as processed |
| Process note with type selection | Correct entity type assigned |

### Timeline

| Scenario | What to Assert |
|---|---|
| Events ordered chronologically | Correct sort order |
| Filter timeline by entity | Only related events shown |
| Era grouping | Events grouped by era boundaries |
| Events without dates | Handled gracefully (end of list or separate section) |

### Export / Import

| Scenario | What to Assert |
|---|---|
| JSON export structure | Valid JSON, contains all entity types, relationships, metadata |
| Export completeness | All entities, relationships, tags, custom fields included |
| Import round-trip | Export → Import → state matches original |
| Import into non-empty DB | Conflict handling (skip, overwrite, merge) |

### Edge Cases & Performance

| Scenario | What to Assert |
|---|---|
| Entity with very long description (10K+ chars) | Creates and retrieves without truncation |
| Entity with maximum custom fields (20+) | All fields persist and retrieve |
| Duplicate entity names (same type) | System behavior is correct per design decision |
| 1000+ entities in database | List/search/filter completes in <500ms |
| Rapid sequential creates | No race conditions, all persisted |
| Unicode entity names | Full Unicode support (Chinese, Arabic, emoji) |

---

## 6. CI Integration

### Pipeline Steps

```yaml
# .github/workflows/test.yml (or equivalent)
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: stable

      - name: Install dependencies
        run: flutter pub get

      - name: Run code generation
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Analyze
        run: flutter analyze --fatal-infos

      - name: Run tests with coverage
        run: flutter test --coverage

      - name: Check coverage threshold
        run: |
          # Fail if total coverage drops below 75%
          # Use lcov or a custom script to parse coverage/lcov.info
          genhtml coverage/lcov.info -o coverage/html
          # Parse and enforce threshold

      - name: Upload coverage report
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/html/
```

### Policies

- **Zero warnings:** `flutter analyze --fatal-infos` must pass. No `// ignore:` without a comment explaining why.
- **Coverage gate:** Build fails if coverage drops below 75% overall. Domain/data layers enforced at 80%.
- **Pre-commit hook (optional):** Run `flutter analyze` and `flutter test` locally before push.

```bash
# .githooks/pre-commit
#!/bin/sh
flutter analyze --fatal-infos || exit 1
flutter test || exit 1
```

---

## 7. Tools & Packages

| Package | Purpose | Dev/Prod |
|---|---|---|
| `flutter_test` | Built-in test framework | dev |
| `mocktail` | Mocking (null-safe, no codegen, simpler than mockito) | dev |
| `drift` | In-memory SQLite for integration tests (`NativeDatabase.memory()`) | prod (testing mode) |
| `faker_dart` | Generate realistic test data (names, text, dates) | dev |
| `very_good_analysis` | Lint rules (optional, strict defaults) | dev |

### Why mocktail over mockito

- No code generation required (`build_runner` not needed for mocks)
- First-class null safety
- Simpler API: `when(() => mock.method()).thenReturn(value)`
- `registerFallbackValue()` for custom types

### pubspec.yaml (dev_dependencies)

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.0
  faker_dart: ^0.2.0
```

---

## Quick Reference: Test Commands

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/entity_manager/domain/usecases/create_entity_test.dart

# Run tests matching a name pattern
flutter test --name "should create entity"

# Run with coverage
flutter test --coverage

# Run only integration tests
flutter test test/integration/

# Generate HTML coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
```
