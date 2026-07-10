# 09 — UI/UX Design System & Specification

> Visual design guidelines and screen specs for Fictionist. The interface is designed as **"The Gilded Codex"** — combining a premium digital library/book aesthetic with a high-density, low-fatigue writer's database.

---

## 1. The Design Concept: "The Gilded Codex"

Fictionist is not a flat business database or a standard task manager. It is a portal to an epic world. The UI must feel like a **modern grimoire or digital library** — rich, structured, and immersive — but avoid over-the-top fantasy skeumorphism (no heavy wood textures or parchment paper background images that hinder legibility).

### Core Principles
1. **Aesthetic Immersive, Execution Clean:** Use elegant typography and a rich color palette, but keep layouts structured, borders thin, and margins generous.
2. **Deep Mystic Purple base:** Purple represents magic, depth, and creative worldbuilding. It serves as the primary visual anchor.
3. **Manuscript Typographic Contrast:** Combine elegant serif headers (like opening a classical novel) with ultra-readable sans-serif body text (for editing and data density).
4. **Tactile Digital Indexing:** UI cards, list tiles, and panels should evoke the feel of tactile cards, catalog drawers, and book spines.

---

## 2. Visual Tokens & Color Palette

### 2.1 The Color System
The color scheme is designed for high-contrast readability in both dark and light modes. Dark mode is the primary default, optimized for late-night writing sessions.

```
Mystic Velvet (BG) ──► Royal Violet (Primary) ──► Gilded Amber (Accent)
   #120E16                #8B5CF6                     #D4A373
```

| Token | Dark Theme (Default) | Light Theme | Role / Usage |
|---|---|---|---|
| **Primary (Amethyst)** | `#A78BFA` | `#6D28D9` | Brand color, primary buttons, highlighted text |
| **Secondary (Gilded Amber)** | `#D4A373` | `#B58554` | Canon status badges, timeline markers, interactive focal points |
| **Background (Mystic Velvet)**| `#120E16` | `#F9F8FA` | Full-screen app background |
| **Surface (Obsidian Ink)** | `#1E1A24` | `#FFFFFF` | Cards, text inputs, dialog box backgrounds |
| **Surface Variant (Slate Velvet)**| `#2D2836`| `#F0EDF5` | Secondary cards, tag backgrounds, disabled fields |
| **Text Primary (Parchment)** | `#E2E0E6` | `#1A191C` | High-density body text, headings |
| **Text Secondary (Ink Mist)** | `#9E9AA6` | `#625E6A` | Subtitles, field labels, metadata counts |
| **Border (Iron Filigree)** | `#3A3445` | `#E1DCE8` | Card borders, table dividers, form outlines (thin, 1dp) |
| **Success (Canon Green)** | `#34D399` | `#059669` | Canon status, confirmed relationships |
| **Warning (Draft Amber)** | `#FBBF24` | `#D97706` | Draft status, duplicate name warnings |
| **Error (Broken Quill)** | `#F87171` | `#DC2626` | Deprecated status, delete actions, validation errors |

---

## 3. Typography Hierarchy

To maintain the digital library aesthetic, the typography uses a dual-font structure:
*   **Header Font:** A premium Serif font (e.g., *Lora*, *Playfair Display*, or *Cormorant Garamond* via Google Fonts).
*   **Body Font:** A highly legible Sans-Serif font (e.g., *Inter* or *Outfit*).

```
[ Lora - Bold Serif ] ──────────► [ Inter - Sans-Serif ]
  "The genius society of elves"      "Established in the age of Ash..."
```

### Typographic Scales (M3 Compliant)
*   **Display Large (Serif, Bold, 32sp):** Screen titles (e.g., Entity Name on Detail Page).
*   **Headline Medium (Serif, SemiBold, 24sp):** Section titles (e.g., "Relationships", "Timeline").
*   **Title Medium (Sans-Serif, Medium, 16sp):** Card titles, list headers, list tiles.
*   **Body Large (Sans-Serif, Regular, 16sp):** Markdown content, notes, entity descriptions.
*   **Label Medium (Sans-Serif, SemiBold, 12sp):** Badges, tags, form field labels, metadata.

---

## 4. Entity-Type Visual System

