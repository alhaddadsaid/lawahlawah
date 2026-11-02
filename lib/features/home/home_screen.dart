import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ads/ads.dart';
import '../../browser/browser_view.dart';
import '../../browser/media_capture.dart';
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
      if (next != null && handoff != null && handoff.tabId == tab.id && _handoff != null) {
        _handoff = null;
        _autoOpened.add('${tab.id}|${next.url}');
        await _playInReelway(tab, next, contentId: handoff.contentId, number: handoff.number);
      } else if (found != null &&
          _handoff == null &&
          context.read<AppState>().settings.openVideosInReelway &&
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
    final page = MediaCapture.describe(tab.url, body, scanned: scanned, current: number);
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
    final before = pressed == null ? <String>{} : {for (final m in await commands?.media() ?? []) m.url.toString()};
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
    if (app.settings.openVideosInReelway &&
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
    if (!app.settings.openVideosInReelway || !PageSource.isNartoSeries(target)) return false;
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
                  Expanded(child: Text('Reelway', style: RwType.headline)),
                  TextButton.icon(
                    onPressed: () => context.read<ShellController>().go(AppTab.browse),
                    icon: const Icon(Icons.video_library_outlined),
                    label: const Text('Series'),
                  ),
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
        Padding(
          padding: const EdgeInsets.fromLTRB(RwSpace.gutter, RwSpace.md, RwSpace.gutter, 0),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.play_circle_outline, size: 18),
                label: const Text('YouTube'),
                onPressed: () => onOpen(Uri.parse('https://m.youtube.com/')),
              ),
              ActionChip(
                avatar: const Icon(Icons.movie_outlined, size: 18),
                label: const Text('Narto-Drama'),
                onPressed: () => onOpen(Uri.parse('https://narto-drama.com/')),
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
        if (app.continueWatching.isNotEmpty) ...[
          const SectionHeader('Continue watching'),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: RwSpace.gutter),
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
