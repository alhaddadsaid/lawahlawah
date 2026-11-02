import 'dart:convert';

import 'package:html/parser.dart' as html;

import 'popup_protection.dart';
import 'site_profiles.dart';
import 'website_ad_rules.dart';

/// A video address a page's own player loaded, as seen by the browser.
class CapturedMedia {
  const CapturedMedia({
    required this.url,
    required this.page,
    required this.fromVideo,
    this.seconds = 0,
    this.at = 0,
    this.segment = false,
    this.referer,
  });

  final Uri url;

  /// The page (top document) that was open when the video loaded.
  final Uri page;

  /// True when read from a playing `<video>` element, false when seen as a
  /// network resource (an HLS playlist fetched by the page's player script).
  final bool fromVideo;

  /// Length reported by the `<video>` element; 0 when unknown.
  final int seconds;

  /// When the browser saw it (milliseconds since epoch); 0 when unknown.
  final int at;

  /// A piece of a stream (.ts, .m4s): not playable alone, but it shows which
  /// playlist the page is really playing.
  final bool segment;

  /// The page of the player that loaded it (an embedded player's own address
  /// when it plays in a frame); sent as Referer when Reelway plays it.
  final Uri? referer;
}

/// An episode number the page shows (link or button), read from the live page.
class ScannedEpisode {
  const ScannedEpisode({required this.number, this.link, this.active = false});
  final int number;

  /// Where the episode opens, when it is a link; null for a button.
  final Uri? link;

  /// Marked by the page as the episode playing now.
  final bool active;
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
  // r: the page of the player that loaded it (an embedded player's own
  // address), which its video server expects as Referer.
  function record(url, fromVideo, seconds, referer) {
    if (typeof url !== 'string' || url.indexOf('https://') !== 0) return;
    if (!fromVideo && !MEDIA.test(url)) return;
    add({ u: url, v: !!fromVideo, d: isFinite(seconds) && seconds > 0 ? Math.round(seconds) : 0,
          p: isTop ? location.href : '', r: referer || location.href, t: Date.now() });
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
      if (e && typeof e.u === 'string') record(e.u, !!e.v, e.d, typeof e.r === 'string' ? e.r : '');
    });
  }
})();
""";

  static const readerJs = 'JSON.stringify(window.__rwMedia || [])';

  /// Runs in the page itself (main frame): notes the playlist and segment
  /// addresses its player requests with XMLHttpRequest or fetch. Script
  /// players (hls.js) play from a blob: address, and not every WebKit build
  /// reports those requests to Reelway's own script world. Requests are passed
  /// on unchanged.
  static const pageHookJs = r"""
