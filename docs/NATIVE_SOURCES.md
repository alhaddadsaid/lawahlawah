# Native sources (November 2026)

Current user-directed product change: Reelway is a native source explorer and
video player. Earlier browser/partner-only decisions in historical handoffs no
longer describe the active playback path. Store review is a separate release step;
this implementation is not an assertion of approval or rights to third-party media.

## Flow

Browse → paste a public URL (or choose Narto-Drama) → choose a title → Add to
Library & watch → choose an episode in the existing native detail/player UI.
Library's link button accepts the same series/episode URLs, direct MP4/HLS links,
and the existing JSON catalogs. The responsibility acknowledgement remains once
per installation. No per-site partner agreement flag is required by this path.

Narto-Drama's episode HTML currently serializes `episodeItemsRaw` as JSON, including
public HLS addresses. The parser reads that literal without executing JavaScript.
Series pages follow one same-site episode link. The website's five-ad JavaScript
prompt, ad scripts, banners and pop-ups are never loaded or completed. No fabricated
ad clicks, ad counters, completion requests or sessions are sent.

The old WebView implementation is retained as text under docs/legacy for reference;
its plugin is removed from pubspec. The Browse tab uses Flutter widgets, HTTP, an
HTML parser and the existing native video_player integration.

## Bounds

- HTTPS only, no URL credentials or browser cookies; redirects are revalidated,
  limited to five requests, with a 4 MiB page limit and network timeouts.
- Generic pages support video/source tags, direct Open Graph video files, and
  JSON-LD VideoObject.contentUrl. No execution of arbitrary website scripts.
- Narto playlists skip unavailable items, duplicate episode numbers, insecure URLs
  and sources requiring separate audio tracks (not supported by this player yet).
- Page-derived episode URLs are re-read before playback to refresh expiring links.
- No login, CAPTCHA, anti-bot, paywall or DRM circumvention. No guarantee every
  provider or every site works. Ads embedded into the video itself are not removed.
- The homepage returned a JavaScript verification/loading page during direct
  HTTP testing. The start tile therefore opens the verified example series; users
  can paste other public series/episode URLs. This is not a complete native mirror
  of Narto-Drama’s entire catalog.
- Browse lists titles found in the fetched HTML; provider-specific client-rendered
  catalogs, server search, pagination and subtitle extraction are not implemented.
- No App Store submission, GitHub push or TestFlight distribution is performed here.

## Verification

Run the project CI checks:

```
dart format --output=none --set-exit-if-changed -l 120 lib test
flutter analyze
flutter test
```

Read-only live source check:

```
dart run tools/check_public_source.dart
```

The initial development investigation verified the 47-episode JSON playlist and
fetched episode 1's public HLS manifest and one 5-second segment. ffprobe reported
H.264 540×960 video and AAC audio without website ads. This is network/codec evidence,
not an iPhone playback or App Store approval claim. Validation on this implementation: formatting passed, Flutter analyze reported
no issues, and all 88 tests passed (including the native import UI flow). The live
Dart extractor found 47 playable episode links from both the series and episode
URLs. Device playback still needs a signed build and iPhone.
