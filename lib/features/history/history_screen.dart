import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
import '../../core/widgets/components.dart';
import '../../data/models/models.dart';
import '../../data/repositories/app_state.dart';
import '../content/content_detail_screen.dart';
import '../player/player_screen.dart';
import '../shell/shell.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Future<void> _confirmClear(BuildContext context) async {
    final app = context.read<AppState>();
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.public_off),
              title: const Text('Clear browsing history'),
              onTap: () => Navigator.pop(ctx, 'browse'),
            ),
            ListTile(
              leading: const Icon(Icons.video_library_outlined),
              title: const Text('Clear watch history'),
              onTap: () => Navigator.pop(ctx, 'watch'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep, color: RwColors.danger),
              title: const Text('Clear both', style: TextStyle(color: RwColors.danger)),
              onTap: () => Navigator.pop(ctx, 'both'),
            ),
          ],
        ),
      ),
    );
    if (choice == 'browse' || choice == 'both') app.clearBrowsingHistory();
    if (choice == 'watch' || choice == 'both') app.clearWatchHistory();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final watch = app.watchHistory;
    final pages = app.visited;

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(RwSpace.gutter, RwSpace.md, RwSpace.xs, 0),
              child: Row(
                children: [
                  Expanded(child: Text('History', style: RwType.headline)),
                  if (watch.isNotEmpty || pages.isNotEmpty)
                    TextButton(onPressed: () => _confirmClear(context), child: const Text('Clear')),
                ],
              ),
            ),
          ),
          if (watch.isEmpty && pages.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                icon: Icons.history,
                title: 'No history yet',
                message: 'Pages you visit and videos you watch will show up here.',
              ),
            ),
          if (watch.isNotEmpty) ...[
            const SliverToBoxAdapter(child: SectionHeader('Watched')),
            SliverList.builder(
              itemCount: watch.length,
              itemBuilder: (context, i) {
                final h = watch[i];
                final c = app.contentById(h.contentId);
                if (c == null) return const SizedBox.shrink();
                return Dismissible(
                  key: ValueKey(h.id),
                  direction: DismissDirection.endToStart,
                  background: const _DeleteBg(),
                  onDismissed: (_) => app.removeWatch(h.id),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: RwSpace.gutter, vertical: 4),
                    leading: SizedBox(
                      width: 48,
                      height: 72,
                      child: PosterArt(content: c, showTitle: false, radius: RwRadius.sm),
                    ),
                    title: Text(c.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          [
                            if (h.episodeId != null) 'Episode ${h.episodeId!.split('-e').last}',
                            h.isFinished ? 'Finished' : '${formatDuration(h.duration - h.playbackPosition)} left',
                            timeAgo(h.lastWatched),
                          ].join(' · '),
                        ),
                        const SizedBox(height: 6),
                        RwProgressBar(value: h.progress),
                      ],
                    ),
                    trailing: IconButton(
                      tooltip: h.isFinished ? 'Watch again' : 'Resume',
                      icon: Icon(h.isFinished ? Icons.replay : Icons.play_circle_fill, color: RwColors.accent),
                      onPressed: () => _resume(context, c, h.sourceUrl),
                    ),
                    onTap: () => ContentDetailScreen.open(context, c),
                  ),
                );
              },
            ),
          ],
          if (pages.isNotEmpty) ...[
            const SliverToBoxAdapter(child: SectionHeader('Visited pages')),
            SliverList.builder(
              itemCount: pages.length,
              itemBuilder: (context, i) {
                final p = pages[i];
                final uri = Uri.tryParse(p.url);
                return Dismissible(
                  key: ValueKey(p.url),
                  direction: DismissDirection.endToStart,
                  background: const _DeleteBg(),
                  onDismissed: (_) => app.removeVisited(p.url),
                  child: ListTile(
                    leading: SiteAvatar(name: uri?.host ?? '?', size: 36),
                    title: Text(
                      p.title.isEmpty ? (uri?.host ?? p.url) : p.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('${uri?.host ?? ''} · ${timeAgo(p.visitedAt)}', maxLines: 1),
                    onTap: () => uri == null ? null : context.read<ShellController>().openSource(uri),
                  ),
                );
              },
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: RwSpace.xxl)),
        ],
      ),
    );
  }
}

class _DeleteBg extends StatelessWidget {
  const _DeleteBg();

  @override
  Widget build(BuildContext context) => Container(
    color: RwColors.danger,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: RwSpace.lg),
    child: const Icon(Icons.delete_outline, color: Colors.white),
  );
}

/// Plays in Reelway's player when the title comes from an added link;
/// otherwise opens the page it was watched on.
void _resume(BuildContext context, Content c, String sourceUrl) {
  if (context.read<AppState>().episodesFor(c.id).any((e) => e.isPlayable)) {
    PlayerScreen.resume(context, c);
  } else {
    context.read<ShellController>().openSource(Uri.parse(sourceUrl));
  }
}
