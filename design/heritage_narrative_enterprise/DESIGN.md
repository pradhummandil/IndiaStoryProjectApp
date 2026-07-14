---
name: Heritage Narrative Enterprise
colors:
  surface: '#fff8f7'
  surface-dim: '#ebd5d3'
  surface-bright: '#fff8f7'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#fff0ef'
  surface-container: '#ffe9e7'
  surface-container-high: '#fae3e1'
  surface-container-highest: '#f4dddb'
  on-surface: '#251917'
  on-surface-variant: '#58413f'
  inverse-surface: '#3b2d2c'
  inverse-on-surface: '#ffedeb'
  outline: '#8b716e'
  outline-variant: '#dfbfbc'
  surface-tint: '#aa3531'
  primary: '#6a020a'
  on-primary: '#ffffff'
  primary-container: '#8b1e1e'
  on-primary-container: '#ff9d95'
  inverse-primary: '#ffb3ad'
  secondary: '#635d5a'
  on-secondary: '#ffffff'
  secondary-container: '#e6ded9'
  on-secondary-container: '#67625e'
  tertiary: '#36312a'
  on-tertiary: '#ffffff'
  tertiary-container: '#4d4740'
  on-tertiary-container: '#beb6ac'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdad6'
  primary-fixed-dim: '#ffb3ad'
  on-primary-fixed: '#410003'
  on-primary-fixed-variant: '#891c1d'
  secondary-fixed: '#e9e1dc'
  secondary-fixed-dim: '#cdc5c0'
  on-secondary-fixed: '#1e1b18'
  on-secondary-fixed-variant: '#4b4642'
  tertiary-fixed: '#eae1d6'
  tertiary-fixed-dim: '#cec5bb'
  on-tertiary-fixed: '#1f1b15'
  on-tertiary-fixed-variant: '#4b463e'
  background: '#fff8f7'
  on-background: '#251917'
  surface-variant: '#f4dddb'
typography:
  display-lg:
    fontFamily: EB Garamond
    fontSize: 57px
    fontWeight: '500'
    lineHeight: 64px
    letterSpacing: -0.25px
  display-md:
    fontFamily: EB Garamond
    fontSize: 45px
    fontWeight: '500'
    lineHeight: 52px
  headline-lg:
    fontFamily: EB Garamond
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: EB Garamond
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  title-lg:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0.5px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.25px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.1px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  unit: 8px
  margin-mobile: 16px
  margin-tablet: 32px
  margin-desktop: 64px
  gutter: 24px
  container-max-width: 1280px
---

## Brand & Style

The design system is engineered for the "India Story Project," an enterprise-grade platform dedicated to cultural preservation and storytelling. The brand personality is **Authoritative, Cinematic, and Curated**, functioning like a digital museum. 

The visual style is a sophisticated blend of **Minimalism** and **Modern Corporate** standards, utilizing high-contrast editorial layouts and expansive white space to allow archival content to lead the experience. It prioritizes legibility and structure, ensuring that even dense historical data feels premium and accessible. The "Museum-Quality" aesthetic is achieved through a restrained use of color, meticulous typography, and subtle, intentional depth.

## Colors

This design system uses a palette rooted in traditional pigments but optimized for digital accessibility (WCAG AA/AAA). 

- **Primary (Royal Madder):** Used for key actions, brand moments, and active states. It carries the weight of heritage without compromising urgency.
- **Background (Paper):** A warm, off-white neutral that reduces eye strain and provides a tactile, archival feel compared to pure white.
- **Surface:** Pure white is reserved for cards and elevated containers to create a clear visual hierarchy against the Paper background.
- **Functional Neutrals:** A range of charcoals and warm greys for text and iconography to ensure high contrast against both surface and background colors.

## Typography

The typographic strategy employs a "Serif for Soul, Sans for Function" philosophy.

1.  **EB Garamond (Display/Headlines):** Used for all storytelling elements, section headers, and large titles. It provides the intellectual and historical weight required for the project.
2.  **Inter (UI/Functional):** Used for all body copy, navigation, data tables, and input fields. Its high x-height and neutral character ensure maximum legibility at small sizes within complex enterprise workflows.

**Scale Rules:**
- Use `display-lg` exclusively for hero sections or landing chapters.
- `title-lg` (Inter) should be used for card titles to maintain a modern, clean grid.
- All functional labels (buttons, chips) must use `label-lg` for clarity.

## Layout & Spacing

This design system follows a **12-column Fixed Grid** for desktop and a **4-column Fluid Grid** for mobile. The layout is centered on a containerized approach to maintain "museum-box" focal points.

- **Rhythm:** An 8px linear scale governs all padding and margins. 
- **Density:** Enterprise views (data dashboards) may utilize a "Compact" 4px unit, while editorial views (story pages) must use the 8px unit with generous vertical padding (64px+) between sections to maintain a premium feel.
- **Reflow:** On mobile, margins shrink to 16px, and all multi-column cards stack vertically.

## Elevation & Depth

To maintain a "Museum-Quality" aesthetic, depth is achieved through **Tonal Layering** and **Subtle Ambient Shadows**. 

- **Level 0 (Base):** Background color (`#F8F5EF`).
- **Level 1 (Cards/Surface):** Pure white surface with a 1px border (`#E0DDD6`) or a very soft, diffused shadow (Blur: 8px, Y: 2px, Opacity: 4% Black).
- **Level 2 (Dropdowns/Modals):** Increased shadow depth (Blur: 16px, Y: 4px, Opacity: 8% Black) to indicate temporary overlay.
- **Physicality:** Use subtle inner shadows for input fields to give a "pressed" paper feel, reinforcing the archival metaphor.

## Shapes

The design system utilizes **Soft** roundedness (4px) to balance modern software expectations with the structured, "square" nature of traditional print and architectural layouts.

- **Small Components (Buttons, Chips):** 4px radius.
- **Medium Components (Cards, Modals):** 8px radius.
- **Large Components (Hero Banners):** 0px radius (Sharp) to emphasize a cinematic, edge-to-edge frame.

## Components

**Buttons:**
- **Primary:** Solid Royal Madder (`#8B1E1E`) with white Inter Bold text. High-contrast and impactful.
- **Secondary:** Outlined (1px Royal Madder) with Madder text.
- **Tertiary:** Ghost style, using color only for text.

**Cards:**
- Editorial cards feature a top-aligned image with a 2:3 or 16:9 aspect ratio. 
- Content padding is strictly 24px. Card headers use `title-lg` (Inter).

**Navigation Bars:**
- Top Navigation: Persistent Paper background with a thin bottom border. 
- Use the primary color for the active indicator—a simple 2px underline rather than a pill shape to keep it elegant.

**Progress Indicators:**
- Linear only. Avoid circular loaders for a more cinematic, horizontal "timeline" feel. Use the Primary color for the progress bar and the Tertiary Neutral for the track.

**Input Fields:**
- Material 3 "Outlined" style. Labels should be `label-sm` (Inter) when floating. Use the Paper color for the internal fill to blend into the background.