To help writers instantly scan lists and graphs, each of the 8 entity types has a dedicated icon glyph and secondary accent color.

| Entity Type | Mapped Icon | Color Accent | Aesthetic Intent |
|---|---|---|---|
| **Character** | `Icons.person_outline` | Amethyst (`#A78BFA`) | Individuals, agency, relationships |
| **Faction** | `Icons.shield_outlined` | Gold (`#F59E0B`) | Shield / banner representing groups |
| **Race/Culture** | `Icons.fingerprint` | Emerald (`#10B981`) | Identity, ancestry, traditions |
| **Location** | `Icons.map_outlined` | Sapphire (`#3B82F6`) | Geography, physical space |
| **Power System** | `Icons.bolt` | Crimson (`#EF4444`) | Rules, magic, energy |
| **Item/Artifact**| `Icons.auto_awesome` | Amber (`#FBBF24`) | Relics, items, legendary weapons |
| **Event** | `Icons.auto_stories` | Rose (`#F43F5E`) | Chapters, timeline items, milestones |
| **Concept** | `Icons.lightbulb_outline` | Teal (`#14B8A6`) | Ideas, philosophies, magic laws |

---

## 5. Layout & Screen Specifications

### 5.1 Dashboard (The Library Desk)
The first screen the user sees. It feels like an organized writer's desk — displaying stats, recent entries, and a quick-capture drawer.

```
+-------------------------------------------------+
| [Icon] FICTIONIST                 [Search Icon] |
+-------------------------------------------------+
| Welcome, Archivist                              |
| World Stats: 104 Entities | 412 Links           |
|                                                 |
| +-----------+  +-----------+  +---------------+ |
| | 52 Chars  |  | 14 Locs   |  | 12 Orphans ⚠️  | |
| +-----------+  +-----------+  +---------------+ |
|                                                 |
| RECENT SCROLLS                                  |
| ─────────────────────────────────────────────── |
| [Char] Elidor Thorne             (Canon) 2m ago |
| [Loc]  Scania Valley             (Draft) 1h ago |
| [Fact] Genius Society            (Canon) 4h ago |
|                                                 |
| UNPROCESSED INBOX (3)                           |
| ─────────────────────────────────────────────── |
| - "Need custom runic name for Scania weapons"   |
| - "Elidor's sword has a split blade?"           |
|                                                 |
| [ + Quick Capture Idea ]                        |
+-------------------------------------------------+
```

#### Key UX Specs:
*   **Stats Carousel:** Horizontal scroll of high-level stats (counts, orphans, pending inbox ideas). Tapping a card filters the main library by that type/status.
*   **Inbox Quick Actions:** Swipe right on an inbox idea to convert it to an Entity immediately; swipe left to archive/delete.
*   **Quick Capture FAB:** A persistent purple floating action button on the dashboard that slides open a single, distraction-free bottom sheet text field.

---

### 5.2 Entity Detail View (The Codex Page)
Designed to read like a beautifully typeset page from an encyclopedia. Information scales progressively.

```
+-------------------------------------------------+
| [Back]                                [Edit/More] |
+-------------------------------------------------+
| Character · Canon                               |
| ELIDOR THORNE                                   |
|                                                 |
| [Tag: Elf] [Tag: Mage] [Tag: Scania]            |
| ─────────────────────────────────────────────── |
| A high scholar of the Genius Society who was    |
| exiled for investigating the Scania Valley      |
| anomaly. Known for wielding the Iron Quill.     |
|                                                 |
| [ Fields ]   [ Relationships ]   [ Timeline ]   |
|                                                 |
|  * Age: 142 years                               |
|  * Title: Exiled Scholar                        |
|  * Physical Description: Tall, carrying...      |
|                                                 |
| BACKLINKS (2)                                   |
| ─────────────────────────────────────────────── |
| [Item] Iron Quill - owned by Elidor Thorne      |
| [Fact] Genius Society - exiled Elidor Thorne    |
+-------------------------------------------------+
```

