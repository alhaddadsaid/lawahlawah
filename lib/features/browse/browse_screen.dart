import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../browser/browser_view.dart';
import '../../browser/popup_protection.dart';
import '../../browser/tab_manager.dart';
import '../../core/design/tokens.dart';
import '../../core/security/url_policy.dart';
import '../../core/widgets/components.dart';
import '../../data/repositories/app_state.dart';
import '../settings/protection_screen.dart';
import '../settings/websites_screen.dart';
import '../shell/shell.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final _tabs = TabManager();
  final _commands = <String, BrowserCommands>{};
  late final ShellController _shell;

  @override
  void initState() {
    super.initState();
    _shell = context.read<ShellController>()..addListener(_takePending);
    _tabs.addListener(_onTabs);
    WidgetsBinding.instance.addPostFrameCallback((_) => _takePending());
  }

  @override
  void dispose() {
    _shell.removeListener(_takePending);
    _tabs.dispose();
    super.dispose();
  }

  void _onTabs() {
    _commands.removeWhere((id, _) => !_tabs.tabs.any((t) => t.id == id));
    if (mounted) setState(() {});
  }

  void _takePending() {
    final url = _shell.takePendingUrl();
    if (url != null) _open(url);
  }

  /// Opens [url] in the current tab, or a new tab if none is open.
  void _open(Uri url, {bool newTab = false}) {
    final active = _tabs.active;
    if (active == null || newTab) {
      if (_tabs.open(url) == null) _snack('Tab limit reached. Close a tab first.');
    } else {
      _commands[active.id]?.load(url);
    }
  }

  void _submitAddress(String text, {bool newTab = false}) {
    final s = context.read<AppState>().settings;
    final parsed = UrlPolicy.parse(text);
    switch (parsed) {
      case AddressRejected(:final reason):
        _snack(reason);
      case AddressSearch():
        _open(parsed.searchUri(), newTab: newTab);
      case AddressUrl(:final uri, :final upgradedToHttps):
        // With the HTTPS default switched off, honour what the user typed.
        final u = (!s.httpsUpgrade && upgradedToHttps) ? uri.replace(scheme: 'http') : uri;
        _open(u, newTab: newTab);
    }
  }

  void _snack(String msg, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg), action: action, duration: const Duration(seconds: 4)));
  }

  void _onBlocked(Uri site, Decision d, {required bool popup}) {
    final target = d.target;
    final app = context.read<AppState>();
    final domain = PopupProtection.registrableDomain(site.host);
    _snack(
      'Blocked: ${d.reason}',
      action: target == null
          ? SnackBarAction(
              label: 'Allow site',
              textColor: RwColors.accent,
              onPressed: () {
                app.allowPopupsFor(site);
                _snack('Pop-ups and redirects allowed on $domain');
              },
            )
          : SnackBarAction(
              label: 'Open anyway',
              textColor: RwColors.accent,
              onPressed: () {
                app.popupProtection.allowOnce(target);
                _open(target, newTab: popup);
              },
            ),
    );
  }

  Future<void> _showAddressEditor() async {
    final text = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddressSheet(initial: _tabs.active?.url.toString() ?? ''),
    );
    if (text != null) _submitAddress(text);
  }

  Future<void> _showTabs() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _TabsSheet(
        tabs: _tabs,
        onNewTab: () {
          Navigator.pop(context);
          _newTabPrompt();
        },
      ),
    );
  }

  Future<void> _newTabPrompt() async {
    final text = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddressSheet(initial: ''),
    );
    if (text != null) _submitAddress(text, newTab: true);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final active = _tabs.active;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          if (active != null)
            _Toolbar(
              tab: active,
              tabCount: _tabs.tabs.length,
              warnInsecure: app.settings.warnOnHttp,
              bookmarked: app.isBookmarked(active.url.toString()),
              onBack: active.canGoBack ? () => _commands[active.id]?.back() : null,
              onAddress: _showAddressEditor,
              onTabs: _showTabs,
              onMenu: (action) {
                final c = _commands[active.id];
                switch (action) {
                  case _MenuAction.forward:
                    c?.forward();
                  case _MenuAction.reload:
                    c?.reload();
                  case _MenuAction.bookmark:
                    app.toggleBookmark(active.url.toString(), active.displayTitle);
                  case _MenuAction.newTab:
                    _newTabPrompt();
                  case _MenuAction.closeTab:
                    _tabs.close(active.id);
                  case _MenuAction.allowSite:
                    app.allowPopupsFor(active.url);
                    _snack('Pop-ups allowed on ${PopupProtection.registrableDomain(active.url.host)}');
                  case _MenuAction.protection:
                    Navigator.of(context).push(ProtectionScreen.route());
                }
              },
            ),
          // Only built while loading: an idle indeterminate indicator would
          // keep animating (and draining battery) even when invisible.
          SizedBox(
            height: 2,
            child: active?.isLoading == true
                ? LinearProgressIndicator(
                    value: active!.progress > 0 ? active.progress : null,
                    minHeight: 2,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation(RwColors.accent),
                  )
                : null,
          ),
          Expanded(
            child: active == null
                ? _StartPage(onSubmit: _submitAddress, onOpen: _open, tabCount: _tabs.tabs.length, onTabs: _showTabs)
                : IndexedStack(
                    index: _tabs.activeIndex,
                    children: [
                      for (final t in _tabs.tabs)
                        BrowserView(
                          key: ValueKey(t.id),
                          tab: t,
                          tabs: _tabs,
                          protection: app.popupProtection,
                          partners: app.partners,
                          settings: app.settings,
                          commands: _commands.putIfAbsent(t.id, BrowserCommands.new),
                          onBlocked: _onBlocked,
                          onPageLoaded: app.markVisited,
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

enum _MenuAction { forward, reload, bookmark, newTab, closeTab, allowSite, protection }

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.tab,
    required this.tabCount,
    required this.warnInsecure,
    required this.bookmarked,
    required this.onBack,
    required this.onAddress,
    required this.onTabs,
    required this.onMenu,
  });

  final BrowserTab? tab;
  final int tabCount;
  final bool warnInsecure;
  final bool bookmarked;
  final VoidCallback? onBack;
  final VoidCallback onAddress;
  final VoidCallback onTabs;
  final void Function(_MenuAction) onMenu;

  @override
  Widget build(BuildContext context) {
    final t = tab;
    final insecure = t != null && !t.isSecure && t.url.scheme != 'about';
    return Padding(
      padding: const EdgeInsets.fromLTRB(RwSpace.xxs, RwSpace.xs, RwSpace.xxs, RwSpace.xs),
      child: Row(
        children: [
          IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back_ios_new, size: 20), tooltip: 'Back'),
          Expanded(
            child: Material(
              color: RwColors.card,
              borderRadius: BorderRadius.circular(RwRadius.pill),
              child: InkWell(
                borderRadius: BorderRadius.circular(RwRadius.pill),
                onTap: onAddress,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: RwSpace.md, vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        t == null ? Icons.search : (insecure ? Icons.lock_open : Icons.lock),
                        size: 16,
                        color: insecure && warnInsecure ? RwColors.warning : RwColors.textSecondary,
                      ),
                      const SizedBox(width: RwSpace.xs),
                      Expanded(
                        child: Text(
                          t == null
                              ? 'Search or enter address'
                              : (insecure && warnInsecure ? 'Not secure · ${t.url.host}' : t.url.host),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: RwType.body.copyWith(color: t == null ? RwColors.textTertiary : RwColors.textPrimary),
                        ),
                      ),
                      if (t != null && t.blockedCount > 0)
                        Tooltip(
                          message: '${t.blockedCount} blocked',
                          child: Row(
                            children: [
                              const Icon(Icons.shield, size: 14, color: RwColors.accent),
                              Text(' ${t.blockedCount}', style: RwType.caption.copyWith(color: RwColors.accent)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onTabs,
            tooltip: 'Tabs',
            icon: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: RwColors.textPrimary, width: 1.6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('$tabCount', style: RwType.label.copyWith(fontSize: 11)),
            ),
          ),
          PopupMenuButton<_MenuAction>(
            color: RwColors.surface,
            icon: const Icon(Icons.more_vert),
            onSelected: onMenu,
            itemBuilder: (_) => [
              if (t != null) ...[
                PopupMenuItem(value: _MenuAction.forward, enabled: t.canGoForward, child: const Text('Forward')),
                const PopupMenuItem(value: _MenuAction.reload, child: Text('Reload')),
                PopupMenuItem(
                  value: _MenuAction.bookmark,
                  child: Text(bookmarked ? 'Remove bookmark' : 'Bookmark page'),
                ),
              ],
              const PopupMenuItem(value: _MenuAction.newTab, child: Text('New tab')),
              if (t != null) ...[
                const PopupMenuItem(value: _MenuAction.closeTab, child: Text('Close tab')),
                const PopupMenuItem(value: _MenuAction.allowSite, child: Text('Allow pop-ups on this site')),
              ],
              const PopupMenuItem(value: _MenuAction.protection, child: Text('Pop-up protection')),
            ],
          ),
        ],
      ),
    );
  }
}

class _StartPage extends StatelessWidget {
  const _StartPage({required this.onSubmit, required this.onOpen, required this.tabCount, required this.onTabs});
  final void Function(String) onSubmit;
  final void Function(Uri) onOpen;
  final int tabCount;
  final VoidCallback onTabs;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return ListView(
      padding: const EdgeInsets.only(bottom: RwSpace.xxl),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(RwSpace.gutter, RwSpace.lg, RwSpace.gutter, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Browse', style: RwType.headline)),
                  if (tabCount > 0)
                    TextButton.icon(onPressed: onTabs, icon: const Icon(Icons.tab), label: Text('$tabCount tabs')),
                ],
              ),
              const SizedBox(height: RwSpace.xxs),
              Text(
                'Pop-up protection is ${app.settings.protectionLevel == ProtectionLevel.off ? 'off' : 'on'}.',
                style: RwType.caption,
              ),
              const SizedBox(height: RwSpace.md),
              TextField(
                keyboardType: TextInputType.url,
                autocorrect: false,
                textInputAction: TextInputAction.go,
                onSubmitted: onSubmit,
                decoration: const InputDecoration(hintText: 'Search or enter address', prefixIcon: Icon(Icons.search)),
              ),
            ],
          ),
        ),
        SectionHeader('Your websites', action: 'Add', onAction: () => showAddWebsiteSheet(context)),
        if (app.websites.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: RwSpace.gutter),
            child: Text('Saved websites appear here for one-tap access.', style: RwType.caption),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: RwSpace.gutter),
            child: Wrap(
              spacing: RwSpace.md,
              runSpacing: RwSpace.md,
              children: [
                for (final w in app.websites)
                  InkWell(
                    onTap: () => onOpen(Uri.parse(w.url)),
                    borderRadius: BorderRadius.circular(RwRadius.lg),
                    child: SizedBox(
                      width: 68,
                      child: Column(
                        children: [
                          SiteAvatar(name: w.name, favicon: w.favicon, size: 56),
                          const SizedBox(height: RwSpace.xs),
                          Text(w.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: RwType.caption),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (app.bookmarks.isNotEmpty) ...[
          const SectionHeader('Bookmarks'),
          for (final b in app.bookmarks)
            ListTile(
              leading: const Icon(Icons.bookmark_outline),
              title: Text(b.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(Uri.tryParse(b.url)?.host ?? b.url),
              trailing: IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => app.removeBookmark(b.id)),
              onTap: () => onOpen(Uri.parse(b.url)),
            ),
        ],
        if (app.visited.isNotEmpty) ...[
          SectionHeader(
            'Recent',
            action: 'History',
            onAction: () => context.read<ShellController>().go(AppTab.history),
          ),
          for (final v in app.visited.take(5))
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(v.title.isEmpty ? v.url : v.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(Uri.tryParse(v.url)?.host ?? ''),
              onTap: () => onOpen(Uri.parse(v.url)),
            ),
        ],
      ],
    );
  }
}

class _AddressSheet extends StatefulWidget {
  const _AddressSheet({required this.initial});
  final String initial;

  @override
  State<_AddressSheet> createState() => _AddressSheetState();
}

class _AddressSheetState extends State<_AddressSheet> {
  late final _c = TextEditingController(text: widget.initial)
    ..selection = TextSelection(baseOffset: 0, extentOffset: widget.initial.length);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      RwSpace.gutter,
      0,
      RwSpace.gutter,
      MediaQuery.viewInsetsOf(context).bottom + RwSpace.lg,
    ),
    child: TextField(
      controller: _c,
      autofocus: true,
      keyboardType: TextInputType.url,
      autocorrect: false,
      textInputAction: TextInputAction.go,
      onSubmitted: (t) => Navigator.pop(context, t),
      decoration: const InputDecoration(hintText: 'Search or enter address', prefixIcon: Icon(Icons.search)),
    ),
  );
}

