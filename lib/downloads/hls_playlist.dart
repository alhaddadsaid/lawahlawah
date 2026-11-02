/// Reads HLS playlists (.m3u8) for offline downloads. Pure functions, so they
/// can be tested without a network.
library;

/// One quality in a master playlist.
class HlsVariant {
  const HlsVariant({required this.uri, this.bandwidth = 0, this.height = 0});
  final Uri uri;
  final int bandwidth;
  final int height;
}

/// A file a media playlist needs: a segment, its encryption key or its init
/// segment, with the local name it is saved under.
class HlsFile {
  const HlsFile({required this.uri, required this.name});
  final Uri uri;
  final String name;
}

/// A media playlist rewritten to point at local files.
class HlsMedia {
  const HlsMedia({required this.files, required this.localPlaylist});
  final List<HlsFile> files;
  final String localPlaylist;
}

abstract final class HlsPlaylist {
  static bool isMaster(String text) => text.contains('#EXT-X-STREAM-INF');

  static List<HlsVariant> variants(Uri base, String text) {
    final lines = text.split(RegExp(r'\r?\n')).map((l) => l.trim()).toList();
    final out = <HlsVariant>[];
    for (var i = 0; i < lines.length; i++) {
      if (!lines[i].startsWith('#EXT-X-STREAM-INF')) continue;
      final next = lines.skip(i + 1).firstWhere((l) => l.isNotEmpty && !l.startsWith('#'), orElse: () => '');
      if (next.isEmpty) continue;
      final bandwidth = int.tryParse(RegExp(r'BANDWIDTH=(\d+)').firstMatch(lines[i])?.group(1) ?? '') ?? 0;
      final height = int.tryParse(RegExp(r'RESOLUTION=\d+x(\d+)').firstMatch(lines[i])?.group(1) ?? '') ?? 0;
      out.add(HlsVariant(uri: base.resolve(next), bandwidth: bandwidth, height: height));
    }
    return out;
  }

  /// The quality to keep: closest to 720p (good on a phone, half the size of
  /// 1080p); without resolutions, the middle bandwidth.
  static HlsVariant? pick(List<HlsVariant> variants) {
    if (variants.isEmpty) return null;
    final withHeight = variants.where((v) => v.height > 0).toList();
    if (withHeight.isNotEmpty) {
      withHeight.sort((a, b) => (a.height - 720).abs().compareTo((b.height - 720).abs()));
      return withHeight.first;
    }
    final sorted = [...variants]..sort((a, b) => a.bandwidth.compareTo(b.bandwidth));
    return sorted[sorted.length ~/ 2];
  }

  /// Lists every file of a media playlist and rewrites it to local names.
  /// Throws [FormatException] for live streams, which never end.
  static HlsMedia media(Uri base, String text) {
    if (!text.contains('#EXT-X-ENDLIST')) {
      throw const FormatException('This is a live stream and cannot be downloaded.');
    }
    final files = <HlsFile>[];
    final out = StringBuffer();
    var segment = 0;
    var key = 0;
    String rewriteUri(String line, String prefix, String ext) {
      final m = RegExp(r'URI="([^"]+)"').firstMatch(line);
      if (m == null) return line;
      final name = '$prefix${files.length}$ext';
      files.add(HlsFile(uri: base.resolve(m.group(1)!), name: name));
      return line.replaceRange(m.start, m.end, 'URI="$name"');
    }

    for (final raw in text.split(RegExp(r'\r?\n'))) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      if (line.startsWith('#EXT-X-KEY') && !line.contains('METHOD=NONE')) {
        out.writeln(rewriteUri(line, 'key${key++}_', '.key'));
      } else if (line.startsWith('#EXT-X-MAP')) {
        out.writeln(rewriteUri(line, 'init', '.mp4'));
      } else if (line.startsWith('#')) {
        out.writeln(line);
      } else {
        final uri = base.resolve(line);
        final ext = RegExp(r'\.(ts|m4s|mp4|aac|m4a|vtt)$').firstMatch(uri.path)?.group(0) ?? '.ts';
        final name = 'seg${segment++}$ext';
        files.add(HlsFile(uri: uri, name: name));
        out.writeln(name);
      }
    }
    return HlsMedia(files: files, localPlaylist: out.toString());
  }
}
