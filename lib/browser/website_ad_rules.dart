import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'site_profiles.dart';

/// Common advertising networks. Also used to ignore ad videos when the
/// browser looks for the video a page is playing.
const adNetworkHosts = [
  'doubleclick.net',
  'googlesyndication.com',
  'googleadservices.com',
  'popads.net',
  'popcash.net',
  'adsterra.com',
  'exoclick.com',
  'onclickads.net',
  'clickadu.com',
];

/// The EasyList ad domains bundled in assets/adblock (about 46,000, refreshed
/// with tools/update_ad_list.dart). Loaded once at start-up.
abstract final class AdDomains {
  static const asset = 'assets/adblock/easylist_domains.txt';
  static Set<String> _all = const {};

  static Future<void> load() async {
    try {
      _all = parse(await rootBundle.loadString(asset));
    } catch (_) {
      _all = const {}; // The short built-in list still applies.
    }
    _rules = null;
  }

  static Set<String> parse(String text) => {
    for (final line in const LineSplitter().convert(text))
      if (line.trim().isNotEmpty && !line.startsWith('#')) line.trim().toLowerCase(),
  };

  @visibleForTesting
  static set domains(Set<String> value) {
    _all = value;
    _rules = null;
  }

  static int get count => _all.length;

  /// Whether [host] or one of its parent domains serves ads.
  static bool isAdHost(String host) {
    var h = host.toLowerCase();
    while (true) {
      if (_all.contains(h) || adNetworkHosts.contains(h)) return true;
      final dot = h.indexOf('.');
      if (dot < 0) return false;
      h = h.substring(dot + 1);
    }
  }

  static List<ContentBlocker>? _rules;
}

ContentBlocker _block(String host) => ContentBlocker(
  trigger: ContentBlockerTrigger(urlFilter: '^https?://([^/]*\\.)?${RegExp.escape(host)}[/:]'),
  action: ContentBlockerAction(type: ContentBlockerActionType.BLOCK),
);

/// Browser request rules for advertising networks. On iOS WebKit compiles the
/// whole EasyList set once per tab; Android's plugin checks every rule on every
/// request, so it keeps the short list. Ads served by a site itself (including
/// YouTube video ads) are not removed by these rules.
///
/// Sites with an ads exception (admin "Website's own ads") come last: on
/// their pages every earlier rule is ignored, so they work as in any browser.
List<ContentBlocker> browserAdRules() {
  final full = defaultTargetPlatform == TargetPlatform.iOS && AdDomains.count > 0;
  final rules = full
      ? AdDomains._rules ??= [
          for (final host in {...adNetworkHosts, ...AdDomains._all}) _block(host),
        ]
      : [for (final host in adNetworkHosts) _block(host)];
  final allowed = SiteProfiles.adsAllowedSites();
  if (allowed.isEmpty) return rules;
  return [
    ...rules,
    ContentBlocker(
      trigger: ContentBlockerTrigger(urlFilter: '.*', ifDomain: [for (final d in allowed) '*$d']),
      action: ContentBlockerAction(type: ContentBlockerActionType.IGNORE_PREVIOUS_RULES),
    ),
  ];
}
