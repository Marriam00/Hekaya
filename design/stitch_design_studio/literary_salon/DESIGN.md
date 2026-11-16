---
name: Literary Salon
colors:
  surface: '#fff8f6'
  surface-dim: '#e4d7d4'
  surface-bright: '#fff8f6'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#fff1ed'
  surface-container: '#f9ebe7'
  surface-container-high: '#f3e5e2'
  surface-container-highest: '#ede0dc'
  on-surface: '#211a18'
  on-surface-variant: '#56423e'
  inverse-surface: '#362f2d'
  inverse-on-surface: '#fceeea'
  outline: '#89726d'
  outline-variant: '#dcc1bb'
  surface-tint: '#9c432f'
  primary: '#933c29'
  on-primary: '#ffffff'
  primary-container: '#b2533e'
  on-primary-container: '#fff1ee'
  inverse-primary: '#ffb4a4'
  secondary: '#51634e'
  on-secondary: '#ffffff'
  secondary-container: '#d1e5cb'
  on-secondary-container: '#556752'
  tertiary: '#754f27'
  on-tertiary: '#ffffff'
  tertiary-container: '#91673c'
  on-tertiary-container: '#fff2e9'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdad3'
  primary-fixed-dim: '#ffb4a4'
  on-primary-fixed: '#3d0600'
  on-primary-fixed-variant: '#7d2c1a'
  secondary-fixed: '#d4e8ce'
  secondary-fixed-dim: '#b8ccb3'
  on-secondary-fixed: '#0f1f0f'
  on-secondary-fixed-variant: '#3a4b38'
  tertiary-fixed: '#ffdcbd'
  tertiary-fixed-dim: '#f0bd8b'
  on-tertiary-fixed: '#2c1600'
  on-tertiary-fixed-variant: '#623f18'
  background: '#fff8f6'
  on-background: '#211a18'
  surface-variant: '#ede0dc'
typography:
  display-lg:
    fontFamily: Newsreader
    fontSize: 36px
    fontWeight: '500'
    lineHeight: 44px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Newsreader
    fontSize: 30px
    fontWeight: '500'
    lineHeight: 38px
    letterSpacing: -0.015em
  headline-lg:
    fontFamily: Newsreader
    fontSize: 26px
    fontWeight: '600'
    lineHeight: 34px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Newsreader
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Newsreader
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  title-md:
    fontFamily: Newsreader
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 22px
    letterSpacing: 0.01em
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 26px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 22px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.04em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 12px
    letterSpacing: 0.06em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-compact: 0.75rem
  margin: 1.25rem
  margin-expanded: 1.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.25rem
---

## Brand & Style

This design system is tailored for an intimate, invite-only literary sanctum and personal reading catalog. The brand evokes the feeling of stepping into an exclusive sunlit study or curated private archive: quiet, deliberate, intellectually generous, and tactile.

The visual style embraces **Warm Editorial Minimalism with Tactile Print Nuance**. Rather than stark digital planes or synthetic neomorphism, the UI prioritizes natural archival paper surfaces, rich carbon-pigment ink text, and delicate hairline separators reminiscent of bookbinding and letterpress craft. The atmosphere is unhurried and reverent toward long-form thought, replacing algorithmic noise with generous whitespace, disciplined layout proportions, and quiet dignity.

## Colors

The palette draws directly from physical bookmaking—aged rag paper, bookcloth binders, dried botanical pressings, and archival iron-gall inks.

### Primary Role: Terracotta Ink
- **Hex**: `#B2533E` (with `#C86446` for interactive active/hover states)
- Reserved for intentional calls to action, active tab indicators, primary status stamps, and prominent reading highlights. It carries the warmth of kiln-fired clay and edge-gilded leather.

### Secondary Role: Sage Pressing
- **Hex**: `#546651` (with `#6B7D68` for softer contextual backdrops)
- Evoking pressed botanicals and linen library bindings. Used for secondary metadata tags, reading progress states, accepted book loan confirmations, and subtle accents.

### Neutral System & Surfaces
- **Canvas Base (`surface-base`)**: `#FAF8F5`, a warm unbleached rag paper tone.
- **Card & Recessed Surface (`surface-container`)**: `#F5F1EB`, adding faint tactile separation without introducing cold grayscale.
- **Primary Ink (`text-primary`)**: `#1A1615` for headlines and `#2C2523` for body text, delivering absolute contrast with softened digital glare.
- **Muted Ink (`text-secondary`)**: `#736B63`, used for timestamps, page markers, and secondary metadata.
- **Hairline Rule (`border-paper`)**: `#E8E2D9`, defining structural edges strictly via delicate 1px rules.

## Typography

The typographic hierarchy establishes tension between the literary heritage of classic typesetting and modern digital clarity:

- **Editorial Headings (`Newsreader`)**: A transitional serif with optical proportions optimized for long-form comfort, literary titles, quotes, and book spine details. Utilizes moderate contrast to feel anchored rather than fragile.
- **Interface & Metadata (`Plus Jakarta Sans`)**: A contemporary grotesque sans-serif with subtle geometric warmth and humanist open apertures. It ensures instantaneous legibility across small status pills, cataloging metadata, pagination tags, and dense discussion threads.
- All body copy defaults to a generous line-height multiplier (1.55x–1.65x) to evoke physical book margins and prevent eye fatigue.

