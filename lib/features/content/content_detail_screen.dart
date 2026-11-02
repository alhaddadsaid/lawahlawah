import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
import '../../core/widgets/components.dart';
import '../../data/models/models.dart';
import '../../data/repositories/app_state.dart';
import '../../data/sample/sample_data.dart';
import '../player/player_screen.dart';
import '../shell/shell.dart';

class ContentDetailScreen extends StatelessWidget {
  const ContentDetailScreen({super.key, required this.content});
  final Content content;

  static Future<void> open(BuildContext context, Content c) => Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: RwMotion.slow,
      reverseTransitionDuration: RwMotion.normal,
      pageBuilder: (_, _, _) => ContentDetailScreen(content: c),
      transitionsBuilder: (_, a, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: a, curve: RwMotion.curve),
        child: child,
      ),
    ),
  );

  /// Opens the title's page on its source website. This is always available
  /// and is the fallback whenever native playback is not possible/permitted.
  void _openSource(BuildContext context, String url) {
    Navigator.of(context).popUntil((r) => r.isFirst);
    context.read<ShellController>().openBrowser(Uri.parse(url));
  }

  /// Plays in Reelway's player when the title comes from an added link;
  /// otherwise opens its source page.
  void _watch(BuildContext context, List<Episode> playable, WatchHistory? history) {
    if (playable.isNotEmpty) {
      PlayerScreen.resume(context, content);
    } else {
      _openSource(context, history?.sourceUrl ?? content.sourcePageUrl);
    }
  }

  void _openEpisode(BuildContext context, Episode e, List<Episode> playable) {
    final i = playable.indexOf(e);
    if (i >= 0) {
      PlayerScreen.open(context, content, playable, index: i);
    } else {
      _openSource(context, e.sourcePageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final site = app.websiteById(content.sourceWebsiteId);
    final history = app.historyFor(content.id);
    final saved = app.isFavorite(content.id);
    var episodes = app.episodesFor(content.id);
    if (episodes.isEmpty && content.category == ContentCategory.series && content.isSample) {
      episodes = SampleData.episodesFor(content.id);
    }
    final playable = episodes.where((e) => e.isPlayable).toList();
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: width * 1.05,
            pinned: true,
            backgroundColor: RwColors.background,
            leading: const _CircleBack(),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PosterArt(content: content, showTitle: false, radius: 0),
                  const DecoratedBox(decoration: BoxDecoration(gradient: RwColors.scrim)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: RwSpace.gutter),
            sliver: SliverList.list(
              children: [
                Text(content.title, style: RwType.display),
                const SizedBox(height: RwSpace.xs),
                Wrap(
                  spacing: RwSpace.xs,
                  runSpacing: RwSpace.xs,
                  children: [
                    _Pill(content.category == ContentCategory.movie ? 'Movie' : 'Series'),
                    if (content.releaseYear != null) _Pill('${content.releaseYear}'),
                    for (final g in content.genres) _Pill(g),
                  ],
                ),
                const SizedBox(height: RwSpace.md),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _watch(context, playable, history),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: Text(history != null && !history.isFinished ? 'Resume' : 'Watch'),
                      ),
                    ),
                    const SizedBox(width: RwSpace.sm),
                    IconButton.outlined(
                      onPressed: () => app.toggleFavorite(content.id),
                      icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
                      tooltip: saved ? 'Remove from saved' : 'Save',
                    ),
                  ],
                ),
                if (history != null && !history.isFinished) ...[
                  const SizedBox(height: RwSpace.sm),
                  RwProgressBar(value: history.progress, height: 4),
                  const SizedBox(height: RwSpace.xxs),
                  Text('${formatDuration(history.duration - history.playbackPosition)} left', style: RwType.caption),
                ],
                const SizedBox(height: RwSpace.lg),
                if (content.description != null)
                  Text(content.description!, style: RwType.body.copyWith(color: RwColors.textSecondary)),
                const SizedBox(height: RwSpace.md),
                Row(
                  children: [
                    const Icon(Icons.public, size: 16, color: RwColors.textTertiary),
                    const SizedBox(width: RwSpace.xs),
                    Expanded(
                      child: Text(
                        'Source: ${site?.name ?? Uri.parse(content.sourcePageUrl).host}',
                        style: RwType.caption,
                      ),
                    ),
                  ],
                ),
                if (episodes.isNotEmpty) ...[
                  const SizedBox(height: RwSpace.lg),
                  Text('Season 1', style: RwType.title),
                  const SizedBox(height: RwSpace.sm),
                  for (final e in episodes)
                    _EpisodeTile(
                      episode: e,
                      current: history?.episodeId == e.id,
                      onTap: () => _openEpisode(context, e, playable),
                    ),
                ],
                const SizedBox(height: RwSpace.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleBack extends StatelessWidget {
  const _CircleBack();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8),
    child: CircleAvatar(
      backgroundColor: Colors.black45,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).maybePop(),
        tooltip: 'Back',
      ),
    ),
  );
}

class _Pill extends StatelessWidget {
  const _Pill(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: RwSpace.sm, vertical: 6),
    decoration: BoxDecoration(color: RwColors.card, borderRadius: BorderRadius.circular(RwRadius.pill)),
    child: Text(text, style: RwType.caption.copyWith(color: RwColors.textPrimary)),
  );
}

class _EpisodeTile extends StatelessWidget {
  const _EpisodeTile({required this.episode, required this.current, required this.onTap});
  final Episode episode;
  final bool current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: RwSpace.xs),
    child: Material(
      color: current ? RwColors.accentSoft : RwColors.surface,
      borderRadius: BorderRadius.circular(RwRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(RwRadius.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(RwSpace.sm),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: RwColors.card, borderRadius: BorderRadius.circular(RwRadius.sm)),
                child: Text('${episode.episodeNumber}', style: RwType.subtitle),
              ),
              const SizedBox(width: RwSpace.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(episode.title ?? 'Episode ${episode.episodeNumber}', style: RwType.subtitle),
                    Text(current ? '${episode.code} · Watching' : episode.code, style: RwType.caption),
                  ],
                ),
              ),
              Icon(
                current ? Icons.play_circle_fill : Icons.play_circle_outline,
                color: current ? RwColors.accent : RwColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
