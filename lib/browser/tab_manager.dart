import 'package:flutter/foundation.dart';

/// State of one browser tab. The live WebView controller is held by the
/// widget layer; this class tracks what the UI needs to show.
class BrowserTab {
  BrowserTab({required this.id, required this.initialUrl, this.openedByPopup = false, this.windowId})
    : url = initialUrl,
      title = '';

  final String id;
  final Uri initialUrl;
  final bool openedByPopup;

  /// Platform window id when this tab hosts a page-opened window that the
  /// WebView must attach to (window.open with content written afterwards).
  final int? windowId;

  Uri url;
  String title;
  double progress = 0;
  bool canGoBack = false;
  bool canGoForward = false;
  bool isLoading = false;
  int blockedCount = 0;

  bool get isSecure => url.scheme == 'https';
  String get displayTitle => title.isNotEmpty ? title : url.host;
}

/// Ordered list of tabs with an active index. Tabs are capped so a hostile
/// page cannot exhaust memory by opening windows.
class TabManager extends ChangeNotifier {
  TabManager({this.maxTabs = 12});

  final int maxTabs;
  final List<BrowserTab> _tabs = [];
  int _active = -1;
  int _seq = 0;

  List<BrowserTab> get tabs => List.unmodifiable(_tabs);
  BrowserTab? get active => _active >= 0 && _active < _tabs.length ? _tabs[_active] : null;
  int get activeIndex => _active;
  bool get isEmpty => _tabs.isEmpty;
  bool get isFull => _tabs.length >= maxTabs;

  /// Opens a tab and makes it active. Returns null when the cap is reached.
  BrowserTab? open(Uri url, {bool openedByPopup = false, bool activate = true, int? windowId}) {
    if (isFull) return null;
    final tab = BrowserTab(id: 'tab-${_seq++}', initialUrl: url, openedByPopup: openedByPopup, windowId: windowId);
    final insertAt = _active < 0 ? _tabs.length : _active + 1;
    _tabs.insert(insertAt, tab);
    if (activate || _active < 0) _active = insertAt;
    notifyListeners();
    return tab;
  }

  void activate(String id) {
    final i = _tabs.indexWhere((t) => t.id == id);
    if (i >= 0 && i != _active) {
      _active = i;
      notifyListeners();
    }
  }

  void close(String id) {
    final i = _tabs.indexWhere((t) => t.id == id);
    if (i < 0) return;
    _tabs.removeAt(i);
    if (_tabs.isEmpty) {
      _active = -1;
    } else if (i < _active || _active >= _tabs.length) {
      _active = (_active - 1).clamp(0, _tabs.length - 1);
    }
    notifyListeners();
  }

  void closeAll() {
    _tabs.clear();
    _active = -1;
    notifyListeners();
  }

  /// Called by the WebView layer whenever tab state changes.
  void update(String id, void Function(BrowserTab t) change) {
    final tab = _tabs.where((t) => t.id == id).firstOrNull;
    if (tab == null) return;
    change(tab);
    notifyListeners();
  }
}
