import 'package:flutter_test/flutter_test.dart';
import 'package:reelway/adapters/adapter_registry.dart';
import 'package:reelway/adapters/site_adapter.dart';
import 'package:reelway/browser/popup_protection.dart';
import 'package:reelway/browser/tab_manager.dart';
import 'package:reelway/core/security/url_policy.dart';
import 'package:reelway/data/models/models.dart';
import 'package:reelway/data/models/user_settings.dart';

class _FakeAdapter extends SiteAdapter {
  _FakeAdapter(this.permission);
  @override
  final AdapterPermission permission;
  @override
  String get id => 'fake';
  @override
  String get displayName => 'Fake';
  @override
  List<String> get domains => ['fake.example'];
  @override
  PageKind classify(Uri url) => PageKind.other;
  @override
  Future<List<Content>> parseCatalogue(PageSnapshot page) async => const [];
  @override
  Future<Content?> parseMovie(PageSnapshot page) async => null;
  @override
  Future<Content?> parseSeries(PageSnapshot page) async => null;
  @override
  Future<List<Episode>> parseEpisodes(PageSnapshot page, String seriesId) async => const [];
  @override
  Future<PlaybackSource?> resolvePlayback(PageSnapshot page) async => null;
}

void main() {
  group('UrlPolicy.parse', () {
    test('bare host upgrades to https', () {
      final r = UrlPolicy.parse('example.com/path') as AddressUrl;
      expect(r.uri.toString(), 'https://example.com/path');
      expect(r.upgradedToHttps, isTrue);
    });
    test('explicit http is kept', () {
      final r = UrlPolicy.parse('http://example.com') as AddressUrl;
      expect(r.uri.scheme, 'http');
      expect(r.upgradedToHttps, isFalse);
    });
    test('words become a search', () {
      expect(UrlPolicy.parse('best drama 2025'), isA<AddressSearch>());
      final s = UrlPolicy.parse('cats') as AddressSearch;
      expect(s.searchUri().toString(), 'https://duckduckgo.com/?q=cats');
    });
    test('dangerous schemes rejected', () {
      for (final t in ['javascript:alert(1)', 'JAVASCRIPT:x', 'file:///etc/hosts', 'data:text/html,x']) {
        expect(UrlPolicy.parse(t), isA<AddressRejected>(), reason: t);
      }
    });
    test('empty and oversize rejected', () {
      expect(UrlPolicy.parse('   '), isA<AddressRejected>());
      expect(UrlPolicy.parse('a' * 5000), isA<AddressRejected>());
    });
    test('host:port and IPs', () {
      expect((UrlPolicy.parse('localhost:8080') as AddressUrl).uri.port, 8080);
      expect((UrlPolicy.parse('10.0.0.1') as AddressUrl).uri.host, '10.0.0.1');
    });
  });

  group('TabManager', () {
    test('open, activate, close keeps a valid active tab', () {
      final m = TabManager();
      final a = m.open(Uri.parse('https://a.com'))!;
      final b = m.open(Uri.parse('https://b.com'))!;
      expect(m.active!.id, b.id);
      m.activate(a.id);
      expect(m.active!.id, a.id);
      m.close(a.id);
      expect(m.active!.id, b.id);
      m.close(b.id);
      expect(m.active, isNull);
      expect(m.isEmpty, isTrue);
    });
    test('caps the number of tabs', () {
      final m = TabManager(maxTabs: 2);
      expect(m.open(Uri.parse('https://a.com')), isNotNull);
      expect(m.open(Uri.parse('https://b.com')), isNotNull);
      expect(m.open(Uri.parse('https://c.com')), isNull);
    });
  });

  group('Adapters', () {
    test('undocumented adapter never activates', () {
      final r = AdapterRegistry([_FakeAdapter(AdapterPermission.notDocumented)]);
      final u = Uri.parse('https://www.fake.example/x');
      expect(r.activeFor(u), isNull);
      expect(r.statusFor(u), IntegrationStatus.pendingPermission);
    });
    test('documented without content rights still inactive', () {
      final r = AdapterRegistry([_FakeAdapter(AdapterPermission(documented: true, verifiedOn: DateTime(2026)))]);
      expect(r.activeFor(Uri.parse('https://fake.example')), isNull);
    });
    test('fully documented adapter activates', () {
      final r = AdapterRegistry([
        _FakeAdapter(AdapterPermission(documented: true, contentRightsConfirmed: true, verifiedOn: DateTime(2026))),
      ]);
      expect(r.activeFor(Uri.parse('https://fake.example')), isNotNull);
      expect(r.statusFor(Uri.parse('https://other.example')), IntegrationStatus.browserOnly);
    });
    test('default registry: Narto-Drama is locked', () {
      final r = AdapterRegistry();
      expect(r.all.single.permission.canActivate, isFalse);
    });
  });

  group('PlaybackSource', () {
    test('detects formats', () {
      expect(PlaybackSource.detectFormat(Uri.parse('https://x/a.m3u8?t=1')), StreamFormat.hls);
      expect(PlaybackSource.detectFormat(Uri.parse('https://x/a.mpd')), StreamFormat.dash);
      expect(PlaybackSource.detectFormat(Uri.parse('https://x/a.MP4')), StreamFormat.mp4);
      expect(
        PlaybackSource.detectFormat(Uri.parse('https://x/play'), mimeType: 'application/vnd.apple.mpegurl'),
        StreamFormat.hls,
      );
      expect(PlaybackSource.detectFormat(Uri.parse('https://x/play')), StreamFormat.unknown);
    });
    test('never claims DRM or unknown streams are playable', () {
      final u = Uri.parse('https://x/a.m3u8');
      expect(PlaybackSource(uri: u, format: StreamFormat.hls).canPlayNatively, isTrue);
      expect(PlaybackSource(uri: u, format: StreamFormat.hls, drmProtected: true).canPlayNatively, isFalse);
      expect(PlaybackSource(uri: u, format: StreamFormat.unknown).canPlayNatively, isFalse);
    });
  });

  group('Models', () {
    test('UserSettings JSON round trip and tolerant parsing', () {
      const s = UserSettings(
        protectionLevel: ProtectionLevel.strict,
        allowedPopupSites: {'a.com'},
        preferredPlaybackSpeed: 1.5,
      );
      final back = UserSettings.fromJson(s.toJson());
      expect(back.protectionLevel, ProtectionLevel.strict);
      expect(back.allowedPopupSites, {'a.com'});
      expect(back.preferredPlaybackSpeed, 1.5);
      final junk = UserSettings.fromJson({'protectionLevel': 'nonsense', 'saveHistory': 'yes'});
      expect(junk.protectionLevel, ProtectionLevel.balanced);
      expect(junk.saveHistory, isTrue);
    });
    test('WatchHistory progress', () {
      final h = WatchHistory(
        id: 'h',
        contentId: 'c',
        sourceUrl: 'https://x',
        lastWatched: DateTime(2026),
        playbackPosition: const Duration(minutes: 57),
        duration: const Duration(minutes: 60),
      );
      expect(h.progress, closeTo(0.95, 0.001));
      expect(h.isFinished, isTrue);
    });
    test('Website JSON round trip', () {
      final w = Website(id: '1', name: 'A', url: 'https://a.com/', dateAdded: DateTime(2026, 1, 2));
      final back = Website.fromJson(w.toJson());
      expect(back.host, 'a.com');
      expect(back.integrationStatus, IntegrationStatus.browserOnly);
    });
  });
}
