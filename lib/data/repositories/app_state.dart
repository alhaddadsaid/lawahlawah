import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../adapters/adapter_registry.dart';
import '../../browser/popup_protection.dart';
import '../../core/security/url_policy.dart';
import '../../partners/partner_registry.dart';
import '../models/models.dart';
import '../models/user_settings.dart';
import '../sample/sample_data.dart';

/// Single source of app data for the UI.
///
/// Persistence: websites, bookmarks, page history and settings are stored as
/// JSON in SharedPreferences. That holds no passwords or tokens — website
/// sessions live in the WebView's own cookie store. Phase 5 moves catalogue
/// and watch history into an SQLite database (drift).
class AppState extends ChangeNotifier {
  AppState({AdapterRegistry? registry, bool? useSampleData})
    : registry = registry ?? AdapterRegistry(),
      useSampleData = useSampleData ?? (kDebugMode || _previewBuild);

  /// Set only for the web design preview (`--dart-define=SAMPLE_DATA=true`).
  /// Store builds never pass it, so they never contain sample data.
  static const _previewBuild = bool.fromEnvironment('SAMPLE_DATA');

  final AdapterRegistry registry;

  /// Sample catalogue is shown in debug builds only.
  final bool useSampleData;

  final popupProtection = PopupProtection();

  /// Partner websites whose contract lets Reelway hide their ads.
  final partners = PartnerRegistry();

  SharedPreferences? _prefs;
  UserSettings _settings = const UserSettings();
  final List<Website> _websites = [];
  final List<Bookmark> _bookmarks = [];
  final List<VisitedPage> _visited = [];
  final List<WatchHistory> _watch = [];
  final List<Content> _content = [];
  final Set<String> _favorites = {};

  UserSettings get settings => _settings;
  List<Website> get websites => List.unmodifiable(_websites);
  List<Bookmark> get bookmarks => List.unmodifiable(_bookmarks);
  List<VisitedPage> get visited => List.unmodifiable(_visited);
  List<WatchHistory> get watchHistory => List.unmodifiable(_watch);
  List<Content> get content => List.unmodifiable(_content);
  Set<String> get favorites => Set.unmodifiable(_favorites);

  List<Content> get movies => _content.where((c) => c.category == ContentCategory.movie).toList();
  List<Content> get series => _content.where((c) => c.category == ContentCategory.series).toList();
  List<Content> get favoriteContent => _content.where((c) => _favorites.contains(c.id)).toList();
  List<Content> get recentlyAdded => _content.reversed.toList();

  List<WatchHistory> get continueWatching =>
      (_watch.where((h) => !h.isFinished).toList()..sort((a, b) => b.lastWatched.compareTo(a.lastWatched)));

  List<Website> get recentWebsites =>
      [..._websites]..sort((a, b) => (b.lastVisited ?? b.dateAdded).compareTo(a.lastVisited ?? a.dateAdded));

  Content? contentById(String id) => _content.where((c) => c.id == id).firstOrNull;
  Website? websiteById(String id) => _websites.where((w) => w.id == id).firstOrNull;
  WatchHistory? historyFor(String contentId) => _watch.where((h) => h.contentId == contentId).firstOrNull;

  // ---------------------------------------------------------------------------

  static const _kSettings = 'settings.v1';
  static const _kWebsites = 'websites.v1';
  static const _kBookmarks = 'bookmarks.v1';
  static const _kVisited = 'visited.v1';
  static const _kFavorites = 'favorites.v1';

  Future<void> load() async {
    final p = _prefs = await SharedPreferences.getInstance();
    _settings =
        _decode(p.getString(_kSettings), (m) => UserSettings.fromJson(m as Map<String, dynamic>)) ??
        const UserSettings();
    _websites
      ..clear()
      ..addAll(_decodeList(p.getString(_kWebsites), Website.fromJson));
    _bookmarks
      ..clear()
      ..addAll(_decodeList(p.getString(_kBookmarks), Bookmark.fromJson));
    _visited
      ..clear()
      ..addAll(_decodeList(p.getString(_kVisited), VisitedPage.fromJson));
    _favorites
      ..clear()
      ..addAll(p.getStringList(_kFavorites) ?? const []);

    if (useSampleData) {
      _content
        ..clear()
        ..addAll(SampleData.content);
      _watch
        ..clear()
        ..addAll(SampleData.history());
    }
    _applyProtectionSettings();
    notifyListeners();
  }

  T? _decode<T>(String? raw, T Function(Object?) f) {
    if (raw == null) return null;
    try {
      return f(jsonDecode(raw));
    } catch (_) {
      return null; // Corrupt data: fall back to defaults rather than crash.
    }
  }

  List<T> _decodeList<T>(String? raw, T Function(Map<String, dynamic>) f) =>
      _decode(raw, (o) => (o as List).map((e) => f(e as Map<String, dynamic>)).toList()) ?? <T>[];

