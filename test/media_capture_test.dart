import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:reelway/browser/media_capture.dart';
import 'package:reelway/browser/website_ad_rules.dart';
import 'package:reelway/data/repositories/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final page = Uri.parse('https://drama.example.com/watch/love-story/ep-3');

  CapturedMedia media(String url, {bool video = false, int seconds = 0, Uri? on, int at = 0}) =>
      CapturedMedia(url: Uri.parse(url), page: on ?? page, fromVideo: video, seconds: seconds, at: at);

  group('Episode switching', () {
    test('the latest burst of playlists is the episode playing now', () {
      final found = MediaCapture.pick([
        media('https://cdn.example.com/ep1/master.m3u8', at: 1000),
        media('https://cdn.example.com/ep1/720.m3u8', at: 1200),
        media('https://cdn.example.com/ep2/master.m3u8', at: 60000),
        media('https://cdn.example.com/ep2/720.m3u8', at: 60150),
      ], page);
      expect(found?.url.path, '/ep2/master.m3u8');
    });

    test('the segments being downloaded pick the episode on screen, not the preloaded next one', () {
      CapturedMedia seg(String url, int at) =>
          CapturedMedia(url: Uri.parse(url), page: page, fromVideo: false, at: at, segment: true);
      final found = MediaCapture.pick([
        media('https://video.example.com/hls/5065/ep1.m3u8', at: 1000),
        seg('https://video.example.com/hls/5065/ep1/s0.ts', 1100),
        media('https://video.example.com/hls/5065/ep2.m3u8', at: 9000),
        seg('https://video.example.com/hls/5065/ep2/s0.ts', 9100),
        seg('https://video.example.com/hls/5065/ep1/s7.ts', 9500),
        seg('https://video.example.com/hls/5065/ep1/s8.ts', 12000),
      ], page);
      expect(found?.url.path, '/hls/5065/ep1.m3u8');
      expect(
        MediaCapture.decode(
          jsonEncode([
            {'u': 'https://video.example.com/a/s1.ts', 's': true, 'p': page.toString(), 't': 5},
          ]),
        ).single.segment,
        isTrue,
      );
    });

    test('videos from the previous episode are skipped', () {
      final items = [
        media('https://cdn.example.com/ep1/master.m3u8', at: 1000),
        media('https://cdn.example.com/ep1/720.m3u8', at: 1100),
      ];
      final exclude = {for (final m in items) m.url.toString()};
      expect(MediaCapture.pick(items, page, exclude: exclude), isNull);
      items.add(media('https://cdn.example.com/ep2/master.m3u8', at: 1500));
      expect(MediaCapture.pick(items, page, exclude: exclude)?.url.path, '/ep2/master.m3u8');
    });

    test('reads the page episode list; buttons become pressable episodes', () {
      final scanned = MediaCapture.decodeEpisodes(
        jsonEncode([
          {'n': 1, 'h': 'https://drama.example.com/watch/love-story/ep-1', 'a': false},
          {'n': 2, 'h': '', 'a': true},
          {'n': 3, 'h': 'https://elsewhere.com/ep-3', 'a': false},
          {'n': 0, 'h': ''},
        ]),
        page,
      );
      expect(scanned.map((e) => e.number), [1, 2, 3]);
      expect(scanned[2].link, isNull, reason: 'links to other sites are not followed');

      final title = MediaCapture.describe(page, '<title>Love Story</title>', scanned: scanned);
      expect(title.current, 2, reason: 'the page marks episode 2 as active');
      expect(title.episodes.map((e) => e.number), [1, 2, 3]);
      expect(title.episodes.first.page.toString(), 'https://drama.example.com/watch/love-story/ep-1');
      expect(MediaCapture.pressedEpisode(title.episodes.last.page), 3);
      expect(MediaCapture.pressedEpisode(title.episodes.first.page), isNull);
    });

    test('the episode the player asked for wins over the page', () {
      final scanned = [const ScannedEpisode(number: 1, active: true), const ScannedEpisode(number: 2)];
      expect(MediaCapture.describe(page, '', scanned: scanned, current: 2).current, 2);
    });
  });

  group('Ad domains', () {
    tearDown(() => AdDomains.domains = const {});

    test('parses the bundled list and matches subdomains', () {
      AdDomains.domains = AdDomains.parse('# comment\nn6wxm.com\n\nAdServer.Example\n');
      expect(AdDomains.isAdHost('n6wxm.com'), isTrue);
      expect(AdDomains.isAdHost('cdn.n6wxm.com'), isTrue);
      expect(AdDomains.isAdHost('adserver.example'), isTrue);
      expect(AdDomains.isAdHost('example.com'), isFalse);
      expect(MediaCapture.isAd(Uri.parse('https://x.n6wxm.com/v.m3u8')), isTrue);
    });

    test('the bundled EasyList file is present and only holds plain domains', () {
      final domains = AdDomains.parse(File(AdDomains.asset).readAsStringSync());
      expect(domains.length, greaterThan(20000));
      expect(domains.every((d) => RegExp(r'^[a-z0-9.-]+\.[a-z]{2,}$').hasMatch(d)), isTrue);
    });
  });

  group('MediaCapture.decode', () {
    test('reads what the watcher script recorded', () {
      final raw = jsonEncode([
        {'u': 'https://cdn.example.com/a/master.m3u8', 'v': false, 'd': 0, 'p': page.toString(), 't': 1},
        {'u': 'https://cdn.example.com/a.mp4', 'v': true, 'd': 95, 'p': page.toString(), 't': 2},
        {'u': 42, 'p': page.toString()},
      ]);
      final items = MediaCapture.decode(raw);
      expect(items, hasLength(2));
      expect(items.last.fromVideo, isTrue);
      expect(items.last.seconds, 95);
    });

    test('ignores anything that is not the expected list', () {
      expect(MediaCapture.decode(null), isEmpty);
      expect(MediaCapture.decode('not json'), isEmpty);
      expect(MediaCapture.decode('{"u":"x"}'), isEmpty);
    });
  });

  group('MediaCapture.pick', () {
    test('prefers a playing video long enough to be an episode', () {
      final found = MediaCapture.pick([
        media('https://cdn.example.com/ep3/master.m3u8'),
        media('https://cdn.example.com/ep3.mp4', video: true, seconds: 120),
      ], page);
      expect(found?.url.path, '/ep3.mp4');
    });

    test('skips short videos and ad networks', () {
      final found = MediaCapture.pick([
        media('https://cdn.example.com/promo.mp4', video: true, seconds: 15),
        media('https://ad.doubleclick.net/x/master.m3u8'),
        media('https://cdn.example.com/ads/preroll.m3u8'),
      ], page);
      expect(found, isNull);
    });

    test('falls back to the first HLS playlist (the master playlist)', () {
      final found = MediaCapture.pick([
        media('https://cdn.example.com/ep3/master.m3u8'),
        media('https://cdn.example.com/ep3/720p/index.m3u8'),
      ], page);
      expect(found?.url.path, '/ep3/master.m3u8');
    });

    test('only counts videos loaded on the page that is open now', () {
      final other = Uri.parse('https://drama.example.com/watch/love-story/ep-2');
      expect(MediaCapture.pick([media('https://cdn.example.com/ep2/master.m3u8', on: other)], page), isNull);
      expect(
        MediaCapture.pick([media('https://cdn.example.com/ep3/master.m3u8')], page.replace(fragment: 'player')),
        isNotNull,
      );
    });

    test('never picks insecure addresses', () {
      expect(MediaCapture.pick([media('http://cdn.example.com/ep3.m3u8')], page), isNull);
    });
  });

  group('MediaCapture.describe', () {
    const body = '''
<html><head>
<title>Watch Love Story Episode 3 | DramaSite</title>
<meta property="og:image" content="/posters/love.jpg">
</head><body>
<div class="episodes">
  <a href="/watch/love-story/ep-1">1</a>
  <a href="/watch/love-story/ep-2">EP 2</a>
  <a href="/watch/love-story/ep-3"><span>3</span></a>
  <a href="/watch/love-story/ep-4">Episode 4</a>
  <a href="https://other-site.com/ep-5">5</a>
  <a href="/vip">VIP</a>
</div></body></html>''';

    test('finds the title, poster and episode list', () {
      final title = MediaCapture.describe(page, body);
      expect(title.title, 'Love Story');
      expect(title.poster.toString(), 'https://drama.example.com/posters/love.jpg');
      expect(title.current, 3);
      expect(title.episodes.map((e) => e.number), [1, 2, 3, 4]);
      expect(title.episodes.first.page.toString(), 'https://drama.example.com/watch/love-story/ep-1');
    });

    test('episode labels in other languages are recognised', () {
      final title = MediaCapture.describe(
        Uri.parse('https://dramaexpress.example/serie/tres-novias/capitulo-1'),
        '<html><body>'
        '<a href="/serie/tres-novias/capitulo-1">Capítulo 1</a>'
        '<a href="/serie/tres-novias/capitulo-2">Capítulo 2</a>'
        '<a href="/serie/tres-novias/capitulo-3">Capítulo 3</a>'
        '</body></html>',
      );
      expect(title.episodes.map((e) => e.number), [1, 2, 3]);
      expect(title.current, 1);
    });

    test('feeds with the episode in the address get every episode from the total shown', () {
      final title = MediaCapture.describe(
        Uri.parse('https://liderdrama.example/dizi/nefes-dersleri?lang=en&ep=2'),
        '<html><body><div>Bölüm 2</div><div>Bölüm 3</div><button>2 / 40</button></body></html>',
      );
      expect(title.current, 2);
      expect(title.episodes, hasLength(40));
      expect(title.episodes.last.page.toString(), 'https://liderdrama.example/dizi/nefes-dersleri?lang=en&ep=40');
      expect(MediaCapture.totalEpisodes('Episode 4 of 60', 4), 60);
      expect(MediaCapture.totalEpisodes('30 Capítulos', 1), 30);
      expect(MediaCapture.totalEpisodes('Top 10 dramas 2026', 1), isNull);
    });

    test('the first episode without a number in the address uses the parameter its links use', () {
      final title = MediaCapture.describe(
        Uri.parse('https://drama.example/watch/love'),
        '<html><body><a href="/watch/love?ep=2">next</a><span>1 / 12</span></body></html>',
      );
      expect(title.episodes, hasLength(12));
      expect(title.episodes[4].page.toString(), 'https://drama.example/watch/love?ep=5');
    });

    test('a page without an episode list is one episode', () {
      final single = MediaCapture.describe(
        Uri.parse('https://videos.example.com/v/abc'),
        '<html><head><meta property="og:title" content="A Short Film"></head><body><a href="/x">1</a></body></html>',
      );
      expect(single.title, 'A Short Film');
      expect(single.current, 1);
      expect(single.episodes, hasLength(1));
    });

    test('reads the episode number from the address when the list does not show it', () {
      final title = MediaCapture.describe(
        Uri.parse('https://drama.example.com/play?id=9&episode=12'),
        '<html><head><title>Love Story</title></head><body>'
        '<a href="/play?id=9&episode=1">1</a><a href="/play?id=9&episode=2">2</a></body></html>',
      );
      expect(title.current, 12);
      expect(title.episodes.map((e) => e.number), [1, 2, 12]);
    });

    test('cleans common page title decorations', () {
      expect(
        MediaCapture.cleanTitle('Watch Sleep with Me, Mortal! Full Episodes Online Free | FindDrama', 'x.com'),
        'Sleep with Me, Mortal!',
      );
      expect(MediaCapture.cleanTitle('Love Story - EP 7 - DramaSite', 'x.com'), 'Love Story');
      expect(MediaCapture.cleanTitle('爱情故事 第3集', 'x.com'), '爱情故事');
      expect(MediaCapture.cleanTitle('   ', 'x.com'), 'x.com');
    });
  });

  group('AppState website titles', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('only the current episode has a video; the page is sent as Referer', () {
      final app = AppState(useSampleData: false);
      final video = Uri.parse('https://cdn.example.com/ep3/master.m3u8');
      final title = MediaCapture.describe(
        page,
        '<html><head><title>Love Story</title></head><body>'
        '<a href="/watch/love-story/ep-1">1</a><a href="/watch/love-story/ep-3">3</a></body></html>',
      );
      final content = app.showWebTitle(title, video);

      expect(AppState.isWebTitle(content.id), isTrue);
      expect(app.contentById(content.id)?.title, 'Love Story');
      expect(app.content.where((c) => c.id == content.id), isEmpty, reason: 'not listed in the Library');
      final episodes = app.episodesFor(content.id);
      expect(episodes.map((e) => e.isPlayable), [false, true]);
      expect(app.playbackHeadersFor(video)['Referer'], page.toString());
      expect(app.playbackHeadersFor(Uri.parse('https://cdn.example.com/other.m3u8')), isNot(contains('Referer')));
    });

    test('continuing a title keeps its id for the next episode', () async {
      final app = AppState(useSampleData: false);
      final first = app.showWebTitle(
        MediaCapture.describe(page, '<title>Love Story</title>'),
        Uri.parse('https://cdn.example.com/ep3.m3u8'),
      );
      final next = app.showWebTitle(
        MediaCapture.describe(Uri.parse('https://drama.example.com/watch/love-story/ep-4'), '<title>Other</title>'),
        Uri.parse('https://cdn.example.com/ep4.m3u8'),
        contentId: first.id,
      );
      expect(next.id, first.id);
      final source = await app.playbackSourceFor(app.episodesFor(first.id).single);
      expect(source.videoUrl.toString(), 'https://cdn.example.com/ep4.m3u8');
    });
  });
}
