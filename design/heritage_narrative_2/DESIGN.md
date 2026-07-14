---
name: Heritage Narrative
colors:
  surface: '#fef8f8'
  surface-dim: '#ded9d9'
  surface-bright: '#fef8f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f8f2f2'
  surface-container: '#f2edec'
  surface-container-high: '#ece7e7'
  surface-container-highest: '#e7e1e1'
  on-surface: '#1d1b1b'
  on-surface-variant: '#58413f'
  inverse-surface: '#323030'
  inverse-on-surface: '#f5efef'
  outline: '#8b716e'
  outline-variant: '#dfbfbc'
  surface-tint: '#aa3531'
  primary: '#6a020a'
  on-primary: '#ffffff'
  primary-container: '#8b1e1e'
  on-primary-container: '#ff9d95'
  inverse-primary: '#ffb3ad'
  secondary: '#775652'
  on-secondary: '#ffffff'
  secondary-container: '#ffd3cd'
  on-secondary-container: '#7a5955'
  tertiary: '#402f05'
  on-tertiary: '#ffffff'
  tertiary-container: '#59451a'
  on-tertiary-container: '#d0b37e'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdad6'
  primary-fixed-dim: '#ffb3ad'
  on-primary-fixed: '#410003'
  on-primary-fixed-variant: '#891c1d'
  secondary-fixed: '#ffdad5'
  secondary-fixed-dim: '#e7bdb7'
  on-secondary-fixed: '#2c1512'
  on-secondary-fixed-variant: '#5d3f3c'
  tertiary-fixed: '#fddfa6'
  tertiary-fixed-dim: '#e0c38c'
  on-tertiary-fixed: '#261900'
  on-tertiary-fixed-variant: '#584419'
  background: '#fef8f8'
  on-background: '#1d1b1b'
  surface-variant: '#e7e1e1'
typography:
  display-lg:
    fontFamily: EB Garamond
    fontSize: 57px
    fontWeight: '500'
    lineHeight: 64px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: EB Garamond
    fontSize: 44px
    fontWeight: '500'
    lineHeight: 52px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: EB Garamond
    fontSize: 32px
    fontWeight: '500'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: EB Garamond
    fontSize: 28px
    fontWeight: '500'
    lineHeight: 36px
  title-lg:
    fontFamily: EB Garamond
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
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
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  margin-mobile: 1rem
  margin-tablet: 2.5rem
  margin-desktop: 5rem
  gutter: 1.5rem
  unit: 4px
---

## Brand & Style
The design system is a sophisticated blend of **Editorial Luxury** and **Modern Utility**. It is designed for high-end production applications that prioritize storytelling, cultural heritage, and immersive content. The aesthetic balances the authoritative weight of traditional publishing with the sleek, functional fluidity of a premium SaaS platform.

The target audience consists of discerning users who value depth, history, and craftsmanship. The UI evokes a sense of "digital archival quality"—it feels permanent, curated, and expansive. By mixing **Minimalism** (generous whitespace) with **Glassmorphism** (modern overlays), the design system ensures that high-resolution imagery and long-form narrative remain the focal points while maintaining a cutting-edge technological feel.

## Colors
The palette is rooted in a deep, oxblood primary (`#8B1E1E`) and a warm, paper-inspired background (`#F8F5EF`). This creates a high-contrast yet organic reading environment.

- **Primary & Tonal Palettes:** The primary red is reserved for brand moments, key actions, and active states. Tonal variations provide subtle differentiation for containers.
- **Surface Strategy:** We utilize a "layered paper" approach. The base background is the warmest tone, while `surface-container` levels become progressively cooler or more saturated to indicate elevation without relying solely on shadows.
- **Semantics:** Success and Warning colors are desaturated to maintain the heritage aesthetic, avoiding "neon" tones that would clash with the traditional color base.

## Typography
The typographic system uses a "Serif for Soul, Sans for Logic" philosophy. 

- **EB Garamond (Display & Headlines):** Used for all storytelling elements. It should be typeset with slight negative letter-spacing in large sizes to feel cohesive and expensive.
- **Inter (Body & UI):** Used for all functional text, data, and long-form reading. The 18px `body-lg` is the standard for narrative text to ensure maximum readability and a premium "book" feel.
- **Labels:** All UI labels and utility text use Inter with increased letter-spacing and uppercase styling to create a clear visual distinction from narrative content.

## Layout & Spacing
The design system utilizes a **Fixed-Fluid Hybrid Grid**. 
- **Desktop:** A 12-column grid with a max-width of 1440px. Content is centered with wide 80px (5rem) side margins to evoke the look of a wide-margin manuscript.
- **Tablet:** 8-column grid with 40px (2.5rem) margins.
- **Mobile:** 4-column grid with 16px (1rem) margins.

**Spacing Rhythm:** A strict 4px/8px baseline grid is enforced. Vertical rhythm between sections should be expansive (typically 80px or 120px) to allow the "Heritage" elements room to breathe.

## Elevation & Depth
Depth is communicated through **Tonal Layering** and **Soft Diffusion**.

- **Surface Layers:** Elements do not "float" with heavy shadows. Instead, they sit on containers that are slightly darker or lighter than the background.
- **Ambient Shadows:** When elevation is required (e.g., Modals, Floating Action Buttons), use a very large blur (32px+) with low opacity (8-10%) tinted with the Primary color (`#8B1E1E`) to create a warm glow rather than a grey shadow.
- **Glassmorphism:** Navigation bars and over-image cards use a backdrop filter (`blur: 12px`) with a 60% opaque white fill. This maintains context of the imagery beneath while ensuring text legibility.

## Shapes
The design system uses a consistent **18dp (1.125rem) corner radius** for all primary containers and cards. This specific radius is soft enough to feel modern and approachable but structured enough to maintain the "editorial" grid.

- **Small Components:** Buttons and input fields use a smaller 8px radius to feel precise.
- **Story Cards:** Always use the full 18px radius, often paired with an inner 1px border of `surface-container-high` to define the edges against the background.

## Components
### Hero Carousel
Full-bleed imagery with a bottom-aligned glassmorphic overlay for titles. Transitions must use a subtle zoom-in parallax effect on the image while text fades in vertically.

### Immersive Story Cards
Vertical aspect ratios (3:4 or 4:5). Headlines use EB Garamond. The card footer should feature a subtle gradient overlay to ensure the "Read More" label is visible over complex photography.

### Interactive Map Elements
Maps use a customized "Sand & Ink" style (desaturated, warm tones). Markers are minimal circles in Primary Red. Selecting a marker triggers a shared-element transition where the marker expands into a Story Card.

### Navigation
The top bar is transparent on scroll-start and transitions to a glassmorphic blur. Links use `label-md` (Inter, Uppercase). The active state is indicated by a 2px serif underline in Primary Red.

### Motion & Micro-interactions
- **Shared Element Transitions:** 500ms duration using `cubic-bezier(0.4, 0, 0.2, 1)`.
- **Parallax:** Background images move at 0.5x scroll speed.
- **Hover States:** Cards lift slightly (-4px Y-axis) with a soft increase in shadow spread.