class _TabsSheet extends StatelessWidget {
  const _TabsSheet({required this.tabs, required this.onNewTab});
  final TabManager tabs;
  final VoidCallback onNewTab;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: tabs,
    builder: (context, _) => SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RwSpace.gutter),
              child: Row(
                children: [
                  Expanded(child: Text('Tabs (${tabs.tabs.length}/${tabs.maxTabs})', style: RwType.title)),
                  if (tabs.tabs.isNotEmpty) TextButton(onPressed: tabs.closeAll, child: const Text('Close all')),
                  IconButton(onPressed: tabs.isFull ? null : onNewTab, icon: const Icon(Icons.add)),
                ],
              ),
            ),
            Flexible(
              child: tabs.tabs.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(RwSpace.lg),
                      child: Text('No open tabs', style: RwType.caption),
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: [
                        for (final t in tabs.tabs)
                          ListTile(
                            selected: t.id == tabs.active?.id,
                            selectedTileColor: RwColors.accentSoft,
                            leading: SiteAvatar(name: t.url.host, size: 36),
                            title: Text(t.displayTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: Text(t.url.host, maxLines: 1),
                            trailing: IconButton(icon: const Icon(Icons.close), onPressed: () => tabs.close(t.id)),
                            onTap: () {
                              tabs.activate(t.id);
                              Navigator.pop(context);
                            },
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}
