# Design system

Source of truth: `lib/core/design/tokens.dart`. Mirror these values in FlutterFlow
(Theme Settings → Colors / Typography) so visually built pages match.

## Colour

| Token | Hex | Use |
|---|---|---|
| `background` | `#101014` | App background |
| `surface` | `#191920` | Nav bar, sheets, grouped settings |
| `card` | `#22222A` | Cards, inputs, pills |
| `cardHigh` | `#2C2C36` | Raised elements, snackbars |
| `accent` | `#E85D35` | Primary actions, progress, selection |
| `accentSoft` | `#E85D35` @ 20% | Selected nav indicator, highlighted rows |
| `textPrimary` | `#FFFFFF` | Headings, body |
| `textSecondary` | `#A0A0AA` | Captions, metadata |
| `textTertiary` | `#6C6C76` | Placeholders |
| `divider` | `#2A2A33` | Hairlines |
| `success` / `warning` / `danger` | `#3DBE7A` / `#F2B33D` / `#E5484D` | Status |

## Typography: Inter (bundled, SIL OFL)

| Style | Size / weight |
|---|---|
| display | 32 / 800, -0.5 tracking |
| headline | 24 / 700 |
| title | 18 / 700 |
| subtitle | 15 / 600 |
| body | 14 / 400, 1.45 line height |
| caption | 12 / 400, secondary colour |
| label | 11 / 700, +0.6 tracking, upper-case use |

## Spacing, radius and motion

Spacing: 4 · 8 · 12 · 16 · 24 · 32 · 48. Page gutter 16.
Radius: 8 (small) · 12 (cards, buttons) · 16 (groups) · 24 (hero) · pill.
Motion: 150 ms (fast), 250 ms (normal), 400 ms (slow), `easeOutCubic`.

## Components (`lib/core/widgets/components.dart`)

- **PosterArt**: authorised poster, or original generated artwork when none exists.
  Shows a SAMPLE badge on development data.
- **ContentCard**: 2:3 poster, title, year · genre · source, optional progress bar.
- **Carousel**: horizontal list with standard gutters.
- **SectionHeader**: title plus optional action ("See all").
- **EmptyState**: icon, title, message, optional primary action.
- **SiteAvatar**: favicon or monogram tile.
- **IntegrationBadge**: BROWSER / PENDING / INTEGRATED.
- **RwProgressBar**, **RwBadge**, **Skeleton** (loading placeholder).

## Branding

Name: **Reelway** (working name; check trademark availability before release).
Logo: orange rounded square with a play glyph. Original, with no resemblance to existing
streaming-service marks.

## Screens

See `docs/screenshots/` (rendered from the actual app with sample data).
