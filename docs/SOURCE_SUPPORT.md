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

The user subsequently requested full browser behaviour like Video Lite. Home now
opens websites normally; supported media/catalogue metadata offers a native series
view without forcing navigation. Ordinary page lists (such as shopping ItemList)
do not trigger series mode. Browser DOM snapshots are memory-only, bounded, and
expire after 10 minutes. This is detection of exposed media, not universal custom
player support. Browser network blocking covers common ad hosts; first-party video
ads, including YouTube video ads, are not guaranteed to be removed.

The verification screen allows Cloudflare about:srcdoc frames and requires a loaded
same-origin page without challenge indicators before enabling Continue. Retry and
external-browser fallback are provided after a wait; external clearance is not
claimed to transfer back automatically.

## Play in Reelway (any website)

Most drama sites build their pages with scripts and load videos from many
providers, so a reader per site breaks often. The browser therefore works the
same way on every site (`lib/browser/media_capture.dart`):

- A read-only script in Reelway's own script world (the page cannot see it)
  notes the videos the page's own player loads: `<video>` elements that play,
  and HLS playlists the page downloads (including from embedded players).
- Home checks the visible tab every 2 seconds. When an episode-length video
  (45 s or more, or an HLS playlist) is found and it is not from an ad network,
  a **Play in Reelway** button appears. It pauses the page and opens the video in
  Reelway's player, with the page as Referer.
- The episode list comes from the page's links (`1`, `EP 2`, `Episode 3`,
  `第4集`). Another episode closes the player and opens that episode's page in
  the same tab; when its video starts, it goes straight back to the player.
- These titles are kept for the session only (video addresses expire) and are
  not listed in the Library.

Not covered: sites whose player uses DRM, episode lists made of buttons without
links (the player then shows one episode), and videos inside cross-site frames
if WebKit does not pass their messages to Reelway's script world.

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
