# Website support and candidate sources

## Current implementation

- Narto-Drama: website address opens its public Featured catalog; Load more series
  follows its same-site next-page link. Search calls the site's public JSON search
  route and returns up to 50 matches, rather than filtering only the visible page.
  Selecting a series uses the existing episode extractor/native player.
- Common formats on other websites: HTML video/source tags, Open Graph video files,
  JSON-LD VideoObject.contentUrl and ItemList catalog links, plus Reelway JSON feeds.
  These formats do not imply universal support for custom website players.
- Website verification: optional, user-opened browser screen. The user completes
  the site's check, then taps Continue in Reelway. No automated CAPTCHA interaction.
  Only known verification cookie names are reused for the exact HTTPS origin,
  in memory for 30 minutes. Login cookies are not forwarded. Settings can clear
  verification cookies and temporary access.
- Verification clearance can be tied to the browser or device fingerprint, so it
  does not guarantee the native HTTP reader gains access or that playback is
  supported. Catalog and playback screens remain native.
- Website/ad-script ads are avoided by direct native playback when media is
  exposed. Ads included in the actual video are not generally removable.

The user explicitly allowed a temporary Cloudflare verification screen after the
original no-WebView implementation. The WebView dependency is now used only for
that opt-in screen; the full browsing UI has not been restored.

## User-supplied candidates (not endorsements or verified “free” claims)

| Source | Current status |
| --- | --- |
| Narto-Drama — narto-drama.com | Catalog/search and known episode extraction implemented; new catalog UI needs iPhone testing |
| ChartDrama — chartdrama.com / reelshort.chartdrama.com | Supplied example blocked direct reads; player integration unverified |
| WhereDrama — wheredrama.com | Search-directory candidate; not integrated |
| DramaFren — dramafren.org / dramabox.dramafren.org | Supplied homepage/series blocked direct reads; player integration unverified |
| DramaTap — dramatap.app | Not investigated |
| KiligDrama — kiligdrama.com | Not investigated |
| Dailymotion | Not investigated |
| TikTok / TikTok Lite | Not investigated |
| YouTube | Not investigated |
| Rumble | Not investigated |
| Rakuten Viki | Not investigated |
| iQIYI | Not investigated |
| Tencent Video / WeTV | Not investigated |
| FMHY | Directory candidate; not integrated |

Examples supplied by the user:

- https://reelshort.chartdrama.com/d/68c0cabeabd4f6e6ea08fe93/sleep-with-me-mortal
- https://dramabox.dramafren.org/index.php?page=detail&id=41000104250&lang=en&slug=seduction-of-shadows

New sources need an actual catalog, search and episode-page inspection. Do not
mark a source supported because its title can be parsed or a verification screen
can be opened. No VIP, account, payment or DRM workarounds are implemented.

## Subtitles

External SRT and WebVTT tracks are read from Narto's `multi_subtitles` metadata
(or its default subtitle URL) and HTML video `<track>` elements. The native CC
menu selects a language or Off; the chosen language follows the next episode
within the current playback session when available. The existing subtitle-size
setting controls caption text size. Video continues if a subtitle download fails.
Embedded/segmented HLS text tracks, image subtitles and changing burned-in text
are not implemented. Subtitle-language selection still needs testing on iPhone.

## Delivery preference

The user requested a TestFlight build after every update. `ios-testflight` now
listens for pushes on streaming-browser and runs format, analysis and tests before
signing/uploading for internal testing. Confirm actual build delivery in Apple;
YAML trigger configuration alone is not proof that a Codemagic webhook fired.
