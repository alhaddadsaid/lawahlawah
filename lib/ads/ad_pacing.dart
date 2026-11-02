import 'package:flutter/foundation.dart';

import 'ad_config.dart';

/// Decides when full-screen ads may show, so ads earn without driving
/// viewers away. Shared by every ad format.
abstract final class AdPacing {
  /// Clock, replaceable in tests.
  @visibleForTesting
  static DateTime Function() now = DateTime.now;

  static bool fullScreenActive = false;
  static DateTime? _lastFullScreenEnd;
  static int _episodesSinceAd = 0;
  static bool _returningFromAdClick = false;

  /// Call when the viewer taps any ad: the next return to the app comes
  /// from that ad, so no app open ad is shown on it.
  static void adClicked() => _returningFromAdClick = true;

  static void fullScreenStarted() => fullScreenActive = true;

  static void fullScreenEnded() {
    fullScreenActive = false;
    _lastFullScreenEnd = now();
  }

  static bool _quietFor(Duration d) {
    final last = _lastFullScreenEnd;
    return last == null || now().difference(last) >= d;
  }

  /// Call each time the viewer moves on to another episode. Returns true
  /// when an interstitial is due now.
  static bool episodeStarted() {
    _episodesSinceAd++;
    return !fullScreenActive &&
        _episodesSinceAd >= AdConfig.interstitialEveryEpisodes &&
        _quietFor(AdConfig.fullScreenCooldown);
  }

  static void interstitialShown() => _episodesSinceAd = 0;

  /// Whether an app open ad may show after the viewer was away for [away].
  /// [launches] = how many times the app has been opened on this device.
  static bool appOpenAllowed(Duration away, {int launches = 1 << 30}) {
    final fromAdClick = _returningFromAdClick;
    _returningFromAdClick = false;
    return !fromAdClick &&
        !fullScreenActive &&
        launches >= AdConfig.appOpenMinLaunches &&
        away >= AdConfig.appOpenMinAway &&
        _quietFor(AdConfig.appOpenCooldown);
  }

  @visibleForTesting
  static void reset() {
    now = DateTime.now;
    fullScreenActive = false;
    _lastFullScreenEnd = null;
    _episodesSinceAd = 0;
    _returningFromAdClick = false;
  }
}
