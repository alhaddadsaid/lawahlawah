import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
import '../../core/widgets/components.dart';
import '../../data/models/models.dart';
import '../../data/repositories/app_state.dart';
import '../content/content_detail_screen.dart';
import '../search/search_screen.dart';
import '../settings/websites_screen.dart';
import '../shell/shell.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final hasAnything = app.websites.isNotEmpty || app.content.isNotEmpty;

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header(onSearch: () => SearchScreen.open(context))),
          if (!hasAnything)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                icon: Icons.travel_explore,
                title: 'Add your first website',
                message: 'Save a site you watch on and Reelway turns it into a clean, pop-up-free viewing space.',
                action: 'Add website',
                onAction: () => showAddWebsiteSheet(context),
              ),
            )
          else ...[
            if (app.content.isNotEmpty) SliverToBoxAdapter(child: _Hero(content: app.recentlyAdded.first)),
            if (app.continueWatching.isNotEmpty) ...[
              const SliverToBoxAdapter(child: SectionHeader('Continue watching')),
              SliverToBoxAdapter(child: _ContinueRow(items: app.continueWatching)),
            ],
            SliverToBoxAdapter(
              child: SectionHeader(
                'Your websites',
                action: 'Manage',
                onAction: () => Navigator.of(context).push(WebsitesScreen.route()),
              ),
            ),
            SliverToBoxAdapter(child: _WebsitesRow(sites: app.recentWebsites)),
            if (app.recentlyAdded.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: SectionHeader(
                  'Recently added',
                  action: 'See all',
                  onAction: () => context.read<ShellController>().go(AppTab.library),
                ),
              ),
              SliverToBoxAdapter(child: _PosterRow(items: app.recentlyAdded)),
            ],
            if (app.favoriteContent.isNotEmpty) ...[
              const SliverToBoxAdapter(child: SectionHeader('Saved')),
              SliverToBoxAdapter(child: _PosterRow(items: app.favoriteContent)),
            ],
            if (app.watchHistory.isNotEmpty) ...[
              const SliverToBoxAdapter(child: SectionHeader('Recently watched')),
              SliverToBoxAdapter(
                child: _PosterRow(
                  items: app.watchHistory.map((h) => app.contentById(h.contentId)).whereType<Content>().toList(),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: RwSpace.xxl)),
          ],
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onSearch});
  final VoidCallback onSearch;

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(RwSpace.gutter, RwSpace.md, RwSpace.xs, RwSpace.xs),
    child: Row(
      children: [
        const _Logo(),
        const SizedBox(width: RwSpace.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_greeting, style: RwType.caption),
              Text('What are we watching?', style: RwType.title),
            ],
          ),
        ),
        IconButton(onPressed: onSearch, icon: const Icon(Icons.search), tooltip: 'Search'),
      ],
    ),
  );
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(RwRadius.md),
      gradient: const LinearGradient(colors: [RwColors.accent, Color(0xFFB8361A)]),
    ),
    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
  );
}

class _Hero extends StatelessWidget {
  const _Hero({required this.content});
  final Content content;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final saved = app.isFavorite(content.id);
    return Padding(
      padding: const EdgeInsets.fromLTRB(RwSpace.gutter, RwSpace.md, RwSpace.gutter, 0),
      child: GestureDetector(
        onTap: () => ContentDetailScreen.open(context, content),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PosterArt(content: content, showTitle: false, radius: RwRadius.xl),
              ClipRRect(
                borderRadius: BorderRadius.circular(RwRadius.xl),
                child: const DecoratedBox(decoration: BoxDecoration(gradient: RwColors.scrim)),
              ),
              Positioned(
                left: RwSpace.lg,
                right: RwSpace.lg,
                bottom: RwSpace.lg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NEW ON YOUR SITES', style: RwType.label.copyWith(color: RwColors.accent)),
                    const SizedBox(height: RwSpace.xxs),
                    Text(content.title, style: RwType.display.copyWith(fontSize: 28)),
                    const SizedBox(height: RwSpace.xxs),
                    Text(
                      [?content.releaseYear?.toString(), ...content.genres].join(' · '),
                      style: RwType.caption.copyWith(color: RwColors.textPrimary.withValues(alpha: 0.8)),
                    ),
                    const SizedBox(height: RwSpace.md),
                    Wrap(
                      spacing: RwSpace.sm,
                      runSpacing: RwSpace.xs,
                      children: [
                        FilledButton.icon(
                          onPressed: () => ContentDetailScreen.open(context, content),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Watch'),
                        ),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(backgroundColor: Colors.black26),
                          onPressed: () => app.toggleFavorite(content.id),
                          icon: Icon(saved ? Icons.check : Icons.add),
                          label: Text(saved ? 'Saved' : 'My list'),
                        ),
                      ],
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
}

class _ContinueRow extends StatelessWidget {
  const _ContinueRow({required this.items});
  final List<WatchHistory> items;

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    return Carousel(
      height: 184,
      itemCount: items.length,
      itemBuilder: (context, i) {
        final h = items[i];
        final c = app.contentById(h.contentId);
        if (c == null) return const SizedBox.shrink();
        final remaining = h.duration - h.playbackPosition;
        return SizedBox(
          width: 240,
          child: GestureDetector(
            onTap: () => ContentDetailScreen.open(context, c),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 124,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      PosterArt(content: c, showTitle: false),
                      const Center(
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.black45,
                          child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
                        ),
                      ),
                      Positioned(left: 10, right: 10, bottom: 10, child: RwProgressBar(value: h.progress)),
                    ],
                  ),
                ),
                const SizedBox(height: RwSpace.xs),
                Text(
                  c.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: RwType.subtitle.copyWith(fontSize: 13),
                ),
                Text(
                  '${h.episodeId != null ? 'Episode ${h.episodeId!.split('-e').last} · ' : ''}${formatDuration(remaining)} left',
                  style: RwType.caption,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PosterRow extends StatelessWidget {
  const _PosterRow({required this.items});
  final List<Content> items;

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    return Carousel(
      height: 236,
      itemCount: items.length,
      itemBuilder: (context, i) {
        final c = items[i];
        return ContentCard(
          content: c,
          progress: app.historyFor(c.id)?.progress,
          onTap: () => ContentDetailScreen.open(context, c),
        );
      },
    );
  }
}

class _WebsitesRow extends StatelessWidget {
  const _WebsitesRow({required this.sites});
  final List<Website> sites;

  @override
  Widget build(BuildContext context) {
    final shell = context.read<ShellController>();
    return Carousel(
      height: 92,
      itemCount: sites.length + 1,
      itemBuilder: (context, i) {
        if (i == sites.length) {
          return _SiteChip(
            label: 'Add',
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RwRadius.lg),
                border: Border.all(color: RwColors.divider, width: 1.5),
              ),
              child: const Icon(Icons.add, color: RwColors.textSecondary),
            ),
            onTap: () => showAddWebsiteSheet(context),
          );
        }
        final s = sites[i];
        return _SiteChip(
          label: s.name,
          child: SiteAvatar(name: s.name, favicon: s.favicon, size: 56),
          onTap: () => shell.openInBrowser(Uri.parse(s.url)),
        );
      },
    );
  }
}

class _SiteChip extends StatelessWidget {
  const _SiteChip({required this.label, required this.child, required this.onTap});
  final String label;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(RwRadius.lg),
    child: SizedBox(
      width: 64,
      child: Column(
        children: [
          child,
          const SizedBox(height: RwSpace.xs),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: RwType.caption),
        ],
      ),
    ),
  );
}
