/// Website adapter contract (spec section 4).
///
/// Each supported website gets its own adapter in `lib/adapters/<site>/`.
/// Adapters only ever read pages the user has opened in the browser with
/// their own session, or a documented API, and only when the site's
/// permission is recorded in [AdapterPermission]. The registry refuses to
/// activate an adapter whose permission is not documented, so the site
/// falls back to plain browsing.
library;

import '../data/models/models.dart';

/// Recorded evidence that the site allows this integration. Required before
/// an adapter is activated. Keep the signed agreement itself out of the repo;
/// reference it here.
class AdapterPermission {
  const AdapterPermission({
    required this.documented,
    this.reference,
    this.grantedBy,
    this.verifiedOn,
    this.allowsCatalogueDisplay = false,
    this.allowsPosterDisplay = false,
    this.allowsNativePlayback = false,
    this.contentRightsConfirmed = false,
  });

  static const notDocumented = AdapterPermission(documented: false);

  final bool documented;
  final String? reference;
  final String? grantedBy;
  final DateTime? verifiedOn;
  final bool allowsCatalogueDisplay;
  final bool allowsPosterDisplay;
  final bool allowsNativePlayback;

  /// The site has shown it holds (or licenses) the rights to what it serves.
  final bool contentRightsConfirmed;

  bool get canActivate => documented && contentRightsConfirmed && verifiedOn != null;
}

enum PageKind { home, catalogue, movie, series, episode, search, verification, other }

/// What the adapter is given: a page the user already loaded.
class PageSnapshot {
  const PageSnapshot({required this.url, required this.html, this.cookies = const {}});
  final Uri url;
  final String html;
  final Map<String, String> cookies;
}

enum StreamFormat { mp4, hls, dash, unknown }

class PlaybackSource {
  const PlaybackSource({
    required this.uri,
    required this.format,
    this.headers = const {},
    this.drmProtected = false,
    this.subtitles = const [],
  });

  final Uri uri;
  final StreamFormat format;
  final Map<String, String> headers;
  final bool drmProtected;
  final List<Uri> subtitles;

  /// Only claims native playback for formats the player supports and never
  /// for DRM-protected streams (the app does not decrypt DRM).
  bool get canPlayNatively => format != StreamFormat.unknown && !drmProtected;

  static StreamFormat detectFormat(Uri uri, {String? mimeType}) {
    final mime = mimeType?.toLowerCase() ?? '';
    if (mime.contains('mpegurl')) return StreamFormat.hls;
    if (mime.contains('dash+xml')) return StreamFormat.dash;
    if (mime == 'video/mp4') return StreamFormat.mp4;
    final path = uri.path.toLowerCase();
    if (path.endsWith('.m3u8')) return StreamFormat.hls;
    if (path.endsWith('.mpd')) return StreamFormat.dash;
    if (path.endsWith('.mp4') || path.endsWith('.m4v')) return StreamFormat.mp4;
    return StreamFormat.unknown;
  }
}

abstract class SiteAdapter {
  String get id;
  String get displayName;

  /// Hosts this adapter handles (exact host or subdomain).
  List<String> get domains;

  AdapterPermission get permission;

  bool matches(Uri url) {
    final h = url.host.toLowerCase();
    return domains.any((d) => h == d || h.endsWith('.$d'));
  }

  PageKind classify(Uri url);

  Future<List<Content>> parseCatalogue(PageSnapshot page);
  Future<Content?> parseMovie(PageSnapshot page);
  Future<Content?> parseSeries(PageSnapshot page);
  Future<List<Episode>> parseEpisodes(PageSnapshot page, String seriesId);

  /// Returns a source only if it is directly playable and allowed; otherwise
  /// null, and the user keeps watching in the site's own page.
  Future<PlaybackSource?> resolvePlayback(PageSnapshot page);
}