#### Key UX Specs:
*   **Header Backdrop:** A very subtle radial gradient matching the Entity Type's accent color (e.g., soft purple glow behind "Elidor Thorne") fades into the background.
*   **Markdown Support:** The description supports standard markdown. Entity mentions (e.g., `@Scania Valley`) are rendered as inline clickable links (`InkWell` buttons highlighted in primary color).
*   **Segmented Control / Tab Bar:** Quickly switch between "Fields" (custom fields), "Relationships" (and backlinks), and "Timeline" (specific history).
*   **Backlinks Drawer:** Always visible at the bottom of the Relationships tab. Shows which items or factions mention this entity.

---

### 5.3 Relationship Connector Sheet
A clean modal sheet designed to link entities with semantic types.

```
+-------------------------------------------------+
| Link Entities                                   |
| ─────────────────────────────────────────────── |
| Source: [ Elidor Thorne ]                       |
|                                                 |
| Relationship Type:                              |
| ( ) parent_of      ( ) child_of                 |
| (*) exiled_by      ( ) member_of                |
|                                                 |
| Target Entity:                                  |
| [ Search target entity...                     ] |
| > [ Genius Society (Faction) ]                  |
|                                                 |
| Description:                                    |
| [ Wrote thesis on anomaly, deemed heretic.    ] |
|                                                 |
| [ Cancel ]                         [ Link (✓) ] |
+-------------------------------------------------+
```

#### Key UX Specs:
*   **Dynamic Filtering:** When searching the target entity, candidate lists exclude the source entity (no self-relations) and are pre-sorted by frequency of recent interactions.
*   **Reciprocal Suggestion Prompt:** Immediately after saving, if the relationship type is directional (e.g. `exiled_by`), show a snackbar at the bottom:
    > *"Also link **Genius Society** as exiled → **Elidor Thorne**?"* `[ Add Link ]` `[ Dismiss ]`

---

## 6. Micro-Interactions & Transitions

Subtle, high-fidelity animations make the app feel tactile and alive without slowing down operations.

### 6.1 Hero Animations
*   **Spine Expand:** When transitioning from the Entity List Page to the Entity Detail Page, the selected item card expands outward using a standard Flutter `Hero` animation. The card borders fade out as the background expands to fill the screen, mimicking the act of opening a book.
*   **Tag Pop:** Adding a tag pops it into existence with a subtle scale-up spring animation (`Curves.easeOutBack`, duration: 250ms).

### 6.2 Gesture Language
*   **Page Swipes:** On the Entity Detail page, swiping left or right on the content area transitions between the "Fields", "Relationships", and "Timeline" tabs.
*   **Swipe-to-Dismiss:** Sweeping left on lists (like Tags or Relationships) reveals a red trash icon; sweeping right reveals an edit action.
*   **Tap-and-Hold (Reordering):** Long-pressing a timeline entry triggers haptic feedback and enters "Chronological Reordering Mode", enabling drag-and-drop sort order.

### 6.3 Page Transitions
All main-route transitions use a sliding page transition:
*   **Push:** Slide in from right, fade in.
*   **Pop:** Slide out to right, fade out.
*   **Quick-Switcher Overlay:** The quick-switcher modal overlay slides down from the top of the screen with a slight elastic bounce and applies a blur effect (`BackdropFilter` with `ImageFilter.blur(sigmaX: 5, sigmaY: 5)`) to the background, creating a focused dark-library focus zone.

---

## 7. Material 3 Dark/Light Themes

```dart
// presentation/common/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFA78BFA),       // Mystic Purple
        secondary: Color(0xFFD4A373),     // Gilded Amber
        background: Color(0xFF120E16),    // Mystic Velvet
        surface: Color(0xFF1E1A24),       // Obsidian Ink
        onPrimary: Color(0xFF120E16),
        onBackground: Color(0xFFE2E0E6),  // Parchment Text
        onSurface: Color(0xFFE2E0E6),
        error: Color(0xFFF87171),         // Broken Quill Red
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.lora(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFE2E0E6),
        ),
        headlineMedium: GoogleFonts.lora(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFE2E0E6),
        ),
        titleMedium: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFE2E0E6),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: const Color(0xFFE2E0E6),
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF9E9AA6),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1A24),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF3A3445), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1A24),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3A3445)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3A3445)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFA78BFA), width: 2),
        ),
      ),
    );
  }
}
```
