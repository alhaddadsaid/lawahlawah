import 'dart:convert';

import 'package:html/parser.dart' as html;

import 'popup_protection.dart';
import 'website_ad_rules.dart';

/// A video address a page's own player loaded, as seen by the browser.
class CapturedMedia {
  const CapturedMedia({required this.url, required this.page, required this.fromVideo, this.seconds = 0});

  final Uri url;

  /// The page (top document) that was open when the video loaded.
  final Uri page;

  /// True when read from a playing `<video>` element, false when seen as a
  /// network resource (an HLS playlist fetched by the page's player script).
  final bool fromVideo;

  /// Length reported by the `<video>` element; 0 when unknown.
  final int seconds;
}

/// One episode link found on the page, for the player's episode list.
class WebEpisode {
  const WebEpisode({required this.number, required this.page});
  final int number;
  final Uri page;
}

/// What the page says about the title being watched.
class WebTitle {
  const WebTitle({required this.title, required this.current, required this.episodes, this.poster});
  final String title;
  final Uri? poster;

  /// The episode playing on this page.
  final int current;

  /// Episode pages in order; always contains [current].
  final List<WebEpisode> episodes;
}

/// "Play in Reelway" for any website: notices the video a page's own player
/// starts, then hands it to Reelway's player.
///
/// The watcher runs in Reelway's own script world, so the page cannot see or
/// call it. It only reads: video elements the page plays and the addresses of
/// video playlists the page downloads. It sends nothing anywhere; the app
/// reads the list with evaluateJavascript while the tab is on screen.
abstract final class MediaCapture {
  static const worldName = 'reelway';

  static const watcherJs = r"""
(function () {
  if (window.__rwMediaReady) return;
  window.__rwMediaReady = true;
  var isTop = window === window.top;
  var list = isTop ? (window.__rwMedia = []) : null;
  var MEDIA = /\.(m3u8|mp4|m4v|mov)(\?|#|$)/i;
  function add(e) {
    if (!isTop) {
      try { window.top.postMessage({ __rwMedia: e }, '*'); } catch (x) {}
      return;
    }
    for (var i = 0; i < list.length; i++) {
      if (list[i].u === e.u && list[i].p === e.p) {
        if (e.d > list[i].d) list[i].d = e.d;
        list[i].v = list[i].v || e.v;
        return;
      }
    }
    list.push(e);
    if (list.length > 40) list.shift();
  }
  function record(url, fromVideo, seconds) {
    if (typeof url !== 'string' || url.indexOf('https://') !== 0) return;
    if (!fromVideo && !MEDIA.test(url)) return;
    add({ u: url, v: !!fromVideo, d: isFinite(seconds) && seconds > 0 ? Math.round(seconds) : 0,
          p: isTop ? location.href : '', t: Date.now() });
  }
  function onVideo(ev) {
    var el = ev.target;
    if (el && el.tagName === 'VIDEO') record(el.currentSrc || el.src, true, el.duration);
  }
  ['loadedmetadata', 'durationchange', 'playing'].forEach(function (n) {
    document.addEventListener(n, onVideo, true);
  });
  try {
    new PerformanceObserver(function (l) {
      l.getEntries().forEach(function (en) { record(en.name, false, 0); });
    }).observe({ type: 'resource', buffered: true });
  } catch (x) {}
  if (isTop) {
    window.addEventListener('message', function (m) {
      var e = m.data && m.data.__rwMedia;
      if (e && typeof e.u === 'string') record(e.u, !!e.v, e.d);
    });
  }
})();
""";

  static const readerJs = 'JSON.stringify(window.__rwMedia || [])';

  /// Stops the page's own player so the video does not play twice.
  static const pauseJs = r"""
document.querySelectorAll('video').forEach(function (v) { try { v.pause(); } catch (e) {} });
""";

  /// Ad videos are short; an episode is longer than this.
  static const minEpisodeSeconds = 45;

  static List<CapturedMedia> decode(Object? raw) {
    if (raw is! String) return const [];
    try {
      final data = jsonDecode(raw);
      if (data is! List) return const [];
      return [
        for (final e in data.whereType<Map>())
          if (e['u'] is String && e['p'] is String)
            if ((Uri.tryParse(e['u'] as String), Uri.tryParse(e['p'] as String)) case (final url?, final page?))
              CapturedMedia(
                url: url,
                page: page,
                fromVideo: e['v'] == true,
                seconds: e['d'] is num ? (e['d'] as num).toInt() : 0,
              ),
      ];
    } on FormatException {
      return const [];
    }
  }

