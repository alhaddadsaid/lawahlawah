# Reelway server settings

`config.json` is read by the app at every start (from `https://reelbrow.space/config.json`,
or this file on GitHub until the domain is set up). Change a value, publish the file, and
the app uses it on its next start. No app update is needed.

| Key | Meaning |
| --- | --- |
| `ads.enabled` | All ads on or off (also skips the consent and tracking prompts when off) |
| `ads.banner`, `ads.interstitial`, `ads.appOpen` | Each ad type on or off |
| `ads.interstitialEveryEpisodes` | One interstitial every N episodes |
| `ads.interstitialCooldownSeconds` | Minimum seconds between full-screen ads |
| `ads.appOpenCooldownMinutes` | Minimum minutes between app open ads |
| `features.downloads` | Download button and Downloads in the Library |
| `features.openVideosInReelway` | Videos and series move into Reelway by themselves |
| `features.playOnTv` | The Chromecast button in the player |
| `features.backgroundPlay` | iPhone only: YouTube audio keeps playing in the background. Default off; ignored on Android |

Missing keys use the app's defaults. Keep the JSON valid: a broken file is ignored and the
app keeps the last good copy.

## Site profiles (`sites`)

One entry per website (its main domain, e.g. `liderdrama.com`), so each site uses the method
that fits how it is built. A profile here replaces the one built into the app for that site.

| Key | Values |
| --- | --- |
| `episodes` | `auto` (try everything), `links`, `buttons`, `param` |
| `param` | for `param`: the address parameter with the episode number, e.g. `ep` |
| `seriesPath` | pattern of series page addresses Reelway opens itself, e.g. `^/detail/watch/` |
| `autoOpen` | `false` keeps that site's videos in the browser |

## Admin panel

`server/admin.php` is deployed as `/var/www/reelbrow/admin/index.php` on the Hetzner server
(nginx basic auth, password file `/etc/nginx/reelbrow-admin.htpasswd`). It edits `config.json`:
ad switches and frequency, feature switches, and the Websites list (name, link, "Show on start
page", "Open videos in Reelway", and advanced episode settings).

### Announcements and push notifications

Each store has its own list in `announcements` (top level = App Store, inside `android` = Play
Store). Entry: `{"id", "title", "body", "date", "action": {"type": "url|settings|protection", "value", "label"}}`.
The newest entry is first. The app shows the newest one a person has not read on a full page
when the app opens, and keeps all of them under Settings, News.

"Also send as push notification" (new announcement) and the "Send a push notification" section
send through Firebase Cloud Messaging (HTTP v1) to the topic `ios-all` or `android-all`, with
`data`: `target` (`announcement|url|settings|protection`), `id` (announcement) or `value` (website).
The service account key is read from `/etc/reelway/fcm-service-account.json` (outside the web
root, owner root, group www-data, mode 640). It is never in git. Without it the push section
says push is not set up. Setup steps for Said: `docs/PUSH_SETUP.md`.
