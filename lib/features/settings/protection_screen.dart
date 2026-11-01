import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../browser/popup_protection.dart';
import '../../core/design/tokens.dart';
import '../../core/widgets/components.dart';
import '../../data/repositories/app_state.dart';

/// Transparent controls for pop-up protection: level, per-site exceptions,
/// and a log of everything blocked this session.
class ProtectionScreen extends StatelessWidget {
  const ProtectionScreen({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (_) => const ProtectionScreen());

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final s = app.settings;
    final log = app.popupProtection.log;

    return Scaffold(
      appBar: AppBar(title: const Text('Pop-up protection')),
      body: ListView(
        padding: const EdgeInsets.all(RwSpace.gutter),
        children: [
          for (final (level, title, desc) in [
            (
              ProtectionLevel.balanced,
              'Balanced (recommended)',
              'Blocks pop-ups you did not tap, automatic jumps to other sites and known bad ad destinations.',
            ),
            (
              ProtectionLevel.strict,
              'Strict',
              'Also blocks pop-ups that follow a tap. Some sites may need an exception.',
            ),
            (
              ProtectionLevel.off,
              'Off',
              'Only always-on safety rules apply (for example, blocking javascript: links).',
            ),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: RwSpace.xs),
              child: Material(
                color: s.protectionLevel == level ? RwColors.accentSoft : RwColors.surface,
                borderRadius: BorderRadius.circular(RwRadius.md),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RwRadius.md)),
                  leading: Icon(
                    s.protectionLevel == level ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: s.protectionLevel == level ? RwColors.accent : RwColors.textSecondary,
                  ),
                  title: Text(title),
                  subtitle: Text(desc),
                  onTap: () => app.updateSettings((x) => x.copyWith(protectionLevel: level)),
                ),
              ),
            ),
          const SectionHeader('Allowed sites'),
          if (s.allowedPopupSites.isEmpty)
            Text(
              'No exceptions. When something is blocked you can allow that site from the browser.',
              style: RwType.caption,
            ),
          for (final d in s.allowedPopupSites)
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: RwColors.success),
              title: Text(d),
              trailing: IconButton(icon: const Icon(Icons.close), onPressed: () => app.disallowPopupsFor(d)),
            ),
          SectionHeader('Blocked this session (${log.length})'),
          if (log.isEmpty) Text('Nothing blocked yet.', style: RwType.caption),
          for (final e in log.take(50))
            ListTile(
              dense: true,
              leading: const Icon(Icons.block, color: RwColors.danger, size: 20),
              title: Text(e.reason),
              subtitle: Text('${e.site} → ${e.target}', maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
        ],
      ),
    );
  }
}
