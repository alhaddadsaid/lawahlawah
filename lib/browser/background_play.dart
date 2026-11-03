import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../data/remote_config.dart';

/// "Play in background" for YouTube on iPhone: the audio of a playing video
/// keeps going when the app is left or the screen is locked, like a music app.
///
/// iPhone only (Google Play policy: this code never runs on Android) and only
/// while the server switch `features.backgroundPlay` is on (default off).
class BackgroundPlay {
  const BackgroundPlay._();

  static const _channel = MethodChannel('reelway/audio_session');

  /// Pure rule, so tests can check it: iPhone, YouTube page, switch on.
  static bool shouldRun({required TargetPlatform platform, required Uri? url, required bool switchOn}) =>
      platform == TargetPlatform.iOS && switchOn && isYouTube(url);

  static bool isYouTube(Uri? url) {
    final host = url?.host.toLowerCase();
    if (host == null || host.isEmpty) return false;
    return host == 'youtube.com' || host.endsWith('.youtube.com');
  }

  /// Whether the switch is on in the server settings (missing key = off).
  static bool get switchOn => RemoteConfig.instance.flag('features.backgroundPlay', fallback: false);

  /// Whether the feature should run for [url] right now on this phone.
  static bool activeFor(Uri? url) => shouldRun(platform: defaultTargetPlatform, url: url, switchOn: switchOn);

  /// Puts the iPhone audio session in "playback" (or back to normal).
  static Future<void> setAudioSession(bool playback) async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    try {
      await _channel.invokeMethod<void>('setPlayback', playback);
    } catch (_) {
      /* No native side (tests, old build): nothing to do. */
    }
  }

  /// Keeps the page "visible" so WebKit does not pause the video when the app
  /// goes to the background. [offJs] undoes it when the switch goes off.
  static const hookJs = r'''
(function () {
  var h = location.hostname;
  if (h !== 'youtube.com' && !h.endsWith('.youtube.com')) return;
  if (window.__rwBg) return;
  var stop = function (e) { e.stopImmediatePropagation(); };
  try {
    Object.defineProperty(document, 'hidden', { configurable: true, get: function () { return false; } });
    Object.defineProperty(document, 'webkitHidden', { configurable: true, get: function () { return false; } });
    Object.defineProperty(document, 'visibilityState', { configurable: true, get: function () { return 'visible'; } });
    Object.defineProperty(document, 'webkitVisibilityState', { configurable: true, get: function () { return 'visible'; } });
  } catch (e) {}
  document.addEventListener('visibilitychange', stop, true);
  window.addEventListener('visibilitychange', stop, true);
  document.addEventListener('webkitvisibilitychange', stop, true);
  window.__rwBg = stop;
})();
''';

  static const offJs = r'''
(function () {
  var stop = window.__rwBg;
  if (!stop) return;
  ['hidden', 'webkitHidden', 'visibilityState', 'webkitVisibilityState'].forEach(function (k) {
    try { delete document[k]; } catch (e) {}
  });
  document.removeEventListener('visibilitychange', stop, true);
  window.removeEventListener('visibilitychange', stop, true);
  document.removeEventListener('webkitvisibilitychange', stop, true);
  window.__rwBg = null;
})();
''';
}
