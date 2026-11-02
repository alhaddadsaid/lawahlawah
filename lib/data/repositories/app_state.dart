import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../adapters/adapter_registry.dart';
import '../../browser/popup_protection.dart';
import '../../core/security/url_policy.dart';
import '../../partners/partner_registry.dart';
import '../../sources/link_feed.dart';
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
  final List<String> _links = [];
  final Map<String, List<Episode>> _episodes = {};
  bool _linksDisclaimerAccepted = false;

  UserSettings get settings => _settings;
  List<Website> get websites => List.unmodifiable(_websites);
  List<Bookmark> get bookmarks => List.unmodifiable(_bookmarks);
  List<VisitedPage> get visited => List.unmodifiable(_visited);
  List<WatchHistory> get watchHistory => List.unmodifiable(_watch);
  List<Content> get content => List.unmodifiable(_content);
  Set<String> get favorites => Set.unmodifiable(_favorites);

  /// Public video and catalog links the user added to the Library.
  List<String> get links => List.unmodifiable(_links);

  /// The user confirmed they have the right to play the links they add.
  bool get linksDisclaimerAccepted => _linksDisclaimerAccepted;

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

  /// Episodes Reelway's player can play, for a title from an added link.
  List<Episode> episodesFor(String contentId) => _episodes[contentId] ?? const [];

  // ---------------------------------------------------------------------------

  static const _kSettings = 'settings.v1';
  static const _kWebsites = 'websites.v1';
  static const _kBookmarks = 'bookmarks.v1';
  static const _kVisited = 'visited.v1';
  static const _kFavorites = 'favorites.v1';
  static const _kLinks = 'links.v1';
  static const _kWatch = 'watch.v1';
  static const _kLinksDisclaimer = 'links.disclaimer.v1';

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
    _links
      ..clear()
      ..addAll(p.getStringList(_kLinks) ?? const []);
    _linksDisclaimerAccepted = p.getBool(_kLinksDisclaimer) ?? false;
    _watch
      ..clear()
      ..addAll(_decodeList(p.getString(_kWatch), WatchHistory.fromJson));

    if (useSampleData) {
      _content
        ..clear()
        ..addAll(SampleData.content);
      _watch.addAll(SampleData.history());
    }
    _applyProtectionSettings();
    notifyListeners();
    unawaited(refreshLinks());
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
    final watch = _watch.where((h) => contentById(h.contentId)?.isSample != true).map((h) => h.toJson()).toList();
    await Future.wait([
      p.setString(_kSettings, jsonEncode(_settings.toJson())),
      p.setString(_kWebsites, jsonEncode(_websites.map((e) => e.toJson()).toList())),
      p.setString(_kBookmarks, jsonEncode(_bookmarks.map((e) => e.toJson()).toList())),
      p.setString(_kVisited, jsonEncode(_visited.map((e) => e.toJson()).toList())),
      p.setStringList(_kFavorites, _favorites.toList()),
      p.setStringList(_kLinks, _links),
      p.setString(_kWatch, jsonEncode(watch)),
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

  // Links -----------------------------------------------------------------------

  /// Adds a public video or catalog link. Returns an error message, or null.
  Future<String?> addLink(String input) async {
    final Uri link;
    try {
      link = LinkFeed.check(input);
    } on FormatException catch (e) {
      return e.message;
    }
    final key = link.toString();
    if (_links.contains(key)) return 'That link is already in your Library.';
    try {
      _setLinkContent(key, await _readLink(link));
    } on FormatException catch (e) {
      return e.message;
    } catch (_) {
      return 'Could not load the link. Check that it opens without signing in, then try again.';
    }
    _links.add(key);
    _changed();
    return null;
  }

  void acceptLinksDisclaimer() {
    if (_linksDisclaimerAccepted) return;
    _linksDisclaimerAccepted = true;
    _prefs?.setBool(_kLinksDisclaimer, true);
    notifyListeners();
  }

  void removeLink(String link) {
    final prefix = '${_linkSource(link)}#';
    _links.remove(link);
    _content.removeWhere((c) => c.sourceWebsiteId == _linkSource(link));
    _episodes.removeWhere((id, _) => id.startsWith(prefix));
    _watch.removeWhere((h) => h.contentId.startsWith(prefix));
    _changed();
  }

  /// How many titles a link added to the Library.
  int titlesFrom(String link) => _content.where((c) => c.sourceWebsiteId == _linkSource(link)).length;

  /// Reads every saved link again; titles appear as each one loads.
  Future<void> refreshLinks() async {
    for (final link in [..._links]) {
      try {
        _setLinkContent(link, await _readLink(Uri.parse(link)));
      } catch (_) {
        // Offline, or the link moved: keep it and try again next time.
      }
    }
  }

  /// Fetches a link with no cookies or sign-in, so only public links work.
  static Future<List<LinkSeries>> _readLink(Uri link) async {
    if (LinkFeed.isVideo(link)) return [LinkFeed.single(link)];
    final source = LinkFeed.resolve(link);
    final res = await http.get(source).timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) throw FormatException('The link answered with error ${res.statusCode}.');
    return LinkFeed.parse(source, utf8.decode(res.bodyBytes, allowMalformed: true));
  }

  static String _linkSource(String link) => 'link:$link';

  void _setLinkContent(String link, List<LinkSeries> series) {
    final source = _linkSource(link);
    _content.removeWhere((c) => c.sourceWebsiteId == source);
    _episodes.removeWhere((id, _) => id.startsWith('$source#'));
    for (final s in series) {
      final id = '$source#${s.id}';
      final item = Content(
        id: id,
        title: s.title,
        description: s.description,
        poster: s.poster?.toString(),
        category: s.episodes.length == 1 ? ContentCategory.movie : ContentCategory.series,
        sourceWebsiteId: source,
        sourcePageUrl: link,
      );
      _content.add(item);
      _episodes[id] = [
        for (final e in s.episodes)
          Episode(
            id: '$id-e${e.number}',
            seriesId: id,
            seasonNumber: 1,
            episodeNumber: e.number,
            title: e.title,
            sourcePageUrl: e.videoUrl.toString(),
            videoUrl: e.videoUrl.toString(),
            duration: e.duration,
          ),
      ];
    }
    notifyListeners();
  }

  /// Saves how far the user got in [episode] of [content].
  void recordProgress(Content content, Episode episode, Duration position, Duration duration) {
    _watch.removeWhere((h) => h.contentId == content.id);
    _watch.insert(
      0,
      WatchHistory(
        id: 'h${content.id}',
        contentId: content.id,
        episodeId: episode.id,
        sourceUrl: episode.videoUrl ?? episode.sourcePageUrl,
        playbackPosition: position,
        duration: duration,
        lastWatched: DateTime.now(),
      ),
    );
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
    _links.clear();
    _episodes.clear();
    _linksDisclaimerAccepted = false;
    _content.removeWhere((c) => c.sourceWebsiteId.startsWith('link:'));
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
