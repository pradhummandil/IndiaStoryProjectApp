# India Story Project: Developer Handoff Package

## 1. Design System Specification
**Base Design System:** {{DATA:DESIGN_SYSTEM:DESIGN_SYSTEM_1}} (Heritage Narrative)

### Color Tokens (Material 3 Mapping)
- **Primary (Royal Madder):** `#8B1E1E` (Used for branding, primary CTAs, active states)
- **Surface:** `#FCF9F3` (Main background, warm paper texture)
- **Surface Dim:** `#DCDAD4` (Secondary backgrounds, subtle containers)
- **On-Surface:** `#1C1B1B` (Primary body text)
- **Primary Container:** `#FFDAD5` (Subtle highlight backgrounds)
- **On-Primary Container:** `#410002` (Text on highlights)
- **Outline:** `#857371` (Borders, dividers)

### Typography Scale
- **Display Large:** EB Garamond, 57pt, -0.25 tracking (App Headlines)
- **Headline Medium:** EB Garamond, 28pt, 0 tracking (Section Headers)
- **Title Large:** EB Garamond, 22pt, 0 tracking (Article Titles)
- **Label Large:** Inter, 14pt, +0.1 tracking (Buttons, UI Controls)
- **Body Large:** EB Garamond, 16pt, +0.5 tracking (Story Narrative Text)
- **Body Medium:** Inter, 14pt, +0.25 tracking (Descriptions, Metadata)

### Structural Tokens
- **Radius:** `ROUND_EIGHT` (8px) for cards and containers. Buttons use `full` (pill) for Production v2 components.
- **Spacing:** 8dp baseline grid. Primary margins: 16dp (Mobile), 24dp (Tablet/Desktop).
- **Elevation:** Low elevation (`Level 1`) for floating story cards. Surface tonal elevation preferred over heavy shadows.

---

## 2. Component Inventory & States

### Primary Navigation (Shared)
- **TopAppBar (HERITAGE):**
  - *Default:* Center-aligned brand name, menu leading, search trailing.
  - *Variants:* Small (Writer Studio), Transparent (Interactive Map).
- **BottomNavBar (5-Destination):**
  - *Home, Explore, Share, Saved, Profile.*
  - *State:* Active destination uses Royal Madder icon with `primary-container` pill background.

### UI Elements
- **Story Cards:**
  - *States:* Default, Pressed (scale 98%), Loading (Shimmer).
- **Primary Buttons:**
  - *Default:* Royal Madder background, white text.
  - *Hover/Focused:* 12% white overlay.
  - *Disabled:* 12% On-Surface background, 38% On-Surface text.
- **Input Fields:**
  - *Default:* Outlined with label.
  - *Error State:* `#BA1A1A` border and helper text.

---

## 3. Screen Inventory & Flow
- **Home (Discover):** Entry point. Feeds into Story Reading and Competitions.
- **Interactive Map:** Flagship feature. Accessible via Bottom Nav "Explore".
- **Story Reading:** Deep-view of narratives. Entry from Home/Map.
- **Writer Studio:** Creator suite. Separate navigation drawer flow.
- **Admin Dashboard:** Management suite. High-density data grid layout.

---

## 4. Responsive Rules
- **Phone (360-480dp):** Standard single-column layout. 16dp margins.
- **Tablet (600dp+):** Two-column grid for Discover feed. Navigation Rail replaces Bottom Nav.
- **Foldables:** Center-hinge awareness. Expandable story view with side-panel metadata.

---

## 5. Motion Specification
- **Transitions:** Container Transform (Story Card -> Story Page)
  - *Duration:* 300ms
  - *Curve:* Standard Easing (Cubic-bezier 0.4, 0.0, 0.2, 1)
- **Ambient:** Living Paper Shader (Interactive Map)
  - *Effect:* Subtle noise field + mouse-reactive ink bleed.
- **Feedback:** Haptic feedback on all primary button presses.

---

## 6. Accessibility (WCAG AA Compliance)
- **Contrast:** Minimum 4.5:1 for all body text. 3:1 for large text.
- **Touch Targets:** Minimum 48x48dp for all interactive elements.
- **Screen Reader:** All imagery requires meaningful `Alt Text`. Group metadata (e.g., "12 min read") for clear announcement.

---

## 7. Flutter Implementation Guide
- **Widget Hierarchy:**
  - `MaterialApp` with `ThemeData` derived from `Design_System_1`.
  - `Scaffold` as base for every screen.
  - `CustomScrollView` for narrative pages with `SliverAppBar`.
- **Token Mapping:**
  - `primaryColor` -> `#8B1E1E`
  - `surfaceColor` -> `#FCF9F3`
  - `fontFamily` -> `'EB Garamond'` for Display/Headline/Body.
  - `fontFamily` -> `'Inter'` for Labels/UI.
- **Asset Management:**
  - Use `flutter_svg` for all iconography.
  - Fragment shaders (for Map) should be implemented via `FragmentProgram` API.
