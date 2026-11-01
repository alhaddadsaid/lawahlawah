import '../models/models.dart';

/// UI-DEVELOPMENT SAMPLE DATA (spec phase 1).
///
/// Every title here is invented. These items exist only so screens can be
/// designed and tested, and they load only in debug builds (see AppState).
/// They are not real catalogue entries and must never ship.
abstract final class SampleData {
  static const sampleSiteId = 'sample-site';

  static final website = Website(
    id: sampleSiteId,
    name: 'Sample Site',
    url: 'https://example.com',
    dateAdded: DateTime(2026, 10, 1),
    lastVisited: DateTime(2026, 10, 31),
  );

  static Content _c(String id, String title, ContentCategory cat, int year, List<String> genres, String desc) =>
      Content(
        id: id,
        title: title,
        category: cat,
        releaseYear: year,
        genres: genres,
        description: desc,
        sourceWebsiteId: sampleSiteId,
        sourcePageUrl: 'https://example.com/title/$id',
        isSample: true,
      );

  static final content = <Content>[
    _c('s1', 'The Lantern Keeper', ContentCategory.series, 2025, [
      'Drama',
      'Mystery',
    ], 'In a harbour town where the lights never go out, a young keeper finds a letter that should not exist.'),
    _c('s2', 'Orbit of Glass', ContentCategory.movie, 2024, [
      'Sci-Fi',
    ], 'Two engineers aboard a failing station must decide who goes home.'),
    _c('s3', 'Salt & Cedar', ContentCategory.series, 2023, [
      'Romance',
      'Drama',
    ], 'Rival bakers on the same street, one summer, and a competition neither can afford to lose.'),
    _c('s4', 'Midnight Ledger', ContentCategory.movie, 2025, [
      'Thriller',
      'Crime',
    ], 'An accountant notices one number that changes everything.'),
    _c('s5', 'Paper Cranes', ContentCategory.series, 2022, [
      'Family',
      'Drama',
    ], 'Three generations, one house, and the folded notes hidden in its walls.'),
    _c('s6', 'Northbound', ContentCategory.movie, 2023, [
      'Adventure',
    ], 'A road trip to return a borrowed dog turns into the journey of a lifetime.'),
    _c('s7', 'Echo Valley', ContentCategory.series, 2026, [
      'Mystery',
      'Thriller',
    ], 'Every sound in the valley repeats — except the one that matters.'),
    _c('s8', 'Kintsugi', ContentCategory.movie, 2021, ['Drama'], 'A potter repairs bowls and, slowly, herself.'),
    _c('s9', 'Static Hearts', ContentCategory.series, 2024, [
      'Romance',
      'Comedy',
    ], 'Two late-night radio hosts who have never met fall for each other on air.'),
    _c('s10', 'The Last Tram', ContentCategory.movie, 2026, [
      'Fantasy',
    ], 'The final tram of the night stops at a station that is not on any map.'),
  ];

  static List<WatchHistory> history() {
    final now = DateTime.now();
    return [
      WatchHistory(
        id: 'h1',
        contentId: 's1',
        episodeId: 's1-e4',
        sourceUrl: 'https://example.com/title/s1',
        playbackPosition: const Duration(minutes: 31),
        duration: const Duration(minutes: 52),
        lastWatched: now.subtract(const Duration(hours: 3)),
      ),
      WatchHistory(
        id: 'h2',
        contentId: 's4',
        sourceUrl: 'https://example.com/title/s4',
        playbackPosition: const Duration(minutes: 72),
        duration: const Duration(minutes: 118),
        lastWatched: now.subtract(const Duration(days: 1)),
      ),
      WatchHistory(
        id: 'h3',
        contentId: 's9',
        episodeId: 's9-e2',
        sourceUrl: 'https://example.com/title/s9',
        playbackPosition: const Duration(minutes: 9),
        duration: const Duration(minutes: 45),
        lastWatched: now.subtract(const Duration(days: 2)),
      ),
      WatchHistory(
        id: 'h4',
        contentId: 's6',
        sourceUrl: 'https://example.com/title/s6',
        playbackPosition: const Duration(minutes: 101),
        duration: const Duration(minutes: 104),
        lastWatched: now.subtract(const Duration(days: 4)),
      ),
    ];
  }

  static List<Episode> episodesFor(String seriesId) => List.generate(
    8,
    (i) => Episode(
      id: '$seriesId-e${i + 1}',
      seriesId: seriesId,
      seasonNumber: 1,
      episodeNumber: i + 1,
      title: 'Episode ${i + 1}',
      sourcePageUrl: 'https://example.com/title/$seriesId/1/${i + 1}',
    ),
  );
}
