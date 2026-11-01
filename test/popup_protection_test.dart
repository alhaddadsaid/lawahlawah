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
    test('allows popup the user tapped, into a new tab', () {
      final d = p.onPopup(PopupRequestInfo(opener: site, target: other, hasUserGesture: true));
      expect(d.action, DecisionAction.allowInNewTab);
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
}
