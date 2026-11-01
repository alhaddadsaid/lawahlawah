# Architecture

Reelway is a single Flutter codebase for **iOS and Android**. It is a real web browser
(platform WebView: `WKWebView` on iOS, Android System WebView on Android) with a
streaming-style interface around it. It does not host, upload or redistribute video.

## Module map

```
lib/
├── main.dart                     App entry: loads AppState, provides state, theme
├── core/
│   ├── design/tokens.dart        Colours, spacing, radii, motion, type scale
│   ├── design/theme.dart         Material 3 theme built from the tokens
│   ├── widgets/components.dart   PosterArt, ContentCard, Carousel, EmptyState, badges…
│   └── security/url_policy.dart  Address-bar parsing, scheme allow/deny rules
├── browser/                      BROWSER ENGINE
│   ├── popup_protection.dart     Pure-Dart decision engine (fully unit-tested)
│   ├── tab_manager.dart          Tabs, active tab, tab cap
│   ├── browser_view.dart         InAppWebView wired to the protection engine
│   └── browser_data.dart         Clear cookies / cache / web storage
├── adapters/                     WEBSITE INTEGRATION
│   ├── site_adapter.dart         Adapter contract, permission record, PlaybackSource
│   ├── adapter_registry.dart     Activates an adapter only if permission is documented
│   └── narto_drama/              Locked stub (no parsing until permission verified)
├── data/
│   ├── models/                   Website, Content, Episode, WatchHistory, Bookmark, UserSettings
│   ├── repositories/app_state.dart  App data + persistence (ChangeNotifier)
│   └── sample/sample_data.dart   Invented titles, debug builds only
└── features/                     UI, one folder per screen
    ├── shell/                    Bottom navigation + cross-tab ShellController
    ├── home/  browse/  library/  history/  settings/  content/  search/
```

Planned modules (later phases): `player/` (phase 3), `ads/` (phase 6), `db/` with drift (phase 5).

## Key flows

**Opening a page.** Address text → `UrlPolicy.parse` → URL (bare hosts upgraded to HTTPS),
web search, or rejection (`javascript:`, `file:`, `data:` …). The URL loads in the active tab.

**Every navigation** the page attempts → `BrowserView._onNavigate` → `PopupProtection.onNavigation`:

| Situation | Balanced (default) |
|---|---|
| Unsafe scheme (`javascript:`, `file:`, `data:`…) | Always blocked, at every level |
| Known bad ad/redirect host | Blocked |
| User tapped a link | Allowed |
| Page switches itself to a *different site* without a tap | Blocked, logged, "Allow site" offered |
| Same-site automatic navigation (e.g. after a verification check) | Allowed |
| Sub-frames (embedded players) | Allowed unless host is blocklisted |
| `tel:`, `mailto:`, store links | Only after a tap, then the user confirms |

**Every new window** → `PopupProtection.onPopup`: no tap → blocked; tapped → opens as a new
in-app tab (Strict mode blocks this too). On iOS, WebKit itself refuses `window.open`
without a gesture; on Android the gesture flag is checked in `onCreateWindow`.

Nothing is injected into pages and JavaScript or third-party requests are never blocked
wholesale, so logins, CAPTCHAs and verification pages work as in a normal browser.

## Website adapters

An adapter (`SiteAdapter`) handles one site: classify pages, parse catalogue / movie /
series / episodes, and resolve a playback source. `AdapterRegistry.activeFor(url)` returns
an adapter **only** when its `AdapterPermission` is documented, verified and confirms the
site's content rights. Otherwise the site is a plain browser page (`IntegrationStatus.browserOnly`
or `pendingPermission`).

`PlaybackSource.canPlayNatively` is false for unknown formats and for DRM-protected
streams, so the app never claims a stream is playable when it is not; the user keeps
watching in the site's own page.

## Security

- No JavaScript bridge is registered. Any future bridge must check the page origin
  against the adapter's domains before handling a message.
- File and content access disabled; mixed content never allowed.
- TLS errors are not overridden: invalid certificates fail as the platform decides.
- Safe Browsing (Android) / fraudulent-site warnings (iOS) on.
- Tabs are capped (12) so a page cannot exhaust memory by opening windows.
- Local data: no passwords or tokens are stored by the app. Website sessions live in the
  WebView cookie store and can be cleared from Settings.

## State management

`provider` + `ChangeNotifier` (`AppState`, `ShellController`, `TabManager`). This matches
what FlutterFlow generates, so FlutterFlow pages and this code can share state.

## Persistence

Phase 1–2: `shared_preferences` (JSON) for websites, bookmarks, visited pages, favourites,
settings. Phase 5 moves catalogue and watch history to SQLite (`drift`).
