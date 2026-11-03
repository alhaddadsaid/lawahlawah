import 'dart:collection';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/design/tokens.dart';
import '../data/models/user_settings.dart';
import '../core/security/url_policy.dart';
import '../data/remote_config.dart';
import '../partners/partner_registry.dart';
import 'background_play.dart';
import 'browser_user_agent.dart';
import 'media_capture.dart';
import 'popup_protection.dart';
import 'tab_manager.dart';
import 'website_ad_rules.dart';

/// Commands the toolbar sends to the live WebView of a tab.
class BrowserCommands {
  InAppWebViewController? _c;
  Future<void> back() async => _c?.goBack();
  Future<void> forward() async => _c?.goForward();
  Future<void> reload() async => _c?.reload();
  Future<void> stop() async => _c?.stopLoading();
  Future<void> load(Uri url) async {
    _userNavAt = DateTime.now();
    await _c?.loadUrl(urlRequest: URLRequest(url: WebUri.uri(url)));
  }

  /// When the user last started a page load (tap, typed address); its server
  /// redirects are let through (see PopupProtection.isRedirectOfUserNavigation).
  DateTime? _userNavAt;
  Future<String?> html() async => _c?.getHtml();

  static final _world = ContentWorld.world(name: MediaCapture.worldName);

  /// Videos the page's own player has loaded so far (see [MediaCapture]).
  Future<List<CapturedMedia>> media() async {
    try {
      return [
        ...MediaCapture.decode(await _c?.evaluateJavascript(source: MediaCapture.readerJs, contentWorld: _world)),
        ...MediaCapture.decode(await _c?.evaluateJavascript(source: MediaCapture.pageReaderJs)),
      ];
    } catch (_) {
      return const []; // The page is navigating or the tab closed.
    }
  }

  /// The page's episode list (see [MediaCapture.episodesJs]).
  Future<List<ScannedEpisode>> episodes(Uri page) async {
    try {
      return MediaCapture.decodeEpisodes(
        await _c?.evaluateJavascript(source: MediaCapture.episodesJs, contentWorld: _world),
        page,
      );
    } catch (_) {
      return const [];
    }
  }

