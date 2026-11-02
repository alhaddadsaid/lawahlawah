import 'dart:convert';

import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

import 'link_feed.dart';

class PageTitle {
  const PageTitle({required this.title, required this.url, this.poster});
  final String title;
  final Uri url;
  final Uri? poster;
}

class SourcePage {
  const SourcePage({required this.url, required this.title, this.series = const [], this.titles = const []});
  final Uri url;
  final String title;
  final List<LinkSeries> series;
  final List<PageTitle> titles;
}

/// Reads public documents as data. Never evaluates website JavaScript, opens
/// ad windows, shares browser cookies, or manufactures ad-completion requests.
class PageSource {
  PageSource({this.client});
  final http.Client? client;
  static const maxBytes = 4 * 1024 * 1024;

  static bool isNarto(Uri uri) => uri.host == 'narto-drama.com' || uri.host == 'www.narto-drama.com';

  Future<SourcePage> read(Uri input) async {
    final requestClient = client ?? http.Client();
    try {
      var page = await _read(requestClient, LinkFeed.resolve(LinkFeed.check(input.toString())));
      // Series pages expose episode page links; the first episode contains the
      // serialized playlist. Follow only one same-site link, never crawl ads.
      if (page.series.isEmpty && isNarto(page.url) && page.url.path.startsWith('/detail/watch/')) {
        final episode = page.titles.where((t) => RegExp(r'/detail/watch/[^/]+/\d+/?$').hasMatch(t.url.path));
        if (episode.isNotEmpty) page = await _read(requestClient, episode.first.url);
      }
      return page;
    } finally {
      if (client == null) requestClient.close();
    }
  }

  Future<SourcePage> _read(http.Client client, Uri input) async {
    if (LinkFeed.isVideo(input)) {
      return SourcePage(url: input, title: LinkFeed.single(input).title, series: [LinkFeed.single(input)]);
    }
    var url = input;
    for (var redirects = 0; redirects <= 4; redirects++) {
      LinkFeed.check(url.toString());
      final response = await client
          .send(http.Request('GET', url)..followRedirects = false)
          .timeout(const Duration(seconds: 20));
      if ([301, 302, 303, 307, 308].contains(response.statusCode)) {
        final location = response.headers['location'];
        if (location == null) throw const FormatException('The website returned an invalid redirect.');
        await response.stream.listen((_) {}).cancel();
        url = url.resolve(location);
        continue;
      }
      if (response.statusCode != 200) {
        throw FormatException('The website returned error ${response.statusCode}.');
      }
      final bytes = <int>[];
      await for (final chunk in response.stream.timeout(const Duration(seconds: 20))) {
        if (bytes.length + chunk.length > maxBytes) {
          throw const FormatException('This page is too large to import. Try a series or episode link.');
        }
        bytes.addAll(chunk);
      }
      return parse(url, utf8.decode(bytes, allowMalformed: true));
    }
    throw const FormatException('The website redirected too many times.');
  }

