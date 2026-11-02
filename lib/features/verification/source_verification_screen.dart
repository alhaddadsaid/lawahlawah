import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../sources/source_verification.dart';

/// Optional, visible browser used only when the user chooses verification.
/// The user completes the site's check. Reelway never clicks or solves it.
class SourceVerificationScreen extends StatefulWidget {
  const SourceVerificationScreen({super.key, required this.url});
  final Uri url;

  static Future<VerifiedSourceSession?> open(BuildContext context, Uri url) => Navigator.of(context)
      .push<VerifiedSourceSession>(
        MaterialPageRoute(builder: (_) => SourceVerificationScreen(url: url), fullscreenDialog: true),
      );

  static Future<void> clearCookies() async {
    if (!kIsWeb) await CookieManager.instance().deleteAllCookies();
  }

  @override
  State<SourceVerificationScreen> createState() => _SourceVerificationScreenState();
}

class _SourceVerificationScreenState extends State<SourceVerificationScreen> {
  InAppWebViewController? _controller;
  bool _loading = true;
  bool _finishing = false;
  String? _error;

  Future<void> _finish() async {
    final controller = _controller;
    if (controller == null || _finishing) return;
    setState(() {
      _finishing = true;
      _error = null;
    });
    try {
      final current = Uri.tryParse((await controller.getUrl()).toString());
      if (current?.origin != widget.url.origin) {
        throw const FormatException('Return to the original website before continuing.');
      }
      final cookies = await CookieManager.instance().getCookies(url: WebUri(widget.url.toString()));
      final session = VerifiedSourceSession(
        origin: widget.url,
        userAgent: await InAppWebViewController.getDefaultUserAgent(),
        cookies: {
          for (final cookie in cookies)
            if (VerifiedSourceSession.allowedCookies.contains(cookie.name)) cookie.name: cookie.value,
        },
      );
      if (mounted) Navigator.pop(context, session);
    } catch (_) {
      if (mounted) {
        setState(() {
          _finishing = false;
          _error = 'Could not read website verification. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Verify website')),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Complete the check on ${widget.url.host}, then continue in Reelway. '
            'Verification does not guarantee that this website’s videos are supported.',
          ),
        ),
        if (_loading && !kIsWeb) const LinearProgressIndicator(),
        Expanded(
          child: kIsWeb
              ? const Center(child: Text('Website verification is available in the iPhone and Android app.'))
              : InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(widget.url.toString())),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    useShouldOverrideUrlLoading: true,
                    javaScriptCanOpenWindowsAutomatically: false,
                    supportMultipleWindows: false,
                    mediaPlaybackRequiresUserGesture: true,
                  ),
                  onWebViewCreated: (controller) => _controller = controller,
                  onLoadStart: (_, _) {
                    if (mounted) setState(() => _loading = true);
                  },
                  onLoadStop: (_, _) {
                    if (mounted) setState(() => _loading = false);
                  },
                  onCreateWindow: (_, _) async => false,
                  shouldOverrideUrlLoading: (_, action) async {
                    final url = Uri.tryParse(action.request.url.toString());
                    if (url == null || (url.scheme != 'https' && url.toString() != 'about:blank')) {
                      return NavigationActionPolicy.CANCEL;
                    }
                    if (url.toString() == 'about:blank') return NavigationActionPolicy.ALLOW;
                    if (action.isForMainFrame && url.origin != widget.url.origin) return NavigationActionPolicy.CANCEL;
                    return NavigationActionPolicy.ALLOW;
                  },
                ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_error != null) Text(_error!),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _loading || _finishing || kIsWeb ? null : _finish,
                    child: Text(_finishing ? 'Returning…' : 'Continue in Reelway'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
