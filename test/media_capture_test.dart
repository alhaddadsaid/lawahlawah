import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:reelway/browser/media_capture.dart';
import 'package:reelway/data/repositories/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final page = Uri.parse('https://drama.example.com/watch/love-story/ep-3');

  CapturedMedia media(String url, {bool video = false, int seconds = 0, Uri? on}) =>
      CapturedMedia(url: Uri.parse(url), page: on ?? page, fromVideo: video, seconds: seconds);

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
