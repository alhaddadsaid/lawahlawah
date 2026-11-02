import 'package:flutter/foundation.dart';

/// AdMob settings and ad pacing rules.
///
/// iOS uses Reelway's own AdMob app "Reelway Browser"
/// (ca-app-pub-7280343659534747~8852134564, set in ios/Runner/Info.plist).
/// Test builds (debug, or --dart-define=REELWAY_TEST_ADS=true as the ReelBro
/// workflows do) use Google's TEST units instead: clicking your own real ads
/// breaks AdMob policy. Android has no AdMob app yet and always uses test units.
abstract final class AdConfig {
  static const testAds = kDebugMode || bool.fromEnvironment('REELWAY_TEST_ADS');

  // ------------------------------------------------------------ ad units
  static const androidBanner = 'ca-app-pub-3940256099942544/9214589741';
  static const androidInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const androidAppOpen = 'ca-app-pub-3940256099942544/9257395921';

  static const iosBanner = testAds
      ? 'ca-app-pub-3940256099942544/2435281174'
      : 'ca-app-pub-7280343659534747/1664955867';
  static const iosInterstitial = testAds
      ? 'ca-app-pub-3940256099942544/4411468910'
      : 'ca-app-pub-7280343659534747/5842827846';
  static const iosAppOpen = testAds
      ? 'ca-app-pub-3940256099942544/5575463023'
      : 'ca-app-pub-7280343659534747/9151517464';

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
