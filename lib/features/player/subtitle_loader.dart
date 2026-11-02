import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import '../../sources/link_feed.dart';
import '../../sources/subtitle_track.dart';

/// Loads external SRT/WebVTT tracks. HLS subtitle playlists and image-based
/// subtitle formats need separate support; they are not parsed as text captions.
class SubtitleLoader {
  SubtitleLoader({this.client});
  final http.Client? client;
  static const maxBytes = 2 * 1024 * 1024;

  Future<ClosedCaptionFile> load(SubtitleTrack track, {Map<String, String> Function(Uri)? headersFor}) async {
    final connection = client ?? http.Client();
    try {
      var url = LinkFeed.check(track.url.toString());
      for (var redirects = 0; redirects <= 4; redirects++) {
        LinkFeed.check(url.toString());
        final request = http.Request('GET', url)..followRedirects = false;
        request.headers.addAll(headersFor?.call(url) ?? const {});
        final response = await connection.send(request).timeout(const Duration(seconds: 15));
        if ([301, 302, 303, 307, 308].contains(response.statusCode)) {
          final next = response.headers['location'];
          if (next == null) throw const FormatException('Invalid subtitle redirect.');
          await response.stream.listen((_) {}).cancel();
          url = url.resolve(next);
          continue;
        }
        if (response.statusCode != 200) throw const FormatException('The subtitle track is unavailable.');
        final bytes = <int>[];
        await for (final chunk in response.stream.timeout(const Duration(seconds: 15))) {
          if (bytes.length + chunk.length > maxBytes) throw const FormatException('This subtitle track is too large.');
          bytes.addAll(chunk);
        }
        return parse(utf8.decode(bytes, allowMalformed: true));
      }
      throw const FormatException('Too many subtitle redirects.');
    } finally {
      if (client == null) connection.close();
    }
  }

  static ClosedCaptionFile parse(String body) {
    final text = body.replaceFirst(RegExp('^\\uFEFF'), '').trimLeft();
    final ClosedCaptionFile file = text.startsWith('WEBVTT') ? WebVTTCaptionFile(text) : SubRipCaptionFile(text);
    if (file.captions.isEmpty) throw const FormatException('No supported text captions were found.');
    return file;
  }
}