## Layout & Spacing

The layout model is anchored in a responsive 4-column fluid mobile grid transitioning to an 8-column layout on larger tablet formats:

- **Canvas Margins**: Default outer edge padding is `1.25rem` (20px), expanding to `1.5rem` on wide mobile devices.
- **Rhythm & Grid**: Book listings, member reviews, and catalog items align to a fluid multi-column flow with a standard `1rem` column gutter. Horizontal scroll shelves (e.g., "Currently Reading", "Curated Stacks") bleed seamlessly to the right screen edge with trailing edge padding matching the starting margin.
- **Vertical Hierarchy**: Spacing scales progressively. Dense metadata elements rely on `space-xs` and `space-sm`, while section breaks between shelf divisions and member annotations leverage `space-xl` to preserve editorial breathing room.

## Elevation & Depth

To maintain the physical warmth of fine paper goods, standard blurred drop shadows and glossy multi-stop gradients are strictly avoided. Depth is achieved via **low-contrast outlines, paper layering, and tonal shifts**:

1. **Flat Structural Planes**: Cards, lists, and drawers rely on a solid `#F5F1EB` container placed upon the `#FAF8F5` base canvas, demarcated by a 1px border in `#E8E2D9`.
2. **Book Spine Physicality**: Book covers carry a 2:3 aspect ratio paired with a single subtle vertical inset line (`1px inset rgba(0,0,0,0.08)`) down the left margin to subtly evoke a book spine crease without skeuomorphic excess.
3. **Elevated Overlays & Modals**: Bottom sheets and floating context menus use a whisper-light tinted scrim (`rgba(44, 37, 35, 0.35)`) and an opaque `#FAF8F5` surface enclosed in a 1px `#E8E2D9` border. No drop shadows are permitted on floating menus or chips.

## Shapes

The design system employs a soft, sculpted architectural geometry:

- **Components (`0.5rem` / 8px - `0.75rem` / 12px)**: Used on input controls, status pills, and compact cards.
- **Containers (`1rem` / 16px)**: Applied to book detail cards, modal sheets, and primary panels to preserve warmth without appearing toy-like.
- **Book Covers**: Constrained strictly to `0.25rem` (4px) corner rounding to honor physical book boards and prevent distorted cover art.
- **Action Buttons & Badges**: Retain an elongated pill shape (`9999px`) where touch target ergonomics and immediate micro-actions require clear differentiation from reading cards.

## Components

### Buttons
- **Primary CTA**: Terracotta background (`#B2533E`), text in `#FAF8F5`, pill-shaped (`9999px`), 48px height, medium weight label. No shadow.
- **Secondary / Ghost**: Background in `#FAF8F5`, 1px outline in `#E8E2D9`, text in `#2C2523`. Active state tints surface to `#F5F1EB`.
- **Text Link Button**: Editorial serif italic or semi-bold sans-serif with a 1px terracotta underline offset by 3px.

### Status Badges & Stamps
- **Public vs. Private**: Compact pill badge (10px upper label font). Public displays in sage tint (`#546651` text on 10% opacity `#546651` background); Private displays in muted ink (`#736B63` border and text).
- **Available vs. Lent Out**: Available utilizes a solid 1px border with a soft green indicator dot; Lent Out utilizes a warm parchment background with `#B2533E` micro-serif text.
- **Pending / Active**: Displayed with bookplate-style hairline borders and 10px uppercase tracking (`0.06em`).

### Cards & Book Displays
- **Book Cover Display**: Fixed 2:3 aspect ratio with an interior 1px paper edge border. Covers feature subtle paper texture overlay.
- **Annotation & Review Cards**: `#F5F1EB` background, 1px `#E8E2D9` border, 16px corner radius. Features author initials in a circular terracotta seal, serif excerpt text, and sans-serif metadata.

### Form Inputs & Checkboxes
- **Text Inputs**: 48px container, `#FAF8F5` background, 1px `#E8E2D9` border, focusing to 1px `#B2533E`. Placeholder text rendered in `#736B63`.
- **Checkboxes & Radios**: 20px custom square/circle in `#FAF8F5` with 1px `#E8E2D9` border. Selected state fills with `#B2533E` and a crisp white tick.

### Bottom Navigation Bar
- Grounded fixed bar at device bottom with a `#FAF8F5` background, anchored by a top hairline divider (`1px solid #E8E2D9`).
- Features exactly 5 icon destinations:
  1. **Home** (Open Book Icon)
  2. **Discover** (Compass / Monocle Icon)
  3. **Add [+]** (Distinct circular terracotta button, 44px, inset, elevating the core cataloging action)
  4. **Reading Corner** (Lamp / Bookmark Icon)
  5. **Profile** (Ex-Libris Stamp Icon)
- Inactive items rendered in `#736B63`; active state switches to `#B2533E` with a 3px terracotta micro-dot below the icon.