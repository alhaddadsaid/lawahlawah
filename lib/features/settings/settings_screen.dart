import 'package:flutter/material.dart';

import '../../ads/ads.dart';

import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
import '../../browser/browser_data.dart';
import '../../browser/website_ad_rules.dart';
import '../../data/remote_config.dart';
import 'protection_screen.dart';
import '../../data/announcements.dart';
import '../announcements/announcement_screen.dart';
import '../../data/models/user_settings.dart';
import '../../data/repositories/app_state.dart';
import 'legal_screen.dart';
import 'websites_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final s = app.settings;
    void set(UserSettings Function(UserSettings) f) => app.updateSettings(f);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: RwSpace.xxl),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(RwSpace.gutter, RwSpace.md, RwSpace.gutter, RwSpace.xs),
            child: Text('Settings', style: RwType.headline),
          ),
          ListenableBuilder(
            listenable: Listenable.merge([Announcements.instance, RemoteConfig.instance]),
            builder: (context, _) {
              final all = Announcements.instance.all;
              if (all.isEmpty) return const SizedBox.shrink();
              final unseen = Announcements.instance.unseenCount;
              return _Group('News', [
                _NavTile(
                  Icons.campaign_outlined,
                  'News',
                  unseen > 0 ? '$unseen new' : 'Announcements from Reelway',
                  () => Navigator.of(context).push(NewsScreen.route()),
                ),
              ]);
            },
          ),
          _Group('General', [
            SwitchListTile(
              title: const Text('Save history'),
              subtitle: const Text('Remember pages you visit and what you watch'),
              value: s.saveHistory,
              onChanged: (v) => set((s) => s.copyWith(saveHistory: v)),
            ),
            _NavTile(
              Icons.public,
              'Websites',
              '${app.websites.length} saved',
              () => Navigator.of(context).push(WebsitesScreen.route()),
            ),
          ]),
          const _Group('Appearance', [
            ListTile(
              leading: Icon(Icons.dark_mode_outlined),
              title: Text('Theme'),
              subtitle: Text('Dark (cinema). A light theme is planned.'),
            ),
          ]),
          _Group('Browser', [
            // Reelway's server can set this for everyone; then it shows as set.
            if (RemoteConfig.instance.value('features.blockWebsiteAds') is bool)
              SwitchListTile(
                title: const Text('Block website ads'),
                subtitle: const Text('Set by Reelway. Sites whose own ads are allowed, like YouTube, keep them.'),
                value: websiteAdBlocking(s.blockWebsiteAds),
                onChanged: null,
              )
            else
              SwitchListTile(
                title: const Text('Block website ads'),
                subtitle: const Text(
                  'Blocks known ad networks (EasyList). Sites whose own ads are allowed, like YouTube, keep them.',
                ),
                value: s.blockWebsiteAds,
                onChanged: (value) => set((s) => s.copyWith(blockWebsiteAds: value)),
              ),
            SwitchListTile(
              title: const Text('Open videos in Reelway'),
              subtitle: const Text('When a website plays a video, continue watching it in Reelway’s player'),
              value: s.openVideosInReelway,
              onChanged: (value) => set((s) => s.copyWith(openVideosInReelway: value)),
            ),
            _NavTile(
              Icons.shield_outlined,
              'Pop-up protection',
              null,
              () => Navigator.of(context).push(ProtectionScreen.route()),
            ),
          ]),
          _Group('Privacy', [
            ListTile(
              leading: const Icon(Icons.cookie_outlined),
              title: const Text('Clear website data'),
              subtitle: const Text('Remove browser cookies, cache and temporary source access'),
              onTap: () =>
                  _confirm(context, 'Clear website data?', 'Some websites may ask you to verify again.', () async {
                    await BrowserData.clearAll();
                    app.clearSourceVerification();
                  }),
            ),
            const ListTile(
              leading: Icon(Icons.shield_outlined),
              title: Text('Native playback'),
              subtitle: Text('Browse websites normally. Videos on a page can also play in Reelway’s player.'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever_outlined, color: RwColors.danger),
              title: const Text('Delete all app data', style: TextStyle(color: RwColors.danger)),
              subtitle: const Text('Websites, bookmarks, history and settings'),
              onTap: () => _confirm(context, 'Delete everything?', 'This cannot be undone.', () async {
                await BrowserData.clearAll();
                await app.clearAllData();
              }),
            ),
          ]),
          _Group('Advertising', [
            SwitchListTile(
              title: const Text('Personalised ads'),
              subtitle: const Text(
                'Off by default. Your choice in the consent form controls this once ads are enabled.',
              ),
              value: s.personalizedAds,
              onChanged: null, // Wired to the Google UMP consent form in phase 6.
            ),
            const ListTile(
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text('Privacy options'),
              subtitle: Text('Available when advertising is enabled'),
              enabled: false,
            ),
          ]),
          _Group('Playback', [
            SwitchListTile(
              title: const Text('Play the next video automatically'),
              value: s.autoplayNext,
              onChanged: (v) => set((s) => s.copyWith(autoplayNext: v)),
            ),
            ListTile(
              title: const Text('Default speed'),
              trailing: DropdownButton<double>(
                value: s.preferredPlaybackSpeed,
                underline: const SizedBox.shrink(),
                items: [
                  for (final v in const [0.5, 0.75, 1.0, 1.25, 1.5, 2.0])
                    DropdownMenuItem(value: v, child: Text('${v}x')),
                ],
                onChanged: (v) => v == null ? null : set((s) => s.copyWith(preferredPlaybackSpeed: v)),
              ),
            ),
          ]),
          _Group('Subtitles', [
            SwitchListTile(
              title: const Text('Show subtitles when available'),
              value: s.subtitlesEnabled,
              onChanged: (v) => set((s) => s.copyWith(subtitlesEnabled: v)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RwSpace.gutter, vertical: RwSpace.xs),
              child: SegmentedButton<SubtitleSize>(
                segments: const [
                  ButtonSegment(value: SubtitleSize.small, label: Text('Small')),
                  ButtonSegment(value: SubtitleSize.medium, label: Text('Medium')),
                  ButtonSegment(value: SubtitleSize.large, label: Text('Large')),
                ],
                selected: {s.subtitleSize},
                onSelectionChanged: (v) => set((s) => s.copyWith(subtitleSize: v.first)),
              ),
            ),
          ]),
          _Group('About', [
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Reelway'),
              subtitle: Text('Version 0.1.0 · development build'),
            ),
            _NavTile(
              Icons.policy_outlined,
              'Privacy policy',
              null,
              () => Navigator.of(context).push(LegalScreen.route(LegalDoc.privacy)),
            ),
            _NavTile(
              Icons.gavel_outlined,
              'Terms of service',
              null,
              () => Navigator.of(context).push(LegalScreen.route(LegalDoc.terms)),
            ),
            // Required where Google's consent form applies (EU, UK, some US states).
            FutureBuilder<bool>(
              future: privacyOptionsRequired(),
              builder: (context, snapshot) => snapshot.data == true
                  ? _NavTile(Icons.privacy_tip_outlined, 'Privacy choices', 'Ad personalisation', showPrivacyOptions)
                  : const SizedBox.shrink(),
            ),
          ]),
        ],
      ),
    );
  }

  static Future<void> _confirm(BuildContext context, String title, String body, Future<void> Function() action) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: RwColors.surface,
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirm')),
        ],
      ),
    );
    if (ok == true) {
      await action();
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Done')));
    }
  }
}

class _Group extends StatelessWidget {
  const _Group(this.title, this.children);
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(RwSpace.gutter, RwSpace.md, RwSpace.gutter, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: RwSpace.xxs, bottom: RwSpace.xs),
          child: Text(title.toUpperCase(), style: RwType.label.copyWith(color: RwColors.textSecondary)),
        ),
        Material(
          color: RwColors.surface,
          borderRadius: BorderRadius.circular(RwRadius.lg),
          clipBehavior: Clip.antiAlias,
          child: Column(children: children),
        ),
      ],
    ),
  );
}

class _NavTile extends StatelessWidget {
  const _NavTile(this.icon, this.title, this.subtitle, this.onTap);
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: subtitle == null ? null : Text(subtitle!),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}
