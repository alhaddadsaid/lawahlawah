import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:reelway/sources/page_source.dart';
import 'package:reelway/sources/source_verification.dart';

void main() {
  final origin = Uri.parse('https://source.example/show');

  test('verification keeps only check cookies for the same HTTPS origin', () {
    final session = VerifiedSourceSession(
      origin: origin,
      userAgent: 'Browser UA',
      cookies: {'cf_clearance': 'verified', 'login_session': 'private', 'nd_ck': 'bad;injection'},
    );
    expect(session.headersFor(origin)['Cookie'], 'cf_clearance=verified');
    expect(session.headersFor(origin)['User-Agent'], 'Browser UA');
    for (final url in [
      'https://other.example/',
      'https://sub.source.example/',
      'http://source.example/',
      'https://source.example:444/',
    ]) {
      expect(session.headersFor(Uri.parse(url)), isEmpty);
    }
    final expired = VerifiedSourceSession(
      origin: origin,
      userAgent: 'UA',
      cookies: {'cf_clearance': 'old'},
      createdAt: DateTime.now().subtract(const Duration(minutes: 31)),
    );
    expect(expired.headersFor(origin), isEmpty);
  });

  test('a redirect never forwards verification cookies to another website', () async {
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      return request.url.host == origin.host
          ? http.Response('', 302, headers: {'location': 'https://other.example/show'})
          : http.Response('<h1>Other website</h1>', 200);
    });
    final source = PageSource(client: client)
      ..rememberVerification(
        VerifiedSourceSession(origin: origin, userAgent: 'Browser UA', cookies: {'cf_clearance': 'ok'}),
      );
    await source.read(origin);
    expect(requests.first.headers['cookie'], 'cf_clearance=ok');
    expect(requests.last.headers.containsKey('cookie'), isFalse);
    expect(requests.last.headers.containsKey('user-agent'), isFalse);
    client.close();
  });

  test('blocked requests ask for user verification without automatic challenge attempts', () async {
    var requests = 0;
    final client = MockClient((_) async {
      requests++;
      return http.Response('Forbidden', 403);
    });
    await expectLater(PageSource(client: client).read(origin), throwsA(isA<SourceVerificationRequired>()));
    expect(requests, 1);
    expect(
      () => PageSource.parse(
        origin,
        '<title>Loading</title>Checking your browser<script src="/cdn-cgi/check.js"></script>',
      ),
      throwsA(isA<SourceVerificationRequired>()),
    );
    expect(PageSource.parse(origin, '<h1>Unsupported player</h1>').series, isEmpty);
    client.close();
  });

  test('common structured catalogs expose series links without guessing player code', () {
    final page = PageSource.parse(origin, '''
<script type="application/ld+json">{"@type":"CollectionPage","mainEntity":{"@type":"ItemList","itemListElement":[
{"@type":"ListItem","item":{"name":"Another show","url":"/series/one","image":"/poster.jpg"}},
{"@type":"ListItem","item":{"name":"External","url":"https://ads.example/series"}}
]}}</script>
''');
    expect(page.titles.single.title, 'Another show');
    expect(page.titles.single.url.toString(), 'https://source.example/series/one');
    expect(page.series, isEmpty);
  });
}
