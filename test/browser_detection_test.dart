import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:reelway/sources/page_source.dart';
import 'package:reelway/sources/source_verification.dart';

void main() {
  final url = Uri.parse('https://example.com/show');
  test('ordinary browsing and shopping lists do not trigger series detection', () {
    final source = PageSource();
    expect(source.inspectBrowserPage(url, '<h1>Welcome</h1><p>Read our news</p>'), isNull);
    expect(
      source.inspectBrowserPage(
        url,
        '''<script type="application/ld+json">
{"@type":"ItemList","itemListElement":[{"@type":"ListItem","item":{"name":"Shoes","url":"/products/shoes"}}]}</script>''',
      ),
      isNull,
    );
  });

  test('browser media snapshot is reused and clearing website data removes it', () async {
    var requests = 0;
    final client = MockClient((_) async {
      requests++;
      return http.Response('<h1>Not a video</h1>', 200);
    });
    final source = PageSource(client: client);
    expect(
      source.inspectBrowserPage(url, '<h1>A show</h1><video src="https://cdn.example/movie.mp4"></video>'),
      isNotNull,
    );
    expect((await source.read(url)).series, isNotEmpty);
    expect(requests, 0);
    source.clearVerification();
    expect((await source.read(url)).series, isEmpty);
    expect(requests, 1);
    client.close();
  });

  test('verification supports Cloudflare frames but never marks a waiting challenge ready', () {
    expect(VerificationPolicy.allows(url, Uri.parse('about:srcdoc'), mainFrame: false), isTrue);
    expect(
      VerificationPolicy.allows(url, Uri.parse('https://challenges.cloudflare.com/check'), mainFrame: false),
      isTrue,
    );
    expect(VerificationPolicy.allows(url, Uri.parse('javascript:alert(1)'), mainFrame: true), isFalse);
    expect(VerificationPolicy.allows(url, Uri.parse('https://unrelated.example'), mainFrame: true), isFalse);
    for (final text in ['Performing security verification', 'Verify you are human', '']) {
      expect(
        VerificationPolicy.pageReady(
          original: url,
          current: url,
          title: 'Website',
          text: text,
          challengeVisible: false,
        ),
        isFalse,
      );
    }
    expect(
      VerificationPolicy.pageReady(
        original: url,
        current: url,
        title: 'Series',
        text: 'Choose an episode',
        challengeVisible: true,
      ),
      isFalse,
    );
    expect(
      VerificationPolicy.pageReady(
        original: url,
        current: url,
        title: 'Series',
        text: 'Choose an episode',
        challengeVisible: false,
      ),
      isTrue,
    );
  });
}
