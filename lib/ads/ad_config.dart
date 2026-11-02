/// AdMob settings and ad pacing rules.
///
/// The unit IDs below are Google's official TEST units: they always show a
/// sample ad and are safe to tap during development. Before release, replace
/// them with Reelway's own ad unit IDs from the AdMob console, and replace the
/// test App IDs in ios/Runner/Info.plist (GADApplicationIdentifier) and
/// android/app/src/main/AndroidManifest.xml (APPLICATION_ID).
abstract final class AdConfig {
  // ------------------------------------------------------------ ad units
  static const androidBanner = 'ca-app-pub-3940256099942544/9214589741';
  static const androidInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const androidAppOpen = 'ca-app-pub-3940256099942544/9257395921';

  static const iosBanner = 'ca-app-pub-3940256099942544/2435281174';
  static const iosInterstitial = 'ca-app-pub-3940256099942544/4411468910';
  static const iosAppOpen = 'ca-app-pub-3940256099942544/5575463023';

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
