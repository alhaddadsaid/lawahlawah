import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:reelway/sources/page_source.dart';

void main() {
  final episode = Uri.parse('https://narto-drama.com/detail/watch/a-show/1');
  const page = '''
<html><head><meta property="og:image" content="/poster.jpg"></head>
<body><h1>A &amp; B</h1><script>
const episodeItemsRaw = [
 {"number":2,"title":"Episode ]; 2","play_url":"https:\\/\\/cdn.example\\/two.m3u8","watch_url":"/detail/watch/a-show/2"},
 {"number":1,"play_url":"https://cdn.example/one.m3u8","watch_url":"/detail/watch/a-show/1"},
 {"number":1,"play_url":"https://cdn.example/duplicate.m3u8"},
 {"number":3,"play_url":"http://cdn.example/insecure.m3u8"},
 {"number":4,"play_url":"https://cdn.example/locked.m3u8","is_playable":false},
 {"number":5,"play_url":"https://cdn.example/silent.mp4","direct_audio_url":"https://cdn.example/audio.m4a"}
];
window.adCode = 'never executed';</script></body></html>
''';

  test('reads Narto playlist without running gate or ad scripts', () {
    final series = PageSource.parse(episode, page).series.single;
    expect(series.title, 'A & B');
    expect(series.id, 'a-show');
    expect(series.poster.toString(), 'https://narto-drama.com/poster.jpg');
    expect(series.episodes.map((e) => e.number), [1, 2]);
    expect(series.episodes.last.videoUrl.toString(), 'https://cdn.example/two.m3u8');
    expect(series.episodes.last.title, 'Episode ]; 2');
    expect(series.episodes.first.pageUrl.toString(), 'https://narto-drama.com/detail/watch/a-show/1');
  });

  test('never interprets playlist-shaped scripts on unrelated hosts', () {
    expect(PageSource.parse(Uri.parse('https://example.com/'), page).series, isEmpty);
  });

  test('supports HTML video and JSON-LD content URLs, ignoring ad links', () {
    final result = PageSource.parse(Uri.parse('https://example.com/show'), '''
<title>Example</title><video><source src="/a.mp4"></video>
<a href="https://ads.example/ad.mp4">Advertisement</a>
<script type="application/ld+json">{"@graph":[{"@type":"VideoObject","contentUrl":"/b.m3u8"}]}</script>
<meta property="og:video" content="/a.mp4">
''');
    expect(result.series.single.episodes.map((e) => e.videoUrl.path), ['/a.mp4', '/b.m3u8']);
  });

  test('malformed scripts and unsupported pages produce no fake streams', () {
    expect(PageSource.parse(episode, '<script>const episodeItemsRaw = [oops];</script>').series, isEmpty);
    expect(PageSource.parse(episode, '<h1>Verification required</h1>').series, isEmpty);
  });

  test('reads series then its first episode once, without cookies or ad requests', () async {
    final requests = <Uri>[];
    final client = MockClient((request) async {
      requests.add(request.url);
      expect(request.headers.containsKey('cookie'), isFalse);
      if (request.url.path.endsWith('/a-show')) {
        return http.Response('<a href="/detail/watch/a-show/1">EP 1</a>', 200);
      }
      return http.Response(page, 200);
    });
    final result = await PageSource(client: client).read(Uri.parse('https://narto-drama.com/detail/watch/a-show'));
    expect(result.series.single.episodes, hasLength(2));
    expect(requests, hasLength(2));
    expect(requests.every((u) => u.host == 'narto-drama.com'), isTrue);
    client.close();
  });

  test('blocks insecure redirects and bounds redirect loops', () async {
    final insecure = MockClient((_) async => http.Response('', 302, headers: {'location': 'http://example.com/'}));
    await expectLater(PageSource(client: insecure).read(episode), throwsFormatException);
    insecure.close();
    var count = 0;
    final loop = MockClient((_) async {
      count++;
      return http.Response('', 302, headers: {'location': '/loop'});
    });
    await expectLater(PageSource(client: loop).read(episode), throwsFormatException);
    expect(count, 5);
    loop.close();
  });

  test('bounds response size and reports HTTP failures', () async {
    final large = MockClient((_) async => http.Response('x' * (PageSource.maxBytes + 1), 200));
    await expectLater(PageSource(client: large).read(episode), throwsFormatException);
    large.close();
    final forbidden = MockClient((_) async => http.Response('Forbidden', 403));
    await expectLater(PageSource(client: forbidden).read(episode), throwsFormatException);
    forbidden.close();
  });
}
