import '../../data/models/models.dart';
import '../site_adapter.dart';
import 'narto_drama_config.dart';

/// Narto-Drama adapter: DEVELOPMENT TEST TARGET.
///
/// Runs in debug builds so the integration can be built and tested on the
/// developer's device. In release builds the registry keeps it off unless
/// NartoDramaConfig.permission is documented, so it cannot ship by accident.
///
/// Rules that apply in every build: read only pages the user opened in the
/// in-app browser; never bypass CAPTCHA, Cloudflare/anti-bot checks, logins
/// or DRM; if a stream is not directly playable, return null and the user
/// keeps watching in the site's own page.
///
/// Parsers are still stubs: they get written once the site's page
/// structure has been inspected.
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
