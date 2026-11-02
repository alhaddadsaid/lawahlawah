import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
import '../../data/repositories/app_state.dart';
import '../../sources/link_feed.dart';
import '../../sources/page_source.dart';
import '../shell/shell.dart';

/// Adds a public video or catalog link to the Library, after the user
/// confirms they have the right to play what they add.
class AddLinkSheet extends StatefulWidget {
  const AddLinkSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: RwColors.surface,
    builder: (_) => const AddLinkSheet(),
  );

  static const disclaimer =
      'Reelway does not host, provide or check any videos. Only add links you have the right to play: '
      'you are responsible for the links you add. Links must be public: anything that needs a sign-in will not play.';

  @override
  State<AddLinkSheet> createState() => _AddLinkSheetState();
}

class _AddLinkSheetState extends State<AddLinkSheet> {
  final _text = TextEditingController();
  bool _busy = false;
  bool _agreed = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _agreed = context.read<AppState>().linksDisclaimerAccepted;
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  bool get _isWebsite {
    try {
      final url = LinkFeed.check(_text.text);
      return PageSource.isNartoCatalogue(url) || url.path.isEmpty || url.path == '/';
    } on FormatException {
      return false;
    }
  }

  Future<void> _add() async {
    final app = context.read<AppState>();
    setState(() {
      _busy = true;
      _error = null;
    });
    app.acceptLinksDisclaimer();
    try {
      final url = LinkFeed.check(_text.text);
      if (_isWebsite) {
        final shell = context.read<ShellController>();
        if (!app.websites.any((site) => site.host == url.host)) {
          app.addWebsite(Uri.https(url.authority, '/').toString(), name: 'Narto-Drama');
        }
        if (!mounted) return;
        Navigator.pop(context);
        shell.openBrowser(url);
        return;
      }
    } on FormatException {
      /* addLink below displays the validation message. */
    }
    final error = await app.addLink(_text.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
    });
    if (error == null) _text.clear();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final canAdd = _agreed && !_busy;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(RwSpace.gutter),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add a link', style: RwType.title),
              const SizedBox(height: RwSpace.xs),
              Text(
                'Paste a website to browse its series, or a public episode, video (.mp4, .m3u8), or catalog link. '
                'Reelway plays it in its own player.',
                style: RwType.caption,
              ),
              const SizedBox(height: RwSpace.md),
              TextField(
                controller: _text,
                onChanged: (_) => setState(() => _error = null),
                keyboardType: TextInputType.url,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => canAdd ? _add() : null,
                decoration: InputDecoration(hintText: 'https://', errorText: _error, errorMaxLines: 3),
              ),
              const SizedBox(height: RwSpace.md),
              Container(
                padding: const EdgeInsets.all(RwSpace.sm),
                decoration: BoxDecoration(color: RwColors.card, borderRadius: BorderRadius.circular(RwRadius.md)),
                child: Text(AddLinkSheet.disclaimer, style: RwType.caption),
              ),
              if (!app.linksDisclaimerAccepted)
                CheckboxListTile(
                  value: _agreed,
                  onChanged: (v) => setState(() => _agreed = v ?? false),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('I have the right to play the links I add', style: RwType.body),
                ),
              const SizedBox(height: RwSpace.sm),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: canAdd ? _add : null,
                  child: _busy
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(_isWebsite ? 'Browse website' : 'Add to Library'),
                ),
              ),
              if (app.links.isNotEmpty) ...[
                const SizedBox(height: RwSpace.lg),
                Text('Your links', style: RwType.subtitle),
                for (final link in app.links)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(link, maxLines: 2, overflow: TextOverflow.ellipsis, style: RwType.body),
                    subtitle: Text('${app.titlesFrom(link)} titles', style: RwType.caption),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Remove link',
                      onPressed: () => app.removeLink(link),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
