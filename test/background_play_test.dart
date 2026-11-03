import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reelway/browser/background_play.dart';
import 'package:reelway/data/remote_config.dart';

void main() {
  final yt = Uri.parse('https://m.youtube.com/watch?v=abc');

  test('runs only on iPhone, on YouTube, with the switch on', () {
    bool run(TargetPlatform p, Uri? u, bool on) => BackgroundPlay.shouldRun(platform: p, url: u, switchOn: on);
    expect(run(TargetPlatform.iOS, yt, true), isTrue);
    expect(run(TargetPlatform.iOS, Uri.parse('https://youtube.com/'), true), isTrue);
    expect(run(TargetPlatform.android, yt, true), isFalse, reason: 'never on Android');
    expect(run(TargetPlatform.iOS, yt, false), isFalse);
    expect(run(TargetPlatform.iOS, Uri.parse('https://example.com/'), true), isFalse);
    expect(run(TargetPlatform.iOS, Uri.parse('https://notyoutube.com/'), true), isFalse);
    expect(run(TargetPlatform.iOS, Uri.parse('https://youtube.com.evil.io/'), true), isFalse);
    expect(run(TargetPlatform.iOS, null, true), isFalse);
  });

  group('switch', () {
    tearDown(() => RemoteConfig.instance.debugSet(const {}));

    test('is off by default and follows the server', () {
      RemoteConfig.instance.debugSet(const {});
      expect(BackgroundPlay.switchOn, isFalse);
      RemoteConfig.instance.debugSet({
        'features': {'backgroundPlay': true},
      });
      expect(BackgroundPlay.switchOn, isTrue);
    });

    test('each store reads its own block', () {
      RemoteConfig.instance.debugSet({
        'features': {'backgroundPlay': false},
        'android': {
          'features': {'backgroundPlay': true},
        },
      });
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(BackgroundPlay.switchOn, isFalse, reason: 'iPhone reads the top level');
      debugDefaultTargetPlatformOverride = null;
    });

    test('activeFor follows platform, page and switch', () {
      RemoteConfig.instance.debugSet({
        'features': {'backgroundPlay': true},
      });
      final page = Uri.parse('https://www.youtube.com/watch?v=1');
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(BackgroundPlay.activeFor(page), isTrue);
      expect(BackgroundPlay.activeFor(Uri.parse('https://example.com/')), isFalse);
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(BackgroundPlay.activeFor(page), isFalse, reason: 'never on Android');
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
