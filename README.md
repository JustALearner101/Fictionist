# Fictionist

<!-- TODO: Replace with actual CI badge -->
![Status](https://img.shields.io/badge/status-in%20development-blue)
![Platform](https://img.shields.io/badge/platform-Android-green)
![License](https://img.shields.io/badge/license-MIT-brightgreen)

**An offline-first mobile knowledge graph for fiction writers.** Fictionist lets novelists organize worldbuilding elements — characters, factions, races, locations, power systems, items, events, and concepts — as linked entities with typed relationships. Think personal wiki meets graph database, purpose-built for complex fantasy and sci-fi worlds, running entirely on your device with zero network dependency.

## Tech Stack

| Layer              | Choice                          |
| ------------------ | ------------------------------- |
| Framework          | Flutter 3.x (Dart)              |
| Database           | Drift (SQLite) + FTS5           |
| State Management   | Riverpod (`flutter_riverpod`)   |
| Architecture       | Clean Architecture + Repository |
| Dependency Injection | `get_it` + `injectable`       |
| Navigation         | `go_router`                     |
| Target Platform    | Android 8.0+ (API 26+)         |

## Documentation

### Core Docs

| Document | Description |
| -------- | ----------- |
| [Project Rules](docs/00-project-rules.md) | Working conventions, principles, and decision log |
| [Product Overview](docs/01-overview.md) | Problem statement, vision, design principles, competitive landscape |
| [PRD](docs/02-prd.md) | User stories, NFRs, success criteria, MVP scope, risks |
| [Architecture](docs/03-architecture.md) | Database decision, ER diagram, layer design, state management, export strategy |
| [Repository Structure](docs/04-repository-structure.md) | Flutter project folder layout and pubspec.yaml |
| [Coding Standard](docs/05-coding-standard.md) | Dart conventions, naming, architecture rules, error handling |
| [Testing Standard](docs/06-testing-standard.md) | Testing pyramid, patterns, coverage targets, CI integration |
| [Deployment](docs/07-deployment.md) | Build configs, signing, release checklist, code generation |
| [Roadmap](docs/08-roadmap.md) | Phased plan: MVP → V1.x → V2.0 → V3.0 |
| [UI/UX Design](docs/09-ui-ux.md) | Visual design tokens, typography, dark/light themes, and screen layout flows |

### Feature Specs

| Feature | Description |
| ------- | ----------- |
| [Entity Management](docs/features/01-entity-management.md) | CRUD, custom fields, templates, entity types |
| [Linking & Relationships](docs/features/02-linking-relationships.md) | Typed relationships, reciprocals, backlinks, relationship registry |
| [Specialized Views](docs/features/03-specialized-views.md) | Graph view, family tree, faction map, world map |
| [Timeline](docs/features/04-timeline.md) | Event tracking, era grouping, per-entity timelines |
| [Search & Navigation](docs/features/05-search-navigation.md) | Quick-switcher, FTS5, orphan detection, navigation structure |
| [Consistency Helpers](docs/features/06-consistency-helpers.md) | Reciprocal suggestions, duplicate warnings, version history |
| [Quality of Life](docs/features/07-quality-of-life.md) | Quick-capture, stats, dark mode, export/backup, onboarding |

## Quick Start

```bash
# Clone the repo
git clone https://github.com/your-username/fictionist.git
cd fictionist

# Install dependencies
flutter pub get

# Generate Drift and injectable code
dart run build_runner build --delete-conflicting-outputs

# Run on connected Android device or emulator
flutter run
```

### Prerequisites

- Flutter SDK 3.x (stable channel)
- Dart SDK (bundled with Flutter)
- Android SDK with API 26+ target
- An Android device or emulator

## Project Structure

```
lib/
├── core/           # Shared utilities, constants, theme, DI setup
├── data/           # Data sources, Drift database, repositories impl
├── domain/         # Entities, repository interfaces, use cases
└── presentation/   # Riverpod, pages, widgets (organized by feature)
```

## License

MIT — see [LICENSE](LICENSE) for details.
