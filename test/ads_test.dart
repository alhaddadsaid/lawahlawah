import 'package:flutter_test/flutter_test.dart';
import 'package:reelway/ads/ad_config.dart';
import 'package:reelway/ads/ad_pacing.dart';

void main() {
  var clock = DateTime(2026, 11, 2, 20);
  setUp(() {
    AdPacing.reset();
    clock = DateTime(2026, 11, 2, 20);
    AdPacing.now = () => clock;
  });
  tearDown(AdPacing.reset);

  test('an interstitial is due every few episodes, with a cooldown', () {
    final due = [for (var i = 0; i < AdConfig.interstitialEveryEpisodes; i++) AdPacing.episodeStarted()];
    expect(due, [...List.filled(AdConfig.interstitialEveryEpisodes - 1, false), true]);

    AdPacing.fullScreenStarted();
    AdPacing.interstitialShown();
    AdPacing.fullScreenEnded();
    for (var i = 0; i < AdConfig.interstitialEveryEpisodes - 1; i++) {
      AdPacing.episodeStarted();
    }
    expect(AdPacing.episodeStarted(), isFalse, reason: 'too soon after the last ad');
    clock = clock.add(AdConfig.fullScreenCooldown);
    expect(AdPacing.episodeStarted(), isTrue);
  });

  test('app open ads wait for a few launches, time away and a cooldown', () {
    const away = Duration(minutes: 5);
    expect(AdPacing.appOpenAllowed(away, launches: 1), isFalse, reason: 'new users first');
    expect(AdPacing.appOpenAllowed(const Duration(seconds: 10), launches: 5), isFalse, reason: 'quick switch');
    expect(AdPacing.appOpenAllowed(away, launches: 5), isTrue);

    AdPacing.adClicked();
    expect(AdPacing.appOpenAllowed(away, launches: 5), isFalse, reason: 'coming back from an ad');

    AdPacing.fullScreenStarted();
    AdPacing.fullScreenEnded();
    expect(AdPacing.appOpenAllowed(away, launches: 5), isFalse, reason: 'cooldown after any ad');
    clock = clock.add(AdConfig.appOpenCooldown);
    expect(AdPacing.appOpenAllowed(away, launches: 5), isTrue);
  });
}
