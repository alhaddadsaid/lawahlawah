import 'partner_agreement.dart';

/// Reelway's partner agreements. Add a website only once its contract is
/// signed; see docs/PARTNERS.md for the steps.
abstract final class Partners {
  /// Runs the test agreement in a store-style build (TestFlight). Never set
  /// for an App Store or Play Store release.
  static const testPartnerBuild = bool.fromEnvironment('REELWAY_TEST_PARTNER');

  static const all = <PartnerAgreement>[
    // Reelway's own check, on a public test page (https://httpbin.org/html):
    // its heading stands in for an ad and is hidden, and the unlock step shows
    // a green "Reelway partner unlock active" bar. Proves the rules run.
    PartnerAgreement(
      id: 'reelway-test',
      siteName: 'Reelway test page (httpbin.org)',
      domains: ['httpbin.org'],
      status: AgreementStatus.test,
      allowsHidingAds: true,
      allowsSkippingAdGate: true,
      hideSelectors: ['h1'],
      unlockScript: _testUnlock,
    ),
    // A real partner, once the contract is signed (example):
    // PartnerAgreement(
    //   id: 'example-site',
    //   siteName: 'Example Site',
    //   domains: ['example-site.com'],
    //   status: AgreementStatus.signed,
    //   contractReference: 'RW-2027-001, Google Drive > Reelway > Partners',
    //   validFrom: '2027-01-01',
    //   allowsHidingAds: true,
    //   allowsSkippingAdGate: true,
    //   hideSelectors: ['.ad-slot', '#banner-top'],
    //   unlockScript: '...written for the site and agreed with the partner...',
    // ),
  ];

  static const _testUnlock = r'''
if (document.getElementById('reelway-partner-check')) return;
var bar = document.createElement('div');
bar.id = 'reelway-partner-check';
bar.textContent = 'Reelway partner unlock active';
bar.style.cssText = 'background:#1f9d55;color:#fff;padding:12px;font:16px sans-serif;text-align:center';
document.body.insertBefore(bar, document.body.firstChild);
''';
}
