---
name: Heritage Narrative
colors:
  surface: '#fcf9f3'
  surface-dim: '#dcdad4'
  surface-bright: '#fcf9f3'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3ed'
  surface-container: '#f0eee8'
  surface-container-high: '#ebe8e2'
  surface-container-highest: '#e5e2dc'
  on-surface: '#1c1c18'
  on-surface-variant: '#58413f'
  inverse-surface: '#31312d'
  inverse-on-surface: '#f3f0ea'
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
  tertiary: '#735c00'
  on-tertiary: '#ffffff'
  tertiary-container: '#cca730'
  on-tertiary-container: '#4f3d00'
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
  tertiary-fixed: '#ffe088'
  tertiary-fixed-dim: '#e9c349'
  on-tertiary-fixed: '#241a00'
  on-tertiary-fixed-variant: '#574500'
  background: '#fcf9f3'
  on-background: '#1c1c18'
  surface-variant: '#e5e2dc'
typography:
  display-lg:
    fontFamily: EB Garamond
    fontSize: 48px
    fontWeight: '600'
    lineHeight: 56px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: EB Garamond
    fontSize: 36px
    fontWeight: '600'
    lineHeight: 44px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: EB Garamond
    fontSize: 32px
    fontWeight: '500'
    lineHeight: 40px
  headline-md:
    fontFamily: EB Garamond
    fontSize: 24px
    fontWeight: '500'
    lineHeight: 32px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  xxl: 48px
  margin-mobile: 16px
  margin-desktop: 64px
  gutter: 16px
---

## Brand & Style

This design system is built for the India Story Project, a platform dedicated to historical storytelling and cultural preservation. The aesthetic is **Modern Editorial**, blending the timeless sophistication of traditional publishing with the precision of modern digital interfaces.

The UI evokes the feeling of a high-end archival journal. It utilizes a **Minimalist** approach with a focus on deep vertical rhythm and purposeful whitespace, punctuated by **Tactile** accents that mimic the texture of physical paper and ink. The goal is to establish a sense of authority, reverence, and immersive storytelling that feels both ancient and contemporary.

## Colors

The color palette is rooted in historical Indian pigments and materials. 

- **Royal Madder (#8B1E1E):** Used for primary actions, branding, and highlighting significant narrative milestones. It conveys weight and legacy.
- **Warm Paper (#F8F5EF):** The primary background color. It reduces eye strain and provides a softer, more organic feel than pure white, reminiscent of parchment.
- **Secondary Carbon (#2D2926):** Used for high-contrast typography and iconography to ensure legibility.
- **Antique Gold (#D4AF37):** Reserved for subtle accents, badges of authenticity, and decorative dividers.

All interactive elements must maintain a 4.5:1 contrast ratio against the Warm Paper background.

## Typography

The typography system uses a classic serif/sans-serif pairing to distinguish between narrative content and functional UI.

- **EB Garamond** is the voice of the story. It is used for all display titles, headings, and long-form pull quotes. It should always be set with "Optical Sizing" enabled where possible to maintain its elegant thin strokes.
- **Inter** is the functional workhorse. It is used for all UI components, metadata, body descriptions, and data-heavy tables. Its neutral character ensures that the functional parts of the app do not compete with the stories.

For long-form reading, `body-lg` is preferred to maintain a comfortable measure and rhythm. All uppercase labels should include a slight tracking increase (+5%) for better readability.

## Layout & Spacing

This design system employs a strict **8dp grid** for all spatial relationships. Every margin, padding, and height increment must be a multiple of 8px (or 4px for micro-adjustments).

- **Grid:** A 12-column fluid grid for desktop and a 4-column fluid grid for mobile.
- **Content Width:** Reading content should be centered with a max-width of 720px to maintain optimal line length.
- **Margins:** Standard mobile screens use 16px side margins. Desktop screens use 64px margins to allow the "Warm Paper" background to frame the content.
- **Rhythm:** Use `xxl` (48px) spacing between major narrative sections and `md` (16px) for internal component spacing.

## Elevation & Depth

To maintain the "Modern Editorial" feel, this design system avoids heavy shadows, opting instead for **Tonal Layers** and **Low-Contrast Outlines**.

- **Level 0 (Base):** Warm Paper (#F8F5EF).
- **Level 1 (Cards/Surface):** Pure White (#FFFFFF) with a 1px border of #E5E1D8. No shadow.
- **Level 2 (Floating/Interactive):** Pure White with a very soft, diffused shadow: `0px 4px 12px rgba(45, 41, 38, 0.05)`. This is used for menus or active states.
- **Level 3 (Modals):** Pure White with a `0px 12px 24px rgba(45, 41, 38, 0.1)`.

Depth is primarily communicated through the layering of white surfaces on top of the cream background, creating a subtle physical "stacked paper" effect.

## Shapes

The shape language is controlled and sophisticated. 

- **Corner Radius:** A consistent **8px (0.5rem)** radius is applied to all primary UI elements, including buttons, cards, and input fields. 
- **Large Components:** Larger containers or bottom sheets may use **16px (1rem)** for a softer transition.
- **Interactive Elements:** Checkboxes and selection indicators should maintain the 8px radius or remain square (0px) if used in a strictly archival data context. 

Avoid fully circular (pill-shaped) buttons to keep the aesthetic grounded and professional.

## Components

### Buttons
- **Primary:** Background: Royal Madder (#8B1E1E), Text: White, Radius: 8px. Bold Inter 14px.
- **Secondary:** Border: 1px Royal Madder, Text: Royal Madder, Background: Transparent.
- **Text Button:** Text: Royal Madder, no border, 4px radius on hover with #F1EDE4 background.

### Cards
- Background: White (#FFFFFF).
- Border: 1px #E5E1D8.
- Padding: 24px.
- Use for story teasers, archival entries, and featured collections.

### Input Fields
- Background: White (#FFFFFF).
- Border: 1px #2D2926 at 20% opacity. 
- Focus State: 2px border in Royal Madder.
- Label: Inter 12px Medium, uppercase.

### Lists
- Separated by 1px horizontal dividers (#E5E1D8).
- 16px vertical padding for each list item.

### Chips/Tags
- Background: #E5E1D8.
- Text: #2D2926.
- Radius: 4px.
- Used for categorizing eras (e.g., "Mughal Era", "Post-Independence").