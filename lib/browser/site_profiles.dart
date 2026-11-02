import '../data/remote_config.dart';
import 'popup_protection.dart';

/// How a website lists its episodes, so the browser uses the method that fits
/// that site instead of guessing.
enum EpisodeMethod {
  /// Try every method and keep the longest list (sites without a profile).
  auto,

  /// Links on the page labelled 1, 2, "Episode 3", "Capítulo 4"...
  links,

  /// Buttons (or links) read from the live page and pressed to switch.
  buttons,

  /// The episode number is in the address (?ep=2) and the page shows the
  /// total ("2 / 40"): every episode gets its own address.
  param,
}

/// What Reelway knows about one website. Built-in profiles are verified on
/// the site; the server settings ("sites" in config.json) can add or change
/// them without an app update. A fix in one profile never changes another site.
class SiteProfile {
  const SiteProfile({this.episodes = EpisodeMethod.auto, this.param, this.seriesPath, this.autoOpen = true});

  final EpisodeMethod episodes;

  /// For [EpisodeMethod.param]: the query parameter name (for example "ep").
  final String? param;

  /// Addresses matching this pattern are series pages Reelway reads itself;
  /// tapping one opens Reelway's series screen without loading the page.
  final RegExp? seriesPath;

  /// Whether this site's videos and series move into Reelway by themselves.
  final bool autoOpen;

  static const none = SiteProfile();

  static SiteProfile fromJson(Map<String, dynamic> j) {
    RegExp? path;
    if (j['seriesPath'] is String) {
      try {
        path = RegExp(j['seriesPath'] as String);
      } on FormatException {
        path = null;
      }
    }
    return SiteProfile(
      episodes: EpisodeMethod.values.asNameMap()[j['episodes']] ?? EpisodeMethod.auto,
      param: j['param'] is String ? j['param'] as String : null,
      seriesPath: path,
      autoOpen: j['autoOpen'] is bool ? j['autoOpen'] as bool : true,
    );
  }
}

abstract final class SiteProfiles {
  /// Verified on each site (Nov 2026).
  static final builtIn = <String, SiteProfile>{
    // Native catalog reader; series pages are /detail/watch/<slug>.
    'narto-drama.com': SiteProfile(seriesPath: RegExp(r'^/detail/watch/')),
    // Swipe feed: ?ep=N in the address and "N / total" on the page.
    'liderdrama.com': const SiteProfile(episodes: EpisodeMethod.param, param: 'ep'),
    // Player page lists every episode as a button (no links).
    'chartdrama.com': const SiteProfile(episodes: EpisodeMethod.buttons),
  };

  /// The profile for [url]'s site: the server's version first, then the
  /// built-in one, else automatic detection.
  static SiteProfile forUrl(Uri url) {
    final site = PopupProtection.registrableDomain(url.host);
    // Site names contain dots, so look them up in the "sites" map directly.
    final sites = RemoteConfig.instance.value('sites');
    final remote = sites is Map ? sites[site] : null;
    if (remote is Map<String, dynamic>) return SiteProfile.fromJson(remote);
    return builtIn[site] ?? SiteProfile.none;
  }

  /// Whether [url] is a series page Reelway reads itself (see [SiteProfile.seriesPath]).
  static bool isSeriesPage(Uri url) => forUrl(url).seriesPath?.hasMatch(url.path) ?? false;
}