  Future<void> _save() async {
    final p = _prefs;
    if (p == null) return;
    await Future.wait([
      p.setString(_kSettings, jsonEncode(_settings.toJson())),
      p.setString(_kWebsites, jsonEncode(_websites.map((e) => e.toJson()).toList())),
      p.setString(_kBookmarks, jsonEncode(_bookmarks.map((e) => e.toJson()).toList())),
      p.setString(_kVisited, jsonEncode(_visited.map((e) => e.toJson()).toList())),
      p.setStringList(_kFavorites, _favorites.toList()),
    ]);
  }

  void _changed() {
    notifyListeners();
    _save();
  }

  // Websites ------------------------------------------------------------------

  /// Adds a website from user input. Returns an error message, or null.
  String? addWebsite(String input, {String? name}) {
    final parsed = UrlPolicy.parse(input);
    if (parsed is AddressRejected) return parsed.reason;
    if (parsed is! AddressUrl) return 'Enter a full web address, for example example.com';
    final uri = parsed.uri;
    if (_websites.any((w) => w.host == uri.host)) return 'That website is already saved.';
    final display = (name?.trim().isNotEmpty ?? false) ? name!.trim() : _prettyHost(uri.host);
    _websites.add(
      Website(
        id: 'w${DateTime.now().microsecondsSinceEpoch}',
        name: display,
        url: uri.replace(path: uri.path.isEmpty ? '/' : uri.path).toString(),
        dateAdded: DateTime.now(),
        integrationStatus: registry.statusFor(uri),
      ),
    );
    _changed();
    return null;
  }

  static String _prettyHost(String host) {
    final h = host.startsWith('www.') ? host.substring(4) : host;
    final first = h.split('.').first;
    return first.isEmpty ? h : first[0].toUpperCase() + first.substring(1);
  }

  void removeWebsite(String id) {
    _websites.removeWhere((w) => w.id == id);
    _changed();
  }

  void markVisited(Uri url, String title) {
    final i = _websites.indexWhere((w) => w.host == url.host);
    if (i >= 0) _websites[i] = _websites[i].copyWith(lastVisited: DateTime.now());
    if (_settings.saveHistory && (url.scheme == 'https' || url.scheme == 'http')) {
      _visited.removeWhere((v) => v.url == url.toString());
      _visited.insert(0, VisitedPage(url: url.toString(), title: title, visitedAt: DateTime.now()));
      if (_visited.length > 500) _visited.removeRange(500, _visited.length);
    }
    _changed();
  }

  // Bookmarks -----------------------------------------------------------------

  bool isBookmarked(String url) => _bookmarks.any((b) => b.url == url);

  void toggleBookmark(String url, String title) {
    if (isBookmarked(url)) {
      _bookmarks.removeWhere((b) => b.url == url);
    } else {
      _bookmarks.insert(
        0,
        Bookmark(id: 'b${DateTime.now().microsecondsSinceEpoch}', title: title, url: url, dateAdded: DateTime.now()),
      );
    }
    _changed();
  }

  void removeBookmark(String id) {
    _bookmarks.removeWhere((b) => b.id == id);
    _changed();
  }

  // Favorites & history -------------------------------------------------------

  bool isFavorite(String id) => _favorites.contains(id);

  void toggleFavorite(String id) {
    _favorites.contains(id) ? _favorites.remove(id) : _favorites.add(id);
    _changed();
  }

  void removeVisited(String url) {
    _visited.removeWhere((v) => v.url == url);
    _changed();
  }

  void removeWatch(String id) {
    _watch.removeWhere((h) => h.id == id);
    _changed();
  }

  void clearBrowsingHistory() {
    _visited.clear();
    _changed();
  }

  void clearWatchHistory() {
    _watch.clear();
    _changed();
  }

  /// Wipes all locally stored app data (spec section 9). The browser layer
  /// separately clears cookies, cache and web storage.
  Future<void> clearAllData() async {
    _websites.clear();
    _bookmarks.clear();
    _visited.clear();
    _watch.clear();
    _favorites.clear();
    _settings = const UserSettings();
    _applyProtectionSettings();
    popupProtection.clearLog();
    await _prefs?.clear();
    notifyListeners();
  }

  // Settings ------------------------------------------------------------------

  void updateSettings(UserSettings Function(UserSettings s) f) {
    _settings = f(_settings);
    _applyProtectionSettings();
    _changed();
  }

  void allowPopupsFor(Uri site) {
    final domain = PopupProtection.registrableDomain(site.host);
    updateSettings((s) => s.copyWith(allowedPopupSites: {...s.allowedPopupSites, domain}));
  }

  void disallowPopupsFor(String domain) {
    updateSettings((s) => s.copyWith(allowedPopupSites: {...s.allowedPopupSites}..remove(domain)));
  }

  void _applyProtectionSettings() {
    popupProtection.level = _settings.protectionLevel;
    popupProtection.allowedSites
      ..clear()
      ..addAll(_settings.allowedPopupSites);
  }
}
