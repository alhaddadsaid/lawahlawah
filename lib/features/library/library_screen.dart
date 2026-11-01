import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
import '../../core/widgets/components.dart';
import '../../data/models/models.dart';
import '../../data/repositories/app_state.dart';
import '../content/content_detail_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static const _tabs = ['Movies', 'TV Series', 'Recently Added', 'Favorites', 'Continue Watching'];

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final lists = <List<Content>>[
      app.movies,
      app.series,
      app.recentlyAdded,
      app.favoriteContent,
      app.continueWatching.map((h) => app.contentById(h.contentId)).whereType<Content>().toList(),
    ];

    return DefaultTabController(
      length: _tabs.length,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(RwSpace.gutter, RwSpace.md, RwSpace.gutter, 0),
              child: Row(children: [Text('Library', style: RwType.headline)]),
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
              tabs: [for (final t in _tabs) Tab(text: t)],
            ),
            Expanded(
              child: TabBarView(
                children: [for (var i = 0; i < _tabs.length; i++) _Grid(items: lists[i], emptyLabel: _tabs[i])],
              ),
            ),
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
        message: 'Titles appear here from websites whose integration is permitted, and from what you save.',
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