  static SourcePage parse(Uri source, String body) {
    if (body.trimLeft().startsWith('{')) {
      final series = LinkFeed.parse(source, body);
      return SourcePage(url: source, title: source.host, series: series);
    }
    final document = html.parse(body);
    final title =
        document.querySelector('h1')?.text.trim() ?? document.querySelector('title')?.text.trim() ?? source.host;
    String? meta(String name) =>
        document.querySelector('meta[property="$name"],meta[name="$name"]')?.attributes['content'];
    Uri? secure(String? value) {
      if (value == null || value.trim().isEmpty) return null;
      try {
        return LinkFeed.check(source.resolve(value.trim()).toString());
      } on FormatException {
        return null;
      }
    }

    final episodes = <LinkEpisode>[];
    final seen = <String>{};
    if (isNarto(source)) {
      for (final script in document.querySelectorAll('script:not([src])')) {
        final value = _jsonArray(script.text, 'episodeItemsRaw');
        if (value == null) continue;
        for (final item in value.whereType<Map>()) {
          if (item['is_playable'] == false) continue;
          // A separate audio track needs a different playback implementation.
          if (item['direct_audio_url'] is String && (item['direct_audio_url'] as String).isNotEmpty) continue;
          final url = secure(item['direct_play_url'] as String?) ?? secure(item['play_url'] as String?);
          final number = item['route_episode_number'] ?? item['number'];
          if (url == null || number is! int || number < 1 || !seen.add('episode:$number')) continue;
          episodes.add(
            LinkEpisode(
              number: number,
              videoUrl: url,
              pageUrl: secure(item['watch_url'] as String?),
              title: item['title'] as String?,
            ),
          );
        }
        if (episodes.isNotEmpty) break;
      }
    }
    if (episodes.isEmpty) {
      // Only media elements and video metadata; arbitrary .mp4 anchors may be ads.
      final candidates = <String?>[
        for (final node in document.querySelectorAll('video[src],video source[src]')) node.attributes['src'],
        meta('og:video:secure_url'),
        meta('og:video'),
      ];
      for (final script in document.querySelectorAll('script[type="application/ld+json"]')) {
        try {
          void walk(Object? node) {
            if (node is List) {
              for (final item in node) {
                walk(item);
              }
            } else if (node is Map) {
              final type = node['@type'];
              if (type == 'VideoObject' || (type is List && type.contains('VideoObject'))) {
                if (node['contentUrl'] is String) candidates.add(node['contentUrl'] as String);
              }
              walk(node['@graph']);
            }
          }

          walk(jsonDecode(script.text));
        } on FormatException {
          /* Ignore malformed optional metadata. */
        }
      }
      for (final candidate in candidates) {
        final url = secure(candidate);
        if (url == null || !LinkFeed.isVideo(url) || !seen.add(url.toString())) continue;
        episodes.add(LinkEpisode(number: episodes.length + 1, videoUrl: url, pageUrl: source));
      }
    }
    episodes.sort((a, b) => a.number.compareTo(b.number));
    final titles = <PageTitle>[];
    final destinations = <String>{};
    for (final anchor in document.querySelectorAll('a[href]')) {
      final url = secure(anchor.attributes['href']);
      if (url == null || url.host != source.host || !destinations.add(url.toString())) continue;
      if (isNarto(source) && !url.path.startsWith('/detail/watch/')) continue;
      if (!isNarto(source) && !LinkFeed.isVideo(url)) continue;
      final image = anchor.querySelector('img');
      final label = anchor.attributes['aria-label'] ?? image?.attributes['alt'] ?? anchor.text.trim();
      if (label.isEmpty) continue;
      titles.add(
        PageTitle(title: label, url: url, poster: secure(image?.attributes['data-src'] ?? image?.attributes['src'])),
      );
    }
    final slug = source.pathSegments.length >= 3 && isNarto(source) ? source.pathSegments[2] : 'page';
    return SourcePage(
      url: source,
      title: title,
      series: episodes.isEmpty
          ? const []
          : [
              LinkSeries(
                id: slug,
                title: title,
                description: meta('og:description') ?? meta('description'),
                poster: secure(meta('og:image')),
                episodes: episodes,
              ),
            ],
      titles: titles,
    );
  }

  /// Decode a JSON literal embedded in a script without executing any script.
  /// Balanced brackets handle strings containing `];`, quotes, or nested arrays.
  static List? _jsonArray(String script, String variable) {
    final match = RegExp('(?:const|let|var)\\s+$variable\\s*=\\s*(\\[)').firstMatch(script);
    if (match == null) return null;
    final start = match.end - 1;
    var depth = 0;
    var quoted = false;
    var escaped = false;
    for (var i = start; i < script.length; i++) {
      final ch = script[i];
      if (quoted) {
        if (escaped) {
          escaped = false;
        } else if (ch == r'\') {
          escaped = true;
        } else if (ch == '"') {
          quoted = false;
        }
      } else if (ch == '"') {
        quoted = true;
      } else if (ch == '[') {
        depth++;
      } else if (ch == ']' && --depth == 0) {
        try {
          return jsonDecode(script.substring(start, i + 1)) as List;
        } on FormatException {
          return null;
        }
      }
    }
    return null;
  }
}
