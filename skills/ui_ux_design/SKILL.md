---
name: mobile-ui-ux-design
description: Guidelines and best practices for creating responsive, modern, and beautiful mobile UI/UX layouts, prioritizing the 8-point spacing grid, thumb zone, touch targets, and visual aesthetics.
---

# Mobile UI/UX Design System & Best Practices (SKILL.md)

This playbook outlines the standards, constraints, and guidelines for designing high-fidelity mobile applications. Follow these rules whenever creating or modifying UI components, layouts, and animations.

---

## 1. Interaction & Ergonometrics (The Thumb Zone)
*   **The 75% Rule**: Place primary interactive elements (navigation tabs, FABs, primary action buttons, filter chips) in the bottom third of the screen where they are easily reachable by a user's thumb.
*   **Destructive Protection**: Destructive actions (like Delete, Sever Connection, Reset) must be placed in harder-to-reach areas (top-right headers or inside double-confirmation sheets) to prevent accidental trigger.
*   **Haptic Ticks**: Apply tactile haptic feedback to reinforce physical interaction:
    *   `HapticFeedback.selectionClick()`: Tab bar changes, chip selections, switch toggles.
    *   `HapticFeedback.lightImpact()`: General button clicks, list item taps, card selections.
    *   `HapticFeedback.mediumImpact()`: Destructive actions, successful submissions, resets.

---

## 2. Touch Targets & Spacing System
*   **Minimum Touch Targets**: Every interactive element must have a minimum size of **48x48 dp** (Material Design) or **44x44 pt** (Apple Human Interface Guidelines) to accommodate human fingers. If the icon is small (e.g., 18px), expand its hit area using `IconButton` padding or `BoxConstraints`.
*   **8-Point Grid System**: All margins, paddings, and spacers must align to multiples of 8 (8dp, 16dp, 24dp, 32dp). multi-layered dense lists may use 4dp or 12dp where necessary, but keep the outer spacing consistent.

---

## 3. High-Fidelity Aesthetics & Aesthetics
*   **Bento Grid Layout**: Organise dense dashboards or detail screens into asymmetric, modular cards of varying sizes. This establishes a clean visual hierarchy.
*   **Evolved Glassmorphism**: Use translucent surfaces with dynamic blurs (`BackdropFilter` with `ImageFilter.blur(sigmaX: 5, sigmaY: 5)`) over dark velvet backgrounds to convey physical depth. Contrast this with thin, elegant borders (0.5dp to 1dp thickness) in semi-transparent colors.
*   **Typographic Contrast**: Pair premium Serif headings (for titles and names, e.g., *Lora* or *Playfair Display*) with ultra-legible Sans-Serif body text (for editing and values, e.g., *Inter* or *Outfit*).

---

## 4. Calm UI & Fluid Animations
*   **Micro-Animations**: Animate transitions in response to user actions (e.g., scale bounce on hover/tap, slide entries on lists). Avoid heavy, long-running theatrical animations. Keep transition durations between **150ms to 250ms**.
*   **Spring Curves**: Use elastic or spring-back curves (`Curves.easeOutBack` or custom cubic-bezier) for entrance animations of dialogs and sheets to make the app feel alive and springy.
*   **Clean Dismissals**: When using swipe-to-dismiss patterns, always settle the list items, trigger quick haptic ticks, and display clear confirmation before permanently deleting database records.
