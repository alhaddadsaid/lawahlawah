# Reelway: handoff notes for Claude

> **Current update — 2 November 2026:** Browser-first Home has an address bar,
> saved websites and a compact Continue Watching row. Four main tabs: Home,
> Library, History and Settings. Browsing stays available on unknown websites;
> media metadata on the loaded page offers native series/playback when detected.
> Native source extraction does not require partner flags. Narto has a dedicated
> catalogue/search adapter; other custom players are not universally supported.
> Common ad-network requests are blocked by a browser setting. YouTube playback
> uses its normal website; removal of its first-party video ads is not verified.
> Verification waits for the challenge to disappear, allows Cloudflare srcdoc
> frames, and offers retry/external browser when stalled. Actual clearance still
> depends on the site. Player now has previous/next and an episode grid.
> Play in Reelway: on any website, the video the page's own player starts is
> offered in Reelway's player, with the page's episode links; see
> docs/SOURCE_SUPPORT.md. Per-site readers are not the plan for other sites.
> Standing instruction: push verified updates to streaming-browser and confirm
> Codemagic delivery to internal TestFlight. Older notes below are historical.


> Standing user instruction: after each verified update, push streaming-browser
> and deliver a TestFlight build. ios-testflight now triggers on branch pushes and
> runs format/analyze/tests before signing. Confirm the actual Codemagic/Apple
> result; do not equate a push or queued build with TestFlight availability.


> Update: the user also authorized an optional browser screen for manually
> completing website verification. Catalog/search/player stay native. Current
> source support is documented in SOURCE_SUPPORT.md under docs; candidates must
> not be presented as verified integrations.


> **Current direction (2 November 2026):** The user requested native source
> exploration and playback in native screens, including skipping website ad
> prompts when public stream URLs are already exposed in page HTML. The active
> implementation is `lib/sources/page_source.dart` and the native Browse screen.
> Per-site partner approval flags do not gate this path. See
> [Native sources](docs/NATIVE_SOURCES.md) (from docs, use `NATIVE_SOURCES.md`).
> Older browser/partner decisions below are historical. No App Store approval,
> rights clearance, device verification or distribution is implied.


Streaming-focused mobile web browser (Flutter, iOS + Android). It looks like a streaming
app but is a real browser with pop-up/ad-hijack protection. It does not host video.
Full product spec: the original "master development prompt" (summarised in docs/).
Access, Codemagic, TestFlight and signing (where every key lives): docs/HANDOFF.md.

## Where things stand (Nov 2026)
- Phase 1 UI: done (5 tabs, design system, sample data in debug builds only).
- Phase 2 browser: `lib/browser/`. Decision logic unit-tested; WebView wiring compiles
  and builds on CI but has NOT been verified on a real device yet. Do that first.
- Ad protection against click-hijacking (taps sent to ads) was added for narto-drama.com.
  Its pop-under script (seen in page source): on a tap it cancels the click, opens a blank
  window, loads the ad there (fallback: `window.open(adUrl)`), 2 ads per batch, 60 s
  cooldown. Our rules block blank pop-ups after a tap and cross-site pop-ups unless the
  pressed link points there, then open the tapped link (`PopupProtection.intendedDestination`).
  A read-only user script (`_tapRecorderJs` in browser_view.dart) records what was tapped.
- Our own video player is done (links feature below). Phases 4-8 (drift DB, AdMob,
  release) not started. The Narto-Drama adapter will not be built (see docs/HANDOFF.md).
  See docs/ROADMAP.md.

- Partner unlock: `lib/partners/`. A site with a signed contract (recorded in
  `partners.dart`) gets its ads hidden and its ad gate skipped inside Reelway; no other
  site does. Test page: https://httpbin.org/html (green "partner unlock active" bar, heading
  hidden). Narto-Drama has no agreement, so nothing runs there. See docs/PARTNERS.md.

- Links and player: Library > link button adds a public video or catalog link (user is
  responsible, disclaimer accepted once); titles play in our own player
  (`lib/features/player/`). Test link: https://github.com/alhaddadsaid/dabreels-media
  (free-licensed episodes). See docs/LINKS.md.

## Commands
```bash
flutter pub get
flutter analyze            # must be clean
flutter test               # 61 tests, all passing
dart format -l 120 lib test   # CI checks this formatting
flutter run                # on a device/emulator
```

## Rules that must hold
- Never bypass CAPTCHA, Cloudflare challenges, logins, paywalls or DRM.
- No JavaScript bridge to pages; TLS validation untouched.
- Sample data only in debug builds or with `--dart-define=SAMPLE_DATA=true` (web preview).
- Website adapters run in debug builds for testing (DEV TEST badge); release builds only
  activate an adapter whose `AdapterPermission` is documented (see adapter_registry.dart).
  Narto-Drama is the dev test target; permission is needed before publishing.
- Don't claim something works until it ran on a device or in CI.

## Pipelines
- `.github/workflows/ci.yml`: format, analyze, test, debug APK artifact, iOS build and
  an iOS simulator zip (for Appetize.io).
- `.github/workflows/web-preview.yml`: web build to the `web-preview` branch. Preview page:
  https://claude.ai/artifact/1f73SCkNpGwYpoA45dNUUS (refresh with tools/prep_preview.py +
  tools/preview_index.html; see README). The preview cannot load other websites (claude.ai
  blocks it), so browsing must be tested on a device, emulator or Appetize.
- `codemagic.yaml`: APK builds once the repo is added in Codemagic.
- `codemagic.yaml` `ios-testflight`: signed release IPA to TestFlight, started by hand. Needs the
  Codemagic App Store Connect integration "Reelway ASC" and signing files for com.reelway.reelway.
  This is how the app reaches Said's iPhone (no Xcode on his Mac). Release builds keep the
  pop-up protection; sample titles and the Narto-Drama adapter are debug-only.
- `flutter_inappwebview` is pinned to 6.2.0-beta.3 because 6.1.x fails on Android
  Gradle Plugin 9; move to stable 6.2.0 when released.

## Next steps
1. Run on a real Android/iOS device; test narto-drama.com: page loads, tapping a title
   opens it on the first tap, no ad tab, shield count increases.
2. Fix whatever the device test shows.
3. Phase 3 video player, then the Narto-Drama adapter (titles are rendered client-side
   from `nartodrama-api.online`; title URLs look like `/detail/watch/<slug>`).
4. Move the code to its own repo (currently branch `streaming-browser` of
   `alhaddadsaid/lawahlawah`, whose `main` is an unrelated project).
