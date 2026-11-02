import 'dart:convert';

import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

import 'link_feed.dart';
import 'source_verification.dart';
import 'subtitle_track.dart';

class PageTitle {
  const PageTitle({required this.title, required this.url, this.poster});
  final String title;
  final Uri url;
  final Uri? poster;
}

class SourcePage {
  const SourcePage({
    required this.url,
    required this.title,
    this.series = const [],
    this.titles = const [],
    this.nextPage,
    this.searchQuery,
    this.notice,
  });
  final Uri url;
  final String title;
  final List<LinkSeries> series;
  final List<PageTitle> titles;
  final Uri? nextPage;
  final String? searchQuery;
  final String? notice;
  bool get canSearch => PageSource.isNartoCatalogue(url);

  SourcePage append(SourcePage more) {
    final unique = {for (final item in titles) item.url.path: item};
    for (final item in more.titles) {
      unique.putIfAbsent(item.url.path, () => item);
    }
    return SourcePage(
      url: url,
      title: title,
      series: series,
      titles: unique.values.toList(),
      nextPage: more.nextPage,
      searchQuery: searchQuery,
      notice: more.notice,
    );
  }
}

/// Reads public documents as data. Never evaluates website JavaScript, opens
/// ad windows, shares browser cookies, or manufactures ad-completion requests.
class PageSource {
  PageSource({this.client});
  final http.Client? client;
  final Map<String, VerifiedSourceSession> _verification = {};
  final Map<String, ({SourcePage page, DateTime expires})> _browserPages = {};

  void rememberVerification(VerifiedSourceSession session) => _verification[session.origin.origin] = session;
  void clearVerification() {
    _verification.clear();
    _browserPages.clear();
  }

  Map<String, String> verificationHeadersFor(Uri url) => _verification[url.origin]?.headersFor(url) ?? const {};
  static const maxBytes = 4 * 1024 * 1024;

  static bool isNarto(Uri uri) => uri.host == 'narto-drama.com' || uri.host == 'www.narto-drama.com';
  static bool isNartoCatalogue(Uri uri) =>
      isNarto(uri) && (uri.path.isEmpty || ['/', '/featured', '/search'].contains(uri.path));

  /// Whether [page] is one series Reelway can show with its episodes: the
  /// episodes are on the page, or it is a Narto series page whose episodes
  /// [read] fetches from the first episode.
  static bool isSingleSeries(SourcePage page) =>
      page.series.isNotEmpty || (isNarto(page.url) && page.url.path.startsWith('/detail/watch/'));

  static Uri catalogueUrl(Uri uri) {
    if (!isNarto(uri) || (uri.path.isNotEmpty && uri.path != '/')) return uri;
    // The publicly linked Featured route is server-rendered. The homepage itself
    // requires website JavaScript; do not execute or simulate its browser checks.
    return uri
        .replace(path: '/featured', queryParameters: {'lang': uri.queryParameters['lang'] ?? 'es-ES'})
        .removeFragment();
  }

  Future<SourcePage> search(Uri origin, String query) async {
    LinkFeed.check(origin.toString());
    if (!isNarto(origin)) throw const FormatException('Website search is not supported for this source yet.');
    final term = query.trim();
    if (term.length < 2) throw const FormatException('Enter at least 2 characters to search the website.');
    return read(
      origin
          .replace(
            path: '/search',
            queryParameters: {'q': term, 'limit': '50', 'lang': origin.queryParameters['lang'] ?? 'es-ES'},
          )
          .removeFragment(),
    );
  }

  /// Inspect only the page the user actually opened. Browser snapshots stay in
  /// memory briefly and are never persisted or forwarded to another website.
  SourcePage? inspectBrowserPage(Uri url, String body) {
    if (url.scheme != 'https' || url.userInfo.isNotEmpty || body.length > maxBytes) return null;
    try {
      final page = parse(url, body);
      if (page.series.isEmpty) {
        // An ordinary shopping/news ItemList is not evidence of a drama catalogue.
        final mediaCatalogue =
            page.titles.isNotEmpty &&
            (isNarto(url) ||
                RegExp(
                  r'"@type"\s*:\s*"(?:TVSeries|Movie|CreativeWorkSeries|VideoObject)"',
                  caseSensitive: false,
                ).hasMatch(body) ||
                page.titles.any(
                  (item) => RegExp(r'/(?:series|drama|detail/watch|episode)(?:/|$)').hasMatch(item.url.path),
                ));
        if (!mediaCatalogue) return null;
      }
      _browserPages.removeWhere((_, cached) => cached.expires.isBefore(DateTime.now()));
      // Keep browser metadata bounded even during long browsing sessions.
      while (_browserPages.length >= 160) {
        _browserPages.remove(_browserPages.keys.first);
      }
      final snapshot = (page: page, expires: DateTime.now().add(const Duration(minutes: 10)));
      _browserPages[url.toString()] = snapshot;
      for (final series in page.series) {
        for (final episode in series.episodes) {
          final link = episode.pageUrl;
          if (link != null && link.origin == url.origin && _browserPages.length < 200) {
            _browserPages[link.toString()] = snapshot;
          }
        }
      }
      return page;
    } on FormatException {
      return null;
    }
  }

