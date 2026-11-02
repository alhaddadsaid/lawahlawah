import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'hls_playlist.dart';

enum DownloadStatus { queued, downloading, done, failed }

/// One downloaded (or downloading) episode.
class DownloadItem {
  DownloadItem({
    required this.contentId,
    required this.title,
    required this.episode,
    required this.source,
    required this.hls,
    this.poster,
    this.status = DownloadStatus.queued,
    this.progress = 0,
    this.bytes = 0,
    this.error,
    this.headers = const {},
  });

  final String contentId;
  final String title;
  final String? poster;
  final int episode;
  final Uri source;

  /// True for a stream (.m3u8) saved as a playlist plus segments.
  final bool hls;
  DownloadStatus status;
  double progress;
  int bytes;
  String? error;

  /// Headers the player used for this video (Referer and so on).
  final Map<String, String> headers;

  String get key => keyFor(contentId, episode);
  static String keyFor(String contentId, int episode) => '$contentId|$episode';

  /// Folder name on disk: safe characters only.
  String get folder => key.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');

  Map<String, dynamic> toJson() => {
    'contentId': contentId,
    'title': title,
    'poster': poster,
    'episode': episode,
    'source': source.toString(),
    'hls': hls,
    'status': status.name,
    'bytes': bytes,
    'headers': headers,
  };

  static DownloadItem? fromJson(Map<String, dynamic> j) {
    final source = Uri.tryParse(j['source'] as String? ?? '');
    if (source == null || j['contentId'] is! String || j['episode'] is! int) return null;
    final status = DownloadStatus.values.asNameMap()[j['status']] ?? DownloadStatus.failed;
    return DownloadItem(
      contentId: j['contentId'] as String,
      title: j['title'] as String? ?? '',
      poster: j['poster'] as String?,
      episode: j['episode'] as int,
      source: source,
      hls: j['hls'] == true,
      // A download cut off by closing the app restarts from the beginning.
      status: status == DownloadStatus.done ? DownloadStatus.done : DownloadStatus.failed,
      progress: status == DownloadStatus.done ? 1 : 0,
      bytes: j['bytes'] as int? ?? 0,
      headers: {
        if (j['headers'] is Map)
          for (final e in (j['headers'] as Map).entries)
            if (e.key is String && e.value is String) e.key as String: e.value as String,
      },
    );
  }
}

/// Saves episodes for watching without internet. MP4 files are saved as they
/// are; HLS streams are saved as their playlist plus every segment (and key),
/// then played through a small server on the phone (127.0.0.1), because the
/// iPhone player only plays HLS from a web address.
class DownloadManager extends ChangeNotifier {
  DownloadManager._();
  static final instance = DownloadManager._();

  final Map<String, DownloadItem> _items = {};
  Directory? _root;
  HttpServer? _server;
  final List<DownloadItem> _queue = [];
  bool _running = false;
  http.Client _client = http.Client();

  @visibleForTesting
  void debugUse({required Directory root, http.Client? client}) {
    _root = root;
    _items.clear();
    if (client != null) _client = client;
  }

  List<DownloadItem> get items => _items.values.toList()..sort((a, b) => a.episode.compareTo(b.episode));

  DownloadItem? itemFor(String contentId, int episode) => _items[DownloadItem.keyFor(contentId, episode)];

  /// Titles that have finished episodes, newest first by insertion.
  List<DownloadItem> get titles {
    final seen = <String, DownloadItem>{};
    for (final item in _items.values) {
      if (item.status == DownloadStatus.done) seen.putIfAbsent(item.contentId, () => item);
    }
    return seen.values.toList();
  }

  List<DownloadItem> episodesOf(String contentId) =>
      items.where((i) => i.contentId == contentId && i.status == DownloadStatus.done).toList();

  Future<Directory> _dir() async {
    final existing = _root;
    if (existing != null) return existing;
    final docs = await getApplicationDocumentsDirectory();
    final root = Directory('${docs.path}/downloads');
    await root.create(recursive: true);
    return _root = root;
  }

  File _index(Directory root) => File('${root.path}/index.json');

  Future<void> load() async {
    try {
      final root = await _dir();
      final file = _index(root);
      if (!await file.exists()) return;
      final data = jsonDecode(await file.readAsString());
      if (data is! List) return;
      for (final j in data.whereType<Map<String, dynamic>>()) {
        final item = DownloadItem.fromJson(j);
        if (item != null) _items[item.key] = item;
      }
      notifyListeners();
    } catch (_) {
      /* A damaged index starts empty; files stay on disk until deleted. */
    }
  }

  Future<void> _save() async {
    final root = await _dir();
    await _index(root).writeAsString(jsonEncode([for (final i in _items.values) i.toJson()]));
  }

  /// Adds an episode to the download queue. [headers] are the ones the
  /// player uses for this video (Referer and so on).
  void start({
    required String contentId,
    required String title,
    String? poster,
    required int episode,
    required Uri video,
    Map<String, String> headers = const {},
  }) {
    final existing = itemFor(contentId, episode);
    if (existing != null &&
        (existing.status == DownloadStatus.done ||
            existing.status == DownloadStatus.downloading ||
            existing.status == DownloadStatus.queued)) {
      return;
    }
    final item = DownloadItem(
      contentId: contentId,
      title: title,
      poster: poster,
      episode: episode,
      source: video,
      hls: video.path.toLowerCase().endsWith('.m3u8'),
      headers: headers,
    );
    _items[item.key] = item;
    _queue.add(item);
    notifyListeners();
    unawaited(_save());
    unawaited(_run());
  }

