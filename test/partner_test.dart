import 'package:flutter_test/flutter_test.dart';
import 'package:reelway/partners/partner_agreement.dart';
import 'package:reelway/partners/partner_registry.dart';
import 'package:reelway/partners/partners.dart';

void main() {
  const signed = PartnerAgreement(
    id: 'site',
    siteName: 'Site',
    domains: ['site.example'],
    status: AgreementStatus.signed,
    contractReference: 'RW-TEST-1',
    validFrom: '2027-01-01',
    validUntil: '2027-12-31',
    allowsHidingAds: true,
    allowsSkippingAdGate: true,
    hideSelectors: ['.ad-slot'],
    unlockScript: 'window.rwUnlocked = true;',
  );
  final page = Uri.parse('https://www.site.example/detail/watch/a-title');

  PartnerRegistry on(String day, {List<PartnerAgreement> list = const [signed], bool testBuild = false}) {
    return PartnerRegistry(agreements: list, testBuild: testBuild, clock: () => DateTime.parse(day));
  }

  group('partner agreements', () {
    test('a signed agreement runs only from its start date to its end date', () {
      expect(on('2026-12-31').inForceFor(page), isNull);
      expect(on('2027-01-01 08:00').inForceFor(page), signed);
      expect(on('2027-12-31 23:00').inForceFor(page), signed);
      expect(on('2028-01-01').inForceFor(page), isNull);
    });

    test('covers the site and its subdomains, nothing else', () {
      final r = on('2027-06-01');
      expect(r.inForceFor(Uri.parse('https://site.example/')), signed);
      expect(r.inForceFor(Uri.parse('https://notsite.example/')), isNull);
      expect(r.inForceFor(Uri.parse('https://site.example.evil.com/')), isNull);
    });

    test('no contract reference or start date: never runs', () {
      const noRef = PartnerAgreement(
        id: 'a',
        siteName: 'A',
        domains: ['a.example'],
        status: AgreementStatus.signed,
        validFrom: '2027-01-01',
      );
      const noStart = PartnerAgreement(
        id: 'b',
        siteName: 'B',
        domains: ['b.example'],
        status: AgreementStatus.signed,
        contractReference: 'RW-TEST-2',
      );
      expect(on('2027-06-01', list: [noRef, noStart]).inForce, isEmpty);
    });

    test('negotiating and ended agreements never run', () {
      const talks = PartnerAgreement(
        id: 'c',
        siteName: 'C',
        domains: ['c.example'],
        status: AgreementStatus.negotiating,
      );
      const over = PartnerAgreement(id: 'd', siteName: 'D', domains: ['d.example'], status: AgreementStatus.ended);
      expect(on('2027-06-01', list: [talks, over], testBuild: true).inForce, isEmpty);
    });

    test('the test page runs only in development and test builds', () {
      final httpbin = Uri.parse('https://httpbin.org/html');
      expect(on('2027-06-01', list: Partners.all).inForceFor(httpbin), isNull);
      expect(on('2027-06-01', list: Partners.all, testBuild: true).inForceFor(httpbin)?.id, 'reelway-test');
    });
  });

  group('partner page script', () {
    test('hides the ad slots and runs the unlock step on the partner site', () {
      final js = on('2027-06-01').pageScript!;
      expect(js, contains('"site.example"'));
      expect(js, contains('.ad-slot { display: none !important; }'));
      expect(js, contains('window.rwUnlocked = true;'));
      expect(js, contains('location.hostname'));
    });

    test('runs only what the contract allows', () {
      const hideOnly = PartnerAgreement(
        id: 'e',
        siteName: 'E',
        domains: ['e.example'],
        status: AgreementStatus.test,
        allowsHidingAds: true,
        hideSelectors: ['.ad'],
        unlockScript: 'window.rwUnlocked = true;',
      );
      final js = PartnerRegistry.buildPageScript(const [hideOnly])!;
      expect(js, contains('.ad { display: none !important; }'));
      expect(js, isNot(contains('rwUnlocked')));
    });

    test('no agreement in force: no script at all', () {
      expect(on('2026-06-01').pageScript, isNull);
      expect(PartnerRegistry.buildPageScript(const []), isNull);
    });
  });
}
