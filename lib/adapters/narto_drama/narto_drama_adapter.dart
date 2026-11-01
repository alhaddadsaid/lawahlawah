import '../../data/models/models.dart';
import '../site_adapter.dart';
import 'narto_drama_config.dart';

/// Narto-Drama adapter: LOCKED STUB.
///
/// Per spec phase 4, this adapter must not parse anything until:
///  1. The site's integration permission is documented (NartoDramaConfig.permission).
///  2. The site's rights to the content it serves are confirmed.
///  3. Its page structure has been inspected and the parsers below written
///     against it, with tests using saved, permitted sample pages.
///
/// Until then the registry keeps it inactive and the site behaves as a normal
/// browser page.
class NartoDramaAdapter extends SiteAdapter {
  @override
  String get id => 'narto-drama';

  @override
  String get displayName => 'Narto-Drama';

  @override
  List<String> get domains => NartoDramaConfig.domains;

  @override
  AdapterPermission get permission => NartoDramaConfig.permission;

  @override
  PageKind classify(Uri url) => PageKind.other;

  @override
  Future<List<Content>> parseCatalogue(PageSnapshot page) async => const [];

  @override
  Future<Content?> parseMovie(PageSnapshot page) async => null;

  @override
  Future<Content?> parseSeries(PageSnapshot page) async => null;

  @override
  Future<List<Episode>> parseEpisodes(PageSnapshot page, String seriesId) async => const [];

  @override
  Future<PlaybackSource?> resolvePlayback(PageSnapshot page) async => null;
}