(function () {
  if (window.__rwPageMedia) return;
  var list = window.__rwPageMedia = [];
  var PLAYLIST = /\.m3u8(\?|#|$)/i, SEGMENT = /\.(ts|m4s|aac|m4v|mp4)(\?|#|$)/i;
  function note(u) {
    try { u = new URL(u, location.href).href; } catch (e) { return; }
    if (u.indexOf('https://') !== 0) return;
    var segment = !PLAYLIST.test(u);
    if (segment && !SEGMENT.test(u)) return;
    list.push({ u: u, s: segment, p: location.href, t: Date.now() });
    if (list.length > 150) list.splice(0, list.length - 150);
  }
  var open = XMLHttpRequest.prototype.open;
  XMLHttpRequest.prototype.open = function (method, url) {
    try { note(String(url)); } catch (e) {}
    return open.apply(this, arguments);
  };
  var originalFetch = window.fetch;
  if (originalFetch) {
    window.fetch = function (input) {
      try { note(typeof input === 'string' ? input : (input && input.url) || String(input)); } catch (e) {}
      return originalFetch.apply(this, arguments);
    };
  }
})();
""";

  static const pageReaderJs = 'JSON.stringify(window.__rwPageMedia || [])';

  /// Finds the page's episode list: the group of links or buttons labelled
  /// 1, 2, 3 (or "EP 2", "第3集") under one parent. Remembers the elements so
  /// [clickEpisodeJs] can press one, as the user would.
  static const episodesJs = r"""
(function () {
  // "3", "EP 3", "Episode 3", "Capítulo 3", "الحلقة 3", "第3集": up to two words, the number, a short suffix.
  var RX = [/^(?:[\p{L}.]+\s*){0,2}[#:.\-]?\s*0*(\d{1,4})(?:\s*\p{L}{1,3})?$/u];
  function num(t) {
    t = (t || '').replace(/\s+/g, ' ').trim();
    if (!t || t.length > 22) return 0;
    for (var i = 0; i < RX.length; i++) { var m = RX[i].exec(t); if (m) return +m[1]; }
    return 0;
  }
  var groups = new Map();
  var nodes = document.querySelectorAll('a, button, li, [role="button"], [onclick], div, span');
  for (var i = 0; i < nodes.length && i < 20000; i++) {
    var el = nodes[i];
    if (el.children.length > 3) continue;
    var n = num(el.textContent) || num(el.getAttribute('aria-label'));
    if (!n) continue;
    var a = el.closest('a[href]');
    var parent = a && a.contains(el) && a !== el ? a.parentElement : el.parentElement;
    if (!parent) continue;
    var g = groups.get(parent);
    if (!g) { g = {}; groups.set(parent, g); }
    if (g[n]) continue;
    var cls = ((el.className && el.className.baseVal !== undefined ? el.className.baseVal : el.className) || '') + ' ' +
      ((a && a.className) || '');
    g[n] = {
      el: a || el,
      n: n,
      href: a ? a.href : '',
      active: /(^|[\s_-])(active|current|selected|playing|on)([\s_-]|$)/i.test(cls) ||
        el.getAttribute('aria-current') === 'true' || el.getAttribute('aria-current') === 'page' ||
        el.getAttribute('aria-selected') === 'true'
    };
  }
  var best = null, bestSize = 1;
  groups.forEach(function (g) {
    var size = Object.keys(g).length;
    if (size > bestSize) { best = g; bestSize = size; }
  });
  window.__rwEpisodeEls = {};
  var out = [];
  if (best) {
    Object.keys(best).forEach(function (k) {
      var e = best[k];
      window.__rwEpisodeEls[e.n] = e.el;
      out.push({ n: e.n, h: e.href, a: e.active });
    });
  }
  return JSON.stringify(out);
})();
""";

  /// Presses episode [number] in the page's own episode list.
  static String clickEpisodeJs(int number) =>
      '''
(function () {
  var el = window.__rwEpisodeEls && window.__rwEpisodeEls[$number];
  if (!el || !el.isConnected) { $episodesJs; el = window.__rwEpisodeEls && window.__rwEpisodeEls[$number]; }
  if (!el) return false;
  el.scrollIntoView({ block: 'center' });
  el.click();
  return true;
})();
''';

  /// Marks an episode that is a button on the page rather than a link: the
  /// player opens it by pressing that button.
  static const episodeMarker = 'rw-episode=';

  /// The episode number to press for [page], or null for an ordinary link.
  static int? pressedEpisode(Uri page) =>
      page.fragment.startsWith(episodeMarker) ? int.tryParse(page.fragment.substring(episodeMarker.length)) : null;

  static List<ScannedEpisode> decodeEpisodes(Object? raw, Uri page) {
    if (raw is! String) return const [];
    try {
      final data = jsonDecode(raw);
      if (data is! List) return const [];
      final site = PopupProtection.registrableDomain(page.host);
      return [
        for (final e in data.whereType<Map>())
          if (e['n'] case final int n when n > 0)
            ScannedEpisode(
              number: n,
              active: e['a'] == true,
              link: switch (Uri.tryParse(e['h'] is String ? e['h'] as String : '')) {
                final u? when u.scheme == 'https' && PopupProtection.registrableDomain(u.host) == site =>
                  u.removeFragment(),
                _ => null,
              },
            ),
      ];
    } on FormatException {
      return const [];
    }
  }

  /// Starts the page's own player again (when Reelway's player cannot).
  static const resumeJs = r"""
document.querySelectorAll('video').forEach(function (v) { try { v.play(); } catch (e) {} });
""";

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
                at: e['t'] is num ? (e['t'] as num).toInt() : 0,
                segment: e['s'] == true,
                referer: e['r'] is String ? Uri.tryParse(e['r'] as String) : null,
              ),
      ];
    } on FormatException {
      return const [];
    }
  }

  static bool isAd(Uri url) =>
      AdDomains.isAdHost(url.host) ||
      RegExp(r'(^|[/._-])(ads?|vast|preroll|advert)([/._-]|$)', caseSensitive: false).hasMatch(url.path);

  static String _key(Uri page) => page.removeFragment().toString();

  /// The episode video playing on [page], or null when there is none yet.
  /// Prefers a playing video long enough to be an episode, then the HLS
  /// playlist that started the latest burst of playlist requests (a player
  /// asks for the master playlist first, then its qualities right after).
  /// Videos in [exclude] were already playing before the user chose another
  /// episode, so they are skipped.
  static CapturedMedia? pick(List<CapturedMedia> items, Uri page, {Set<String> exclude = const {}}) {
    final here = [
      for (final item in items)
        if (_key(item.page) == _key(page) &&
            item.url.scheme == 'https' &&
            !isAd(item.url) &&
            !exclude.contains(item.url.toString()))
          item,
    ];
    final playing = here.where((m) => m.fromVideo && m.seconds >= minEpisodeSeconds).toList();
    if (playing.isNotEmpty) return playing.last;
    final playlists = here.where((m) => !m.segment && m.url.path.toLowerCase().endsWith('.m3u8')).toList()
      ..sort((a, b) => a.at.compareTo(b.at));
    if (playlists.isEmpty) return null;
    // Players load the next episode's playlist early. The segments being
    // downloaded now show which playlist is on screen: each recent segment
    // votes for the playlist whose address it shares the most with.
    final segments = here.where((m) => m.segment).toList()..sort((a, b) => a.at.compareTo(b.at));
    final recent = segments.length > 6 ? segments.sublist(segments.length - 6) : segments;
    final votes = <CapturedMedia, int>{};
    for (final seg in recent) {
      CapturedMedia? best;
      var bestLength = seg.url.origin.length + 1;
      for (final p in playlists) {
        final length = _sharedLength(p.url, seg.url);
        if (length > bestLength || (length == bestLength && best != null && p.at > best.at)) {
          best = p;
          bestLength = length;
        }
      }
      if (best != null) votes[best] = (votes[best] ?? 0) + 1;
    }
    if (votes.isNotEmpty) {
      final ranked = votes.entries.toList()
        ..sort((a, b) => b.value != a.value ? b.value - a.value : b.key.at - a.key.at);
      return ranked.first.key;
    }
    CapturedMedia? start;
    for (var i = 0; i < playlists.length; i++) {
      if (i == 0 || playlists[i].at - playlists[i - 1].at > 2000) start = playlists[i];
    }
    return start;
  }

  /// How many leading characters two addresses share (query ignored).
  static int _sharedLength(Uri a, Uri b) {
    final x = a.replace(query: '').removeFragment().toString();
    final y = b.replace(query: '').removeFragment().toString();
    var i = 0;
    while (i < x.length && i < y.length && x.codeUnitAt(i) == y.codeUnitAt(i)) {
      i++;
    }
    return i;
  }

  /// "3", "EP 3", "Episode 3", "Capítulo 3", "الحلقة 3", "第3集".
  static final _numberText = [
    RegExp(r'^(?:[\p{L}.]+\s*){0,2}[#:.\-]?\s*0*(\d{1,4})(?:\s*\p{L}{1,3})?$', unicode: true),
  ];

  static int? _episodeNumber(String text) {
    final t = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    for (final pattern in _numberText) {
      final m = pattern.firstMatch(t);
      if (m != null) return int.parse(m.group(1)!);
    }
    return null;
  }

  /// Reads the title, poster and episode list from the page the user is on.
  /// [scanned] is the live page's episode list ([episodesJs]); episodes that
  /// are buttons get an [episodeMarker] address. [current] overrides which
  /// episode is playing (the one the player just asked for).
  /// [profile] picks the method that fits the site (see [SiteProfiles]).
  static WebTitle describe(
    Uri page,
    String body, {
    List<ScannedEpisode> scanned = const [],
    int? current,
    SiteProfile profile = SiteProfile.none,
  }) {
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
    final method = profile.episodes;
    final useButtons = switch (method) {
      EpisodeMethod.buttons => scanned.isNotEmpty,
      EpisodeMethod.auto => scanned.length >= 2 && scanned.length >= byNumber.length,
      EpisodeMethod.links || EpisodeMethod.param => false,
    };
    if (method == EpisodeMethod.param) byNumber.clear();
    if (useButtons) {
      byNumber
        ..clear()
        ..addAll({for (final e in scanned) e.number: e.link ?? page.replace(fragment: '$episodeMarker${e.number}')});
      current ??= scanned.where((e) => e.active).firstOrNull?.number;
    }

    final rawTitle = meta('og:title') ?? document.querySelector('title')?.text.trim() ?? page.host;
    current ??= byNumber.entries.where((e) => _key(e.value) == _key(page)).firstOrNull?.key;
    current ??= _numberIn(page.path) ?? _numberIn(page.query) ?? _numberIn(rawTitle);
    current ??= 1;
    byNumber[current] = page.removeFragment();

    // Feeds that load a few episodes at a time: when the address carries the
    // episode number (?ep=2) and the page shows the total ("2 / 40", "30
    // episodes"), every episode gets its own address.
    final param = switch (method) {
      EpisodeMethod.param => profile.param ?? _episodeParam(page, current, body),
      EpisodeMethod.auto => _episodeParam(page, current, body),
      EpisodeMethod.links || EpisodeMethod.buttons => null,
    };
    // Text with a space between elements, so "Episode 3" and "2 / 40" stay apart.
    final text = body
        .replaceAll(RegExp(r'<(script|style)[\s\S]*?</\1>', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'<[^>]+>'), ' ');
    final total = param == null ? null : totalEpisodes(text, current);
    if (param != null && total != null && total > byNumber.length) {
      for (var n = 1; n <= total; n++) {
        byNumber.putIfAbsent(
          n,
          () => page.replace(queryParameters: {...page.queryParameters, param: '$n'}).removeFragment(),
        );
      }
    }

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

  static const _episodeParams = ['ep', 'episode', 'episodio', 'capitulo', 'cap', 'bolum', 'e', 'eps', 'part'];

  /// The query parameter that holds the episode number: one in the address
  /// with the current number, or one the page's own links use.
  static String? _episodeParam(Uri page, int current, String body) {
    for (final name in _episodeParams) {
      if (page.queryParameters[name] == '$current') return name;
    }
    final m = RegExp('[?&;](${_episodeParams.join('|')})=\\d{1,4}\\b', caseSensitive: false).firstMatch(body);
    return m?.group(1)?.toLowerCase();
  }

  /// How many episodes the page says the title has: "3 / 40", "3 of 40",
  /// "3 de 40" next to the current episode, or a count like "30 Capítulos".
  static int? totalEpisodes(String text, int current) {
    final t = text.replaceAll(RegExp(r'\s+'), ' ');
    int? best;
    for (final m in RegExp(
      r'(?<![\d.,])(\d{1,4}) ?(?:/|of|de|sur|von|di|из|من) ?(\d{1,4})(?![\d.,])',
      caseSensitive: false,
    ).allMatches(t)) {
      final n = int.parse(m.group(1)!), total = int.parse(m.group(2)!);
      if (n == current && total >= current && total <= 3000 && total > (best ?? 0)) best = total;
    }
    if (best != null) return best;
    for (final m in RegExp(
      r'(?<![\d.,])(\d{1,4}) ?(?:episodes?|ep\.|capítulos?|capitulos?|episodios?|bölüm|épisodes?|folgen|حلقات|حلقة|集)',
      caseSensitive: false,
    ).allMatches(t)) {
      final total = int.parse(m.group(1)!);
      if (total >= current && total <= 3000 && total > (best ?? 0)) best = total;
    }
    return best;
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
