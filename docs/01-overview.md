# Product Overview

> **Fictionist** — An offline-first mobile knowledge graph for fiction worldbuilding.

## Problem Statement

Complex fantasy worldbuilding outgrows flat notes fast. A single epic fantasy novel can spawn hundreds of characters, dozens of factions, layered magic systems, branching timelines, and intricate location hierarchies — all deeply interconnected. Writers currently reach for general-purpose tools, and every one of them falls short:

- **Notion / Google Docs**: Powerful for flat documents, terrible for relationships. No typed links, no graph thinking, no offline mobile story. Notion's offline mode is a crippled cache, not a real database.
- **Obsidian**: Closest to the right model (backlinks, graph view), but it's a general knowledge tool. No entity types, no relationship semantics, no specialized views like timelines or faction hierarchies. Mobile app is an afterthought — sluggish, limited, and vault sync is a known pain point.
- **World Anvil**: Purpose-built for worldbuilding, but web-first and subscription-gated. Offline support is nonexistent. The UI is dense and opinionated toward TTRPG rather than novel writing. Free tier is crippled.
- **LegendKeeper**: Beautiful wiki-style tool with a map focus. Web-only, no mobile app, no offline mode. Indie project with uncertain long-term viability.
- **Campfire Write**: Decent entity management, but desktop-first with a clunky mobile experience. Relationship modeling is shallow — no typed links, no reciprocal relationships, no backlink surfacing.

The gap: **no tool is simultaneously offline-first, mobile-native, relationship-centric, and purpose-built for fiction writers.**

## Vision

Fictionist is a **personal knowledge graph purpose-built for fiction worldbuilding**, running entirely on-device.

The core idea: worldbuilding isn't note-taking — it's entity management. A character isn't a page of markdown; it's a typed object with structured fields, connected to factions, locations, events, and other characters through **typed, bidirectional relationships**. When you say "Kael is the leader of the Iron Pact," that relationship should be queryable from both sides, suggest reciprocal links, and surface in specialized views.

**The architecture is the product.** Entities + typed relationships + specialized views (timelines, hierarchies, graphs) — layered on top of a local SQLite database that never phones home.

## Target User

**V1: The developer.** A fullstack + AI/ML engineer writing an epic fantasy novel with 200+ characters, complex faction politics, multiple magic systems, and a branching timeline. The app is built to solve a real, personal problem first.

**Future (if validated):** Solo novelists and indie authors with complex worldbuilding needs — epic fantasy, sci-fi, historical fiction, sprawling series. Not casual writers. Not TTRPG game masters (World Anvil owns that). Not collaborative teams (V1 is single-user).

## Design Principles

### 1. Offline-First, Not Offline-Capable
Zero network calls. Not "works offline sometimes" — the app never touches the network. SQLite is the source of truth. No login, no account, no sync server. Data lives on the device, period. Cloud sync is a V2+ concern, and when it arrives, it will be opt-in and encrypted.

### 2. Relationship-Centric, Not Note-Centric
The fundamental unit is an **entity**, not a note. Entities have types, structured fields, and typed relationships to other entities. The relationship graph is a first-class data structure, not an afterthought bolted onto markdown links.

### 3. Opinionated Entity Types
Eight pre-defined entity types (Character, Faction, Race/Culture, Location, Power/Magic System, Item/Artifact, Event, Concept/Glossary) with type-specific default fields. This isn't a generic database — it knows what a character is, what a faction is, and what relationships between them look like. Custom fields provide escape hatches without sacrificing structure.

### 4. Progressive Disclosure
Quick-capture a character name in 5 seconds. Fill in details later. The app should never block creation with mandatory fields or complex forms. Start simple, add depth over time. Advanced features (graph view, timeline, custom calendars) surface as the world grows.

### 5. Data Sovereignty
Your world is yours. JSON export is always available. No vendor lock-in, no proprietary formats, no "please subscribe to export your data." The SQLite database is a standard file — if the app dies, your data doesn't.

## What Fictionist Is NOT

| Anti-Goal | Explanation |
|-----------|-------------|
| **Not a writing app** | No manuscript editor, no chapters, no prose composition. Use Scrivener, Google Docs, or whatever you write in. Fictionist manages the *world*, not the *story*. |
| **Not a wiki** | No markdown rendering engine, no wikilinks-as-primary-navigation. Entities are structured objects, not freeform pages. |
| **Not a general notes app** | No daily notes, no task management, no Zettelkasten. Purpose-built for fiction worldbuilding only. |
| **Not AI-powered (V1)** | No AI name generation, no AI relationship suggestions, no LLM integration. V1 is pure manual curation. AI features are V2+ and will be opt-in. |
| **Not collaborative** | Single-user, single-device. No real-time co-editing, no shared worlds. Collaboration is out of scope indefinitely. |

## Competitive Landscape

| Feature | Fictionist | Notion | Obsidian | World Anvil | LegendKeeper | Campfire |
|---|---|---|---|---|---|---|
| **Offline support** | ✅ Full (zero network) | ⚠️ Partial cache | ✅ Local vault | ❌ Web-only | ❌ Web-only | ⚠️ Desktop only |
| **Mobile-native** | ✅ Flutter/Android | ⚠️ Functional but slow | ⚠️ Sluggish, limited | ❌ Responsive web | ❌ None | ❌ Desktop-first |
| **Typed relationships** | ✅ Bidirectional, typed | ❌ Relations exist but untyped | ❌ Backlinks only | ⚠️ Some, rigid | ❌ Wiki links | ⚠️ Shallow |
| **Reciprocal suggestions** | ✅ Auto-suggested | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Specialized views** | ✅ Timeline, graph, hierarchy | ❌ Generic views | ⚠️ Graph (untyped) | ✅ Many (TTRPG-focused) | ✅ Maps | ⚠️ Basic |
| **Entity types** | ✅ 8 pre-defined + custom fields | ❌ Generic databases | ❌ All pages equal | ✅ Many (overwhelming) | ⚠️ Generic articles | ✅ Modules |
| **Data export** | ✅ JSON, always free | ⚠️ Markdown export | ✅ Local files | ⚠️ Paid tiers | ⚠️ Limited | ⚠️ Limited |
| **Pricing** | Free (open-source V1) | Freemium ($8-10/mo) | Free core (sync $4/mo) | Freemium ($5-13/mo) | $9/mo | One-time $44.95 |
| **Target audience** | Solo novelists | Everyone | PKM enthusiasts | TTRPG + worldbuilders | Worldbuilders | Writers |

### Why Not Just Use Obsidian?

Obsidian is the closest competitor and the most likely objection. The answer:

1. **No entity types.** Every note is equal. A character and a location are the same thing — a markdown file. You can fake structure with YAML frontmatter and Dataview, but it's brittle, requires plugin maintenance, and breaks constantly.
2. **No typed relationships.** `[[links]]` are untyped. You can't query "all characters who are members of this faction" without manually maintaining Dataview queries. Fictionist relationships are first-class relational data.
3. **Mobile is an afterthought.** The Obsidian mobile app is functional but slow, with limited plugin support and sync issues. Fictionist is mobile-first.
4. **No specialized views.** Obsidian's graph view is pretty but useless at scale — an undifferentiated hairball. Fictionist's graph view will be typed and filterable. Timeline, faction hierarchy, and family tree views don't exist in Obsidian without fragile community plugins.

---

*Next: [Product Requirements Document](./02-prd.md)*
