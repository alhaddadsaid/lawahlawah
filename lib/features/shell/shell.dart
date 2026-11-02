import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
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

  /// Browse screen takes the queued URL exactly once.
  Uri? takePendingUrl() {
    final u = _pendingUrl;
    _pendingUrl = null;
    return u;
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Browse'),
    NavigationDestination(
      icon: Icon(Icons.video_library_outlined),
      selectedIcon: Icon(Icons.video_library),
      label: 'Library',
    ),
    NavigationDestination(icon: Icon(Icons.history), selectedIcon: Icon(Icons.history_rounded), label: 'History'),
    NavigationDestination(icon: Icon(Icons.tune_outlined), selectedIcon: Icon(Icons.tune), label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final shell = context.watch<ShellController>();
    return Scaffold(
      // Keep source exploration and scroll positions while switching tabs.
      body: IndexedStack(
        index: shell.tab.index,
        children: const [HomeScreen(), BrowseScreen(), LibraryScreen(), HistoryScreen(), SettingsScreen()],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: RwColors.divider, width: 0.5)),
        ),
        child: NavigationBar(
          selectedIndex: shell.tab.index,
          onDestinationSelected: (i) => shell.go(AppTab.values[i]),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: _destinations,
        ),
      ),
    );
  }
}
