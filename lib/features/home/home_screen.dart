import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ads/ads.dart';
import '../../browser/browser_view.dart';
import '../../data/remote_config.dart';
import '../../browser/media_capture.dart';
import '../../browser/site_profiles.dart';
import '../../browser/popup_protection.dart';
import '../../browser/tab_manager.dart';
import '../../core/design/tokens.dart';
import '../../core/security/url_policy.dart';
import '../../core/widgets/components.dart';
import '../../data/models/models.dart';
import '../../data/repositories/app_state.dart';
import '../content/content_detail_screen.dart';
import '../library/add_link_sheet.dart';
import '../settings/protection_screen.dart';
import '../settings/websites_screen.dart';
import '../shell/shell.dart';
import '../../sources/page_source.dart';
import '../../sources/link_feed.dart';
import '../player/player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.browserBuilder});
  final Widget Function(BuildContext, BrowserTab)? browserBuilder;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _tabs = TabManager();
  final _commands = <String, BrowserCommands>{};
  final _detected = <String>{};

  /// The episode video each tab's page is playing, for "Play in Reelway".
  final _media = <String, CapturedMedia>{};

  /// Set when the player sent the user to another episode: the next video
  /// the page starts goes straight back to the player. [exclude] holds the
  /// videos that were already there, so the old episode is not picked again.
  ({String tabId, String contentId, int number, Set<String> exclude, DateTime at})? _handoff;

  /// What already moved into Reelway automatically (tab, page and video), so
  /// coming back to the website does not send the user away again.
  final _autoOpened = <String>{};
  Timer? _mediaTimer;
  bool _checkingMedia = false;
  bool _showStartPage = false;
  late final ShellController _shell;

  @override
  void initState() {
    super.initState();
    _shell = context.read<ShellController>()..addListener(_takePending);
    _tabs.addListener(_onTabs);
    WidgetsBinding.instance.addPostFrameCallback((_) => _takePending());
    _mediaTimer = Timer.periodic(const Duration(seconds: 2), (_) => _checkMedia());
  }

  @override
  void dispose() {
    _mediaTimer?.cancel();
    _shell.removeListener(_takePending);
    _tabs.dispose();
    super.dispose();
  }

  /// Asks the visible tab which videos its page loaded. Only while Home is on
  /// screen; nothing runs for hidden tabs.
  Future<void> _checkMedia() async {
    if (!mounted || _checkingMedia || _shell.tab != AppTab.home || _showStartPage) return;
    final tab = _tabs.active;
    final commands = tab == null ? null : _commands[tab.id];
    if (tab == null || commands == null) return;
    _checkingMedia = true;
    try {
      final media = await commands.media();
      final found = MediaCapture.pick(media, tab.url);
      if (!mounted || _tabs.active?.id != tab.id) return;
      if (found?.url != _media[tab.id]?.url) {
        setState(() {
          if (found == null) {
            _media.remove(tab.id);
          } else {
            _media[tab.id] = found;
          }
        });
      }
      final handoff = _handoff;
      if (handoff != null && DateTime.now().difference(handoff.at) > const Duration(minutes: 3)) _handoff = null;
      final next = handoff == null ? null : MediaCapture.pick(media, tab.url, exclude: handoff.exclude);
      // Waiting for the next episode: start the page's video (muted) so the
      // user does not have to tap play on the website.
      if (handoff != null && handoff.tabId == tab.id && next == null && !tab.isLoading) {
        await commands.autoplayMuted();
        if (!mounted) return;
      }
      if (next != null && handoff != null && handoff.tabId == tab.id && _handoff != null) {
        _handoff = null;
        _autoOpened.add('${tab.id}|${next.url}');
        await _playInReelway(tab, next, contentId: handoff.contentId, number: handoff.number);
      } else if (found != null &&
          _handoff == null &&
          (context.read<AppState>().settings.openVideosInReelway &&
              RemoteConfig.instance.flag('features.openVideosInReelway')) &&
          SiteProfiles.forUrl(tab.url).autoOpen &&
          _autoOpened.add('${tab.id}|${found.url}')) {
        await _playInReelway(tab, found);
      }
    } finally {
      _checkingMedia = false;
    }
  }

  /// Moves the video the page is playing into Reelway's player, with the
  /// episode list the page shows.
  Future<void> _playInReelway(BrowserTab tab, CapturedMedia media, {String? contentId, int? number}) async {
    _autoOpened.add('${tab.id}|${media.url}');
    final commands = _commands[tab.id];
    final body = await commands?.html();
    if (!mounted || commands == null || body == null) return;
    final scanned = await commands.episodes(tab.url);
    await commands.pauseMedia();
    if (!mounted) return;
    final app = context.read<AppState>();
    final page = MediaCapture.describe(
      tab.url,
      body,
      scanned: scanned,
      current: number,
      profile: SiteProfiles.forUrl(tab.url),
    );
    final content = app.showWebTitle(page, media.url, contentId: contentId, referer: media.referer);
    final episodes = app.episodesFor(content.id);
    final index = episodes.indexWhere((e) => e.episodeNumber == page.current);
    await PlayerScreen.open(
      context,
      content,
      episodes,
      index: index < 0 ? 0 : index,
      onOpenPage: (episode) => _openEpisodePage(tab.id, content.id, episode),
      onWatchOnWebsite: () => _commands[tab.id]?.resumeMedia(),
    );
  }

  Future<void> _openEpisodePage(String tabId, String contentId, Episode episode) async {
    if (!mounted || !_tabs.tabs.any((t) => t.id == tabId)) return;
    _tabs.activate(tabId);
    final commands = _commands[tabId];
    final page = Uri.parse(episode.sourcePageUrl);
    final pressed = MediaCapture.pressedEpisode(page);
    // Videos already on the page belong to the episode the user just left.
    final before = {for (final m in await commands?.media() ?? []) m.url.toString()};
    if (!mounted) return;
    _handoff = (tabId: tabId, contentId: contentId, number: episode.episodeNumber, exclude: before, at: DateTime.now());
    if (pressed == null) {
      _open(page);
    } else if (await commands?.pressEpisode(pressed) != true) {
      _handoff = null;
      if (mounted) _snack('Episode ${episode.episodeNumber} is no longer on this page. Choose it on the website.');
      return;
    }
    if (mounted) {
      _snack('Opening episode ${episode.episodeNumber}. When its video starts, it moves to Reelway\'s player.');
    }
  }

  void _onTabs() {
    _commands.removeWhere((id, _) => !_tabs.tabs.any((t) => t.id == id));
    if (mounted) setState(() {});
  }

  void _takePending() {
    final url = _shell.takePendingBrowserUrl();
    if (url != null) _open(url);
  }

  /// Opens [url] in the current tab, or a new tab if none is open.
  void _open(Uri url, {bool newTab = false}) {
    setState(() => _showStartPage = false);
    final active = _tabs.active;
    if (active == null || newTab) {
      if (_tabs.open(url) == null) _snack('Tab limit reached. Close a tab first.');
    } else {
      _tabs.update(active.id, (tab) {
        tab.url = url;
        tab.title = '';
      });
      _commands[active.id]?.load(url);
    }
  }

  Future<void> _detectSource(Uri url, String title) async {
    final app = context.read<AppState>();
    app.markVisited(url, title);
    final active = _tabs.active;
    if (active == null || active.url != url) return;
    final body = await _commands[active.id]?.html();
    if (!mounted || body == null || _tabs.active?.url != url) return;
    final page = app.inspectBrowserPage(url, body);
    if (page == null) return;
    setState(() => _detected.add(url.toString()));
    // Only one series with its episodes moves to Reelway by itself, once per
    // page. A page listing many series stays in the browser so the user can
    // pick one; the button still offers the whole list.
    if ((app.settings.openVideosInReelway && RemoteConfig.instance.flag('features.openVideosInReelway')) &&
        SiteProfiles.forUrl(url).autoOpen &&
        PageSource.isSingleSeries(page) &&
        !LinkFeed.isVideo(url) &&
        _autoOpened.add('${active.id}|$url')) {
      unawaited(_openSeries(url));
    }
  }

  /// A tapped Narto series opens in Reelway's series screen without loading
  /// the website page; the browser stays on the list the user came from.
  bool _interceptSeries(Uri target) {
    final app = context.read<AppState>();
    if (target == _showOnWebsite) {
      _showOnWebsite = null;
      return false;
    }
    final enabled = app.settings.openVideosInReelway && RemoteConfig.instance.flag('features.openVideosInReelway');
    if (!enabled || !SiteProfiles.isSeriesPage(target) || !SiteProfiles.forUrl(target).autoOpen) return false;
    unawaited(_openSeries(target));
    return true;
  }

  bool _openingSeries = false;

  /// A series Reelway could not read: let the browser open it once.
  Uri? _showOnWebsite;

  /// Shows [url]'s series in Reelway's series screen (poster, Watch, episodes).
  /// The title is kept in the Library so Continue Watching survives restarts.
  /// When Reelway cannot read it, the page opens in the browser instead.
  Future<void> _openSeries(Uri url) async {
    if (_openingSeries) return;
    _openingSeries = true;
    try {
      final app = context.read<AppState>();
      if (!app.linksDisclaimerAccepted) {
        final accepted = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Links you add'),
            content: const Text(AddLinkSheet.disclaimer),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('I understand')),
            ],
          ),
        );
        if (!mounted || accepted != true) return;
        app.acceptLinksDisclaimer();
      }
      final key = url.toString();
      String? error;
      if (!app.links.contains(key)) {
        unawaited(
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          ),
        );
        error = await app.addLink(key);
        if (mounted) Navigator.of(context).pop();
      }
      if (!mounted) return;
      final title = app.content.where((c) => c.sourcePageUrl == key).firstOrNull;
      if (error != null || title == null) {
        // Not readable here (or the site wants a check): show the website.
        if (_tabs.active?.url.toString() != key) {
          _showOnWebsite = url;
          _open(url);
        }
        return;
      }
      await ContentDetailScreen.open(context, title);
    } finally {
      _openingSeries = false;
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
    setState(() => _showStartPage = false);
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
    final active = _showStartPage ? null : _tabs.active;

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
                  case _MenuAction.startPage:
                    setState(() => _showStartPage = true);
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
          if (active != null && _media[active.id] != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(RwSpace.gutter, 0, RwSpace.gutter, RwSpace.xs),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _playInReelway(active, _media[active.id]!),
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text('Play in Reelway'),
                ),
              ),
            )
          else if (active != null &&
              (PageSource.isNarto(active.url) ||
                  LinkFeed.isVideo(active.url) ||
                  _detected.contains(active.url.toString())))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RwSpace.gutter),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => _shell.openSource(active.url),
                  icon: const Icon(Icons.video_library_outlined),
                  label: Text(LinkFeed.isVideo(active.url) ? 'Play in Reelway' : 'Browse series in Reelway'),
                ),
              ),
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
            child: IndexedStack(
              index: active == null ? 0 : _tabs.activeIndex + 1,
              children: [
                _StartPage(onSubmit: _submitAddress, onOpen: _open, tabCount: _tabs.tabs.length, onTabs: _showTabs),
                for (final t in _tabs.tabs)
                  widget.browserBuilder?.call(context, t) ??
                      BrowserView(
                        key: ValueKey(t.id),
                        tab: t,
                        tabs: _tabs,
                        protection: app.popupProtection,
                        partners: app.partners,
                        settings: app.settings,
                        commands: _commands.putIfAbsent(t.id, BrowserCommands.new),
                        onBlocked: _onBlocked,
                        onPageLoaded: _detectSource,
                        onOpenSeries: _interceptSeries,
                      ),
              ],
            ),
          ),
          // Banner only on Reelway's own start page, never over a website.
          if (active == null) const BannerAdSlot(),
        ],
      ),
    );
  }
}

