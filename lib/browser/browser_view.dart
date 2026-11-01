import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/design/tokens.dart';
import '../data/models/user_settings.dart';
import 'popup_protection.dart';
import 'tab_manager.dart';

/// Commands the toolbar sends to the live WebView of a tab.
class BrowserCommands {
  InAppWebViewController? _c;
  Future<void> back() async => _c?.goBack();
  Future<void> forward() async => _c?.goForward();
  Future<void> reload() async => _c?.reload();
  Future<void> stop() async => _c?.stopLoading();
  Future<void> load(Uri url) async => _c?.loadUrl(urlRequest: URLRequest(url: WebUri.uri(url)));
}

/// One tab's WebView, wired to [PopupProtection].
///
/// Security configuration (spec section 9):
///  * No JavaScript bridge is registered: pages cannot call native code.
///  * File/content access off; mixed content never allowed.
///  * TLS errors are NOT overridden (no onReceivedServerTrustAuthRequest), so
///    invalid certificates are rejected by the platform.
///  * Safe Browsing (Android) / fraudulent-site warnings (iOS) on.
class BrowserView extends StatefulWidget {
  const BrowserView({
    super.key,
    required this.tab,
    required this.tabs,
    required this.protection,
    required this.settings,
    required this.commands,
    required this.onBlocked,
    required this.onPageLoaded,
  });

  final BrowserTab tab;
  final TabManager tabs;
  final PopupProtection protection;
  final UserSettings settings;
  final BrowserCommands commands;
  final void Function(Uri site, Decision decision) onBlocked;
  final void Function(Uri url, String title) onPageLoaded;

  @override
  State<BrowserView> createState() => _BrowserViewState();
}

class _BrowserViewState extends State<BrowserView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  InAppWebViewSettings get _webSettings => InAppWebViewSettings(
    javaScriptEnabled: true,
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

  bool _gesture(NavigationAction a) {
    if (a.hasGesture != null) return a.hasGesture!; // Android
    final type = a.navigationType; // iOS
    return type == NavigationType.LINK_ACTIVATED || type == NavigationType.FORM_SUBMITTED;
  }

  Future<NavigationActionPolicy> _onNavigate(InAppWebViewController c, NavigationAction a) async {
    final target = a.request.url?.uriValue;
    if (target == null) return NavigationActionPolicy.ALLOW;
    final decision = widget.protection.onNavigation(
      NavigationRequestInfo(
        current: widget.tab.url,
        target: target,
        isMainFrame: a.isForMainFrame,
        hasUserGesture: _gesture(a),
        isRedirect: a.isRedirect ?? false,
      ),
    );
    switch (decision.action) {
      case DecisionAction.allow:
      case DecisionAction.allowInNewTab:
        return NavigationActionPolicy.ALLOW;
      case DecisionAction.block:
        widget.tabs.update(widget.tab.id, (t) => t.blockedCount++);
        widget.onBlocked(widget.tab.url, decision);
        return NavigationActionPolicy.CANCEL;
      case DecisionAction.askExternal:
        _confirmExternal(target);
        return NavigationActionPolicy.CANCEL;
    }
  }

  Future<bool> _onCreateWindow(InAppWebViewController c, CreateWindowAction a) async {
    final target = a.request.url?.uriValue;
    final decision = widget.protection.onPopup(
      PopupRequestInfo(
        opener: widget.tab.url,
        target: (target == null || target.toString().isEmpty || target.scheme == 'about') ? null : target,
        hasUserGesture: a.hasGesture ?? true,
      ),
    );
    if (decision.isBlocked) {
      widget.tabs.update(widget.tab.id, (t) => t.blockedCount++);
      widget.onBlocked(widget.tab.url, decision);
      return false; // Not handled: the platform discards the window.
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

  Future<void> _onDownload(InAppWebViewController c, DownloadStartRequest r) async {
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
    return InAppWebView(
      key: ValueKey(tab.id),
      windowId: tab.windowId,
      initialUrlRequest: tab.windowId == null ? URLRequest(url: WebUri.uri(tab.initialUrl)) : null,
      initialSettings: _webSettings,
      onWebViewCreated: (c) => widget.commands._c = c,
      onLoadStart: (c, url) => widget.tabs.update(tab.id, (t) {
        t.isLoading = true;
        if (url != null) t.url = url.uriValue;
      }),
      onLoadStop: (c, url) async {
        widget.tabs.update(tab.id, (t) => t.isLoading = false);
        _sync(c, url: url);
        final title = await c.getTitle() ?? '';
        if (url != null) widget.onPageLoaded(url.uriValue, title);
      },
      onProgressChanged: (c, p) => widget.tabs.update(tab.id, (t) => t.progress = p / 100),
      onTitleChanged: (c, title) => widget.tabs.update(tab.id, (t) => t.title = title ?? ''),
      onUpdateVisitedHistory: (c, url, _) => _sync(c, url: url),
      shouldOverrideUrlLoading: _onNavigate,
      onCreateWindow: _onCreateWindow,
      onCloseWindow: (c) => widget.tabs.close(tab.id),
      onDownloadStartRequest: _onDownload,
      onPermissionRequest: _onPermission,
    );
  }
}
