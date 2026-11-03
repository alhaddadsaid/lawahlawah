import 'package:flutter/foundation.dart';

import '../data/remote_config.dart';
import 'popup_protection.dart';

/// How a website lists its episodes, so the browser uses the method that fits
/// that site instead of guessing.
/// Where a site's own ads and pop-ups are left alone (admin "Website's own ads").
enum AdsException { none, android, everywhere }

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
  const SiteProfile({
    this.episodes = EpisodeMethod.auto,
    this.param,
    this.seriesPath,
    this.autoOpen = true,
    this.allowAds = AdsException.none,
  });

  final EpisodeMethod episodes;

  /// For [EpisodeMethod.param]: the query parameter name (for example "ep").
  final String? param;

  /// Addresses matching this pattern are series pages Reelway reads itself;
  /// tapping one opens Reelway's series screen without loading the page.
  final RegExp? seriesPath;

  /// Whether this site's videos and series move into Reelway by themselves.
  final bool autoOpen;

  /// Sites whose own ads and pop-ups are left as they are (no blocking).
  final AdsException allowAds;

  /// Whether the exception applies on this phone.
  bool get adsAllowedHere => switch (allowAds) {
    AdsException.everywhere => true,
    AdsException.android => defaultTargetPlatform == TargetPlatform.android,
    AdsException.none => false,
  };

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
      allowAds: switch (j['allowAds']) {
        'all' || true => AdsException.everywhere,
        'android' => AdsException.android,
        _ => AdsException.none,
      },
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

  /// Main domains whose own ads and pop-ups are not blocked on this phone.
  static List<String> adsAllowedSites() {
    final out = <String>{
      for (final e in builtIn.entries)
        if (e.value.adsAllowedHere) e.key,
    };
    final sites = RemoteConfig.instance.value('sites');
    if (sites is Map) {
      for (final e in sites.entries) {
        if (e.value is! Map) continue;
        final profile = SiteProfile.fromJson(Map<String, dynamic>.from(e.value as Map));
        profile.adsAllowedHere ? out.add('${e.key}') : out.remove('${e.key}');
      }
    }
    return out.toList()..sort();
  }

  /// Whether [url] is a series page Reelway reads itself (see [SiteProfile.seriesPath]).
  static bool isSeriesPage(Uri url) => forUrl(url).seriesPath?.hasMatch(url.path) ?? false;
}