  /// Presses episode [number] in the page's episode list. False when the page
  /// no longer shows it.
  Future<bool> pressEpisode(int number) async {
    try {
      return await _c?.evaluateJavascript(source: MediaCapture.clickEpisodeJs(number), contentWorld: _world) == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> resumeMedia() async {
    try {
      await _c?.evaluateJavascript(source: MediaCapture.resumeJs, contentWorld: _world);
    } catch (_) {
      /* The user can press play on the page. */
    }
  }

  Future<void> autoplayMuted() async {
    try {
      await _c?.evaluateJavascript(source: MediaCapture.autoplayJs, contentWorld: _world);
    } catch (_) {
      /* The page may still be loading. */
    }
  }

  Future<void> pauseMedia() async {
    try {
      await _c?.evaluateJavascript(source: MediaCapture.pauseJs, contentWorld: _world);
    } catch (_) {
      /* Nothing to pause. */
    }
  }
}

/// One tab's WebView, wired to [PopupProtection].
///
/// Security configuration (spec section 9):
///  * No JavaScript bridge is registered: pages cannot call native code.
///  * File/content access off; mixed content never allowed.
///  * TLS errors are NOT overridden (no onReceivedServerTrustAuthRequest), so
///    invalid certificates are rejected by the platform.
///  * Safe Browsing (Android) / fraudulent-site warnings (iOS) on.
///  * One read-only script records which link a tap actually pressed, so
///    hijacked taps (ads riding on a real tap) can be told apart. It changes
///    nothing on the page and sends nothing anywhere; the app reads it with
///    evaluateJavascript only when deciding about a cross-site jump.
///  * A second read-only script, in Reelway's own script world (invisible to
///    the page), notes which videos the page's player loads, for
///    "Play in Reelway" (see media_capture.dart).
///  * On partner websites only (contract in force), a second script hides
///    their ads and skips their ad gate as the agreement allows.
class BrowserView extends StatefulWidget {
  const BrowserView({
    super.key,
    required this.tab,
    required this.tabs,
    required this.protection,
    required this.partners,
    required this.settings,
    required this.commands,
    required this.onBlocked,
    required this.onPageLoaded,
    this.onOpenSeries,
  });

  final BrowserTab tab;
  final TabManager tabs;
  final PopupProtection protection;
  final PartnerRegistry partners;
  final UserSettings settings;
  final BrowserCommands commands;
  final void Function(Uri site, Decision decision, {required bool popup}) onBlocked;
  final void Function(Uri url, String title) onPageLoaded;

  /// Asked before the tab opens a page; true when Reelway shows that series
  /// itself, so the website page is not loaded.
  final bool Function(Uri target)? onOpenSeries;

  @override
  State<BrowserView> createState() => _BrowserViewState();
}

class _BrowserViewState extends State<BrowserView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  /// Whether this tab runs with ad rules now: website ad blocking is on (the
  /// server's switch wins over the app setting) and the page is not on a site
  /// whose own ads are allowed (admin "Website's own ads").
  late bool _rulesOn = _wantsRules(widget.tab.url);

  bool _wantsRules(Uri? url) => websiteAdBlocking(widget.settings.blockWebsiteAds) && !adsAllowedOn(url);

  @override
  void initState() {
    super.initState();
    RemoteConfig.instance.addListener(_onConfig);
  }

  @override
  void dispose() {
    RemoteConfig.instance.removeListener(_onConfig);
    super.dispose();
  }

  /// The server's settings changed: apply them to the page already open.
  void _onConfig() {
    unawaited(_matchAdRules(widget.tab.url));
    unawaited(_matchBackgroundPlay(widget.tab.url));
  }

  final _backgroundPlayScript = UserScript(
    source: BackgroundPlay.hookJs,
    injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
    forMainFrameOnly: true,
  );

  /// Whether the hook script is registered in this webview.
  late bool _bgScriptOn = BackgroundPlay.shouldRun(
    platform: defaultTargetPlatform,
    url: Uri.parse('https://youtube.com'),
    switchOn: BackgroundPlay.switchOn,
  );

  /// iPhone only; follows the server switch live. While it is on, the YouTube
  /// keep-playing script and the playback audio session are active; when it
  /// goes off both are undone. Does nothing on Android.
  Future<void> _matchBackgroundPlay(Uri? url) async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    final c = widget.commands._c;
    if (c == null) return;
    final switchOn = BackgroundPlay.switchOn;
    try {
      if (switchOn != _bgScriptOn) {
        _bgScriptOn = switchOn;
        if (switchOn) {
          await c.addUserScript(userScript: _backgroundPlayScript);
        } else {
          await c.removeUserScript(userScript: _backgroundPlayScript);
        }
      }
      if (BackgroundPlay.activeFor(url)) {
        await BackgroundPlay.setAudioSession(true);
        await c.evaluateJavascript(source: BackgroundPlay.hookJs);
      } else {
        await c.evaluateJavascript(source: BackgroundPlay.offJs);
        await BackgroundPlay.setAudioSession(false);
      }
    } catch (_) {
      /* A tab may have closed meanwhile. */
    }
  }

  /// Drops the ad rules on sites whose own ads are allowed (or when blocking
  /// is off) and puts them back elsewhere. Only touches the webview when that
  /// changes.
  Future<void> _matchAdRules(Uri? url) async {
    final on = _wantsRules(url);
    if (on == _rulesOn) return;
    _rulesOn = on;
    await _refreshSettings();
  }

