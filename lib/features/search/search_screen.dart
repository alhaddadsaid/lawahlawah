import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
import '../../sources/link_feed.dart';
import '../../core/widgets/components.dart';
import '../../data/repositories/app_state.dart';
import '../content/content_detail_screen.dart';
import '../shell/shell.dart';

/// Searches the local library and saved websites; anything else can be
/// opened in the native source explorer.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static Future<void> open(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen()));

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _q = TextEditingController();

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  void _openWeb(String text) {
    final Uri uri;
    try {
      uri = LinkFeed.check(text);
    } on FormatException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
      return;
    }
    Navigator.of(context).pop();
    context.read<ShellController>().openSource(uri);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final q = _q.text.trim().toLowerCase();
    final results = q.isEmpty
        ? const []
        : app.content
              .where((c) => c.title.toLowerCase().contains(q) || c.genres.any((g) => g.toLowerCase().contains(q)))
              .toList();
    final sites = q.isEmpty
        ? const []
        : app.websites.where((w) => w.name.toLowerCase().contains(q) || w.host.contains(q)).toList();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: RwSpace.gutter),
          child: TextField(
            controller: _q,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onChanged: (_) => setState(() {}),
            onSubmitted: (t) => results.isEmpty && sites.isEmpty && t.trim().isNotEmpty ? _openWeb(t) : null,
            decoration: const InputDecoration(
              hintText: 'Search titles or paste a source URL',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: q.isEmpty
          ? const EmptyState(
              icon: Icons.search,
              title: 'Search your library',
              message: 'Find titles from your integrated websites, or type an address to open it.',
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: RwSpace.xxl),
              children: [
                ListTile(
                  leading: const Icon(Icons.travel_explore),
                  title: Text('Open "${_q.text.trim()}" as a source'),
                  onTap: () => _openWeb(_q.text),
                ),
                if (sites.isNotEmpty) const SectionHeader('Websites'),
                for (final s in sites)
                  ListTile(
                    leading: SiteAvatar(name: s.name, favicon: s.favicon, size: 40),
                    title: Text(s.name),
                    subtitle: Text(s.host),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.read<ShellController>().openSource(Uri.parse(s.url));
                    },
                  ),
                if (results.isNotEmpty) SectionHeader('Titles (${results.length})'),
                if (results.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: RwSpace.gutter),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 140,
                        mainAxisSpacing: RwSpace.md,
                        crossAxisSpacing: RwSpace.sm,
                        childAspectRatio: 0.52,
                      ),
                      itemCount: results.length,
                      itemBuilder: (_, i) => ContentCard(
                        content: results[i],
                        width: null,
                        onTap: () => ContentDetailScreen.open(context, results[i]),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
