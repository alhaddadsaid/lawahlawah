import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reelway/browser/media_capture.dart';
import 'package:reelway/browser/site_profiles.dart';
import 'package:reelway/browser/website_ad_rules.dart';
import 'package:reelway/data/remote_config.dart';

void main() {
  tearDown(() => RemoteConfig.instance.debugSet(const {}));

  test('built-in profiles per site, automatic detection elsewhere', () {
    expect(SiteProfiles.forUrl(Uri.parse('https://liderdrama.com/dizi/x')).episodes, EpisodeMethod.param);
    expect(SiteProfiles.forUrl(Uri.parse('https://reelshort.chartdrama.com/p/x')).episodes, EpisodeMethod.buttons);
    expect(SiteProfiles.forUrl(Uri.parse('https://example.com/')).episodes, EpisodeMethod.auto);
    expect(SiteProfiles.isSeriesPage(Uri.parse('https://narto-drama.com/detail/watch/love')), isTrue);
    expect(SiteProfiles.isSeriesPage(Uri.parse('https://narto-drama.com/featured')), isFalse);
    expect(SiteProfiles.isSeriesPage(Uri.parse('https://example.com/detail/watch/love')), isFalse);
  });

  test('the server can add or change a site profile', () {
    RemoteConfig.instance.debugSet({
      'sites': {
        'example.com': {'episodes': 'links', 'seriesPath': r'^/show/', 'autoOpen': false},
      },
    });
    final profile = SiteProfiles.forUrl(Uri.parse('https://www.example.com/show/1'));
    expect(profile.episodes, EpisodeMethod.links);
    expect(profile.autoOpen, isFalse);
    expect(SiteProfiles.isSeriesPage(Uri.parse('https://example.com/show/abc')), isTrue);
  });

  test('a profile picks the method: links stay links even when buttons are found', () {
    final page = Uri.parse('https://drama.example/watch/love/ep-1');
    const body = '<a href="/watch/love/ep-1">1</a><a href="/watch/love/ep-2">2</a><a href="/watch/love/ep-3">3</a>';
    const buttons = [
      ScannedEpisode(number: 1),
      ScannedEpisode(number: 2),
      ScannedEpisode(number: 3),
      ScannedEpisode(number: 4),
    ];
    final links = MediaCapture.describe(
      page,
      body,
      scanned: buttons,
      profile: const SiteProfile(episodes: EpisodeMethod.links),
    );
    expect(links.episodes.map((e) => e.number), [1, 2, 3]);
    final pressed = MediaCapture.describe(
      page,
      body,
      scanned: buttons,
      profile: const SiteProfile(episodes: EpisodeMethod.buttons),
    );
    expect(pressed.episodes.map((e) => e.number), [1, 2, 3, 4]);
  });

  test('the param method builds every episode address from the total', () {
    final title = MediaCapture.describe(
      Uri.parse('https://liderdrama.com/dizi/nefes?ep=3'),
      '<a href="/dizi/other">5</a><a href="/dizi/other2">6</a><button>3 / 25</button>',
      profile: SiteProfiles.forUrl(Uri.parse('https://liderdrama.com/')),
    );
    expect(title.episodes, hasLength(25));
    expect(title.current, 3);
  });

  test('ad exceptions per site and platform', () {
    RemoteConfig.instance.debugSet({
      'sites': {
        'youtube.com': {'allowAds': 'all'},
        'facebook.com': {'allowAds': 'android'},
      },
    });
    expect(SiteProfiles.forUrl(Uri.parse('https://m.youtube.com/')).allowAds, AdsException.everywhere);
    expect(SiteProfiles.forUrl(Uri.parse('https://facebook.com/')).allowAds, AdsException.android);
    // Tests run as Android by default.
    expect(SiteProfiles.adsAllowedSites(), ['facebook.com', 'youtube.com']);
    // Each store reads its own site list.
    RemoteConfig.instance.debugSet({
      'sites': {
        'youtube.com': {'allowAds': 'all'},
      },
      'android': {
        'sites': {
          'dailymotion.com': {'allowAds': 'all'},
        },
      },
    });
    expect(SiteProfiles.adsAllowedSites(), ['dailymotion.com']);
    RemoteConfig.instance.debugSet({
      'sites': {
        'youtube.com': {'allowAds': 'all'},
        'facebook.com': {'allowAds': 'android'},
      },
    });
    // A tab on these sites runs without ad rules; other pages keep them.
    expect(adsAllowedOn(Uri.parse('https://m.youtube.com/watch?v=x')), isTrue);
    expect(adsAllowedOn(Uri.parse('https://www.facebook.com/')), isTrue);
    expect(adsAllowedOn(Uri.parse('https://example.com/')), isFalse);
    expect(adsAllowedOn(Uri.parse('about:blank')), isFalse);
    expect(adsAllowedOn(null), isFalse);
    // The server's switch for this store wins over the app setting.
    expect(websiteAdBlocking(true), isTrue);
    RemoteConfig.instance.debugSet({
      'features': {'blockWebsiteAds': true},
      'android': {
        'features': {'blockWebsiteAds': false},
      },
    });
    // Tests run as Android: the Play Store block is used.
    expect(websiteAdBlocking(true), isFalse);
    RemoteConfig.instance.debugSet({
      'features': {'blockWebsiteAds': false},
    });
    // No Play Store value: the App Store one applies.
    expect(websiteAdBlocking(true), isFalse);
    RemoteConfig.instance.debugSet(const {});
    // The rules themselves never carry an exception entry.
    expect(browserAdRules().every((r) => r.action.type == ContentBlockerActionType.BLOCK), isTrue);
  });
}
