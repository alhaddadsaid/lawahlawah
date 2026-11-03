import 'package:flutter/material.dart';

/// Web preview: no ad SDK, no ads.
Future<void> initAds() async {}

Future<bool> adsReady() async => false;

void preloadInterstitialAd() {}

Future<bool> showInterstitialAd(BuildContext context) async => false;

Future<void> maybeShowAppOpenAd(BuildContext context, Duration away, int launches) async {}

Future<bool> privacyOptionsRequired() async => false;

Future<bool> analyticsConsentGiven() async => false;

Future<void> showPrivacyOptions() async {}

class BannerAdSlot extends StatelessWidget {
  const BannerAdSlot({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