  @override
  void didUpdateWidget(covariant BrowserView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings.blockThirdPartyCookies != widget.settings.blockThirdPartyCookies) {
      _rulesOn = _wantsRules(widget.tab.url);
      unawaited(_refreshSettings());
    } else if (oldWidget.settings.blockWebsiteAds != widget.settings.blockWebsiteAds) {
      unawaited(_matchAdRules(widget.tab.url));
    }
  }

  Future<void> _refreshSettings() async {
    try {
      await widget.commands._c?.setSettings(settings: _webSettings);
    } catch (_) {
      /* A tab may have closed while settings were updated. */
    }
  }

  Uri? _lastRescue;
  DateTime _lastRescueAt = DateTime.fromMillisecondsSinceEpoch(0);

  /// The page's ad script cancelled the user's tap and we blocked its ad:
  /// open the link the user actually pressed, once per tap.
  void _rescue(InAppWebViewController c, TapInfo? tap) {
    final dest = PopupProtection.intendedDestination(widget.tab.url, tap);
    if (dest == null) return;
    final now = DateTime.now();
    if (dest == _lastRescue && now.difference(_lastRescueAt) < const Duration(seconds: 3)) return;
    _lastRescue = dest;
    _lastRescueAt = now;
    if (widget.onOpenSeries?.call(dest) == true) {
      // Reelway shows that series itself; do not leave the ad's blank page.
      _restoreIfBlank(c);
      return;
    }
    widget.protection.allowOnce(dest);
    widget.commands._userNavAt = DateTime.now();
    c.loadUrl(urlRequest: URLRequest(url: WebUri.uri(dest)));
  }

  /// The last real page this tab showed, to return to if an ad left it blank.
  Uri? _lastPage;

  /// After a series moved to Reelway, an ad's refused window can leave the tab
  /// on a blank page: go back to the page the user tapped on.
  void _restoreIfBlank(InAppWebViewController c) {
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (!mounted) return;
      final now = (await c.getUrl())?.uriValue;
      if (now != null && (now.scheme == 'https' || now.scheme == 'http')) return;
      if (await c.canGoBack()) {
        await c.goBack();
      } else if (_lastPage != null) {
        await c.loadUrl(urlRequest: URLRequest(url: WebUri.uri(_lastPage!)));
      }
    });
  }

  /// iOS: when onCreateWindow refuses a pop-up, flutter_inappwebview loads the
  /// pop-up's own request in this tab instead (a blank page for pop-unders).
  /// The refused request is remembered briefly so that load can be cancelled.
  Uri? _refusedPopup;
  DateTime? _refusedPopupAt;

  bool _isRefusedPopupLoad(Uri? target) {
    final at = _refusedPopupAt;
    if (at == null || DateTime.now().difference(at) > const Duration(seconds: 2)) return false;
    if (!PopupProtection.isRefusedPopupLoad(refused: _refusedPopup, target: target)) return false;
    _refusedPopupAt = null;
    return true;
  }

  InAppWebViewSettings get _webSettings => InAppWebViewSettings(
    javaScriptEnabled: true,
    domStorageEnabled: true,
    userAgent: BrowserUserAgent.android ?? '',
    // Android's full identity is set above; the suffix is for iOS only.
    applicationNameForUserAgent: defaultTargetPlatform == TargetPlatform.iOS ? BrowserUserAgent.iosSuffix : '',
    sharedCookiesEnabled: true,
    contentBlockers: _rulesOn ? browserAdRules() : [],
    useShouldOverrideUrlLoading: true,
    useOnDownloadStart: true,
    // Android needs these so window.open reaches onCreateWindow, where the
    // gesture flag is checked. iOS WebKit already refuses window.open
    // without a user gesture when this is false.
    supportMultipleWindows: true,
    javaScriptCanOpenWindowsAutomatically: defaultTargetPlatform == TargetPlatform.android,
    thirdPartyCookiesEnabled: !widget.settings.blockThirdPartyCookies,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_NEVER_ALLOW,
    allowFileAccess: false,
    allowContentAccess: false,
    allowFileAccessFromFileURLs: false,
    allowUniversalAccessFromFileURLs: false,
    safeBrowsingEnabled: true,
    isFraudulentWebsiteWarningEnabled: true,
    allowsInlineMediaPlayback: true,
    allowsPictureInPictureMediaPlayback: true,
    mediaPlaybackRequiresUserGesture: true,
    allowsBackForwardNavigationGestures: true,
    isInspectable: kDebugMode,
    transparentBackground: false,
  );

  void _sync(InAppWebViewController c, {WebUri? url}) async {
    final back = await c.canGoBack();
    final fwd = await c.canGoForward();
    widget.tabs.update(widget.tab.id, (t) {
      if (url != null) t.url = url.uriValue;
      t.canGoBack = back;
      t.canGoForward = fwd;
    });
  }

  /// Records the last pressed element at the start of every tap, before the
  /// page's own (ad) handlers can redirect it. Capture phase on window.
  /// Ad scripts often lay an invisible layer over the page; then the page's
  /// own link under the finger is recorded instead of the layer.
  static const _tapRecorderJs = r"""
(function () {
  if (window.__rwTap) return;
  window.__rwTap = { href: null, t: 0 };
  function site(host) { return host.split('.').slice(-2).join('.'); }
  function sameSite(u) {
    try { return site(new URL(u, location.href).hostname) === site(location.hostname); } catch (e) { return false; }
  }
  function rec(e) {
    var el = e.target, a = el && el.closest ? el.closest('a[href]') : null;
    var href = a ? a.href : '';
    if ((!href || !sameSite(href)) && document.elementsFromPoint && typeof e.clientX === 'number') {
      var stack = document.elementsFromPoint(e.clientX, e.clientY);
      for (var i = 0; i < stack.length; i++) {
        var b = stack[i].closest ? stack[i].closest('a[href]') : null;
        if (b && b.href.indexOf('http') === 0 && sameSite(b.href)) { href = b.href; break; }
      }
    }
    window.__rwTap = { href: href, t: Date.now() };
  }
  window.addEventListener('pointerdown', rec, true);
  window.addEventListener('click', rec, true);
})();
""";

  static const _tapReaderJs = r"""
(function () {
  var t = window.__rwTap;
  if (!t || Date.now() - t.t > 2500) return null;
  return t.href;
})();
""";

  /// What the user's last tap pressed: a link, something else, or unknown.
  Future<TapInfo?> _lastTap(InAppWebViewController c) async {
    try {
      final v = await c.evaluateJavascript(source: _tapReaderJs);
      if (v == null) return null;
      final s = v.toString();
      if (s.isEmpty) return const TapInfo.nonLink();
      final uri = Uri.tryParse(s);
      return uri == null ? null : TapInfo.link(uri);
    } catch (_) {
      return null; // Unknown: fall back to the gesture-only rules.
    }
  }

  bool _gesture(NavigationAction a) {
    if (a.hasGesture != null) return a.hasGesture!; // Android
    final type = a.navigationType; // iOS
    return type == NavigationType.LINK_ACTIVATED || type == NavigationType.FORM_SUBMITTED;
  }

  Future<NavigationActionPolicy> _onNavigate(InAppWebViewController c, NavigationAction a) async {
    final target = a.request.url?.uriValue;
    if (a.isForMainFrame && _isRefusedPopupLoad(target)) return NavigationActionPolicy.CANCEL;
    if (target == null) return NavigationActionPolicy.ALLOW;
    if (a.isForMainFrame && widget.onOpenSeries?.call(target) == true) {
      _restoreIfBlank(c);
      return NavigationActionPolicy.CANCEL;
    }
    final tapped = _gesture(a);
    // A server forwarding the page the user just opened (a Google result,
    // a short link) counts as the user's own navigation.
    final redirect =
        !tapped &&
        a.isForMainFrame &&
        PopupProtection.isRedirectOfUserNavigation(
          loading: widget.tab.isLoading,
          userNavAt: widget.commands._userNavAt,
          now: DateTime.now(),
        );
    final gesture = tapped || redirect;
    // Only ask the page what was tapped when it matters: a tapped jump of the
    // main page to a different site.
    final current = widget.tab.url;
    final needsTap =
        tapped &&
        a.isForMainFrame &&
        UrlPolicy.classify(target) == NavigationKind.web &&
        !PopupProtection.sameSite(current, target);
    final tap = needsTap ? await _lastTap(c) : null;
    final decision = widget.protection.onNavigation(
      NavigationRequestInfo(
        current: current,
        target: target,
        isMainFrame: a.isForMainFrame,
        hasUserGesture: gesture,
        isRedirect: a.isRedirect ?? false,
        tap: tap,
      ),
    );
    switch (decision.action) {
      case DecisionAction.allow:
      case DecisionAction.allowInNewTab:
        if (a.isForMainFrame && gesture) widget.commands._userNavAt = DateTime.now();
        if (a.isForMainFrame) await _matchAdRules(target);
        return NavigationActionPolicy.ALLOW;
      case DecisionAction.block:
        widget.tabs.update(widget.tab.id, (t) => t.blockedCount++);
        widget.onBlocked(widget.tab.url, decision, popup: false);
        _rescue(c, tap);
        return NavigationActionPolicy.CANCEL;
      case DecisionAction.askExternal:
        _confirmExternal(target);
        return NavigationActionPolicy.CANCEL;
    }
  }

  Future<bool> _onCreateWindow(InAppWebViewController c, CreateWindowAction a) async {
    final url = a.request.url?.uriValue;
    final target = (url == null || url.toString().isEmpty || url.scheme == 'about') ? null : url;
    final gesture = a.hasGesture ?? true;
    final tap = gesture ? await _lastTap(c) : null;
    final decision = widget.protection.onPopup(
      PopupRequestInfo(opener: widget.tab.url, target: target, hasUserGesture: gesture, tap: tap),
    );
    if (decision.isBlocked) {
      widget.tabs.update(widget.tab.id, (t) => t.blockedCount++);
      widget.onBlocked(widget.tab.url, decision, popup: true);
      _refusedPopup = target;
      _refusedPopupAt = DateTime.now();
      // After the plugin's own load of the refused window has been cancelled,
      // so it cannot replace the page the user meant to open.
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _rescue(c, tap);
      });
      return false; // Not handled: the window is discarded (see _isRefusedPopupLoad for iOS).
    }
    final tab = widget.tabs.open(target ?? Uri.parse('about:blank'), openedByPopup: true, windowId: a.windowId);
    return tab != null;
  }

  Future<void> _confirmExternal(Uri target) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: RwColors.surface,
        title: const Text('Open another app?'),
        content: Text('This page wants to open:\n${target.scheme}:${target.path}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Open')),
        ],
      ),
    );
    if (ok == true) await launchUrl(target, mode: LaunchMode.externalApplication);
  }

  /// Asks before any download, then hands it to the system (browser /
  /// download manager). Reports it as handled so the WebView does nothing more.
  Future<DownloadStartResponse> _onDownload(InAppWebViewController c, DownloadStartRequest r) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: RwColors.surface,
        title: const Text('Download file?'),
        content: Text(r.suggestedFilename ?? r.url.toString()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Download')),
        ],
      ),
    );
    if (ok == true) await launchUrl(r.url.uriValue, mode: LaunchMode.externalApplication);
    return DownloadStartResponse(handled: true);
  }

  Future<PermissionResponse> _onPermission(InAppWebViewController c, PermissionRequest r) async {
    final names = r.resources.map((e) => e.toString().split('.').last.toLowerCase()).join(', ');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: RwColors.surface,
        title: Text('${r.origin.host} wants access'),
        content: Text('Allow access to: $names?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Deny')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Allow')),
        ],
      ),
    );
    return PermissionResponse(
      resources: r.resources,
      action: ok == true ? PermissionResponseAction.GRANT : PermissionResponseAction.DENY,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tab = widget.tab;
    // The web build (design preview) runs inside a page that refuses to load
    // other websites, so say so clearly instead of showing a blank frame.
    if (kIsWeb) return _WebPreviewNotice(url: tab.url);
    final partnerScript = widget.partners.pageScript;
    return InAppWebView(
      key: ValueKey(tab.id),
      windowId: tab.windowId,
      initialUrlRequest: tab.windowId == null ? URLRequest(url: WebUri.uri(tab.initialUrl)) : null,
      initialSettings: _webSettings,
      initialUserScripts: UnmodifiableListView([
        UserScript(
          source: _tapRecorderJs,
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
          forMainFrameOnly: true,
        ),
        UserScript(
          source: MediaCapture.pageHookJs,
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
          forMainFrameOnly: true,
        ),
        UserScript(
          source: MediaCapture.watcherJs,
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
          forMainFrameOnly: false,
          contentWorld: BrowserCommands._world,
        ),
        if (_bgScriptOn) _backgroundPlayScript,
        if (partnerScript != null)
          UserScript(
            source: partnerScript,
            injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
            forMainFrameOnly: true,
          ),
      ]),
      onWebViewCreated: (c) => widget.commands._c = c,
      onLoadStart: (c, url) {
        widget.tabs.update(tab.id, (t) {
          t.isLoading = true;
          if (url != null) t.url = url.uriValue;
        });
        // Back, forward and reloads do not always pass through
        // shouldOverrideUrlLoading (Android).
        if (url != null) {
          unawaited(_matchAdRules(url.uriValue));
          unawaited(_matchBackgroundPlay(url.uriValue));
        }
      },
      onLoadStop: (c, url) async {
        widget.commands._userNavAt = null;
        widget.tabs.update(tab.id, (t) => t.isLoading = false);
        _sync(c, url: url);
        final title = await c.getTitle() ?? '';
        if (url != null && (url.scheme == 'https' || url.scheme == 'http')) _lastPage = url.uriValue;
        if (url != null) widget.onPageLoaded(url.uriValue, title);
      },
      onProgressChanged: (c, p) => widget.tabs.update(tab.id, (t) => t.progress = p / 100),
      onTitleChanged: (c, title) => widget.tabs.update(tab.id, (t) => t.title = title ?? ''),
      onUpdateVisitedHistory: (c, url, _) => _sync(c, url: url),
      shouldOverrideUrlLoading: _onNavigate,
      onCreateWindow: _onCreateWindow,
      onCloseWindow: (c) => widget.tabs.close(tab.id),
      onDownloadStarting: _onDownload,
      onPermissionRequest: _onPermission,
    );
  }
}

class _WebPreviewNotice extends StatelessWidget {
  const _WebPreviewNotice({required this.url});
  final Uri url;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(RwSpace.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.phone_android, size: 48, color: RwColors.accent),
          const SizedBox(height: RwSpace.md),
          Text('Websites open in the phone app', style: RwType.headline, textAlign: TextAlign.center),
          const SizedBox(height: RwSpace.xs),
          Text(
            'This is a design preview. It can show Reelway\'s screens, but it cannot load other '
            'websites such as ${url.host}. Install the Android test app to browse with pop-up and ad protection.',
            style: RwType.body.copyWith(color: RwColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: RwSpace.lg),
          OutlinedButton.icon(
            onPressed: () => launchUrl(url, mode: LaunchMode.externalApplication),
            icon: const Icon(Icons.open_in_new),
            label: Text('Open ${url.host} in a new tab'),
          ),
        ],
      ),
    ),
  );
}
