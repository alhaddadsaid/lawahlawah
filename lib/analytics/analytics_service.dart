import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../data/remote_config.dart';
import '../push/firebase_options.dart';

/// What the app needs from the statistics provider (Google Analytics through
/// Firebase). Tests use a fake.
abstract class AnalyticsBackend {
  /// False when this build has no Firebase values.
  Future<bool> init();
  Future<void> setCollection(bool on);
  Future<void> log(String name, Map<String, Object> params);
}

class FirebaseAnalyticsBackend implements AnalyticsBackend {
  @override
  Future<bool> init() async {
    final options = ReelwayFirebase.current;
    if (options == null) return false;
    try {
      if (Firebase.apps.isEmpty) await Firebase.initializeApp(options: options);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> setCollection(bool on) => FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(on);

  @override
  Future<void> log(String name, Map<String, Object> params) =>
      FirebaseAnalytics.instance.logEvent(name: name, parameters: params);
}

/// Usage statistics. Off until the server switch `analytics.enabled` is on
/// for this store AND consent allows it, so nothing is collected before that
/// (the native defaults are off too, see Info.plist and AndroidManifest).
class AnalyticsService {
  AnalyticsService([AnalyticsBackend? backend]) : _backend = backend ?? FirebaseAnalyticsBackend();
  static final instance = AnalyticsService();

  final AnalyticsBackend _backend;
  bool _ready = false;
  bool _on = false;

  bool get enabled => _on;

  /// Applies the server switch and consent. Call again when the config
  /// changes; [consent] says whether the person's consent allows statistics.
  Future<void> apply(Future<bool> Function() consent) async {
    // Each store has its own switch; a missing one never borrows the other store's.
    final block = RemoteConfig.instance.storeOnly('analytics');
    final wanted = block is Map && block['enabled'] == true;
    final allowed = wanted && await consent();
    if (allowed && !_ready) _ready = await _backend.init();
    final on = allowed && _ready;
    if (on == _on && (_ready || !on)) {
      if (!on && _ready) await _safe(() => _backend.setCollection(false));
      return;
    }
    _on = on;
    if (_ready) await _safe(() => _backend.setCollection(on));
  }

  /// Records one event, only while statistics are on. Names and values are
  /// short ids, never personal data.
  Future<void> log(String name, [Map<String, Object> params = const {}]) async {
    if (!_on) return;
    await _safe(() => _backend.log(name, params));
  }

  static Future<void> _safe(Future<void> Function() f) async {
    try {
      await f();
    } catch (e) {
      debugPrint('analytics: $e');
    }
  }
}
