/// Core data entities (spec section 8). Plain immutable classes with JSON
/// round-tripping so they can be persisted locally and mirrored as FlutterFlow
/// custom data types.
library;

enum IntegrationStatus {
  /// No adapter: the site is browsed as a normal web page.
  browserOnly,

  /// An adapter exists but is switched off until permission is documented.
  pendingPermission,

  /// Adapter active; catalogue features available.
  integrated,
}

enum ContentCategory { movie, series }

class Website {
  const Website({
    required this.id,
    required this.name,
    required this.url,
    required this.dateAdded,
    this.favicon,
    this.lastVisited,
    this.integrationStatus = IntegrationStatus.browserOnly,
  });

  final String id;
  final String name;
  final String url;
  final String? favicon;
  final DateTime dateAdded;
  final DateTime? lastVisited;
  final IntegrationStatus integrationStatus;

  String get host => Uri.tryParse(url)?.host ?? url;

  Website copyWith({String? name, DateTime? lastVisited, IntegrationStatus? integrationStatus}) => Website(
    id: id,
    name: name ?? this.name,
    url: url,
    favicon: favicon,
    dateAdded: dateAdded,
    lastVisited: lastVisited ?? this.lastVisited,
    integrationStatus: integrationStatus ?? this.integrationStatus,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'url': url,
    'favicon': favicon,
    'dateAdded': dateAdded.toIso8601String(),
    'lastVisited': lastVisited?.toIso8601String(),
    'integrationStatus': integrationStatus.name,
  };

  factory Website.fromJson(Map<String, dynamic> j) => Website(
    id: j['id'] as String,
    name: j['name'] as String,
    url: j['url'] as String,
    favicon: j['favicon'] as String?,
    dateAdded: DateTime.parse(j['dateAdded'] as String),
    lastVisited: j['lastVisited'] == null ? null : DateTime.parse(j['lastVisited'] as String),
    integrationStatus: IntegrationStatus.values.byName(j['integrationStatus'] as String),
  );
}

class Content {
  const Content({
    required this.id,
    required this.title,
    required this.category,
    required this.sourceWebsiteId,
    required this.sourcePageUrl,
    this.description,
    this.poster,
    this.releaseYear,
    this.genres = const [],
    this.isSample = false,
  });

  final String id;
  final String title;
  final String? description;
  final String? poster;
  final int? releaseYear;
  final List<String> genres;
  final ContentCategory category;
  final String sourceWebsiteId;
  final String sourcePageUrl;

  /// True for UI-development placeholder data. Sample items must never ship
  /// in a release build (see SampleData and docs/COMPLIANCE_CHECKLIST.md).
  final bool isSample;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'poster': poster,
    'releaseYear': releaseYear,
    'genres': genres,
    'category': category.name,
    'sourceWebsiteId': sourceWebsiteId,
    'sourcePageUrl': sourcePageUrl,
  };

  factory Content.fromJson(Map<String, dynamic> j) => Content(
    id: j['id'] as String,
    title: j['title'] as String,
    description: j['description'] as String?,
    poster: j['poster'] as String?,
    releaseYear: j['releaseYear'] as int?,
    genres: (j['genres'] as List?)?.cast<String>() ?? const [],
    category: ContentCategory.values.byName(j['category'] as String),
    sourceWebsiteId: j['sourceWebsiteId'] as String,
    sourcePageUrl: j['sourcePageUrl'] as String,
  );
}

class Episode {
  const Episode({
    required this.id,
    required this.seriesId,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.sourcePageUrl,
    this.title,
  });

  final String id;
  final String seriesId;
  final int seasonNumber;
  final int episodeNumber;
  final String? title;
  final String sourcePageUrl;

  String get code => 'S${seasonNumber.toString().padLeft(2, '0')}E${episodeNumber.toString().padLeft(2, '0')}';
}

class WatchHistory {
  const WatchHistory({
    required this.id,
    required this.contentId,
    required this.sourceUrl,
    required this.playbackPosition,
    required this.duration,
    required this.lastWatched,
    this.episodeId,
  });

  final String id;
  final String contentId;
  final String? episodeId;
  final String sourceUrl;
  final Duration playbackPosition;
  final Duration duration;
  final DateTime lastWatched;

  double get progress =>
      duration.inMilliseconds <= 0 ? 0 : (playbackPosition.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);

  /// Considered finished once 95% has been watched.
  bool get isFinished => progress >= 0.95;
}

class Bookmark {
  const Bookmark({required this.id, required this.title, required this.url, required this.dateAdded});

  final String id;
  final String title;
  final String url;
  final DateTime dateAdded;

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'url': url, 'dateAdded': dateAdded.toIso8601String()};

  factory Bookmark.fromJson(Map<String, dynamic> j) => Bookmark(
    id: j['id'] as String,
    title: j['title'] as String,
    url: j['url'] as String,
    dateAdded: DateTime.parse(j['dateAdded'] as String),
  );
}

class VisitedPage {
  const VisitedPage({required this.url, required this.title, required this.visitedAt});

  final String url;
  final String title;
  final DateTime visitedAt;

  Map<String, dynamic> toJson() => {'url': url, 'title': title, 'visitedAt': visitedAt.toIso8601String()};

  factory VisitedPage.fromJson(Map<String, dynamic> j) => VisitedPage(
    url: j['url'] as String,
    title: j['title'] as String,
    visitedAt: DateTime.parse(j['visitedAt'] as String),
  );
}
