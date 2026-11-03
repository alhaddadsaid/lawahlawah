import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'remote_config.dart';

/// Where an announcement button or a push notification takes people.
enum AnnouncementTarget { announcement, url, settings, protection }

/// One announcement written in the admin. The server config holds a list per
/// store under "announcements":
///
///     [{"id": "a1", "title": "...", "body": "...", "date": "2026-11-03",
///       "action": {"type": "url", "value": "https://...", "label": "Open"}}]
@immutable
class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    this.date,
    this.actionType,
    this.actionValue,
    this.actionLabel,
  });

  final String id;
  final String title;
  final String body;
  final String? date;
  final AnnouncementTarget? actionType;
  final String? actionValue;
  final String? actionLabel;

  /// Null when the entry is not usable (no id, or nothing to show).
  static Announcement? fromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    final title = json['title'];
    if (id is! String || id.trim().isEmpty || title is! String || title.trim().isEmpty) return null;
    final body = json['body'];
    final action = json['action'];
    AnnouncementTarget? type;
    String? value;
    String? label;
    if (action is Map) {
      type = parseTarget(action['type']);
      if (type == AnnouncementTarget.announcement) type = null;
      value = action['value'] is String ? action['value'] as String : null;
      label = action['label'] is String && (action['label'] as String).trim().isNotEmpty
          ? (action['label'] as String).trim()
          : null;
      if (type == AnnouncementTarget.url && safeUrl(value) == null) type = null;
    }
    return Announcement(
      id: id.trim(),
      title: title.trim(),
      body: body is String ? body.trim() : '',
      date: json['date'] is String ? json['date'] as String : null,
      actionType: type,
      actionValue: value,
      actionLabel: label,
    );
  }

  static AnnouncementTarget? parseTarget(Object? name) {
    for (final t in AnnouncementTarget.values) {
      if (t.name == name) return t;
    }
    return null;
  }

  /// Only web links open from an announcement.
  static Uri? safeUrl(String? value) {
    if (value == null) return null;
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasAuthority || (uri.scheme != 'https' && uri.scheme != 'http')) return null;
    return uri;
  }
}

/// The announcements for this store, and which ones this device has seen.
class Announcements extends ChangeNotifier {
  Announcements._();
  static final instance = Announcements._();
  static const _kSeen = 'announcements.seen';

  Set<String> _seen = {};
  bool _loaded = false;

  /// Newest first (the admin puts the newest at the top).
  List<Announcement> get all {
    final raw = RemoteConfig.instance.storeOnly('announcements');
    if (raw is! List) return const [];
    return [for (final e in raw) ?Announcement.fromJson(e)];
  }

  Announcement? byId(String id) {
    for (final a in all) {
      if (a.id == id) return a;
    }
    return null;
  }

  bool isSeen(String id) => _seen.contains(id);

  /// The newest announcement not opened yet, if any.
  Announcement? get firstUnseen {
    for (final a in all) {
      if (!_seen.contains(a.id)) return a;
    }
    return null;
  }

  int get unseenCount => all.where((a) => !_seen.contains(a.id)).length;

  Future<void> load() async {
    if (_loaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      _seen = (prefs.getStringList(_kSeen) ?? const []).toSet();
    } catch (_) {
      /* Nothing seen yet. */
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> markSeen(String id) async {
    if (!_seen.add(id)) return;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_kSeen, _seen.toList());
    } catch (_) {
      /* Shown again next time. */
    }
  }

  @visibleForTesting
  void debugReset() {
    _seen = {};
    _loaded = false;
  }
}
