import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
import '../../core/widgets/components.dart';
import '../../data/models/models.dart';
import '../../data/repositories/app_state.dart';
import '../shell/shell.dart';

Future<void> showAddWebsiteSheet(BuildContext context) =>
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const _AddWebsiteSheet());

class _AddWebsiteSheet extends StatefulWidget {
  const _AddWebsiteSheet();

  @override
  State<_AddWebsiteSheet> createState() => _AddWebsiteSheetState();
}

class _AddWebsiteSheetState extends State<_AddWebsiteSheet> {
  final _url = TextEditingController();
  final _name = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _url.dispose();
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final err = context.read<AppState>().addWebsite(_url.text, name: _name.text);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      RwSpace.gutter,
      0,
      RwSpace.gutter,
      MediaQuery.viewInsetsOf(context).bottom + RwSpace.lg,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Add a website', style: RwType.headline),
        const SizedBox(height: RwSpace.xxs),
        Text('It opens in the built-in browser with pop-up protection.', style: RwType.caption),
        const SizedBox(height: RwSpace.lg),
        TextField(
          controller: _url,
          autofocus: true,
          keyboardType: TextInputType.url,
          autocorrect: false,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(hintText: 'example.com', prefixIcon: const Icon(Icons.link), errorText: _error),
          onChanged: (_) => _error == null ? null : setState(() => _error = null),
        ),
        const SizedBox(height: RwSpace.sm),
        TextField(
          controller: _name,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
          decoration: const InputDecoration(hintText: 'Name (optional)', prefixIcon: Icon(Icons.label_outline)),
        ),
        const SizedBox(height: RwSpace.lg),
        FilledButton(onPressed: _submit, child: const Text('Save website')),
      ],
    ),
  );
}

class WebsitesScreen extends StatelessWidget {
  const WebsitesScreen({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (_) => const WebsitesScreen());

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Websites'),
        actions: [IconButton(onPressed: () => showAddWebsiteSheet(context), icon: const Icon(Icons.add))],
      ),
      body: app.websites.isEmpty
          ? EmptyState(
              icon: Icons.public,
              title: 'No websites yet',
              message: 'Add the sites you watch on.',
              action: 'Add website',
              onAction: () => showAddWebsiteSheet(context),
            )
          : ListView(
              children: [
                for (final w in app.websites)
                  ListTile(
                    leading: SiteAvatar(name: w.name, favicon: w.favicon, size: 40),
                    title: Text(w.name),
                    subtitle: Text(w.host),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IntegrationBadge(w.integrationStatus),
                        IconButton(
                          tooltip: 'Remove',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => app.removeWebsite(w.id),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).popUntil((r) => r.isFirst);
                      context.read<ShellController>().openInBrowser(Uri.parse(w.url));
                    },
                  ),
                const Padding(padding: EdgeInsets.all(RwSpace.gutter), child: _IntegrationLegend()),
              ],
            ),
    );
  }
}

class _IntegrationLegend extends StatelessWidget {
  const _IntegrationLegend();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final (s, t) in [
        (IntegrationStatus.browserOnly, 'Opens as a normal web page.'),
        (
          IntegrationStatus.pendingPermission,
          'An integration exists but stays off until the site\'s permission is documented.',
        ),
        (IntegrationStatus.integrated, 'Catalogue shown in Library with the site\'s permission.'),
      ])
        Padding(
          padding: const EdgeInsets.only(bottom: RwSpace.xs),
          child: Row(
            children: [
              IntegrationBadge(s),
              const SizedBox(width: RwSpace.sm),
              Expanded(child: Text(t, style: RwType.caption)),
            ],
          ),
        ),
    ],
  );
}
