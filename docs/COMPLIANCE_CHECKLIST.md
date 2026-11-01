# Release compliance checklist

Complete before **every** store submission. Store approval is never guaranteed.

## Content and integrations
- [ ] No sample data in the release build (`AppState.useSampleData` is false outside debug; verify in a release build that no SAMPLE badges appear).
- [ ] Every active adapter has a documented `AdapterPermission` (agreement reference, who granted it, date, content rights confirmed).
- [ ] No adapter bypasses CAPTCHA, Cloudflare/anti-bot checks, logins, paywalls or DRM.
- [ ] Narto-Drama adapter stays locked unless its permission and content rights are on file.
- [ ] Store listing, screenshots and keywords do not name or show third-party sites, films or shows without permission.
- [ ] The app is not described as giving access to free movies/TV.

## Browser
- [ ] Popup protection does not break login, verification or playback on tested sites.
- [ ] No JavaScript bridge exposed to arbitrary sites.
- [ ] TLS validation untouched; mixed content blocked.
- [ ] Users can clear history, cookies, saved websites and all data.

## Advertising (phase 6)
- [ ] Google UMP consent form shown where required (EEA, UK, Switzerland) before ads load.
- [ ] Non-personalised ads when consent is not given.
- [ ] "Privacy options" entry point works (required by Google for consent revocation).
- [ ] No interstitial at launch, during playback, or repeatedly while browsing; frequency cap enforced.
- [ ] Banners never overlap navigation or content; no ads styled like site controls.
- [ ] Test ad unit IDs replaced with production IDs; `app-ads.txt` published.

## Privacy and legal
- [ ] Privacy policy reviewed by a lawyer and published at a public URL (also linked in the app).
- [ ] Terms of service reviewed and published.
- [ ] Google Play Data safety form and Apple App Privacy labels match actual data use (AdMob, Crashlytics).
- [ ] iOS App Tracking Transparency prompt if personalised ads use the IDFA.
- [ ] Age rating questionnaire answered honestly (unrestricted web access usually means 17+ on iOS and "Mature"/web-browser disclosures on Play).

## Platform rules
- [ ] iOS: uses WebKit (WKWebView) for all web content (App Store Review Guideline 2.5.6).
- [ ] iOS: app offers enough native functionality beyond a website wrapper (Guideline 4.2).
- [ ] Google Play: complies with the Intellectual Property, Deceptive Behaviour and WebView policies.
- [ ] Permissions requested only when needed (camera/mic only on a site's request, with user approval).

## Build
- [ ] `flutter analyze` and `flutter test` pass; CI green.
- [ ] Tested on physical iOS and Android devices (see ROADMAP.md test matrix).
- [ ] Version and build numbers bumped; release signed (Android keystore, Apple distribution certificate).
