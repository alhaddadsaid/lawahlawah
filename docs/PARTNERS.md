# Partner unlock

Reelway users watch partner websites without ads. A partner website signs a contract that
allows Reelway to hide its ads and skip its "watch ads to unlock" step **inside Reelway**.
The partner does not build anything: no API, no changes to its site. Reelway applies the
rules itself, on that site only, while the contract is in force.

Websites without a contract are browsed as they are. Reelway still blocks pop-ups,
pop-unders and taps hijacked into ads there, but it does not hide their ads or skip
their ad gates.

## How it works
- `lib/partners/partners.dart` lists the agreements.
- `lib/partners/partner_registry.dart` decides which are in force today and builds one page
  script for them. The script first checks the page's own address, so it does nothing on
  any other website.
- In the browser (`lib/browser/browser_view.dart`) that script runs at the start of every
  page. On a partner site it:
  1. hides the ad slots listed in `hideSelectors` (if `allowsHidingAds`),
  2. runs `unlockScript`, which skips the site's ad gate (if `allowsSkippingAdGate`). It runs
     when the page is ready and again whenever the page changes, so it must be safe to run
     many times.

An agreement runs only when:
- `status` is `signed`, there is a `contractReference` and a `validFrom` date, and today is
  between `validFrom` and `validUntil` (no end date means open-ended); or
- `status` is `test` and this is a development build or a build made with
  `--dart-define=REELWAY_TEST_PARTNER=true` (TestFlight). Test agreements are only for
  Reelway's own test pages, never a real website.

## Adding a partner (after the contract is signed)
1. Keep the signed contract outside this repository (for example Google Drive > Reelway >
   Partners) and note its reference.
2. Open the site in a desktop browser and note:
   - the CSS selectors of its ad slots (banners, overlays, "Support us" boxes the contract
     covers);
   - how its ad gate works (which element shows it, what unlocks the stream) and write a
     short `unlockScript` that skips it. Ask the partner to confirm the rules match the
     contract.
3. Add a `PartnerAgreement` to `Partners.all` with `status: AgreementStatus.signed`, the
   contract reference, `validFrom` (and `validUntil` if the contract ends), the two
   permissions the contract grants, the selectors and the unlock script.
4. Add unit tests for the new agreement (its domains, dates and that its script contains
   the rules) next to `test/partner_test.dart`.
5. Build TestFlight, open the site in Reelway and check: no ads, no ad gate, video plays.
6. When the contract ends, set `status: AgreementStatus.ended`. Nothing runs from then on.

Sites change their pages, so check each partner after their site updates and adjust the
selectors or unlock script.

## Testing on a phone
Debug builds and TestFlight builds include the test agreement for
https://httpbin.org/html: the page heading is hidden (it stands in for an ad) and a green
"Reelway partner unlock active" bar appears at the top. On any other site nothing changes.
