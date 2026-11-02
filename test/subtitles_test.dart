import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:reelway/features/player/subtitle_loader.dart';
import 'package:reelway/sources/page_source.dart';
import 'package:reelway/sources/subtitle_track.dart';

void main() {
  final source = Uri.parse('https://narto-drama.com/detail/watch/show/1?lang=es-ES');
  const vtt = 'WEBVTT\n\n00:00:01.000 --> 00:00:03.000\nHola\n';
  const srt = '1\n00:00:02,000 --> 00:00:04,500\nHello\n\n';

  test('reads Narto subtitle languages without insecure or duplicate tracks', () {
    final page = PageSource.parse(source, '''
<h1>Show</h1><script>const episodeItemsRaw = [{"number":1,"play_url":"https://cdn.example/one.m3u8",
"multi_subtitles":[
{"subtitle_url":"/subs/en.vtt","language_code":"en_US","label":"English"},
{"subtitle_url":"/subs/es.srt","language_code":"es-ES","label":"Español","is_default":true},
{"subtitle_url":"/subs/es2.srt","language_code":"es-ES","label":"Duplicate"},
{"subtitle_url":"http://insecure.example/ar.vtt","language_code":"ar"}],
"subtitle_url":"/subs/es.srt","selected_subtitle_language":"es-ES"}];</script>
''');
    final tracks = page.series.single.episodes.single.subtitles;
    expect(tracks.map((track) => track.language), ['en-us', 'es-es']);
    expect(tracks.last.label, 'Español');
    expect(tracks.last.isDefault, isTrue);
    expect(tracks.first.url.toString(), 'https://narto-drama.com/subs/en.vtt');
  });

  test('reads a default subtitle URL when there is no multi-language list', () {
    final page = PageSource.parse(source, '''
<script>const episodeItemsRaw = [{"number":1,"play_url":"https://cdn.example/one.mp4",
"subtitle_url":"/default.vtt","selected_subtitle_language":"ar"}];</script>
''');
    expect(page.series.single.episodes.single.subtitles.single.language, 'ar');
  });

  test('HTML subtitle tracks stay attached to their own video', () {
    final page = PageSource.parse(Uri.parse('https://example.com/shows'), '''
<video src="/a.mp4"><track kind="subtitles" src="/a.vtt" srclang="es" label="Español"></video>
<video src="/b.mp4"><track kind="subtitles" src="/b.vtt" srclang="en" label="English"></video>
''');
    expect(page.series.single.episodes.map((episode) => episode.subtitles.single.language), ['es', 'en']);
  });

  test('parses VTT and SRT cue timing for synchronized captions', () {
    final spanish = SubtitleLoader.parse(vtt).captions.single;
    expect(spanish.start, const Duration(seconds: 1));
    expect(spanish.end, const Duration(seconds: 3));
    expect(spanish.text, 'Hola');
    final english = SubtitleLoader.parse(srt).captions.single;
    expect(english.start, const Duration(seconds: 2));
    expect(english.end, const Duration(milliseconds: 4500));
    expect(() => SubtitleLoader.parse('#EXTM3U\nsegment.vtt'), throwsFormatException);
  });

  test('loads subtitle text and bounds failures without involving video playback', () async {
    final track = SubtitleTrack(url: Uri.parse('https://example.com/subtitles'), language: 'es', label: 'Español');
    final client = MockClient((_) async => http.Response(vtt, 200));
    final loaded = await SubtitleLoader(client: client).load(track);
    expect(loaded.captions.single.text, 'Hola');
    client.close();
    final insecure = MockClient(
      (_) async => http.Response('', 302, headers: {'location': 'http://example.com/subtitles'}),
    );
    await expectLater(SubtitleLoader(client: insecure).load(track), throwsFormatException);
    insecure.close();
    final large = MockClient((_) async => http.Response('x' * (SubtitleLoader.maxBytes + 1), 200));
    await expectLater(SubtitleLoader(client: large).load(track), throwsFormatException);
    large.close();
  });
}
