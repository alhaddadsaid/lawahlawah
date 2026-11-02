import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../sources/source_verification.dart';

/// The user completes the site's check. This screen only observes whether the
/// challenge is still present; it never clicks, solves or simulates a CAPTCHA.
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
  Timer? _poll;
  bool _checking = false;
  int _navigation = 0;
  bool _ready = false;
  bool _loading = true;
  bool _finishing = false;
  bool _stalled = false;
  String? _error;
  DateTime _started = DateTime.now();

  @override
  void initState() {
    super.initState();
    _poll = Timer.periodic(const Duration(seconds: 2), (_) => unawaited(_observe()));
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _observe() async {
    final controller = _controller;
    if (controller == null || _checking || _finishing) return;
    _checking = true;
    final navigation = _navigation;
    try {
      final uri = Uri.tryParse((await controller.getUrl()).toString());
      final raw = await controller
          .evaluateJavascript(
            source: '''
(() => ({title: document.title, text: (document.body?.innerText || '').slice(0, 4000),
challenge: !!document.querySelector('#challenge-stage, #challenge-running, #cf-challenge-running, #cf-error-details')}))()
''',
          )
          .timeout(const Duration(seconds: 5));
      final data = raw is String ? jsonDecode(raw) : raw;
      final ready =
          uri != null &&
          data is Map &&
          VerificationPolicy.pageReady(
            original: widget.url,
            current: uri,
            title: data['title'] is String ? data['title'] as String : '',
            text: data['text'] is String ? data['text'] as String : '',
            challengeVisible: data['challenge'] != false,
          );
      if (mounted && navigation == _navigation) {
        setState(() {
          _ready = ready;
          _stalled = !ready && DateTime.now().difference(_started) >= const Duration(seconds: 45);
        });
      }
    } catch (_) {
      if (mounted && navigation == _navigation) {
        setState(() {
          _ready = false;
          _stalled = DateTime.now().difference(_started) >= const Duration(seconds: 45);
        });
      }
    } finally {
      _checking = false;
    }
  }

  Future<void> _retry() async {
    setState(() {
      _ready = false;
      _stalled = false;
      _error = null;
      _started = DateTime.now();
    });
    await _controller?.reload();
  }

  Future<void> _finish() async {
    final controller = _controller;
    if (controller == null || !_ready || _finishing || _checking) return;
    await _observe();
    if (!mounted || !_ready) return;
    setState(() {
      _finishing = true;
      _error = null;
    });
    try {
      final current = Uri.tryParse((await controller.getUrl()).toString());
      if (current?.scheme != 'https' || current?.origin != widget.url.origin) {
        throw const FormatException('Return to the original website.');
      }
      final cookies = await CookieManager.instance().getCookies(url: WebUri(widget.url.toString()));
      final actualAgent = await controller.evaluateJavascript(source: 'navigator.userAgent');
      final session = VerifiedSourceSession(
        origin: widget.url,
        userAgent: actualAgent is String ? actualAgent : await InAppWebViewController.getDefaultUserAgent(),
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
          _error = 'Could not read verification. Please retry.';
        });
      }
    }
  }

  Future<void> _openBrowser() async {
    final opened = await launchUrl(widget.url, mode: LaunchMode.externalApplication);
    if (!opened && mounted) setState(() => _error = 'Could not open your browser.');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Verify website'),
      actions: [IconButton(tooltip: 'Reload website', onPressed: _retry, icon: const Icon(Icons.refresh))],
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Icon(
                _ready ? Icons.check_circle_outline : Icons.shield_outlined,
                color: _ready ? Colors.greenAccent : Colors.white70,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(_ready ? 'Page ready — continue in Reelway' : 'Complete the website’s check below.'),
              ),
            ],
          ),
        ),
        if (_loading && !kIsWeb) const LinearProgressIndicator(minHeight: 2),
        Expanded(
          child: kIsWeb
              ? const Center(child: Text('Verification is available in the iPhone and Android app.'))
              : InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(widget.url.toString())),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    domStorageEnabled: true,
                    thirdPartyCookiesEnabled: true,
                    sharedCookiesEnabled: true,
                    incognito: false,
                    useShouldOverrideUrlLoading: true,
                    javaScriptCanOpenWindowsAutomatically: false,
                    supportMultipleWindows: false,
                    mediaPlaybackRequiresUserGesture: true,
                  ),
                  onWebViewCreated: (controller) => _controller = controller,
                  onLoadStart: (_, _) {
                    _navigation++;
                    if (mounted) {
                      setState(() {
                        _loading = true;
                        _ready = false;
                      });
                    }
                  },
                  onLoadStop: (_, _) {
                    if (mounted) setState(() => _loading = false);
                    unawaited(_observe());
                  },
                  onCreateWindow: (_, _) async => false,
                  onReceivedError: (_, request, _) {
                    // Subframe DNS probes used by Turnstile can fail without failing the check.
                    if (request.isForMainFrame == true && mounted) {
                      setState(() {
                        _ready = false;
                        _loading = false;
                        _error = 'This page could not load. Retry or open it in your browser.';
                      });
                    }
                  },
                  shouldOverrideUrlLoading: (_, action) async {
                    final url = Uri.tryParse(action.request.url.toString());
                    return url != null && VerificationPolicy.allows(widget.url, url, mainFrame: action.isForMainFrame)
                        ? NavigationActionPolicy.ALLOW
                        : NavigationActionPolicy.CANCEL;
                  },
                ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_stalled || _error != null) ...[
                  Text(_error ?? 'This website’s check is still waiting. Try reloading or use your browser.'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: _retry, child: const Text('Retry')),
                      TextButton(onPressed: _openBrowser, child: const Text('Open browser')),
                    ],
                  ),
                ],
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: !_ready || _finishing || kIsWeb ? null : _finish,
                    child: Text(
                      _finishing
                          ? 'Returning…'
                          : _ready
                          ? 'Continue in Reelway'
                          : 'Waiting for website verification…',
                    ),
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
