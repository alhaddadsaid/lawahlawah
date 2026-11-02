import 'package:flutter_test/flutter_test.dart';
import 'package:reelway/data/models/models.dart';
import 'package:reelway/data/repositories/app_state.dart';
import 'package:reelway/sources/link_feed.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LinkFeed', () {
    test('accepts https links only, without sign-in details', () {
      expect(LinkFeed.check('example.com/a.mp4').toString(), 'https://example.com/a.mp4');
      expect(() => LinkFeed.check('http://example.com/a.mp4'), throwsFormatException);
      expect(() => LinkFeed.check('https://user:pass@example.com/a.mp4'), throwsFormatException);
      expect(() => LinkFeed.check('   '), throwsFormatException);
    });

    test('GitHub repository and release pages point to the release manifest', () {
      expect(
        LinkFeed.resolve(Uri.parse('https://github.com/alhaddadsaid/dabreels-media')).toString(),
        'https://github.com/alhaddadsaid/dabreels-media/releases/latest/download/manifest.json',
      );
      expect(
        LinkFeed.resolve(Uri.parse('https://github.com/alhaddadsaid/dabreels-media/releases/tag/v1')).toString(),
        'https://github.com/alhaddadsaid/dabreels-media/releases/download/v1/manifest.json',
      );
      final direct = Uri.parse('https://example.com/catalog.json');
      expect(LinkFeed.resolve(direct), direct);
    });

    test('a video link becomes one title with one episode', () {
      final s = LinkFeed.single(Uri.parse('https://example.com/films/my_first_film.mp4'));
      expect(s.title, 'My First Film');
      expect(s.episodes.single.videoUrl.toString(), 'https://example.com/films/my_first_film.mp4');
      expect(LinkFeed.isVideo(Uri.parse('https://example.com/live/index.m3u8')), isTrue);
      expect(LinkFeed.isVideo(Uri.parse('https://example.com/catalog.json')), isFalse);
    });

    test('reads a DabReels manifest: episode files sit next to the manifest', () {
      final source = Uri.parse('https://github.com/o/r/releases/download/v1/manifest.json');
      const body = '''
{"films": [{"id": "big_buck_bunny", "license": "CC BY 3.0", "credit": "Blender Foundation",
  "episodes": [{"n": 1, "file": "ep_01.mp4", "duration": 99.75}, {"n": 2, "file": "ep_02.mp4", "duration": 100}]}]}
''';
      final s = LinkFeed.parse(source, body).single;
      expect(s.title, 'Big Buck Bunny');
      expect(s.description, contains('CC BY 3.0'));
      expect(s.episodes, hasLength(2));
      final first = s.episodes.first.videoUrl.toString();
      expect(first, 'https://github.com/o/r/releases/download/v1/big_buck_bunny__ep_01.mp4');
      expect(s.episodes.first.duration, const Duration(milliseconds: 99750));
    });

    test('reads a Reelway catalog, keeping only https videos', () {
      final source = Uri.parse('https://example.com/shows/catalog.json');
      const body = '''
{"series": [{"title": "My Show", "poster": "poster.jpg", "episodes": [
  {"url": "ep1.mp4", "title": "Pilot"},
  {"url": "http://insecure.example/ep2.mp4"},
  {"url": "https://cdn.example/ep3.m3u8"}]}]}
''';
      final s = LinkFeed.parse(source, body).single;
      expect(s.poster.toString(), 'https://example.com/shows/poster.jpg');
      final urls = s.episodes.map((e) => e.videoUrl.toString()).toList();
      expect(urls, ['https://example.com/shows/ep1.mp4', 'https://cdn.example/ep3.m3u8']);
      expect(s.episodes.first.title, 'Pilot');
    });

    test('anything else is refused with a clear message', () {
      final source = Uri.parse('https://example.com/page');
      expect(() => LinkFeed.parse(source, '<html></html>'), throwsFormatException);
      expect(() => LinkFeed.parse(source, '{"films": []}'), throwsFormatException);
    });
  });

  group('links in the Library', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('a video link adds a playable title that survives a restart', () async {
      final a = AppState(useSampleData: false);
      await a.load();
      expect(await a.addLink('http://example.com/a.mp4'), isNotNull);
      expect(await a.addLink('https://example.com/my_film.mp4'), isNull);
      expect(await a.addLink('https://example.com/my_film.mp4'), isNotNull, reason: 'no duplicates');
      final film = a.content.single;
      expect(film.title, 'My Film');
      expect(film.category, ContentCategory.movie);
      final ep = a.episodesFor(film.id).single;
      expect(ep.isPlayable, isTrue);

      a.recordProgress(film, ep, const Duration(seconds: 30), const Duration(minutes: 2));
      await Future<void>.delayed(Duration.zero);

      final b = AppState(useSampleData: false);
      await b.load();
      await b.refreshLinks();
      expect(b.links, ['https://example.com/my_film.mp4']);
      expect(b.content.single.title, 'My Film');
      expect(b.historyFor(film.id)?.playbackPosition, const Duration(seconds: 30));

      b.removeLink('https://example.com/my_film.mp4');
      expect(b.content, isEmpty);
      expect(b.historyFor(film.id), isNull);
    });

    test('the disclaimer is accepted once and remembered', () async {
      final a = AppState(useSampleData: false);
      await a.load();
      expect(a.linksDisclaimerAccepted, isFalse);
      a.acceptLinksDisclaimer();
      final b = AppState(useSampleData: false);
      await b.load();
      expect(b.linksDisclaimerAccepted, isTrue);
    });
  });
}