  static bool isAd(Uri url) =>
      adNetworkHosts.any((host) => url.host == host || url.host.endsWith('.$host')) ||
      RegExp(r'(^|[/._-])(ads?|vast|preroll|advert)([/._-]|$)', caseSensitive: false).hasMatch(url.path);

  static String _key(Uri page) => page.removeFragment().toString();

  /// The episode video playing on [page], or null when there is none yet.
  /// Prefers a playing video long enough to be an episode, then the first
  /// HLS playlist the page loaded (the master playlist comes first).
  static CapturedMedia? pick(List<CapturedMedia> items, Uri page) {
    final here = [
      for (final item in items)
        if (_key(item.page) == _key(page) && item.url.scheme == 'https' && !isAd(item.url)) item,
    ];
    final playing = here.where((m) => m.fromVideo && m.seconds >= minEpisodeSeconds).toList();
    if (playing.isNotEmpty) return playing.last;
    return here.where((m) => m.url.path.toLowerCase().endsWith('.m3u8')).firstOrNull;
  }

  static final _numberText = [
    RegExp(r'^(?:ep(?:isode)?\.?\s*)?0*(\d{1,4})$', caseSensitive: false),
    RegExp(r'^第\s*(\d{1,4})\s*[集话話]$'),
  ];

  static int? _episodeNumber(String text) {
    final t = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    for (final pattern in _numberText) {
      final m = pattern.firstMatch(t);
      if (m != null) return int.parse(m.group(1)!);
    }
    return null;
  }

  /// Reads the title, poster and episode links from the page the user is on.
  static WebTitle describe(Uri page, String body) {
    final document = html.parse(body);
    String? meta(String name) =>
        document.querySelector('meta[property="$name"],meta[name="$name"]')?.attributes['content']?.trim();
    final site = PopupProtection.registrableDomain(page.host);

    final byNumber = <int, Uri>{};
    for (final a in document.querySelectorAll('a[href]')) {
      final label = a.text.trim().isNotEmpty ? a.text : (a.attributes['aria-label'] ?? a.attributes['title'] ?? '');
      final number = _episodeNumber(label);
      if (number == null || number < 1) continue;
      final url = Uri.tryParse(page.resolve(a.attributes['href']!).toString());
      if (url == null || url.scheme != 'https' || PopupProtection.registrableDomain(url.host) != site) continue;
      byNumber.putIfAbsent(number, () => url.removeFragment());
    }
    // A single number is a button or a badge, not an episode list.
    if (byNumber.length < 2) byNumber.clear();

    final rawTitle = meta('og:title') ?? document.querySelector('title')?.text.trim() ?? page.host;
    var current = byNumber.entries.where((e) => _key(e.value) == _key(page)).firstOrNull?.key;
    current ??= _numberIn(page.path) ?? _numberIn(page.query) ?? _numberIn(rawTitle);
    current ??= 1;
    byNumber[current] = page.removeFragment();

    final numbers = byNumber.keys.toList()..sort();
    Uri? poster;
    final image = meta('og:image');
    if (image != null && image.isNotEmpty) {
      final u = Uri.tryParse(page.resolve(image).toString());
      if (u != null && u.scheme == 'https') poster = u;
    }
    return WebTitle(
      title: cleanTitle(rawTitle, page.host),
      poster: poster,
      current: current,
      episodes: [for (final n in numbers) WebEpisode(number: n, page: byNumber[n]!)],
    );
  }

  static int? _numberIn(String text) {
    final m = RegExp(
      r'(?:\bep(?:isode)?|episodio|\bepi)[\s._/=-]*0*(\d{1,4})\b|第\s*(\d{1,4})\s*[集话話]',
      caseSensitive: false,
    ).firstMatch(text);
    if (m == null) return null;
    return int.parse(m.group(1) ?? m.group(2)!);
  }

  /// "Watch Sleep with Me, Mortal! Episode 3 | FindDrama" -> "Sleep with Me, Mortal!"
  static String cleanTitle(String raw, String host) {
    var t = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
    t = t.split(RegExp(r'\s[|–—]\s|\s-\s')).first.trim();
    t = t.replaceFirst(RegExp(r'^watch\s+', caseSensitive: false), '');
    t = t.replaceFirst(RegExp(r'[\s,:·-]*(?:\bep(?:isode)?\.?\s*\d+|第\s*\d+\s*[集话話]).*$', caseSensitive: false), '');
    t = t.replaceFirst(RegExp(r'\s*full episodes?.*$', caseSensitive: false), '').trim();
    return t.isEmpty ? host : t;
  }
}
