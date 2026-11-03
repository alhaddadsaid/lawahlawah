import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
import '../../browser/tab_manager.dart';
import '../../data/remote_config.dart';
import '../browse/browse_screen.dart';
import '../history/history_screen.dart';
import '../home/home_screen.dart';
import '../library/library_screen.dart';
import '../settings/settings_screen.dart';

enum AppTab { home, browse, library, history, settings }

/// Cross-tab navigation: lets any screen switch tab or read a source URL in Browse.
class ShellController extends ChangeNotifier {
  AppTab _tab = AppTab.home;
  Uri? _pendingUrl;
  Uri? _pendingBrowserUrl;

  AppTab get tab => _tab;

  void go(AppTab t) {
    if (t == _tab) return;
    _tab = t;
    notifyListeners();
  }

  void openSource(Uri url) {
    _pendingUrl = url;
    _tab = AppTab.browse;
    notifyListeners();
  }

  void openBrowser(Uri url) {
    _pendingBrowserUrl = url;
    _tab = AppTab.home;
    notifyListeners();
  }

  Uri? takePendingBrowserUrl() {
    final url = _pendingBrowserUrl;
    _pendingBrowserUrl = null;
    return url;
  }

  /// Browse screen takes the queued URL exactly once.
  Uri? takePendingUrl() {
    final u = _pendingUrl;
    _pendingUrl = null;
    return u;
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key, this.browserBuilder});
  final Widget Function(BuildContext, BrowserTab)? browserBuilder;
  static const _navigationTabs = [AppTab.home, AppTab.library, AppTab.history, AppTab.settings];

  /// The admin's "Library" switch for this store (off on the Play Store).
  static bool get libraryOn => RemoteConfig.instance.flag('features.library');

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
    NavigationDestination(
      icon: Icon(Icons.video_library_outlined),
      selectedIcon: Icon(Icons.video_library),
      label: 'Library',
    ),
    NavigationDestination(icon: Icon(Icons.history), selectedIcon: Icon(Icons.history_rounded), label: 'History'),
    NavigationDestination(icon: Icon(Icons.tune_outlined), selectedIcon: Icon(Icons.tune), label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) =>
      ListenableBuilder(listenable: RemoteConfig.instance, builder: (context, _) => _build(context));

  Widget _build(BuildContext context) {
    final shell = context.watch<ShellController>();
    final tabs = [
      for (final t in _navigationTabs)
        if (t != AppTab.library || libraryOn) t,
    ];
    final destinations = [
      for (var i = 0; i < _navigationTabs.length; i++)
        if (tabs.contains(_navigationTabs[i])) _destinations[i],
    ];
    final shown = shell.tab == AppTab.library && !libraryOn ? AppTab.home : shell.tab;
    return Scaffold(
      // Keep source exploration and scroll positions while switching tabs.
      body: IndexedStack(
        index: shown.index,
        children: [
          HomeScreen(browserBuilder: browserBuilder),
          const BrowseScreen(),
          const LibraryScreen(),
          const HistoryScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: RwColors.divider, width: 0.5)),
        ),
        child: NavigationBar(
          selectedIndex: shown == AppTab.browse ? 0 : tabs.indexOf(shown),
          onDestinationSelected: (i) => shell.go(tabs[i]),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: destinations,
        ),
      ),
    );
  }
}
