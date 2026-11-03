import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:reelway/data/remote_config.dart';
import 'package:reelway/downloads/hls_playlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('HLS playlists for downloads', () {
    final base = Uri.parse('https://cdn.example.com/show/ep1/master.m3u8');

    test('picks the quality closest to 720p', () {
      const master = '''
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=800000,RESOLUTION=640x360
360p/index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=2500000,RESOLUTION=1280x720
720p/index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=5000000,RESOLUTION=1920x1080
1080p/index.m3u8
''';
      expect(HlsPlaylist.isMaster(master), isTrue);
      final picked = HlsPlaylist.pick(HlsPlaylist.variants(base, master));
      expect(picked?.uri.toString(), 'https://cdn.example.com/show/ep1/720p/index.m3u8');
    });

    test('lists segments, keys and init files and rewrites them to local names', () {
      const media = '''
#EXTM3U
#EXT-X-TARGETDURATION:6
#EXT-X-KEY:METHOD=AES-128,URI="https://keys.example.com/k1"
#EXT-X-MAP:URI="init.mp4"
#EXTINF:6.0,
s0.m4s
#EXTINF:6.0,
https://other.example.com/s1.m4s?token=abc
#EXT-X-ENDLIST
''';
      final result = HlsPlaylist.media(base, media);
      expect(result.files.map((f) => f.name), ['key0_0.key', 'init1.mp4', 'seg0.m4s', 'seg1.m4s']);
      expect(result.files[1].uri.toString(), 'https://cdn.example.com/show/ep1/init.mp4');
      expect(result.files[3].uri.toString(), 'https://other.example.com/s1.m4s?token=abc');
      expect(result.localPlaylist, contains('URI="key0_0.key"'));
      expect(result.localPlaylist, contains('URI="init1.mp4"'));
      expect(result.localPlaylist, contains('\nseg0.m4s\n'));
      expect(result.localPlaylist, contains('#EXT-X-ENDLIST'));
    });

    test('live streams cannot be downloaded', () {
      expect(() => HlsPlaylist.media(base, '#EXTM3U\n#EXTINF:6,\ns0.ts\n'), throwsFormatException);
    });
  });

  group('Server settings', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('defaults apply until the server says otherwise', () async {
      final config = RemoteConfig.instance..debugSet(const {});
      expect(config.flag('ads.enabled'), isTrue);
      expect(config.number('ads.interstitialEveryEpisodes', 3), 3);

      config.debugSet({
        'ads': {'enabled': false, 'interstitialEveryEpisodes': 5},
        'features': {'downloads': false},
      });
      expect(config.flag('ads.enabled'), isFalse);
      expect(config.flag('features.downloads'), isFalse);
      expect(config.flag('features.playOnTv'), isTrue, reason: 'missing keys keep the default');
      expect(config.number('ads.interstitialEveryEpisodes', 3), 5);
      config.debugSet(const {});
    });

    test('the bundled server file is valid JSON with the expected switches', () {
      final data = jsonDecode(File('server/config.json').readAsStringSync()) as Map<String, dynamic>;
      // The values are the admin's choice; each store must carry every switch.
      for (final store in [data, data['android'] as Map<String, dynamic>]) {
        expect((store['ads'] as Map)['enabled'], isA<bool>());
        for (final key in ['downloads', 'openVideosInReelway', 'playOnTv', 'blockWebsiteAds']) {
          expect((store['features'] as Map)[key], isA<bool>(), reason: key);
        }
        expect(store['sites'], isA<Map>());
      }
    });

    test('a broken server file is ignored', () async {
      final client = MockClient((request) async => http.Response('{not json', 200));
      final config = RemoteConfig.instance
        ..debugSet({
          'ads': {'enabled': false},
        });
      await config.debugLoad(client);
      expect(config.flag('ads.enabled'), isFalse, reason: 'keeps the last good copy');
      config.debugSet(const {});
    });
  });
}
