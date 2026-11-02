import 'package:flutter/material.dart';

import '../../ads/ads.dart';
import '../../data/remote_config.dart';
import '../../downloads/download_manager.dart';
import '../player/player_screen.dart';

import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
import '../../core/widgets/components.dart';
import '../../data/models/models.dart';
import '../../data/repositories/app_state.dart';
import '../content/content_detail_screen.dart';
import 'add_link_sheet.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static const _tabs = ['Movies', 'TV Series', 'Recently Added', 'Favorites', 'Continue Watching'];

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final tabs = [..._tabs, if (RemoteConfig.instance.flag('features.downloads')) 'Downloads'];
    final lists = <List<Content>>[
      app.movies,
      app.series,
      app.recentlyAdded,
      app.favoriteContent,
      app.continueWatching.map((h) => app.contentById(h.contentId)).whereType<Content>().toList(),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(RwSpace.gutter, RwSpace.md, RwSpace.gutter, 0),
              child: Row(
                children: [
                  Expanded(child: Text('Library', style: RwType.headline)),
                  IconButton(
                    icon: const Icon(Icons.add_link),
                    tooltip: 'Add a link',
                    onPressed: () => AddLinkSheet.show(context),
                  ),
                ],
              ),
            ),
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerColor: Colors.transparent,
              indicatorColor: RwColors.accent,
              labelColor: RwColors.textPrimary,
              unselectedLabelColor: RwColors.textSecondary,
              labelStyle: RwType.subtitle,
              padding: const EdgeInsets.symmetric(horizontal: RwSpace.xs),
              tabs: [for (final t in tabs) Tab(text: t)],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  for (var i = 0; i < _tabs.length; i++) _Grid(items: lists[i], emptyLabel: _tabs[i]),
                  if (tabs.length > _tabs.length) const _Downloads(),
                ],
              ),
            ),
            const BannerAdSlot(),
          ],
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.items, required this.emptyLabel});
  final List<Content> items;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    if (items.isEmpty) {
      return EmptyState(
        icon: Icons.movie_filter_outlined,
        title: 'Nothing in $emptyLabel yet',
        message: 'Tap the link button above to add a public series, episode, video or catalog link.',
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(RwSpace.gutter, RwSpace.md, RwSpace.gutter, RwSpace.xxl),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        mainAxisSpacing: RwSpace.md,
        crossAxisSpacing: RwSpace.sm,
        childAspectRatio: 0.5,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final c = items[i];
        return ContentCard(
          content: c,
          width: null,
          sourceName: app.websiteById(c.sourceWebsiteId)?.name,
          progress: app.historyFor(c.id)?.progress,
          onTap: () => ContentDetailScreen.open(context, c),
        );
      },
    );
  }
}

/// Episodes saved on the phone, by title. They play without internet.
class _Downloads extends StatelessWidget {
  const _Downloads();

  static void _play(BuildContext context, DownloadItem title) {
    final saved = DownloadManager.instance.episodesOf(title.contentId);
    final content = Content(
      id: title.contentId,
      title: title.title,
      poster: title.poster,
      category: saved.length > 1 ? ContentCategory.series : ContentCategory.movie,
      sourceWebsiteId: 'download',
      sourcePageUrl: title.source.toString(),
    );
    PlayerScreen.open(context, content, [
      for (final e in saved)
        Episode(
          id: '${title.contentId}-e${e.episode}',
          seriesId: title.contentId,
          seasonNumber: 1,
          episodeNumber: e.episode,
          sourcePageUrl: e.source.toString(),
          videoUrl: e.source.toString(),
        ),
    ]);
  }

  static String _size(int bytes) => bytes >= 1 << 30
      ? '${(bytes / (1 << 30)).toStringAsFixed(1)} GB'
      : '${(bytes / (1 << 20)).toStringAsFixed(0)} MB';

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: DownloadManager.instance,
    builder: (context, _) {
      final manager = DownloadManager.instance;
      final busy = manager.items.where((i) => i.status != DownloadStatus.done).toList();
      final titles = manager.titles;
      if (busy.isEmpty && titles.isEmpty) {
        return const EmptyState(
          icon: Icons.download_outlined,
          title: 'No downloads yet',
          message: 'Tap the download button in the player to watch an episode without internet.',
        );
      }
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: RwSpace.sm),
        children: [
          for (final item in busy)
            ListTile(
              leading: item.status == DownloadStatus.failed
                  ? const Icon(Icons.error_outline, color: RwColors.danger)
                  : SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        value: item.progress > 0 ? item.progress : null,
                      ),
                    ),
              title: Text('${item.title} · Episode ${item.episode}', maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                item.status == DownloadStatus.failed
                    ? (item.error ?? 'Download failed')
                    : '${(item.progress * 100).round()}% · ${_size(item.bytes)}',
              ),
              trailing: IconButton(
                tooltip: item.status == DownloadStatus.failed ? 'Try again' : 'Cancel',
                icon: Icon(item.status == DownloadStatus.failed ? Icons.refresh : Icons.close),
                onPressed: () => item.status == DownloadStatus.failed
                    ? manager.retry(item.contentId, item.episode)
                    : manager.delete(item.contentId, item.episode),
              ),
            ),
          for (final title in titles)
            Builder(
              builder: (context) {
                final saved = manager.episodesOf(title.contentId);
                final bytes = saved.fold<int>(0, (sum, e) => sum + e.bytes);
                return ListTile(
                  leading: const Icon(Icons.offline_pin, color: RwColors.accent),
                  title: Text(title.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${saved.length} episode${saved.length == 1 ? '' : 's'} · ${_size(bytes)}'),
                  onTap: () => _play(context, title),
                  trailing: IconButton(
                    tooltip: 'Delete download',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete ${title.title}?'),
                          content: const Text('The downloaded episodes are removed from this phone.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                          ],
                        ),
                      );
                      if (ok != true) return;
                      for (final e in saved) {
                        await manager.delete(e.contentId, e.episode);
                      }
                    },
                  ),
                );
              },
            ),
        ],
      );
    },
  );
}
