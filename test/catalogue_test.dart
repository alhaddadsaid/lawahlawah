import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:reelway/sources/page_source.dart';

void main() {
  final featured = Uri.parse('https://narto-drama.com/featured?lang=es-ES');
  const catalogue = '''
<h1>Featured dramas</h1>
<link rel="next" href="/featured?lang=es-ES&amp;page=2">
<article class="card"><a href="/detail/watch/dragon?lang=es-ES">Open</a>
<img src="/dragon.jpg" alt="The Dragon"></article>
<a href="/detail/watch/dragon?from=home">Duplicate</a>
<a href="https://ads.example/ad">Ad</a>
''';

  test('website root opens the public Featured catalog without homepage scripts', () async {
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      return http.Response(catalogue, 200);
    });
    final page = await PageSource(client: client).read(Uri.parse('https://narto-drama.com/'));
    expect(requests.single.url, featured);
    expect(requests.single.headers.containsKey('cookie'), isFalse);
    expect(page.titles.single.title, 'The Dragon');
    expect(page.titles.single.poster.toString(), 'https://narto-drama.com/dragon.jpg');
    expect(page.canSearch, isTrue);
    expect(page.nextPage!.queryParameters['page'], '2');
    client.close();
  });

  test('remote search encodes query and parses results beyond the visible catalog', () async {
    late Uri requested;
    final client = MockClient((request) async {
      requested = request.url;
      expect(request.headers['X-Requested-With'], 'XMLHttpRequest');
      return http.Response(
        jsonEncode({
          'ok': true,
          'items': [
            {'title': 'Ocean & Sun', 'url': '/detail/watch/ocean', 'poster_url': '/ocean.jpg'},
            {'title': 'Duplicate', 'url': '/detail/watch/ocean?from=search'},
            {'title': 'Ad', 'url': 'https://ads.example/detail/watch/ad'},
            {'title': 'Insecure', 'url': 'http://narto-drama.com/detail/watch/no'},
            {'title': 'Invalid', 'url': 42},
          ],
          'failed_providers': ['timeout-provider'],
        }),
        200,
      );
    });
    final page = await PageSource(client: client).search(featured, ' ocean & sun ');
    expect(requested.path, '/search');
    expect(requested.queryParameters['q'], 'ocean & sun');
    expect(requested.queryParameters['lang'], 'es-ES');
    expect(page.titles.single.title, 'Ocean & Sun');
    expect(page.searchQuery, 'ocean & sun');
    expect(page.notice, contains('incomplete'));
    client.close();
  });

  test('empty search results remain searchable without inventing videos', () {
    final page = PageSource.parse(
      featured.replace(path: '/search', queryParameters: {'q': 'not found'}),
      '{"ok":true,"items":[],"failed_providers":[]}',
    );
    expect(page.titles, isEmpty);
    expect(page.series, isEmpty);
    expect(page.canSearch, isTrue);
  });

  test('pagination appends unique series and refuses off-site next links', () {
    final first = PageSource.parse(featured, catalogue);
    final second = PageSource.parse(first.nextPage!, '''
<link rel="next" href="https://ads.example/featured?page=3">
<a href="/detail/watch/dragon">Duplicate</a>
<a href="/detail/watch/new">New series</a>
''');
    final merged = first.append(second);
    expect(merged.titles.map((t) => t.title), ['The Dragon', 'New series']);
    expect(merged.nextPage, isNull);
    expect(merged.url, featured);
  });

  test('search errors and short queries produce actionable errors', () async {
    final throttled = MockClient((_) async => http.Response('{"message":"search_throttled"}', 200));
    final source = PageSource(client: throttled);
    await expectLater(source.search(featured, 'a'), throwsFormatException);
    await expectLater(source.search(featured, 'dragon'), throwsFormatException);
    await expectLater(source.search(Uri.parse('https://other.example/'), 'dragon'), throwsFormatException);
    throttled.close();
  });
}