  Future<void> _run() async {
    if (_running) return;
    _running = true;
    try {
      while (_queue.isNotEmpty) {
        final item = _queue.removeAt(0);
        item.status = DownloadStatus.downloading;
        item.error = null;
        notifyListeners();
        try {
          final folder = Directory('${(await _dir()).path}/${item.folder}');
          if (await folder.exists()) await folder.delete(recursive: true);
          await folder.create(recursive: true);
          final headers = item.headers;
          if (item.hls) {
            await _downloadHls(item, folder, headers);
          } else {
            await _downloadFile(item, item.source, File('${folder.path}/video.mp4'), headers, track: true);
          }
          item.status = DownloadStatus.done;
          item.progress = 1;
        } catch (e) {
          item.status = DownloadStatus.failed;
          item.error = e is FormatException ? e.message : 'The download stopped. Check your connection and try again.';
        }
        notifyListeners();
        await _save();
      }
    } finally {
      _running = false;
    }
  }

  Future<String> _text(Uri url, Map<String, String> headers) async {
    final response = await _client.get(url, headers: headers).timeout(const Duration(seconds: 30));
    if (response.statusCode != 200) throw HttpException('HTTP ${response.statusCode}', uri: url);
    return utf8.decode(response.bodyBytes, allowMalformed: true);
  }

  Future<void> _downloadHls(DownloadItem item, Directory folder, Map<String, String> headers) async {
    var url = item.source;
    var text = await _text(url, headers);
    if (HlsPlaylist.isMaster(text)) {
      final variant = HlsPlaylist.pick(HlsPlaylist.variants(url, text));
      if (variant == null) throw const FormatException('This stream has no playable quality.');
      url = variant.uri;
      text = await _text(url, headers);
    }
    final media = HlsPlaylist.media(url, text);
    var done = 0;
    var next = 0;
    Future<void> worker() async {
      while (next < media.files.length) {
        final file = media.files[next++];
        await _downloadFile(item, file.uri, File('${folder.path}/${file.name}'), headers);
        done++;
        item.progress = done / media.files.length;
        notifyListeners();
      }
    }

    await Future.wait([for (var i = 0; i < 4; i++) worker()]);
    await File('${folder.path}/index.m3u8').writeAsString(media.localPlaylist);
  }

  Future<void> _downloadFile(
    DownloadItem item,
    Uri url,
    File file,
    Map<String, String> headers, {
    bool track = false,
  }) async {
    for (var attempt = 0; ; attempt++) {
      try {
        final request = http.Request('GET', url)..headers.addAll(headers);
        final response = await _client.send(request).timeout(const Duration(seconds: 30));
        if (response.statusCode != 200) throw HttpException('HTTP ${response.statusCode}', uri: url);
        final total = response.contentLength ?? 0;
        final sink = file.openWrite();
        var received = 0;
        try {
          await for (final chunk in response.stream.timeout(const Duration(seconds: 30))) {
            sink.add(chunk);
            received += chunk.length;
            item.bytes += chunk.length;
            if (track && total > 0) {
              item.progress = received / total;
              notifyListeners();
            }
          }
        } finally {
          await sink.close();
        }
        return;
      } catch (_) {
        if (attempt >= 2) rethrow;
        await Future<void>.delayed(Duration(seconds: 1 + attempt));
      }
    }
  }

  /// Where the player reads a finished download: a file for MP4, the local
  /// server address for HLS. Null when the episode is not downloaded.
  Future<({Uri? url, File? file})?> playbackFor(String contentId, int episode) async {
    final item = itemFor(contentId, episode);
    if (item == null || item.status != DownloadStatus.done) return null;
    final folder = '${(await _dir()).path}/${item.folder}';
    if (!item.hls) {
      final file = File('$folder/video.mp4');
      return await file.exists() ? (url: null, file: file) : null;
    }
    if (!await File('$folder/index.m3u8').exists()) return null;
    final server = await _serve();
    return (url: Uri.parse('http://127.0.0.1:${server.port}/${item.folder}/index.m3u8'), file: null);
  }

  /// Serves the downloads folder to the player, on this phone only.
  Future<HttpServer> _serve() async {
    final running = _server;
    if (running != null) return running;
    final root = await _dir();
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      final path = Uri.decodeComponent(request.uri.path);
      final file = File('${root.path}$path');
      // Only files inside the downloads folder.
      if (path.contains('..') || !await file.exists()) {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        return;
      }
      request.response.headers.contentType = ContentType.parse(_type(path));
      await request.response.addStream(file.openRead());
      await request.response.close();
    });
    return _server = server;
  }

  static String _type(String path) {
    final p = path.toLowerCase();
    if (p.endsWith('.m3u8')) return 'application/vnd.apple.mpegurl';
    if (p.endsWith('.ts')) return 'video/mp2t';
    if (p.endsWith('.m4s') || p.endsWith('.mp4')) return 'video/mp4';
    if (p.endsWith('.aac')) return 'audio/aac';
    if (p.endsWith('.vtt')) return 'text/vtt';
    return 'application/octet-stream';
  }

  Future<void> delete(String contentId, int episode) async {
    final item = _items.remove(DownloadItem.keyFor(contentId, episode));
    if (item == null) return;
    _queue.remove(item);
    notifyListeners();
    final folder = Directory('${(await _dir()).path}/${item.folder}');
    if (await folder.exists()) await folder.delete(recursive: true);
    await _save();
  }

  /// Puts a failed download back in the queue.
  void retry(String contentId, int episode) {
    final item = itemFor(contentId, episode);
    if (item == null || item.status != DownloadStatus.failed) return;
    item.status = DownloadStatus.queued;
    item.progress = 0;
    item.bytes = 0;
    _queue.add(item);
    notifyListeners();
    unawaited(_run());
  }
}
