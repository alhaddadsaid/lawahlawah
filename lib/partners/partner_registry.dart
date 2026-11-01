import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'partner_agreement.dart';
import 'partners.dart';

/// The partner agreements in force, and the page script that applies them.
class PartnerRegistry {
  PartnerRegistry({List<PartnerAgreement>? agreements, bool? testBuild, DateTime Function()? clock})
    : agreements = agreements ?? Partners.all,
      testBuild = testBuild ?? (kDebugMode || Partners.testPartnerBuild),
      _clock = clock ?? DateTime.now;

  final List<PartnerAgreement> agreements;

  /// Development and test builds also run the test agreement.
  final bool testBuild;
  final DateTime Function() _clock;

  /// Agreements whose rules run today.
  List<PartnerAgreement> get inForce {
    final now = _clock();
    return agreements.where((a) => a.isInForce(now, testBuild: testBuild)).toList();
  }

  /// The agreement in force for [url], or null: the site is browsed as it is.
  PartnerAgreement? inForceFor(Uri url) => inForce.where((a) => a.covers(url)).firstOrNull;

  /// One page script for all agreements in force, or null when none has a
  /// rule to run. It checks the page's own host first, so nothing runs on any
  /// other website.
  String? get pageScript => buildPageScript(inForce);

  static String? buildPageScript(List<PartnerAgreement> agreements) {
    final rules = <String>[];
    for (final a in agreements) {
      final hide = a.allowsHidingAds ? a.hideSelectors : const <String>[];
      final css = hide.isEmpty ? null : '${hide.join(', ')} { display: none !important; }';
      final unlock = a.allowsSkippingAdGate ? a.unlockScript : null;
      if (css == null && unlock == null) continue;
      final fn = unlock == null ? 'null' : 'function () {\n$unlock\n}';
      rules.add('{domains: ${jsonEncode(a.domains)}, css: ${jsonEncode(css)}, unlock: $fn}');
    }
    if (rules.isEmpty) return null;
    return _runner.replaceFirst('RULES', '[\n${rules.join(',\n')}\n]');
  }

  static const _runner = r'''
(function () {
  if (window.__rwPartner) return;
  window.__rwPartner = true;
  var host = location.hostname;
  var covers = function (d) { return host === d || host.slice(-d.length - 1) === '.' + d; };
  RULES.forEach(function (r) {
    if (!r.domains.some(covers)) return;
    if (r.css) {
      var s = document.createElement('style');
      s.textContent = r.css;
      (document.head || document.documentElement).appendChild(s);
    }
    if (!r.unlock) return;
    var pending = false;
    var run = function () {
      pending = false;
      try { r.unlock(); } catch (e) {}
    };
    var later = function () {
      if (pending) return;
      pending = true;
      setTimeout(run, 300);
    };
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', run);
    else run();
    new MutationObserver(later).observe(document.documentElement, { childList: true, subtree: true });
  });
})();
''';
}
