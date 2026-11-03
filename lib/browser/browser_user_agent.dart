import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// How Reelway's tabs name themselves to websites.
///
/// The plain in-app webview identity makes some sites treat Reelway as an
/// embedded view instead of a browser: YouTube, for one, then sends no video
/// ads at all (checked Nov 2026). Like Chrome, Firefox and Brave on phones,
/// Reelway keeps the system engine's identity, adds its own name, and leaves
/// out the "embedded view" markers.
abstract final class BrowserUserAgent {
  /// iOS: appended to WebKit's own identity ("... Mobile/15E148").
  static const iosSuffix = 'Reelway/1.0 Safari/604.1';

  /// Android: the full identity, set once at start-up by [load].
  static String? android;

  static Future<void> load() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      android = forAndroid(await InAppWebViewController.getDefaultUserAgent());
    } catch (_) {
      android = null; // The webview's own identity still works.
    }
  }

  /// Android WebView's identity without the "; wv" and "Version/4.0" markers,
  /// plus Reelway's name.
  static String forAndroid(String webView) {
    final cleaned = webView
        .replaceAll('; wv)', ')')
        .replaceAll(RegExp(r'Version/\d+(\.\d+)* '), '')
        .replaceAll(RegExp(r' {2,}'), ' ')
        .trim();
    return cleaned.contains('Reelway/') ? cleaned : '$cleaned Reelway/1.0';
  }
}
