/// Popup and redirect protection (spec section 5).
///
/// Pure Dart with no WebView dependency, so every decision is unit-tested.
/// The WebView layer (browser_view.dart) translates platform callbacks into
/// [NavigationRequestInfo] / [PopupRequestInfo] and obeys the [Decision].
///
/// Design rules:
///  * Never block JavaScript or third-party requests wholesale.
///  * Never inject, replace or alter a site's own content or ads.
///  * Navigation the user started (tap/click) is allowed.
///  * Everything blocked is logged and can be allowed per site by the user.
library;

import '../core/security/url_policy.dart';

enum ProtectionLevel {
  /// No filtering beyond the always-on scheme safety rules.
  off,

  /// Blocks popups without a user gesture, cross-site automatic redirects of
  /// the main page, and known malicious destinations. Default.
  balanced,

  /// Also blocks popups that do have a gesture (sites can still be allowed).
  strict,
}

enum DecisionAction { allow, allowInNewTab, block, askExternal }

class Decision {
  const Decision._(this.action, this.reason, [this.target]);
  const Decision.allow() : this._(DecisionAction.allow, null);
  const Decision.allowInNewTab() : this._(DecisionAction.allowInNewTab, null);
  const Decision.block(String reason, [Uri? target]) : this._(DecisionAction.block, reason, target);
  const Decision.askExternal() : this._(DecisionAction.askExternal, null);

  final DecisionAction action;
  final String? reason;

  /// For a block: where the page tried to go (null for a blank pop-up), so
  /// the user can still choose to open it.
  final Uri? target;

  bool get isBlocked => action == DecisionAction.block;

  @override
  String toString() => 'Decision($action${reason == null ? '' : ': $reason'})';
}

/// What the user's most recent tap (within ~2 s) actually pressed, as seen
/// by a read-only click listener in the page. Ad scripts hijack real taps,
/// so a tap alone does not prove the user chose the destination.
class TapInfo {
  const TapInfo.link(Uri this.href) : onLink = true;
  const TapInfo.nonLink() : href = null, onLink = false;

  /// The link's own address, when the tap was on a link.
  final Uri? href;
  final bool onLink;
}

class NavigationRequestInfo {
  const NavigationRequestInfo({
    required this.target,
    required this.isMainFrame,
    required this.hasUserGesture,
    this.current,
    this.isRedirect = false,
    this.tap,
  });

  /// The page currently shown in the tab (null on the first load).
  final Uri? current;
  final Uri target;
  final bool isMainFrame;
  final bool hasUserGesture;
  final bool isRedirect;

  /// Null when unknown (no recent tap seen, or the listener is unavailable).
  final TapInfo? tap;
}

class PopupRequestInfo {
  const PopupRequestInfo({required this.opener, required this.target, required this.hasUserGesture, this.tap});
  final Uri opener;

  /// Null when the page opens a blank window and fills it in afterwards.
  final Uri? target;
  final bool hasUserGesture;
  final TapInfo? tap;
}

class BlockedEvent {
  const BlockedEvent({required this.site, required this.target, required this.reason, required this.at});
  final String site;
  final String target;
  final String reason;
  final DateTime at;
}

class PopupProtection {
  PopupProtection({
    this.level = ProtectionLevel.balanced,
    Set<String>? allowedSites,
    Set<String>? blocklist,
    this.maxLogEntries = 200,
  }) : allowedSites = allowedSites ?? <String>{},
       blocklist = blocklist ?? defaultBlocklist;

  ProtectionLevel level;

  /// Registrable domains the user chose to exempt from popup/redirect rules.
  final Set<String> allowedSites;

  /// Host suffixes always refused. Seed list only; production should load a
  /// maintained, licence-compatible list and update it regularly.
  final Set<String> blocklist;

  final int maxLogEntries;
  final List<BlockedEvent> _log = [];
  final Set<String> _allowOnce = {};