  Future<SourcePage> read(Uri input) async {
    final requestClient = client ?? http.Client();
    try {
      final target = catalogueUrl(LinkFeed.resolve(LinkFeed.check(input.toString())));
      final cached = _browserPages[target.toString()];
      if (cached != null && cached.expires.isAfter(DateTime.now())) return cached.page;
      _browserPages.remove(target.toString());
      var page = await _read(requestClient, target);
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
      final request = http.Request('GET', url)..followRedirects = false;
      request.headers.addAll(verificationHeadersFor(url));
      if (isNarto(url) && url.path == '/search') {
        request.headers['X-Requested-With'] = 'XMLHttpRequest';
        request.headers['Accept'] = 'application/json';
      }
      final response = await client.send(request).timeout(const Duration(seconds: 20));
      if ([301, 302, 303, 307, 308].contains(response.statusCode)) {
        final location = response.headers['location'];
        if (location == null) throw const FormatException('The website returned an invalid redirect.');
        await response.stream.listen((_) {}).cancel();
        url = url.resolve(location);
        continue;
      }
      if (response.statusCode == 403) {
        throw SourceVerificationRequired(url);
      }
      if (response.statusCode == 429) {
        throw const FormatException('The website is receiving too many requests. Wait a moment and try again.');
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
      if (isNarto(source) && source.path == '/search') return _searchResults(source, body);
      final series = LinkFeed.parse(source, body);
      return SourcePage(url: source, title: source.host, series: series);
    }
    final document = html.parse(body);
    final pageHeading = document.querySelector('title')?.text.toLowerCase() ?? '';
    if ((pageHeading.contains('cloudflare') || pageHeading == 'just a moment...' || pageHeading == 'loading') &&
        (body.contains('/cdn-cgi/') || body.contains('Checking your browser'))) {
      throw SourceVerificationRequired(source);
    }
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

    final structuredTitles = <PageTitle>[];
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
              subtitles: LinkFeed.subtitleTracks(
                source,
                item['multi_subtitles'],
                fallbackUrl: item['direct_subtitle_url'] is String && (item['direct_subtitle_url'] as String).isNotEmpty
                    ? item['direct_subtitle_url'] as String
                    : item['subtitle_url'] as String?,
                language: item['selected_subtitle_language'] as String?,
              ),
            ),
          );
        }
        if (episodes.isNotEmpty) break;
      }
    }
    if (episodes.isEmpty) {
      // Only media elements and video metadata; arbitrary .mp4 anchors may be ads.
      final htmlTracks = <Uri, List<SubtitleTrack>>{};
      for (final video in document.querySelectorAll('video')) {
        final tracks = LinkFeed.subtitleTracks(source, [
          for (final track in video.querySelectorAll('track[src]'))
            if (['subtitles', 'captions'].contains(track.attributes['kind'] ?? 'subtitles'))
              {
                'url': track.attributes['src'],
                'language': track.attributes['srclang'],
                'label': track.attributes['label'],
                'is_default': track.attributes.containsKey('default'),
              },
        ]);
        for (final ref in [
          video.attributes['src'],
          ...video.querySelectorAll('source[src]').map((node) => node.attributes['src']),
        ]) {
          final url = secure(ref);
          if (url != null) htmlTracks[url] = tracks;
        }
      }
      final candidates = <String?>[
        for (final node in document.querySelectorAll('video[src],video source[src]')) node.attributes['src'],
        meta('og:video:secure_url'),
        meta('og:video'),
      ];
      for (final script in document.querySelectorAll('script[type="application/ld+json"]')) {
        try {
          void walk(Object? node, [int depth = 0]) {
            if (depth > 8) return;
            if (node is List) {
              for (final item in node) {
                walk(item, depth + 1);
              }
            } else if (node is Map) {
              final type = node['@type'];
              if (type == 'VideoObject' || (type is List && type.contains('VideoObject'))) {
                if (node['contentUrl'] is String) candidates.add(node['contentUrl'] as String);
              }
              if (type == 'ItemList' && node['itemListElement'] is List) {
                for (final entry in (node['itemListElement'] as List).whereType<Map>()) {
                  final item = entry['item'] is Map ? entry['item'] as Map : entry;
                  final ref = item['url'] ?? (entry['item'] is String ? entry['item'] : null);
                  final name = item['name'] ?? entry['name'];
                  final url = secure(ref is String ? ref : null);
                  if (name is! String ||
                      name.trim().isEmpty ||
                      url == null ||
                      url.origin != source.origin ||
                      url.path == source.path) {
                    continue;
                  }
                  final image = item['image'];
                  structuredTitles.add(
                    PageTitle(title: name, url: url, poster: secure(image is String ? image : null)),
                  );
                }
              }
              walk(node['@graph'], depth + 1);
              walk(node['mainEntity'], depth + 1);
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
        episodes.add(
          LinkEpisode(
            number: episodes.length + 1,
            videoUrl: url,
            pageUrl: source,
            subtitles: htmlTracks[url] ?? const [],
          ),
        );
      }
    }
    episodes.sort((a, b) => a.number.compareTo(b.number));
    final titles = <PageTitle>[...structuredTitles];
    final destinations = <String>{for (final title in structuredTitles) title.url.path};
    for (final anchor in document.querySelectorAll('a[href]')) {
      final url = secure(anchor.attributes['href']);
      if (url == null || url.host != source.host || destinations.contains(url.path)) continue;
      if (isNarto(source) && !url.path.startsWith('/detail/watch/')) continue;
      if (!isNarto(source) && !LinkFeed.isVideo(url)) continue;
      var card = anchor.parent;
      while (card != null && !card.classes.contains('card') && !card.classes.contains('nd-hero-card')) {
        card = card.parent;
      }
      final image = anchor.querySelector('img') ?? card?.querySelector('img');
      final label = image?.attributes['alt'] ?? anchor.attributes['aria-label'] ?? anchor.text.trim();
      if (label.isEmpty) continue;
      destinations.add(url.path);
      titles.add(
        PageTitle(title: label, url: url, poster: secure(image?.attributes['data-src'] ?? image?.attributes['src'])),
      );
    }
    final slug = source.pathSegments.length >= 3 && isNarto(source) ? source.pathSegments[2] : 'page';
    final next = secure(document.querySelector('link[rel="next"],a[rel="next"]')?.attributes['href']);
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
      nextPage: isNartoCatalogue(source) && next?.host == source.host && next?.path == source.path && next != source
          ? next
          : null,
    );
  }

  static SourcePage _searchResults(Uri source, String body) {
    final data = jsonDecode(body);
    if (data is! Map || data['ok'] != true || data['items'] is! List) {
      throw FormatException(
        data is Map && data['message'] == 'search_throttled'
            ? 'The website is receiving too many searches. Wait a moment and try again.'
            : 'The website could not complete the search. Please try again.',
      );
    }
    final titles = <PageTitle>[];
    final seen = <String>{};
    for (final item in (data['items'] as List).whereType<Map>()) {
      if (item['title'] is! String || item['url'] is! String) continue;
      final title = (item['title'] as String).trim();
      try {
        final url = LinkFeed.check(source.resolve(item['url'] as String).toString());
        if (title.isEmpty || url.host != source.host || !url.path.startsWith('/detail/watch/') || !seen.add(url.path)) {
          continue;
        }
        Uri? poster;
        if (item['poster_url'] is String) {
          try {
            poster = LinkFeed.check(source.resolve(item['poster_url'] as String).toString());
          } on FormatException {
            /* Ignore an invalid optional poster. */
          }
        }
        titles.add(PageTitle(title: title, url: url, poster: poster));
      } on FormatException {
        /* Ignore invalid and insecure result links. */
      }
    }
    final partial = data['failed_providers'] is List && (data['failed_providers'] as List).isNotEmpty;
    return SourcePage(
      url: source,
      title: 'Narto-Drama search',
      titles: titles,
      searchQuery: source.queryParameters['q'],
      notice: partial ? 'Some providers did not respond. Search results may be incomplete.' : null,
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
