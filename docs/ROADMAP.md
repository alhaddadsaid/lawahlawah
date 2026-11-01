# Roadmap and status

Legend: ✅ done and tested here · 🟡 written, needs testing on a real device · ⬜ not started

## Phase 1: UI/UX ✅
- ✅ Design system (tokens, theme, Inter typeface, components)
- ✅ Five-tab navigation: Home, Browse, Library, History, Settings
- ✅ Home: greeting, featured title, continue watching, websites, recently added, saved, recently watched, empty state
- ✅ Library: Movies, TV Series, Recently Added, Favorites, Continue Watching
- ✅ History: watched (progress, resume, swipe to delete), visited pages, clear options
- ✅ Settings: general, appearance, browser, popup protection, privacy, ads, playback, subtitles, websites, about, legal
- ✅ Content detail, search, website management
- ✅ Sample data (invented titles, debug builds only, labelled SAMPLE)
- Verified by widget tests and rendered screenshots (web preview). Not yet viewed on a physical phone.

## Phase 2: Browser engine 🟡
- ✅ Address parsing and HTTPS default (unit-tested)
- ✅ Popup and redirect protection engine (unit-tested: 25+ cases)
- ✅ Tab manager with cap (unit-tested)
- 🟡 WebView integration: tabs, back/forward/reload, bookmarks, history, popup interception,
  new-window-to-tab, external-app confirmation, downloads, site permission prompts,
  cookie/cache clearing. Compiles and passes static analysis; **needs device testing**
  (cannot run a WebView in this build environment).
- ⬜ Replace the seed blocklist with a maintained, licence-compatible list
- ⬜ Bundle the Public Suffix List (current same-site check is a heuristic)
- ⬜ Per-site cookie view, tab restore after app restart

**Device test matrix for phase 2:** sign-in form, a Cloudflare/hCaptcha/reCAPTCHA check,
`target=_blank` links, a site with aggressive popunders, an embedded HTML5 video,
`tel:`/`mailto:` links, a file download, a camera-permission test page, http:// page warning.

## Phase 3: Video player ⬜
`media_kit` or `video_player` (MP4/HLS/DASH), fullscreen, seek, speed, subtitles, audio
tracks, PiP, resume position, episode navigation, error/network recovery. Fallback to the
site's own page whenever `PlaybackSource.canPlayNatively` is false.

## Phase 4: Website adapter ⬜
Narto-Drama is the development test target: its adapter runs in debug builds (DEV TEST
badge). Release builds keep it off until permission and content rights are documented in
`lib/adapters/narto_drama/narto_drama_config.dart`; get that before publishing.

## Partner unlock 🟡
Websites that sign with Reelway let it hide their ads and skip their "watch ads to unlock"
step inside Reelway. The partner builds nothing; Reelway runs the rules recorded in
`lib/partners/partners.dart`, on that site only, while the contract is in force. Unit-tested;
check on a phone at https://httpbin.org/html (test page, debug and TestFlight builds).
See docs/PARTNERS.md.

## Phase 5: Library and history ⬜
drift (SQLite) for catalogue, episodes, watch history; connect player progress.

## Phase 6: Monetization ⬜
`google_mobile_ads` + UMP consent, banners on Home/Library/History/Search, capped interstitials.

## Phase 7: Security and testing ⬜
## Phase 8: Release ⬜

## Known limitations right now
- Browser features are untested on devices (see above).
- Sample content only; no real catalogue (by design until an adapter is permitted).
- Light theme not implemented.
- Legal texts are drafts.
