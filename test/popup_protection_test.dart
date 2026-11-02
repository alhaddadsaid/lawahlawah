import 'package:flutter_test/flutter_test.dart';
import 'package:reelway/browser/popup_protection.dart';

void main() {
  final site = Uri.parse('https://www.watchsite.com/series/1');
  final sameSiteOther = Uri.parse('https://cdn.watchsite.com/player');
  final other = Uri.parse('https://elsewhere.net/landing');
  final bad = Uri.parse('https://x.popads.net/click?id=1');

  group('registrableDomain', () {
    test('collapses subdomains', () {
      expect(PopupProtection.registrableDomain('a.b.example.com'), 'example.com');
      expect(PopupProtection.registrableDomain('example.com'), 'example.com');
      expect(PopupProtection.registrableDomain('WWW.Example.COM.'), 'example.com');
    });
    test('handles two-part public suffixes', () {
      expect(PopupProtection.registrableDomain('www.bbc.co.uk'), 'bbc.co.uk');
      expect(PopupProtection.registrableDomain('shop.store.com.au'), 'store.com.au');
    });
    test('leaves IPs alone', () {
      expect(PopupProtection.registrableDomain('192.168.1.10'), '192.168.1.10');
    });
  });

  group('popups (balanced)', () {
    late PopupProtection p;
    setUp(() => p = PopupProtection());

    test('blocks popup without a gesture', () {
      final d = p.onPopup(PopupRequestInfo(opener: site, target: other, hasUserGesture: false));
      expect(d.isBlocked, isTrue);
      expect(p.log, hasLength(1));
      expect(p.log.first.site, 'watchsite.com');
    });
    test('allows a tapped open-in-new-tab link to that same site', () {
      final d = p.onPopup(
        PopupRequestInfo(opener: site, target: other, hasUserGesture: true, tap: TapInfo.link(other)),
      );
      expect(d.action, DecisionAction.allowInNewTab);
    });
    test('allows a tapped same-site pop-up', () {
      final d = p.onPopup(PopupRequestInfo(opener: site, target: sameSiteOther, hasUserGesture: true));
      expect(d.action, DecisionAction.allowInNewTab);
    });
    test('blocks a pop-up to another site that hijacks a tap on an internal link', () {
      final episode = Uri.parse('https://www.watchsite.com/series/1/ep/2');
      final d = p.onPopup(
        PopupRequestInfo(opener: site, target: other, hasUserGesture: true, tap: TapInfo.link(episode)),
      );
      expect(d.isBlocked, isTrue);
      expect(d.target, other, reason: 'target kept for "Open anyway"');
    });
    test('blocks a tapped pop-up to another site when the tap is unknown', () {
      expect(p.onPopup(PopupRequestInfo(opener: site, target: other, hasUserGesture: true)).isBlocked, isTrue);
    });
    test('blocks a blank pop-up window even after a tap (pop-under)', () {
      expect(p.onPopup(PopupRequestInfo(opener: site, target: null, hasUserGesture: true)).isBlocked, isTrue);
    });
    test('blocks blocklisted destination even with a gesture', () {
      expect(p.onPopup(PopupRequestInfo(opener: site, target: bad, hasUserGesture: true)).isBlocked, isTrue);
    });
    test('blank-window popup without gesture is blocked and logged', () {
      final d = p.onPopup(PopupRequestInfo(opener: site, target: null, hasUserGesture: false));
      expect(d.isBlocked, isTrue);
      expect(p.log.first.target, '(blank window)');
    });
    test('allowed site bypasses gesture rule but not unsafe schemes', () {
      p.allowSite(site);
      expect(p.onPopup(PopupRequestInfo(opener: site, target: other, hasUserGesture: false)).isBlocked, isFalse);
      expect(
        p
            .onPopup(PopupRequestInfo(opener: site, target: Uri.parse('javascript:alert(1)'), hasUserGesture: true))
            .isBlocked,
        isTrue,
      );
    });
  });

  group('popups (strict / off)', () {
    test('strict blocks even tapped popups', () {
      final p = PopupProtection(level: ProtectionLevel.strict);
      expect(p.onPopup(PopupRequestInfo(opener: site, target: other, hasUserGesture: true)).isBlocked, isTrue);
    });
    test('off allows popups but still refuses dangerous schemes', () {
      final p = PopupProtection(level: ProtectionLevel.off);
      expect(p.onPopup(PopupRequestInfo(opener: site, target: bad, hasUserGesture: false)).isBlocked, isFalse);
      expect(
        p
            .onPopup(PopupRequestInfo(opener: site, target: Uri.parse('file:///etc/passwd'), hasUserGesture: true))
            .isBlocked,
        isTrue,
      );
    });
  });

  group('navigation', () {
    late PopupProtection p;
    setUp(() => p = PopupProtection());

    NavigationRequestInfo nav(Uri target, {bool gesture = false, bool main = true, Uri? from}) =>
        NavigationRequestInfo(current: from ?? site, target: target, isMainFrame: main, hasUserGesture: gesture);

    test('first load is allowed', () {
      expect(
        p.onNavigation(NavigationRequestInfo(target: site, isMainFrame: true, hasUserGesture: false)).isBlocked,
        isFalse,
      );
    });
    test('user-tapped link to another site is allowed', () {
      expect(p.onNavigation(nav(other, gesture: true)).isBlocked, isFalse);
    });
    test('tapped link to another site, confirmed by the tap, is allowed', () {
      final r = NavigationRequestInfo(
        current: site,
        target: other,
        isMainFrame: true,
        hasUserGesture: true,
        tap: TapInfo.link(other),
      );
      expect(p.onNavigation(r).isBlocked, isFalse);
    });
    test('click-hijack: tap on an internal link that lands on an ad site is blocked', () {
      final r = NavigationRequestInfo(
        current: site,
        target: Uri.parse('https://win-prize.example/landing'),
        isMainFrame: true,
        hasUserGesture: true,
        tap: TapInfo.link(Uri.parse('https://www.watchsite.com/series/2')),
      );
      final d = p.onNavigation(r);
      expect(d.isBlocked, isTrue);
      expect(d.reason, contains('redirected to an ad'));
    });
    test('tap on a non-link (ad overlay) that jumps to another site is blocked', () {
      final r = NavigationRequestInfo(
        current: site,
        target: other,
        isMainFrame: true,
        hasUserGesture: true,
        tap: const TapInfo.nonLink(),
      );
      expect(p.onNavigation(r).isBlocked, isTrue);
    });
    test('tapped internal link that stays on the site is allowed', () {
      final r = NavigationRequestInfo(
        current: site,
        target: sameSiteOther,
        isMainFrame: true,
        hasUserGesture: true,
        tap: TapInfo.link(sameSiteOther),
      );
      expect(p.onNavigation(r).isBlocked, isFalse);
    });
    test('"Open anyway" lets one blocked navigation through, once', () {
      expect(p.onNavigation(nav(other)).isBlocked, isTrue);
      p.allowOnce(other);
      expect(p.onNavigation(nav(other)).isBlocked, isFalse);
      expect(p.onNavigation(nav(other)).isBlocked, isTrue);
    });
    test('automatic cross-site redirect of main page is blocked', () {
      final d = p.onNavigation(nav(other));
      expect(d.isBlocked, isTrue);
      expect(d.reason, contains('redirect'));
    });
    test('automatic same-site navigation is allowed (e.g. after verification)', () {
      expect(p.onNavigation(nav(sameSiteOther)).isBlocked, isFalse);
    });
    test('sub-frames are not filtered except blocklist (keeps players working)', () {
      expect(p.onNavigation(nav(other, main: false)).isBlocked, isFalse);
      expect(p.onNavigation(nav(bad, main: false)).isBlocked, isTrue);
    });
    test('blocklisted host is blocked even when tapped', () {
      expect(p.onNavigation(nav(bad, gesture: true)).isBlocked, isTrue);
    });
    test('javascript:, file:, data: are always blocked', () {
      for (final u in ['javascript:void(0)', 'file:///sdcard/x', 'data:text/html,hi']) {
        expect(p.onNavigation(nav(Uri.parse(u), gesture: true)).isBlocked, isTrue, reason: u);
      }
    });
    test('about:blank allowed', () {
      expect(p.onNavigation(nav(Uri.parse('about:blank'))).isBlocked, isFalse);
    });
    test('external app schemes need a gesture, then ask the user', () {
      final tel = Uri.parse('tel:+441234567890');
      expect(p.onNavigation(nav(tel)).isBlocked, isTrue);
      expect(p.onNavigation(nav(tel, gesture: true)).action, DecisionAction.askExternal);
    });
    test('allowed site permits automatic redirects', () {
      p.allowSite(site);
      expect(p.onNavigation(nav(other)).isBlocked, isFalse);
    });
    test('off level allows redirects', () {
      p.level = ProtectionLevel.off;
      expect(p.onNavigation(nav(other)).isBlocked, isFalse);
    });
  });

  test('log is capped', () {
    final p = PopupProtection(maxLogEntries: 3);
    for (var i = 0; i < 10; i++) {
      p.onPopup(PopupRequestInfo(opener: site, target: other, hasUserGesture: false));
    }
    expect(p.log, hasLength(3));
  });

  group('intended destination after a blocked ad', () {
    final title = Uri.parse('https://www.watchsite.com/detail/watch/some-title');
    test('is the pressed link on the same site', () {
      expect(PopupProtection.intendedDestination(site, TapInfo.link(title)), title);
    });
    test('is nothing for a tap on a non-link, another site, or the same page', () {
      expect(PopupProtection.intendedDestination(site, const TapInfo.nonLink()), isNull);
      expect(PopupProtection.intendedDestination(site, TapInfo.link(other)), isNull);
      expect(PopupProtection.intendedDestination(site, TapInfo.link(site.replace(fragment: 'top'))), isNull);
      expect(PopupProtection.intendedDestination(site, TapInfo.link(Uri.parse('javascript:void(0)'))), isNull);
      expect(PopupProtection.intendedDestination(site, null), isNull);
    });
  });

  test('pop-under script pattern (narto-drama, Nov 2026) is fully blocked', () {
    // Tap on a title link -> script opens a blank window, then, if refused,
    // opens the ad address directly. Both must be blocked.
    final p = PopupProtection();
    final page = Uri.parse('https://narto-drama.com/?tab-provider=anyreel');
    final tap = TapInfo.link(Uri.parse('https://narto-drama.com/detail/watch/some-title'));
    expect(p.onPopup(PopupRequestInfo(opener: page, target: null, hasUserGesture: true, tap: tap)).isBlocked, isTrue);
    final ad = Uri.parse('https://bony-teaching.com/WX6wIn');
    expect(p.onPopup(PopupRequestInfo(opener: page, target: ad, hasUserGesture: true, tap: tap)).isBlocked, isTrue);
    final unknownAd = Uri.parse('https://brand-new-ad-network.example/x');
    expect(
      p.onPopup(PopupRequestInfo(opener: page, target: unknownAd, hasUserGesture: true, tap: tap)).isBlocked,
      isTrue,
      reason: 'blocked by the tap rule even when not on any list',
    );
    expect(PopupProtection.intendedDestination(page, tap), tap.href);
  });

  group('refused pop-up replayed in the tab (iOS)', () {
    final ad = Uri.parse('https://bony-teaching.com/WX6wIn');
    final title = Uri.parse('https://narto-drama.com/detail/watch/some-title');
    final blank = Uri.parse('about:blank');
    bool replay(Uri? refused, Uri? target) => PopupProtection.isRefusedPopupLoad(refused: refused, target: target);

    test('blank refused pop-up: blank loads are cancelled, real pages are not', () {
      expect(replay(null, null), isTrue);
      expect(replay(null, Uri()), isTrue);
      expect(replay(null, blank), isTrue);
      expect(replay(null, title), isFalse);
    });

    test('refused pop-up with an address: only that address is cancelled', () {
      expect(replay(ad, ad), isTrue);
      expect(replay(ad, blank), isFalse);
      expect(replay(ad, title), isFalse);
    });
  });

  test('a server redirect of the page the user just opened is part of their tap', () {
    final now = DateTime(2026, 11, 2, 23);
    final tapped = now.subtract(const Duration(seconds: 2));
    expect(PopupProtection.isRedirectOfUserNavigation(loading: true, userNavAt: tapped, now: now), isTrue);
    expect(
      PopupProtection.isRedirectOfUserNavigation(loading: false, userNavAt: tapped, now: now),
      isFalse,
      reason: 'a jump from a page that finished loading is the page itself',
    );
    expect(PopupProtection.isRedirectOfUserNavigation(loading: true, userNavAt: null, now: now), isFalse);
    expect(
      PopupProtection.isRedirectOfUserNavigation(
        loading: true,
        userNavAt: now.subtract(const Duration(seconds: 30)),
        now: now,
      ),
      isFalse,
    );
  });
}
