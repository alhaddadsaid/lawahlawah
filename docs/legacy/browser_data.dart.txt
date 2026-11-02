import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Clears website data held by the platform WebView (cookies, cache, local
/// storage). Logs out of every website.
abstract final class BrowserData {
  static Future<void> clearCookies() async {
    if (kIsWeb) return;
    await CookieManager.instance().deleteAllCookies();
  }

  static Future<void> clearAll() async {
    if (kIsWeb) return;
    await CookieManager.instance().deleteAllCookies();
    await WebStorageManager.instance().deleteAllData();
    await InAppWebViewController.clearAllCache();
  }
}
