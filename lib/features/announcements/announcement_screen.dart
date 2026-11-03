import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
import '../../data/announcements.dart';
import '../../data/remote_config.dart';
import '../../push/push_service.dart';
import '../settings/protection_screen.dart';
import '../shell/shell.dart';

/// Opens the place an announcement button or a push notification points to.
void openAnnouncementTarget(BuildContext context, AnnouncementTarget? type, String? value) {
  switch (type) {
    case AnnouncementTarget.url:
      final uri = Announcement.safeUrl(value);
      if (uri == null) return;
      Navigator.of(context).popUntil((r) => r.isFirst);
      context.read<ShellController>().openBrowser(uri);
    case AnnouncementTarget.settings:
      Navigator.of(context).popUntil((r) => r.isFirst);
      context.read<ShellController>().go(AppTab.settings);
    case AnnouncementTarget.protection:
      Navigator.of(context).push(ProtectionScreen.route());
    case AnnouncementTarget.announcement:
    case null:
      return;
  }
}

/// The full announcement page.
class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key, required this.announcement});
  final Announcement announcement;

  static Route<void> route(Announcement a) => MaterialPageRoute(builder: (_) => AnnouncementScreen(announcement: a));

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  @override
  void initState() {
    super.initState();
    Announcements.instance.markSeen(widget.announcement.id);
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.announcement;
    final hasAction = a.actionType != null;
    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RwSpace.gutter),
          children: [
            if (a.date != null) Text(a.date!, style: RwType.caption),
            const SizedBox(height: RwSpace.xs),
            Text(a.title, style: RwType.headline),
            const SizedBox(height: RwSpace.md),
            if (a.body.isNotEmpty) Text(a.body, style: RwType.body.copyWith(fontSize: 16)),
            const SizedBox(height: RwSpace.lg),
            if (hasAction)
              FilledButton(
                onPressed: () => openAnnouncementTarget(context, a.actionType, a.actionValue),
                child: Text(a.actionLabel ?? _defaultLabel(a.actionType!)),
              ),
            const SizedBox(height: RwSpace.xs),
            TextButton(onPressed: () => Navigator.of(context).maybePop(), child: const Text('Close')),
          ],
        ),
      ),
    );
  }

  static String _defaultLabel(AnnouncementTarget t) => switch (t) {
    AnnouncementTarget.url => 'Open',
    AnnouncementTarget.settings => 'Open Settings',
    AnnouncementTarget.protection => 'Open Pop-up protection',
    AnnouncementTarget.announcement => 'Open',
  };
}

/// Every announcement, newest first, reachable from Settings.
class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (_) => const NewsScreen());

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('News')),
    body: ListenableBuilder(
      listenable: Listenable.merge([Announcements.instance, RemoteConfig.instance]),
      builder: (context, _) {
        final items = Announcements.instance.all;
        if (items.isEmpty) {
          return Center(child: Text('No news right now.', style: RwType.body));
        }
        return ListView(
          children: [
            for (final a in items)
              ListTile(
                title: Text(a.title, style: RwType.subtitle),
                subtitle: a.date == null ? null : Text(a.date!),
                trailing: Announcements.instance.isSeen(a.id)
                    ? const Icon(Icons.chevron_right)
                    : const Icon(Icons.circle, size: 10, color: RwColors.accent),
                onTap: () => Navigator.of(context).push(AnnouncementScreen.route(a)),
              ),
          ],
        );
      },
    ),
  );
}

/// Shows the newest unseen announcement once when people open the app.
/// Waits for the server answer (or the cached copy) before deciding.
class AnnouncementPresenter {
  AnnouncementPresenter(this.navigator);
  final GlobalKey<NavigatorState> navigator;
  final _shownThisRun = <String>{};
  bool _showing = false;

  Future<void> check() async {
    if (_showing) return;
    await Announcements.instance.load();
    await RemoteConfig.instance.ready;
    final next = Announcements.instance.firstUnseen;
    final nav = navigator.currentState;
    if (next == null || nav == null || _shownThisRun.contains(next.id)) return;
    _shownThisRun.add(next.id);
    _showing = true;
    await nav.push(AnnouncementScreen.route(next));
    _showing = false;
  }

  /// A push notification tap: open the announcement, or the chosen place.
  Future<void> openFromPush(Map<String, dynamic> data) async {
    await Announcements.instance.load();
    await RemoteConfig.instance.ready;
    final nav = navigator.currentState;
    final context = navigator.currentContext;
    if (nav == null || context == null) return;
    final target = Announcement.parseTarget(data['target']) ?? AnnouncementTarget.announcement;
    if (target == AnnouncementTarget.announcement) {
      final id = data['id'];
      var a = id is String ? Announcements.instance.byId(id) : null;
      if (a == null) {
        await RemoteConfig.instance.refresh(minAge: Duration.zero);
        a = id is String ? Announcements.instance.byId(id) : null;
      }
      if (a != null) {
        _shownThisRun.add(a.id);
        nav.popUntil((r) => r.isFirst);
        await nav.push(AnnouncementScreen.route(a));
      }
      return;
    }
    if (context.mounted) {
      openAnnouncementTarget(context, target, data['value'] is String ? data['value'] as String : null);
    }
  }
}

/// Our own question before the system permission prompt, so people know why.
Future<void> askAboutNotifications(BuildContext context) async {
  final yes = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Get news from Reelway?'),
      content: const Text('We send a notification only for important news. You can turn it off any time in Settings.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Not now')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
      ],
    ),
  );
  if (yes == true) {
    await PushService.instance.setEnabled(true);
  } else {
    await PushService.instance.markAsked();
  }
}
