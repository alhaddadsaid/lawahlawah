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

Missing keys use the app's defaults. Keep the JSON valid: a broken file is ignored and the
app keeps the last good copy.