  /// Lets the next navigation to [url] through once, when the user chose
  /// "Open anyway" on something that was blocked.
  void allowOnce(Uri url) => _allowOnce.add(url.toString());

  List<BlockedEvent> get log => List.unmodifiable(_log);
  int blockedCountFor(String site) => _log.where((e) => e.site == site).length;

  /// A small illustrative seed of hosts associated with forced popunders and
  /// redirect chains. Replace with a maintained list before release.
  static const defaultBlocklist = <String>{
    'popads.net',
    'popcash.net',
    'propellerads.com',
    'adsterra.com',
    'exoclick.com',
    'onclickads.net',
    'clickadu.com',
    'hilltopads.net',
    // Seen in a pop-under script on narto-drama.com (Nov 2026).
    'quitedrench.org',
    'omg10.com',
    'bony-teaching.com',
    'auctionr.org',
    'topatowedels.com',
    'pupibujisareni.com',
  };

  // ---------------------------------------------------------------------------

  Decision onNavigation(NavigationRequestInfo r) {
    final kind = UrlPolicy.classify(r.target);
    if (kind == NavigationKind.blocked) {
      return _block(r.current ?? r.target, r.target, 'Unsafe link type "${r.target.scheme}:"');
    }
    if (kind == NavigationKind.external) {
      // Apps such as mail or the phone dialler open only after user confirmation,
      // and only when the user actually tapped something.
      if (!r.hasUserGesture && level != ProtectionLevel.off) {
        return _block(r.current ?? r.target, r.target, 'Page tried to open another app automatically');
      }
      return const Decision.askExternal();
    }
    if (r.target.scheme == 'about') return const Decision.allow();
    if (_allowOnce.remove(r.target.toString())) return const Decision.allow();

    if (level == ProtectionLevel.off) return const Decision.allow();

    if (isBlocklisted(r.target.host)) {
      return _block(r.current ?? r.target, r.target, 'Known unwanted ad or redirect destination');
    }

    // Sub-frames (embedded players, comment widgets) are left alone so pages
    // keep working; only blocklisted hosts are stopped above.
    if (!r.isMainFrame) return const Decision.allow();

    final current = r.current;
    if (current == null || current.scheme == 'about') return const Decision.allow();
    if (_isAllowedSite(current)) return const Decision.allow();
    if (sameSite(current, r.target)) return const Decision.allow();

    // From here on the main page is leaving for a different site.
    if (!r.hasUserGesture) {
      return _block(current, r.target, 'Automatic redirect to another site');
    }
    final tap = r.tap;
    if (tap != null) {
      // Click-hijacking: the user pressed a link to one place, the page sent
      // them somewhere else (usually an ad).
      final href = tap.href;
      if (tap.onLink && href != null && !sameSite(href, r.target)) {
        return _block(current, r.target, 'Tap on a link was redirected to an ad');
      }
      // A tap on a picture, button or empty space that sends the page to
      // another site is the typical full-page ad overlay.
      if (!tap.onLink) {
        return _block(current, r.target, 'Tap was turned into a jump to another site');
      }
    }
    return const Decision.allow();
  }

  Decision onPopup(PopupRequestInfo r) {
    final target = r.target;
    if (target != null && UrlPolicy.classify(target) == NavigationKind.blocked) {
      return _block(r.opener, target, 'Unsafe link type "${target.scheme}:"');
    }
    if (level == ProtectionLevel.off) return const Decision.allowInNewTab();
    if (target != null && isBlocklisted(target.host)) {
      return _block(r.opener, target, 'Known unwanted ad or redirect destination');
    }
    if (_isAllowedSite(r.opener)) return const Decision.allowInNewTab();
    if (!r.hasUserGesture) {
      return _block(r.opener, target, 'Pop-up opened without a tap');
    }
    if (level == ProtectionLevel.strict) {
      return _block(r.opener, target, 'Pop-ups are blocked in Strict mode');
    }
    // A blank window opened on a tap is the classic pop-under: it is filled
    // with an ad right after opening, so its destination cannot be checked.
    if (target == null) {
      return _block(r.opener, null, 'Blank pop-up window opened by a tap');
    }
    if (sameSite(r.opener, target)) return const Decision.allowInNewTab();
    // A real "open in new tab" link: the pressed link points to that site.
    final href = r.tap?.href;
    if (href != null && sameSite(href, target)) return const Decision.allowInNewTab();
    return _block(r.opener, target, 'Pop-up to another site');
  }

