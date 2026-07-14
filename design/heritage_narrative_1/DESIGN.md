---
name: Heritage Narrative
colors:
  surface: '#FFFFFF'
  surface-dim: '#dcd9d9'
  surface-bright: '#fcf9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3f2'
  surface-container: '#f0eded'
  surface-container-high: '#eae7e7'
  surface-container-highest: '#e5e2e1'
  on-surface: '#1b1b1c'
  on-surface-variant: '#58413f'
  inverse-surface: '#303030'
  inverse-on-surface: '#f3f0ef'
  outline: '#8b716e'
  outline-variant: '#dfbfbc'
  surface-tint: '#aa3531'
  primary: '#6a020a'
  on-primary: '#ffffff'
  primary-container: '#8b1e1e'
  on-primary-container: '#ff9d95'
  inverse-primary: '#ffb3ad'
  secondary: '#755b00'
  on-secondary: '#ffffff'
  secondary-container: '#fed255'
  on-secondary-container: '#735a00'
  tertiary: '#00364b'
  on-tertiary: '#ffffff'
  tertiary-container: '#004e6a'
  on-tertiary-container: '#86bedf'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdad6'
  primary-fixed-dim: '#ffb3ad'
  on-primary-fixed: '#410003'
  on-primary-fixed-variant: '#891c1d'
  secondary-fixed: '#ffe08e'
  secondary-fixed-dim: '#ecc246'
  on-secondary-fixed: '#241a00'
  on-secondary-fixed-variant: '#584400'
  tertiary-fixed: '#c3e8ff'
  tertiary-fixed-dim: '#95ceef'
  on-tertiary-fixed: '#001e2c'
  on-tertiary-fixed-variant: '#004c68'
  background: '#F8F5EF'
  on-background: '#1b1b1c'
  surface-variant: '#e5e2e1'
  text-secondary: '#5F6368'
  border: '#E8E2D8'
  madder-light: '#F2E8E8'
  gold-light: '#FAF6E9'
typography:
  display-lg:
    fontFamily: EB Garamond
    fontSize: 64px
    fontWeight: '500'
    lineHeight: 72px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: EB Garamond
    fontSize: 40px
    fontWeight: '500'
    lineHeight: 48px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: EB Garamond
    fontSize: 32px
    fontWeight: '500'
    lineHeight: 40px
  headline-sm:
    fontFamily: EB Garamond
    fontSize: 24px
    fontWeight: '600'
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
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.05em
  caption:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  margin-desktop: 64px
  margin-mobile: 20px
  gutter: 24px
  section-gap: 120px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
---

## Brand & Style

This design system is crafted for a premium storytelling platform, blending the editorial sophistication of a high-end magazine with the functional clarity of modern tech giants. The aesthetic is **Minimalist-Editorial**, prioritizing negative space, exquisite typography, and cinematic imagery to create an experience akin to a digital museum.

The narrative tone is "Timeless Discovery." It avoids the clutter of traditional news sites, opting instead for the rhythmic pacing of a luxury travel journal. By utilizing a "Paper & Ink" philosophy, the UI feels tactile and archival, while the underlying logic follows Material 3 principles to ensure accessibility and cross-platform consistency. Every element is designed to recede, allowing the stories of culture, science, and heritage to take center stage.

## Colors

The palette is rooted in the "Royal Madder" red and "Marigold" gold, colors deeply embedded in Indian heritage. 

- **Primary (Royal Madder):** Used for key actions, brand moments, and critical narrative highlights.
- **Secondary (Marigold):** Used for subtle accents, category tags, and decorative flourishes that require warmth without the weight of the primary red.
- **Background (Warm Paper):** The `#F8F5EF` off-white base reduces eye strain and provides a premium, non-clinical feel compared to pure white.
- **Text:** Primary text utilizes a deep charcoal (`#1E1E1E`) rather than pure black to maintain softness against the paper background.

## Typography

The typography system relies on the interplay between the graceful, high-contrast **EB Garamond** (as a substitute for Cormorant for better web rendering) and the utilitarian precision of **Inter**.

- **Serif for Narrative:** All headlines and display text use the serif face to evoke a sense of history and storytelling.
- **Sans for Utility:** Inter is reserved for body copy, labels, and UI elements to ensure high legibility and a modern, "App-like" feel.
- **Hierarchy:** We use generous line heights (1.5x for body) to ensure the reading experience is leisurely and unhurried. Display sizes use tighter tracking to maintain a cinematic, "poster" look.

## Layout & Spacing

The layout follows a **Fluid Editorial Grid**. On desktop, a 12-column grid is used with expansive outer margins to create a "centered-document" feel.

- **Negative Space:** Sections are separated by large vertical gaps (`120px+`) to allow the content to breathe, emphasizing the premium nature of the platform.
- **The Golden Thread:** Content should rarely span the full 12 columns. Narrative text is typically constrained to 6-8 central columns for optimal readability.
- **Mobile Reflow:** On mobile, margins shrink to 20px, and the grid collapses to a single column, but the vertical breathing room remains high to maintain the premium feel.

## Elevation & Depth

This design system avoids heavy shadows in favor of **Tonal Layers** and **Soft Ambient Occlusion**.

- **Surfaces:** The primary background is the warm paper tint. Elevated cards or "Surface" elements use pure white (`#FFFFFF`) with a very subtle, 1px border in the `border` color.
- **Shadows:** Only used for interactive elements like floating action buttons or hovered cards. Use a multi-layered, low-opacity shadow (e.g., `0 10px 30px rgba(30, 30, 30, 0.05)`) to mimic natural light falling on paper.
- **Transitions:** Use slow, ease-in-out transitions (300ms) for hover states to reinforce the calm, deliberate brand personality.

## Shapes

The shape language is defined by the "Rounded Editorial" style. While the overall layout is structured and grid-based, individual containers use a generous `18px` (transformed to `1rem/1.5rem` scale) radius to soften the technical feel of the web.

- **Images:** All cinematic photography must feature the `rounded-xl` (1.5rem) corner radius.
- **Buttons/Inputs:** Use the `rounded-lg` (1rem) for a friendly yet sophisticated touch.
- **Small Components:** Tags and chips may use pill shapes to contrast against the more architectural rectangular elements.

## Components

### Buttons
- **Primary:** Solid Royal Madder with white text. High-contrast, rounded-lg.
- **Secondary:** Transparent with a Royal Madder 1px border.
- **Tertiary:** Text-only in Royal Madder with a subtle underline on hover.

### Narrative Cards
- Large-scale imagery on top, followed by a Marigold category label (all-caps), an EB Garamond headline, and a short Inter summary.
- Background: Pure white with a 1px `#E8E2D8` border.

### Input Fields
- Subtle `#F8F5EF` background with a bottom-only border that transforms to a full Royal Madder border on focus. Consistent with the "writing on paper" metaphor.

### Chips & Tags
- Used for categories (e.g., "Heritage", "Science"). Small, uppercase Inter, with a light Marigold background and deep gold text.

### Icons
- Use 1.5px stroke weight (Light/Thin). Never filled. Icons should feel like delicate line drawings.

### Imagery
- Photography is the hero. Use a 16:9 or 4:5 aspect ratio with a subtle desaturation or warm-tint filter to align with the brand’s color palette.