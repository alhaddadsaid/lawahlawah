# Links and the player

Users add public links in **Library > link button** and watch them in Reelway's own
player (`lib/features/player/player_screen.dart`): no web page, no site ads.

## Rules
- Public `https://` links only. Reelway fetches a link with no cookies or sign-in, so
  anything behind an account does not load. Links with a user name or password are refused.
- Reelway reads only the link itself. It does not read other websites' pages to find videos.
- Each user is responsible for the links they add. Before the first link, the user confirms
  "I have the right to play the links I add" (stored once). The disclaimer is shown in the
  Add link sheet and in the Terms of service.
- The app ships with no links.

## What a link can be
1. **A video file**: `.mp4`, `.m4v`, `.mov` or `.m3u8` (HLS). It becomes one title.
2. **A Reelway catalog** (JSON):
   ```json
   {"series": [
     {"title": "My Show", "description": "...", "poster": "poster.jpg",
      "episodes": [{"title": "Pilot", "url": "ep1.mp4", "duration": 95.5}]}
   ]}
   ```
   Addresses may be relative to the catalog link. Only `https://` videos are kept.
3. **A DabReels manifest** (`{"films": [...]}`), with episode files next to it named
   `<id>__<file>`. A GitHub repository or release page link is read as that release's
   `manifest.json`, so `https://github.com/alhaddadsaid/dabreels-media` works as is.

Code: `lib/sources/link_feed.dart` (reading, unit-tested in `test/links_test.dart`) and
`AppState.addLink / refreshLinks / removeLink / recordProgress`.

## Player
MP4 and HLS through `video_player`. Play/pause, back and forward 10 s, seek bar, speed
(1x, 1.25x, 1.5x, 2x, 0.75x), next episode, automatic next episode at the end, progress
saved every 5 s and on close, resume from History, Home and the title page.
