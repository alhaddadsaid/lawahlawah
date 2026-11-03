import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Settings Reelway reads from its server at start, so ads and features can be
/// changed without an app update. The file is plain JSON (see
/// server/config.json in the repo):
///
///     {"ads": {"enabled": true, "banner": true, "interstitial": true, ...},
///      "features": {"downloads": true, "playOnTv": true, ...}}
///
/// The top-level settings are the App Store (iPhone) ones. The Play Store app
/// reads its own block, "android", with the same keys, so each store is set
/// apart in the admin:
///
///     {"ads": {...}, "features": {...}, "sites": {...},
///      "android": {"ads": {...}, "features": {...}, "sites": {...}}}
///
/// A key missing from "android" falls back to the top-level one.
///
/// The last good copy is kept on the device, so the app starts with it even
/// offline. Anything missing falls back to the defaults in code.
class RemoteConfig extends ChangeNotifier {
  RemoteConfig._();
  static final instance = RemoteConfig._();

  /// Tried in order: Reelway's domain, then the copy on GitHub.
  static const urls = [
    'https://reelbrow.space/config.json',
    'https://raw.githubusercontent.com/alhaddadsaid/lawahlawah/streaming-browser/server/config.json',
  ];
  static const _kCache = 'remote_config.v1';

  Map<String, dynamic> _data = const {};
  Future<void>? _loading;

  /// Resolves when the server answered (or failed); the cached copy is
  /// already in use before that.
  Future<void> get ready => _loading ?? Future.value();

  bool flag(String path, {bool fallback = true}) {
    final v = _lookup(path);
    return v is bool ? v : fallback;
  }

  /// The raw value at [path] (a map, list, string, number or null).
  Object? value(String path) => _lookup(path);

  int number(String path, int fallback) {
    final v = _lookup(path);
    return v is num ? v.toInt() : fallback;
  }

  Object? _lookup(String path) {
    final keys = path.split('.');
    final store = _storeSettings;
    return _walk(store != null && store.containsKey(keys.first) ? store : _data, keys);
  }

  /// The Play Store block on Android; null on iOS (top-level settings).
  Map<dynamic, dynamic>? get _storeSettings {
    if (defaultTargetPlatform != TargetPlatform.android) return null;
    final android = _data['android'];
    return android is Map ? android : null;
  }

  static Object? _walk(Object? root, List<String> keys) {
    Object? node = root;
    for (final key in keys) {
      if (node is! Map) return null;
      node = node[key];
    }
    return node;
  }

  @visibleForTesting
  void debugSet(Map<String, dynamic> data) {
    _data = data;
    notifyListeners();
  }

  @visibleForTesting
  Future<void> debugLoad(http.Client client) => _load(client);

  /// Uses the cached copy at once, then asks the server in the background.
  Future<void> load({http.Client? client}) {
    return _loading ??= _load(client);
  }

  Future<void> _load(http.Client? client) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_kCache);
      if (cached != null) _data = _decode(cached) ?? const {};
    } catch (_) {
      /* No cache yet. */
    }
    await _fetch(client);
  }

  /// Asks the server again, so a switch changed in the admin reaches an app
  /// that stayed open (called when the app comes back to the screen).
  Future<void> refresh({Duration minAge = const Duration(minutes: 1)}) async {
    final last = _fetchedAt;
    if (_fetching || (last != null && DateTime.now().difference(last) < minAge)) return;
    await _fetch(null);
  }

  DateTime? _fetchedAt;
  bool _fetching = false;

  Future<void> _fetch(http.Client? client) async {
    _fetching = true;
    final c = client ?? http.Client();
    try {
      for (final url in urls) {
        try {
          final response = await c.get(Uri.parse(url)).timeout(const Duration(seconds: 6));
          final data = response.statusCode == 200 ? _decode(response.body) : null;
          if (data == null) continue;
          _data = data;
          _fetchedAt = DateTime.now();
          try {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(_kCache, response.body);
          } catch (_) {
            /* Not kept, used anyway. */
          }
          notifyListeners();
          return;
        } catch (_) {
          /* Try the next address. */
        }
      }
    } finally {
      _fetching = false;
      if (client == null) c.close();
    }
  }

  static Map<String, dynamic>? _decode(String body) {
    try {
      final data = jsonDecode(body);
      return data is Map<String, dynamic> ? data : null;
    } on FormatException {
      return null;
    }
  }
}
