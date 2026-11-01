import 'package:flutter/foundation.dart';

import '../data/models/models.dart';
import 'narto_drama/narto_drama_adapter.dart';
import 'site_adapter.dart';

/// Holds all known adapters and decides which may run.
///
/// Two modes:
///  * Development (debug builds): any adapter may run on the developer's
///    own device for building and testing, shown as `devTesting`.
///  * Release (store builds): an adapter runs only when its permission is
///    documented ([AdapterPermission.canActivate]). This is the gate that
///    must hold before distribution; see docs/COMPLIANCE_CHECKLIST.md.
class AdapterRegistry {
  AdapterRegistry({List<SiteAdapter>? adapters, bool? developmentMode})
    : _adapters = adapters ?? [NartoDramaAdapter()],
      developmentMode = developmentMode ?? kDebugMode;

  final List<SiteAdapter> _adapters;

  /// True only in debug builds by default. Never true in a release build.
  final bool developmentMode;

  List<SiteAdapter> get all => List.unmodifiable(_adapters);

  bool _mayRun(SiteAdapter a) => a.permission.canActivate || developmentMode;

  /// The adapter allowed to run for [url], or null (plain browser, no
  /// catalogue extraction).
  SiteAdapter? activeFor(Uri url) {
    for (final a in _adapters) {
      if (a.matches(url) && _mayRun(a)) return a;
    }
    return null;
  }

  IntegrationStatus statusFor(Uri url) {
    final match = _adapters.where((a) => a.matches(url)).firstOrNull;
    if (match == null) return IntegrationStatus.browserOnly;
    if (match.permission.canActivate) return IntegrationStatus.integrated;
    return developmentMode ? IntegrationStatus.devTesting : IntegrationStatus.pendingPermission;
  }
}
