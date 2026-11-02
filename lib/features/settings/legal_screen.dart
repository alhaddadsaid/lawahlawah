import 'package:flutter/material.dart';

import '../../core/design/tokens.dart';

enum LegalDoc { privacy, terms }

/// In-app privacy policy and terms. DRAFT text: must be reviewed by a
/// qualified lawyer and published at a public URL before store submission.
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.doc});
  final LegalDoc doc;

  static Route<void> route(LegalDoc d) => MaterialPageRoute(builder: (_) => LegalScreen(doc: d));

  static const _privacy = [
    ('Draft notice', 'This is a draft for development and must be reviewed before release.'),
    (
      'What Reelway stores',
      'Websites you add, bookmarks, pages you visit, viewing progress and your settings. This data stays on your device.',
    ),
    (
      'Website data',
      'Reelway requests public pages and media directly. It does not render website scripts or share browser cookies. Websites and media providers receive normal network request information, including your IP address.',
    ),
    (
      'Advertising',
      'Reelway shows ads through Google AdMob. Where required by law (for example GDPR and UK GDPR) we ask for your consent first. Without consent only non-personalised ads are shown.',
    ),
    (
      'Crash reports',
      'If enabled, anonymous crash reports help us fix problems. They do not include the pages you visit.',
    ),
    ('Your controls', 'You can delete history, saved websites and all app data from Settings.'),
  ];

  static const _terms = [
    ('Draft notice', 'This is a draft for development and must be reviewed before release.'),
    (
      'What Reelway is',
      'Reelway is a native player for public video links and supported website pages. It does not host, upload or distribute video content.',
    ),
    (
      'Third-party websites',
      'Websites you visit are run by third parties, who are responsible for their content. Only use websites that have the right to offer the content they show.',
    ),
    (
      'Links you add',
      'You can add public links to videos, catalogs or supported website pages and play them in Reelway. Reelway does not host, provide or check these videos. Only add links you have the right to play: you are responsible for the links you add.',
    ),
    ('Acceptable use', 'Do not use Reelway to break the law or bypass logins, paywalls or copy protection.'),
    ('No warranty', 'Reelway is provided as is. Features depend on the websites you visit and may change.'),
  ];

  @override
  Widget build(BuildContext context) {
    final items = doc == LegalDoc.privacy ? _privacy : _terms;
    return Scaffold(
      appBar: AppBar(title: Text(doc == LegalDoc.privacy ? 'Privacy policy' : 'Terms of service')),
      body: ListView(
        padding: const EdgeInsets.all(RwSpace.gutter),
        children: [
          for (final (h, b) in items) ...[
            Text(h, style: RwType.subtitle),
            const SizedBox(height: RwSpace.xxs),
            Text(b, style: RwType.body.copyWith(color: RwColors.textSecondary)),
            const SizedBox(height: RwSpace.md),
          ],
        ],
      ),
    );
  }
}
