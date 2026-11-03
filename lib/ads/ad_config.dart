import 'package:flutter/foundation.dart';

import '../data/remote_config.dart';

/// AdMob settings and ad pacing rules.
///
/// Each platform has its own AdMob app, so a problem with one store listing
/// does not touch the other's ads:
/// - iOS: "Reelway Browser" (ca-app-pub-7280343659534747~8852134564, set in
///   ios/Runner/Info.plist).
/// - Android: "Reelway: Video Browser", package com.reelbrow.videobrowser
///   (ca-app-pub-7280343659534747~1572923698, set in AndroidManifest.xml).
/// Test builds (debug, or --dart-define=REELWAY_TEST_ADS=true as the ReelBro
/// and Android test workflows do) use Google's TEST units instead: clicking
/// your own real ads breaks AdMob policy.
abstract final class AdConfig {
  static const testAds = kDebugMode || bool.fromEnvironment('REELWAY_TEST_ADS');

  // ------------------------------------------------------------ ad units
  static const androidBanner = testAds
      ? 'ca-app-pub-3940256099942544/9214589741'
      : 'ca-app-pub-7280343659534747/3105497214';
  static const androidInterstitial = testAds
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-7280343659534747/8166252200';
  static const androidAppOpen = testAds
      ? 'ca-app-pub-3940256099942544/9257395921'
      : 'ca-app-pub-7280343659534747/4022781032';

  static const iosBanner = testAds
      ? 'ca-app-pub-3940256099942544/2435281174'
      : 'ca-app-pub-7280343659534747/1664955867';
  static const iosInterstitial = testAds
      ? 'ca-app-pub-3940256099942544/4411468910'
      : 'ca-app-pub-7280343659534747/5842827846';
  static const iosAppOpen = testAds
      ? 'ca-app-pub-3940256099942544/5575463023'
      : 'ca-app-pub-7280343659534747/9151517464';

  /// The ad units to try for [format] ("banner", "interstitial", "appOpen"),
  /// main first, then the backup tried when the main one has no ad. The
  /// server sets both per store (ads.units and ads.backupUnits); without them
  /// the built-in IDs above are used. Test builds always use Google's test
  /// units, whatever the server says.
  static List<String> units(String format) {
    final ios = defaultTargetPlatform == TargetPlatform.iOS;
    final builtIn = switch (format) {
      'banner' => ios ? iosBanner : androidBanner,
      'interstitial' => ios ? iosInterstitial : androidInterstitial,
      _ => ios ? iosAppOpen : androidAppOpen,
    };
    if (testAds) return [builtIn];
    String? server(String group) {
      final id = RemoteConfig.instance.value('ads.$group.$format');
      return id is String && isUnitId(id.trim()) ? id.trim() : null;
    }

    final main = server('units') ?? builtIn;
    final backup = server('backupUnits');
    return [main, if (backup != null && backup != main) backup];
  }

  /// An AdMob ad unit ID, like `ca-app-pub-1234567890123456/1234567890`.
  static bool isUnitId(String id) => RegExp(r'^ca-app-pub-\d{10,20}/\d{6,12}$').hasMatch(id);

  // -------------------------------------------------------------- pacing

  /// One interstitial after every N episodes the viewer moves on to.
  static const interstitialEveryEpisodes = 3;

  /// Minimum gap after any full-screen ad before an interstitial can show.
  static const fullScreenCooldown = Duration(seconds: 90);

  /// App open ad: only when the viewer comes back after at least this long...
  static const appOpenMinAway = Duration(seconds: 60);

  /// ...and at most once in this period (also counted from other ads).
  static const appOpenCooldown = Duration(minutes: 4);

  /// No app open ads until the viewer has opened the app this many times.
  static const appOpenMinLaunches = 3;

  /// Highest ad content rating served (Google: G, PG, T, MA). T = teen.
  static const maxAdContentRating = 'T';
}