enum _MenuAction { startPage, forward, reload, bookmark, newTab, closeTab, allowSite, protection }

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
              const PopupMenuItem(value: _MenuAction.startPage, child: Text('Start page')),
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

/// The start page: a search bar, a grid of video sites and shortcuts, like
/// any browser. Continue watching and recent pages fold out below.
class _StartPage extends StatefulWidget {
  const _StartPage({required this.onSubmit, required this.onOpen, required this.tabCount, required this.onTabs});
  final void Function(String) onSubmit;
  final void Function(Uri) onOpen;
  final int tabCount;
  final VoidCallback onTabs;

  @override
  State<_StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<_StartPage> {
  bool _more = false;

  /// Shown on every start page; the server and the user add more.
  static const _defaults = [
    ('YouTube', 'https://m.youtube.com/'),
    ('Twitch', 'https://m.twitch.tv/'),
    ('TikTok', 'https://www.tiktok.com/'),
    ('Rumble', 'https://rumble.com/'),
    ('Dailymotion', 'https://www.dailymotion.com/'),
  ];

  static String _icon(Uri url) => 'https://www.google.com/s2/favicons?domain=${url.host}&sz=128';

  /// Default sites, then the server's "Show on start page" sites, then the
  /// user's own saved websites, without repeats.
  List<(String, Uri, String?)> _sites(AppState app) {
    final out = <(String, Uri, String?)>[];
    final seen = <String>{};
    void add(String name, Uri? url, [String? icon]) {
      if (url == null || url.scheme != 'https') return;
      final key = PopupProtection.registrableDomain(url.host);
      if (seen.add(key)) out.add((name, url, icon ?? _icon(url)));
    }

    for (final (name, url) in _defaults) {
      add(name, Uri.parse(url));
    }
    final server = RemoteConfig.instance.value('sites');
    if (server is Map) {
      for (final entry in server.entries) {
        final site = entry.value;
        if (site is! Map || site['featured'] != true) continue;
        add('${site['name'] ?? entry.key}', Uri.tryParse('${site['url'] ?? 'https://${entry.key}/'}'));
      }
    }
    for (final w in app.websites) {
      add(w.name, Uri.tryParse(w.url), w.favicon);
    }
    return out;
  }

  void _showBookmarks(AppState app) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: app.bookmarks.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(RwSpace.lg),
                child: Text('No bookmarks yet. Use the menu on any page to bookmark it.', style: RwType.caption),
              )
            : ListView(
                shrinkWrap: true,
                children: [
                  for (final b in app.bookmarks)
                    ListTile(
                      leading: const Icon(Icons.bookmark_outline),
                      title: Text(b.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(Uri.tryParse(b.url)?.host ?? b.url),
                      onTap: () {
                        Navigator.pop(context);
                        widget.onOpen(Uri.parse(b.url));
                      },
                    ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final shell = context.read<ShellController>();
    return ListenableBuilder(
      listenable: RemoteConfig.instance,
      builder: (context, _) {
        final sites = _sites(app);
        return ListView(
          padding: const EdgeInsets.fromLTRB(RwSpace.gutter, 56, RwSpace.gutter, RwSpace.xxl),
          children: [
            _SearchBar(onSubmit: widget.onSubmit, tabCount: widget.tabCount, onTabs: widget.onTabs),
            const SizedBox(height: 48),
            _TileGrid(
              tiles: [
                for (final (name, url, icon) in sites)
                  _Tile(
                    label: name,
                    icon: SiteAvatar(name: name, favicon: icon, size: 60),
                    onTap: () => widget.onOpen(url),
                  ),
                _Tile(label: 'Add', icon: const _GlyphIcon(Icons.add), onTap: () => showAddWebsiteSheet(context)),
              ],
            ),
            const SizedBox(height: 32),
            _TileGrid(
              tiles: [
                _Tile(
                  label: 'Bookmarks',
                  icon: const _GlyphIcon(Icons.menu_book_rounded),
                  onTap: () => _showBookmarks(app),
                ),
                _Tile(
                  label: 'History',
                  icon: const _GlyphIcon(Icons.history_rounded),
                  onTap: () => shell.go(AppTab.history),
                ),
                _Tile(
                  label: 'Library',
                  icon: const _GlyphIcon(Icons.folder_rounded),
                  onTap: () => shell.go(AppTab.library),
                ),
                _Tile(
                  label: 'Settings',
                  icon: const _GlyphIcon(Icons.settings_rounded),
                  onTap: () => shell.go(AppTab.settings),
                ),
              ],
            ),
            const SizedBox(height: RwSpace.md),
            Center(
              child: IconButton(
                tooltip: _more ? 'Show less' : 'Show more',
                onPressed: () => setState(() => _more = !_more),
                icon: Icon(_more ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded),
                color: RwColors.textSecondary,
              ),
            ),
            if (_more) ..._extras(app),
          ],
        );
      },
    );
  }

  List<Widget> _extras(AppState app) => [
    if (app.continueWatching.isNotEmpty) ...[
      const SectionHeader('Continue watching'),
      SizedBox(
        height: 96,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemCount: app.continueWatching.length.clamp(0, 6),
          itemBuilder: (context, index) {
            final history = app.continueWatching[index];
            final title = app.contentById(history.contentId);
            if (title == null) return const SizedBox.shrink();
            return SizedBox(
              width: 220,
              child: Material(
                color: RwColors.card,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => PlayerScreen.resume(context, title),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: RwType.subtitle),
                        const SizedBox(height: 6),
                        Text('Continue episode', style: RwType.caption),
                        const Spacer(),
                        RwProgressBar(value: history.progress, height: 3),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
    if (app.visited.isNotEmpty) ...[
      SectionHeader('Recent', action: 'History', onAction: () => context.read<ShellController>().go(AppTab.history)),
      for (final v in app.visited.take(5))
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.history),
          title: Text(v.title.isEmpty ? v.url : v.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(Uri.tryParse(v.url)?.host ?? ''),
          onTap: () => widget.onOpen(Uri.parse(v.url)),
        ),
    ],
    Padding(
      padding: const EdgeInsets.only(top: RwSpace.md),
      child: Text(
        'Pop-up protection is ${app.settings.protectionLevel == ProtectionLevel.off ? 'off' : 'on'}.',
        style: RwType.caption,
        textAlign: TextAlign.center,
      ),
    ),
  ];
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onSubmit, required this.tabCount, required this.onTabs});
  final void Function(String) onSubmit;
  final int tabCount;
  final VoidCallback onTabs;

  @override
  Widget build(BuildContext context) => Container(
    height: 56,
    padding: const EdgeInsets.only(left: 18, right: 6),
    decoration: BoxDecoration(
      color: RwColors.card,
      borderRadius: BorderRadius.circular(28),
      boxShadow: const [BoxShadow(color: Color(0x55000000), blurRadius: 18, offset: Offset(0, 8))],
    ),
    child: Row(
      children: [
        const Icon(Icons.search, color: RwColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.url,
            autocorrect: false,
            textInputAction: TextInputAction.go,
            onSubmitted: onSubmit,
            style: RwType.body,
            decoration: const InputDecoration(
              hintText: 'Search or enter website',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              isDense: true,
            ),
          ),
        ),
        if (tabCount > 0)
          IconButton(
            tooltip: 'Tabs',
            onPressed: onTabs,
            icon: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: RwColors.textSecondary, width: 1.6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('$tabCount', style: RwType.label.copyWith(fontSize: 11)),
            ),
          )
        else
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(color: RwColors.accent, shape: BoxShape.circle),
            child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
          ),
      ],
    ),
  );
}

class _Tile {
  const _Tile({required this.label, required this.icon, required this.onTap});
  final String label;
  final Widget icon;
  final VoidCallback onTap;
}

/// Four tiles per row, icon above its label.
class _TileGrid extends StatelessWidget {
  const _TileGrid({required this.tiles});
  final List<_Tile> tiles;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth / 4;
      return Wrap(
        runSpacing: 20,
        children: [
          for (final t in tiles)
            SizedBox(
              width: width,
              child: InkWell(
                onTap: t.onTap,
                borderRadius: BorderRadius.circular(RwRadius.lg),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      t.icon,
                      const SizedBox(height: 8),
                      Text(t.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: RwType.body),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    },
  );
}

class _GlyphIcon extends StatelessWidget {
  const _GlyphIcon(this.icon);
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      color: RwColors.card,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: RwColors.divider),
    ),
    child: Icon(icon, color: RwColors.textSecondary, size: 28),
  );
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
