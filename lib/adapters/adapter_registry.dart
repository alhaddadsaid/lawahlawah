import '../data/models/models.dart';
import 'narto_drama/narto_drama_adapter.dart';
import 'site_adapter.dart';

/// Holds all known adapters and decides which may run.
class AdapterRegistry {
  AdapterRegistry([List<SiteAdapter>? adapters]) : _adapters = adapters ?? [NartoDramaAdapter()];

  final List<SiteAdapter> _adapters;

  List<SiteAdapter> get all => List.unmodifiable(_adapters);

  /// The active adapter for [url], or null if none exists or its permission
  /// is not documented. Null means: plain browser, no catalogue extraction.
  SiteAdapter? activeFor(Uri url) {
    for (final a in _adapters) {
      if (a.matches(url) && a.permission.canActivate) return a;
    }
    return null;
  }

  IntegrationStatus statusFor(Uri url) {
    final match = _adapters.where((a) => a.matches(url)).firstOrNull;
    if (match == null) return IntegrationStatus.browserOnly;
    return match.permission.canActivate ? IntegrationStatus.integrated : IntegrationStatus.pendingPermission;
  }
}
