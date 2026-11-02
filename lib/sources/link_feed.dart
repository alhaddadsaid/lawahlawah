/// Links the user adds to the Library: a video file, or a catalog of series
/// and episodes, played in Reelway's own player.
///
/// Rules: public links only. Reelway reads a link without cookies or sign-in,
/// so anything behind an account does not load. It reads only the link
/// itself, never other websites' pages, and each user is responsible for the
/// links they add. See docs/LINKS.md for the catalog formats.
library;

import 'dart:convert';

class LinkEpisode {
  const LinkEpisode({required this.number, required this.videoUrl, this.title, this.duration});

  final int number;
  final Uri videoUrl;
  final String? title;
  final Duration? duration;
}

class LinkSeries {
  const LinkSeries({required this.id, required this.title, required this.episodes, this.description, this.poster});

  /// Stable within its catalog (used to keep watch progress).
  final String id;
  final String title;
  final String? description;
  final Uri? poster;
  final List<LinkEpisode> episodes;
}

abstract final class LinkFeed {
  static const videoExtensions = ['.mp4', '.m4v', '.mov', '.m3u8'];

  /// Whether [url] points straight at a video file.
  static bool isVideo(Uri url) => videoExtensions.any(url.path.toLowerCase().endsWith);

  /// Checks what the user typed. Returns the link, or throws a
  /// [FormatException] with a message to show.
  static Uri check(String input) {
    final text = input.trim();
    final uri = Uri.tryParse(text.contains('://') ? text : 'https://$text');
    if (uri == null || uri.host.isEmpty) throw const FormatException('Enter a full link, starting with https://');
    if (uri.scheme != 'https') throw const FormatException('Only secure https:// links can be played.');
    if (uri.userInfo.isNotEmpty) throw const FormatException('Links with a sign-in are not supported.');
    return uri;
  }

  /// Where to read [link] from. A GitHub repository or release page points
  /// to the release's manifest.json.
  static Uri resolve(Uri link) {
    if (link.host != 'github.com') return link;
    final p = link.pathSegments.where((s) => s.isNotEmpty).toList();
    if (p.length == 2) return Uri.https('github.com', '/${p[0]}/${p[1]}/releases/latest/download/manifest.json');
    if (p.length == 5 && p[2] == 'releases' && p[3] == 'tag') {
      return Uri.https('github.com', '/${p[0]}/${p[1]}/releases/download/${p[4]}/manifest.json');
    }
    return link;
  }

  /// A single video link becomes one title with one episode.
  static LinkSeries single(Uri video) {
    final name = video.pathSegments.where((s) => s.isNotEmpty).lastOrNull ?? video.host;
    final dot = name.lastIndexOf('.');
    final title = prettify(dot > 0 ? name.substring(0, dot) : name);
    return LinkSeries(
      id: 'video',
      title: title,
      episodes: [LinkEpisode(number: 1, videoUrl: video)],
    );
  }

  /// The series in a catalog [body] read from [source]. Throws a
  /// [FormatException] when it is not a catalog Reelway can read.
  static List<LinkSeries> parse(Uri source, String body) {
    final Object? json;
    try {
      json = jsonDecode(body);
    } on FormatException {
      throw const FormatException('This link is not a video or a catalog Reelway can read.');
    }
    final List<LinkSeries> series;
    if (json is Map && json['films'] is List) {
      series = _dabReels(source, json['films'] as List);
    } else if (json is Map && json['series'] is List) {
      series = _reelway(source, json['series'] as List);
    } else {
      throw const FormatException('This link is not a video or a catalog Reelway can read.');
    }
    final playable = series.where((s) => s.episodes.isNotEmpty).toList();
    if (playable.isEmpty) throw const FormatException('The catalog has no playable https:// videos.');
    return playable;
  }

  /// DabReels manifest: {"films": [{"id", "credit", "license", "episodes":
  /// [{"n", "file", "duration"}]}]}, episode files next to the manifest as
  /// `<id>__<file>`.
  static List<LinkSeries> _dabReels(Uri source, List films) => [
    for (final f in films.whereType<Map>())
      if (f['id'] is String)
        LinkSeries(
          id: f['id'] as String,
          title: prettify(f['id'] as String),
          description: [
            if (f['credit'] is String) f['credit'] as String,
            if (f['license'] is String) 'License: ${f['license']}',
          ].join('\n'),
          episodes: [
            for (final e in (f['episodes'] as List? ?? const []).whereType<Map>())
              if (e['n'] is int && e['file'] is String)
                LinkEpisode(
                  number: e['n'] as int,
                  videoUrl: source.resolve('${f['id']}__${e['file']}'),
                  duration: _seconds(e['duration']),
                ),
          ],
        ),
  ];

  /// Reelway catalog: {"series": [{"title", "description"?, "poster"?,
  /// "episodes": [{"url", "title"?}]}]}. Addresses may be relative to the
  /// catalog link.
  static List<LinkSeries> _reelway(Uri source, List series) => [
    for (final (i, s) in series.whereType<Map>().indexed)
      if (s['title'] is String)
        LinkSeries(
          id: 's$i',
          title: s['title'] as String,
          description: s['description'] as String?,
          poster: s['poster'] is String ? _https(source, s['poster'] as String) : null,
          episodes: [
            for (final (j, e) in (s['episodes'] as List? ?? const []).whereType<Map>().indexed)
              if (e['url'] is String && _https(source, e['url'] as String) != null)
                LinkEpisode(
                  number: j + 1,
                  videoUrl: _https(source, e['url'] as String)!,
                  title: e['title'] as String?,
                  duration: _seconds(e['duration']),
                ),
          ],
        ),
  ];

  static Uri? _https(Uri source, String ref) {
    final uri = Uri.tryParse(ref);
    if (uri == null) return null;
    final full = source.resolveUri(uri);
    return full.scheme == 'https' ? full : null;
  }

  static Duration? _seconds(Object? v) => v is num ? Duration(milliseconds: (v * 1000).round()) : null;

  /// "big_buck_bunny" -> "Big Buck Bunny".
  static String prettify(String id) {
    final words = id.split(RegExp(r'[_\-\s]+')).where((w) => w.isNotEmpty);
    return words.map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }
}
