# Reelway: handoff for another agent

> Update: the user also authorized an optional browser screen for manually
> completing website verification. Catalog/search/player stay native. Current
> source support is documented in SOURCE_SUPPORT.md under docs; candidates must
> not be presented as verified integrations.


> **Current direction (2 November 2026):** The user requested native source
> exploration and playback in native screens, including skipping website ad
> prompts when public stream URLs are already exposed in page HTML. The active
> implementation is `lib/sources/page_source.dart` and the native Browse screen.
> Per-site partner approval flags do not gate this path. See
> [Native sources](NATIVE_SOURCES.md).
> Older browser/partner decisions below are historical. No App Store approval,
> rights clearance, device verification or distribution is implied.


Everything a new agent needs to change Reelway and ship a new build to Said's iPhone.
No passwords, keys or certificates are in this file or in the repo. Where a secret is
needed, this file says where it lives and who has it.

## 1. The project

| What | Value |
| --- | --- |
| App name | Reelway |
| Tech | Flutter (CI uses stable, 3.47.x / Dart 3.13.x), iOS and Android |
| GitHub repo | https://github.com/alhaddadsaid/lawahlawah |
| Branch | `streaming-browser` (the repo's `main` is an unrelated project, never merge into it) |
| Local copy on Said's Mac | `~/Documents/Flutter Projects /Reelway - Claude` (note the space after "Projects") |
| Bundle ID (iOS) | `com.reelway.reelway` (AdMob app ~8852134564) |
| applicationId (Android, Play: "Reelway: Video Browser") | `com.reelbrow.videobrowser` (AdMob app ~1572923698) |
| Agent notes | `CLAUDE.md` in the repo root, read it first |

Get the code:

```bash
git clone -b streaming-browser https://github.com/alhaddadsaid/lawahlawah.git reelway
cd reelway
flutter pub get
flutter analyze
flutter test
```

Before every push, run the same checks CI runs, or the build goes red:

```bash
dart format --output=none --set-exit-if-changed -l 120 lib test
flutter analyze
flutter test
```

`flutter analyze` treats infos as errors on GitHub CI, so it must say "No issues found".

## 2. GitHub access

The repo belongs to Said's GitHub account `alhaddadsaid`. A new agent can push in one of
two ways:

- **Agent on Said's Mac:** the GitHub CLI is already signed in as Said. Push with
  `git -c credential.helper='!gh auth git-credential' push origin streaming-browser`
  (plain `git push` asks for a username and fails).
- **Agent somewhere else:** Said adds that person or bot as a collaborator
  (GitHub > lawahlawah > Settings > Collaborators), or creates a fine-grained token
  (GitHub > Settings > Developer settings > Fine-grained tokens, repository
  `lawahlawah` only, permission Contents: read and write). Said gives the token to the
  agent privately. Never put it in the repo.

Every push to `streaming-browser` starts GitHub Actions (`.github/workflows/ci.yml`):
format, analyze, tests, Android APK, iOS build. Check it with
`gh run list -R alhaddadsaid/lawahlawah --branch streaming-browser`.

## 3. How a build reaches the iPhone (Codemagic and TestFlight)

Said has no Xcode on his Mac. iOS builds are made and signed by Codemagic in the cloud,
then sent to TestFlight.

| What | Value |
| --- | --- |
| Codemagic app | https://codemagic.io/app/6ae7c4c53d36fc06b58860a1 (signed in with Said's account) |
| Workflow | `ios-testflight`, shown as "Reelway - iOS TestFlight" |
| Config | `codemagic.yaml` in the repo |
| Trigger | By hand only (no push trigger, to save free macOS minutes) |
| App Store Connect app | https://appstoreconnect.apple.com/apps/6829556624 (SKU `reelway-ios`) |
| TestFlight group | Internal group "Said", automatic distribution, tester alhaddadsaid.es@gmail.com |

To ship a new test build:

1. Push the change to `streaming-browser` and wait for GitHub CI to be green.
2. Start the build, either:
   - in Codemagic: open the app, Start new build, branch `streaming-browser`,
     workflow "Reelway - iOS TestFlight"; or
   - from a terminal with a Codemagic API token (Codemagic > Team settings >
     Integrations > Codemagic API, Said copies it and gives it privately):

     ```bash
     curl -s -X POST https://api.codemagic.io/builds \
       -H "Content-Type: application/json" \
       -H "x-auth-token: $CM_API_TOKEN" \
       -d '{"appId":"6ae7c4c53d36fc06b58860a1","workflowId":"ios-testflight","branch":"streaming-browser"}'
     ```
3. The build takes about 5 minutes, then Apple processes it for 5 to 15 minutes.
   Said gets it in the TestFlight app on his iPhone. The build number goes up by itself
   (`$BUILD_NUMBER` from Codemagic); builds 1 to 4 are already used.

The workflow passes `--dart-define=REELWAY_TEST_PARTNER=true` (turns on the partner test
page). Remove it before any App Store release.

## 4. Certificates and keys: where each one lives

A new agent does not need to download any certificate to ship a TestFlight build.
Codemagic already holds everything and signs the app itself.

| Item | Where it is | Who needs it |
| --- | --- | --- |
| Apple Developer account | Said's Apple ID | Only Said signs in |
| App Store Connect API key "Codemagic Reelway" | Key ID `6A22JC6X3L`, Issuer ID `301d49d1-89b0-4c10-9966-a3fb47547add`, role App Manager. The secret part is the `.p8` file Said downloaded once (Apple does not let anyone download it again). | Stored in Codemagic as the team integration "Reelway ASC". Needed again only to set up a new CI service. |
| iOS Distribution certificate | Generated by Codemagic, kept in Codemagic > Team settings > codemagic.yaml settings > Code signing identities | Codemagic only |
| App Store provisioning profile for `com.reelway.reelway` | Fetched by Codemagic from Apple, same place | Codemagic only |
| Android signing | Not set up yet (APKs are debug signed or unsigned test builds) | Set up before a Play Store release |

If the `.p8` file is lost: App Store Connect > Users and Access > Integrations >
App Store Connect API, revoke "Codemagic Reelway", create a new key (App Manager),
download the new `.p8`, then in Codemagic replace the "Reelway ASC" integration with the
new Key ID, Issuer ID and file. Keep the integration name "Reelway ASC" exactly, the
workflow looks for that name.

If the certificate expires or is revoked: Codemagic > Code signing identities >
generate a new iOS distribution certificate, then fetch the App Store profile for
`com.reelway.reelway` again.

Never commit a `.p8`, `.p12`, `.mobileprovision`, token or password to the repo.

## 5. What the app does today

- Browser with pop-up and ad-hijack protection (`lib/browser/`).
- Partner unlock framework (`lib/partners/`, `docs/PARTNERS.md`): hides ads only on sites
  with a signed agreement recorded in `partners.dart`. Only a test entry for httpbin.org
  exists.
- Links and player (`lib/sources/link_feed.dart`, `lib/features/player/`,
  `docs/LINKS.md`): Library > link button. The user pastes a public https link (a video
  file or a catalog), accepts a disclaimer once ("I have the right to play the links I
  add"), and the titles play in Reelway's own player. No cookies or sign-in are sent, so
  only public links work. Test link: https://github.com/alhaddadsaid/dabreels-media
- Sample titles only in debug builds.

## 6. Decisions the next agent must keep

- Reelway does not bypass ads, ad gates, CAPTCHAs, Cloudflare checks, logins, paywalls
  or DRM on any site, and does not extract streams from sites that have not licensed
  them. Narto-Drama: its videos belong to other providers (ReelShort, DramaBox and
  others), so an agreement with Narto-Drama alone does not cover them. Its adapter stays
  `notDocumented` and it is not in `partners.dart`.
- Users are responsible for the links they add; the disclaimer and the "Links you add"
  section of the Terms say so. Keep both.
- Don't say something works until it ran on a device or in CI.

## 7. Next steps

1. Said tests TestFlight build 4 (links and player) on his iPhone. Fix what he reports.
2. Android signing and a Play Store test track when wanted.
3. Move the code to its own GitHub repo (it shares `lawahlawah` with another project).
