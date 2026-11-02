import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
import '../../data/repositories/app_state.dart';
import '../../sources/link_feed.dart';
import '../../sources/page_source.dart';
import '../content/content_detail_screen.dart';
import '../shell/shell.dart';
import '../library/add_link_sheet.dart';

/// Native source explorer. Website HTML is parsed as data, never rendered.
class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final _address = TextEditingController();
  final _filter = TextEditingController();
  final _history = <SourcePage>[];
  late final ShellController _shell;
  SourcePage? _page;
  bool _busy = false;
  bool _saving = false;
  String? _error;
  int _request = 0;

  @override
  void initState() {
    super.initState();
    _shell = context.read<ShellController>()..addListener(_takePending);
    WidgetsBinding.instance.addPostFrameCallback((_) => _takePending());
  }

  @override
  void dispose() {
    _request++;
    _shell.removeListener(_takePending);
    _address.dispose();
    _filter.dispose();
    super.dispose();
  }

  void _takePending() {
    final url = _shell.takePendingUrl();
    if (url != null) _open(url.toString());
  }

  Future<void> _open(String input) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final request = ++_request;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final page = await context.read<AppState>().readSource(LinkFeed.check(input));
      if (!mounted || request != _request) return;
      setState(() {
        if (_page != null) _history.add(_page!);
        _page = page;
        _address.text = page.url.toString();
        _filter.clear();
      });
      context.read<AppState>().markVisited(page.url, page.title);
    } on FormatException catch (error) {
      if (mounted && request == _request) setState(() => _error = error.message);
    } catch (_) {
      if (mounted && request == _request) {
        setState(
          () => _error = 'Could not read this page. Check your connection and try a public series or episode URL.',
        );
      }
    } finally {
      if (mounted && request == _request) setState(() => _busy = false);
    }
  }

  Future<void> _watch() async {
    final page = _page;
    if (page == null || _saving) return;
    final app = context.read<AppState>();
    final key = page.url.toString();
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
    setState(() {
      _saving = true;
      _error = null;
    });
    final error = app.links.contains(key) ? null : await app.addLink(key);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _error = error;
    });
    if (error != null) return;
    final titles = app.content.where((c) => c.sourcePageUrl == key);
    if (titles.isNotEmpty) await ContentDetailScreen.open(context, titles.first);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final page = _page;
    final query = _filter.text.trim().toLowerCase();
    final titles = page?.titles.where((t) => t.title.toLowerCase().contains(query)).toList() ?? const <PageTitle>[];
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.all(RwSpace.gutter),
        children: [
          Row(
            children: [
              if (_history.isNotEmpty)
                IconButton(
                  tooltip: 'Back',
                  onPressed: _busy || _saving
                      ? null
                      : () => setState(() {
                          _page = _history.removeLast();
                          _address.text = _page!.url.toString();
                          _filter.clear();
                          _error = null;
                        }),
                  icon: const Icon(Icons.arrow_back),
                ),
              Expanded(child: Text('Browse', style: RwType.headline)),
              const Icon(Icons.play_circle_outline, color: RwColors.accent),
            ],
          ),
          const SizedBox(height: RwSpace.xs),
          Text('Explore public videos and watch in Reelway’s player.', style: RwType.caption),
          const SizedBox(height: RwSpace.md),
          TextField(
            controller: _address,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.go,
            autocorrect: false,
            onSubmitted: _busy || _saving ? null : _open,
            decoration: InputDecoration(
              hintText: 'Paste a series, episode or video URL',
              prefixIcon: const Icon(Icons.link),
              suffixIcon: IconButton(
                tooltip: 'Read source',
                onPressed: _busy || _saving ? null : () => _open(_address.text),
                icon: const Icon(Icons.arrow_forward),
              ),
            ),
          ),
          const SizedBox(height: RwSpace.md),
          if (_busy) ...[
            const LinearProgressIndicator(),
            const SizedBox(height: RwSpace.sm),
            Text('Finding titles and video links…', style: RwType.caption),
          ],
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: RwSpace.md),
              child: Text(_error!, style: RwType.body.copyWith(color: RwColors.danger)),
            ),
          if (page == null && !_busy) ...[
            Text('Start watching', style: RwType.title),
            const SizedBox(height: RwSpace.sm),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.public, color: RwColors.accent),
              title: const Text('Narto-Drama'),
              subtitle: const Text('Try El dragón indomable'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _open('https://narto-drama.com/detail/watch/el-dragon-indomable'),
            ),
            for (final site in app.websites)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.bookmark_outline),
                title: Text(site.name),
                subtitle: Text(site.host),
                onTap: () => _open(site.url),
              ),
            const SizedBox(height: RwSpace.lg),
            Text(
              'Paste a public video, catalog, or supported website page. Some sites do not expose playable video links.',
              style: RwType.caption,
            ),
          ],
          if (page != null && !_busy) ...[
            Text(page.title, style: RwType.title),
            const SizedBox(height: RwSpace.md),
            if (page.series.isNotEmpty) ...[
              for (final series in page.series)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.video_library_outlined, color: RwColors.accent),
                  title: Text(series.title),
                  subtitle: Text('${series.episodes.length} episodes found'),
                ),
              FilledButton.icon(
                onPressed: _saving ? null : _watch,
                icon: _saving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.play_arrow),
                label: Text(_saving ? 'Adding…' : 'Add to Library & watch'),
              ),
              const SizedBox(height: RwSpace.lg),
            ],
            if (page.series.isEmpty && page.titles.isEmpty)
              Text(
                'No public video links found. Try a series or episode page. Pages requiring sign-in, verification, or protected playback are unsupported.',
                style: RwType.body,
              ),
            if (page.series.isEmpty && page.titles.isNotEmpty) ...[
              TextField(
                controller: _filter,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Filter titles on this page',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: RwSpace.sm),
              Text('${titles.length} titles', style: RwType.caption),
              for (final title in titles)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SizedBox(
                    width: 44,
                    height: 64,
                    child: title.poster == null
                        ? const Icon(Icons.movie_outlined)
                        : Image.network(
                            title.poster.toString(),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(Icons.movie_outlined),
                          ),
                  ),
                  title: Text(title.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _saving ? null : () => _open(title.url.toString()),
                ),
              if (titles.isEmpty) Text('No titles match your filter.', style: RwType.caption),
            ],
          ],
        ],
      ),
    );
  }
}