  // ---------------------------------------------------------------------------

  /// After blocking an ad that rode on a tap, where the user actually meant
  /// to go: the pressed link, when it is a web link on the current site.
  /// Ad scripts cancel the tap itself, so without this the tap does nothing.
  static Uri? intendedDestination(Uri current, TapInfo? tap) {
    final href = tap?.href;
    if (href == null || UrlPolicy.classify(href) != NavigationKind.web || href.scheme == 'about') return null;
    if (!sameSite(current, href)) return null;
    if (href.removeFragment() == current.removeFragment()) return null;
    return href;
  }

  /// Whether a main-page load without a tap is the server forwarding the
  /// user's own navigation (Google result links, short links): it happens
  /// while the page the user opened is still loading, shortly after.
  static bool isRedirectOfUserNavigation({
    required bool loading,
    required DateTime? userNavAt,
    required DateTime now,
  }) => loading && userNavAt != null && now.difference(userNavAt) < const Duration(seconds: 8);

  /// Whether a main-page load is the WebView replaying a pop-up that was just
  /// refused: the same address, or any blank page when the refused pop-up
  /// was blank ([refused] null).
  static bool isRefusedPopupLoad({required Uri? refused, required Uri? target}) {
    final blank = target == null || target.toString().isEmpty || target.scheme == 'about';
    if (refused == null) return blank;
    return target != null && target.removeFragment() == refused.removeFragment();
  }

  void allowSite(Uri uri) => allowedSites.add(registrableDomain(uri.host));
  void disallowSite(String domain) => allowedSites.remove(domain);
  bool _isAllowedSite(Uri uri) => allowedSites.contains(registrableDomain(uri.host));

  bool isBlocklisted(String host) {
    final h = host.toLowerCase();
    return blocklist.any((b) => h == b || h.endsWith('.$b'));
  }

  Decision _block(Uri site, Uri? target, String reason) {
    _log.insert(
      0,
      BlockedEvent(
        site: registrableDomain(site.host),
        target: target?.toString() ?? '(blank window)',
        reason: reason,
        at: DateTime.now(),
      ),
    );
    if (_log.length > maxLogEntries) _log.removeLast();
    return Decision.block(reason, target);
  }

  void clearLog() => _log.clear();

  // ---------------------------------------------------------------------------

  static bool sameSite(Uri a, Uri b) => registrableDomain(a.host) == registrableDomain(b.host);

  /// Common two-part public suffixes. A heuristic, not the full Public Suffix
  /// List; see docs/ROADMAP.md (bundle the PSL before release).
  static const _twoPartSuffixes = {
    'co.uk',
    'org.uk',
    'ac.uk',
    'gov.uk',
    'com.au',
    'net.au',
    'co.nz',
    'co.jp',
    'co.kr',
    'com.br',
    'com.mx',
    'com.tr',
    'com.sa',
    'com.eg',
    'co.za',
    'co.in',
    'com.cn',
    'com.tw',
    'com.hk',
    'co.ma',
  };

  static String registrableDomain(String host) {
    final h = host.toLowerCase().replaceAll(RegExp(r'\.$'), '');
    if (h.isEmpty || RegExp(r'^\d{1,3}(\.\d{1,3}){3}$').hasMatch(h) || h.contains(':')) return h;
    final parts = h.split('.');
    if (parts.length <= 2) return h;
    final lastTwo = '${parts[parts.length - 2]}.${parts.last}';
    if (_twoPartSuffixes.contains(lastTwo)) return parts.sublist(parts.length - 3).join('.');
    return lastTwo;
  }
}
