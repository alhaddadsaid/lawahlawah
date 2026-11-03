import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

/// What the app needs from a push provider. The real one is Firebase Cloud
/// Messaging; tests use a fake.
abstract class PushBackend {
  /// False when the Firebase files are not in the build (push stays off).
  Future<bool> init();

  /// The data of the notification that opened the app from a closed state.
  Future<Map<String, dynamic>?> initialMessage();

  /// Data of a notification tapped while the app was in the background.
  Stream<Map<String, dynamic>> get taps;

  Future<bool> requestPermission();
  Future<bool> hasPermission();
  Future<void> subscribe(String topic);
  Future<void> unsubscribe(String topic);
}

class FirebasePushBackend implements PushBackend {
  FirebaseMessaging get _fcm => FirebaseMessaging.instance;

  @override
  Future<bool> init() async {
    final options = ReelwayFirebase.current;
    if (options == null) return false; // Firebase values not filled in yet.
    try {
      await Firebase.initializeApp(options: options);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> initialMessage() async => (await _fcm.getInitialMessage())?.data;

  @override
  Stream<Map<String, dynamic>> get taps => FirebaseMessaging.onMessageOpenedApp.map((m) => m.data);

  @override
  Future<bool> requestPermission() async {
    final s = await _fcm.requestPermission();
    return s.authorizationStatus == AuthorizationStatus.authorized ||
        s.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<bool> hasPermission() async {
    final s = await _fcm.getNotificationSettings();
    return s.authorizationStatus == AuthorizationStatus.authorized ||
        s.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<void> subscribe(String topic) => _fcm.subscribeToTopic(topic);

  @override
  Future<void> unsubscribe(String topic) => _fcm.unsubscribeFromTopic(topic);
}

/// Push notifications: one topic per store ("ios-all", "android-all") that
/// the admin sends to. Asks for permission only when the user agrees.
class PushService extends ChangeNotifier {
  PushService([PushBackend? backend]) : _backend = backend ?? FirebasePushBackend();
  static final instance = PushService();

  static const _kAsked = 'push.asked';
  static const _kOn = 'push.on';

  final PushBackend _backend;
  bool _available = false;
  bool _enabled = false;
  StreamSubscription<Map<String, dynamic>>? _tapSub;

  /// The topic every device of this store joins.
  static String get topic => defaultTargetPlatform == TargetPlatform.android ? 'android-all' : 'ios-all';

  /// True when this build has Firebase set up.
  bool get available => _available;

  /// True when the user turned notifications on.
  bool get enabled => _enabled;

  /// Starts push and returns the notification that opened the app, if any.
  /// [onTap] gets taps made while the app was already running.
  Future<Map<String, dynamic>?> start(void Function(Map<String, dynamic> data) onTap) async {
    _available = await _backend.init();
    if (!_available) return null;
    try {
      final prefs = await SharedPreferences.getInstance();
      _enabled = (prefs.getBool(_kOn) ?? false) && await _backend.hasPermission();
      // Keep the subscription alive (topics can be lost after reinstalls).
      if (_enabled) await _backend.subscribe(topic);
    } catch (_) {
      /* Stays off. */
    }
    await _tapSub?.cancel();
    _tapSub = _backend.taps.listen(onTap);
    notifyListeners();
    try {
      return await _backend.initialMessage();
    } catch (_) {
      return null;
    }
  }

  /// Whether to show our own "Get news?" question now: push works here, it was
  /// never asked, and the person has opened the app a few times.
  Future<bool> shouldAsk(int launches) async {
    if (!_available || _enabled || launches < 3) return false;
    try {
      final prefs = await SharedPreferences.getInstance();
      return !(prefs.getBool(_kAsked) ?? false);
    } catch (_) {
      return false;
    }
  }

  Future<void> markAsked() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kAsked, true);
    } catch (_) {
      /* Asked again next time. */
    }
  }

  /// Turns notifications on (asks the system for permission) or off.
  /// Returns whether they are on afterwards.
  Future<bool> setEnabled(bool on) async {
    if (!_available) return false;
    try {
      if (on) {
        if (!await _backend.requestPermission()) {
          _enabled = false;
        } else {
          await _backend.subscribe(topic);
          _enabled = true;
        }
      } else {
        await _backend.unsubscribe(topic);
        _enabled = false;
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kOn, _enabled);
      await prefs.setBool(_kAsked, true);
    } catch (_) {
      /* Left as it was. */
    }
    notifyListeners();
    return _enabled;
  }
}
