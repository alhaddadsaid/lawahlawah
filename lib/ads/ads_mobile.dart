import 'dart:async';
import 'dart:io' show Platform;

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/design/tokens.dart';
import '../data/remote_config.dart';
import 'ad_config.dart';
import 'ad_pacing.dart';

/// Real ads only on phones; desktop test hosts show nothing.
final bool _supported = Platform.isAndroid || Platform.isIOS;

String get _bannerId => Platform.isIOS ? AdConfig.iosBanner : AdConfig.androidBanner;
String get _interstitialId => Platform.isIOS ? AdConfig.iosInterstitial : AdConfig.androidInterstitial;
String get _appOpenId => Platform.isIOS ? AdConfig.iosAppOpen : AdConfig.androidAppOpen;

// ------------------------------------------------------- start and consent

/// True once consent is handled and the SDK is running; false if ads are
/// not allowed or not supported. Every ad waits for this before loading.
final Completer<bool> _ready = Completer<bool>();
bool _adsOn = false;
bool _initStarted = false;

Future<bool> adsReady() => _ready.future;

/// Shows Google's consent form when the law requires it (EU, UK and a few US
/// states), then Apple's tracking prompt on iPhone, then starts the ads SDK
/// and preloads full-screen ads. Without consent or tracking permission,
/// Google serves non-personalised ads.
Future<void> initAds() async {
  if (_initStarted) return;
  _initStarted = true;
  // The server can switch all ads off (then no consent or tracking prompt).
  await RemoteConfig.instance.ready.timeout(const Duration(seconds: 4), onTimeout: () {});
  if (!_supported || !RemoteConfig.instance.flag('ads.enabled')) {
    _ready.complete(false);
    return;
  }
  try {
    final updated = await _requestConsentInfo();
    if (updated) await _showConsentFormIfRequired();
    if (updated && !await ConsentInformation.instance.canRequestAds()) {
      _ready.complete(false);
      return;
    }
    if (Platform.isIOS) {
      try {
        if (await AppTrackingTransparency.trackingAuthorizationStatus == TrackingStatus.notDetermined) {
          await AppTrackingTransparency.requestTrackingAuthorization();
        }
      } catch (_) {
        /* Ads still run, non-personalised. */
      }
    }
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(maxAdContentRating: AdConfig.maxAdContentRating),
    );
    _adsOn = true;
    _ready.complete(true);
    preloadInterstitialAd();
    _preloadAppOpenAd();
  } catch (_) {
    if (!_ready.isCompleted) _ready.complete(false);
  }
}

Future<bool> _requestConsentInfo() {
  final done = Completer<bool>();
  ConsentInformation.instance.requestConsentInfoUpdate(
    ConsentRequestParameters(),
    () {
      if (!done.isCompleted) done.complete(true);
    },
    (FormError error) {
      if (!done.isCompleted) done.complete(false);
    },
  );
  return done.future.timeout(const Duration(seconds: 10), onTimeout: () => false);
}

Future<void> _showConsentFormIfRequired() {
  final done = Completer<void>();
  ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
    if (!done.isCompleted) done.complete();
  });
  return done.future;
}

/// Whether to show a "Privacy choices" entry (required where consent applies).
Future<bool> privacyOptionsRequired() async {
  if (!_supported) return false;
  try {
    return await ConsentInformation.instance.getPrivacyOptionsRequirementStatus() ==
        PrivacyOptionsRequirementStatus.required;
  } catch (_) {
    return false;
  }
}

Future<void> showPrivacyOptions() async {
  if (!_supported) return;
  final done = Completer<void>();
  await ConsentForm.showPrivacyOptionsForm((FormError? error) {
    if (!done.isCompleted) done.complete();
  });
  return done.future;
}

// ------------------------------------------------------------ interstitial

InterstitialAd? _interstitial;
bool _interstitialLoading = false;

void preloadInterstitialAd() {
  if (!_adsOn || _interstitial != null || _interstitialLoading) return;
  _interstitialLoading = true;
  InterstitialAd.load(
    adUnitId: _interstitialId,
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        _interstitial = ad;
        _interstitialLoading = false;
      },
      onAdFailedToLoad: (error) {
        _interstitialLoading = false;
      },
    ),
  );
}

/// Shows the preloaded interstitial, if one is ready. Never waits for a load,
/// so the viewer is not held up. Returns true if an ad was shown.
Future<bool> showInterstitialAd(BuildContext context) async {
  final ad = _interstitial;
  if (ad == null) {
    preloadInterstitialAd();
    return false;
  }
  _interstitial = null;

  final done = Completer<bool>();
  ad.fullScreenContentCallback = FullScreenContentCallback(
    onAdClicked: (_) => AdPacing.adClicked(),
    onAdDismissedFullScreenContent: (shown) {
      shown.dispose();
      AdPacing.fullScreenEnded();
      preloadInterstitialAd();
      if (!done.isCompleted) done.complete(true);
    },
    onAdFailedToShowFullScreenContent: (shown, error) {
      shown.dispose();
      AdPacing.fullScreenEnded();
      preloadInterstitialAd();
      if (!done.isCompleted) done.complete(false);
    },
  );
  AdPacing.fullScreenStarted();
  AdPacing.interstitialShown();
  await ad.show();
  return done.future;
}

// ---------------------------------------------------------------- app open

AppOpenAd? _appOpen;
DateTime? _appOpenLoadedAt;
bool _appOpenLoading = false;

void _preloadAppOpenAd() {
  if (!_adsOn || _appOpen != null || _appOpenLoading) return;
  _appOpenLoading = true;
  AppOpenAd.load(
    adUnitId: _appOpenId,
    request: const AdRequest(),
    adLoadCallback: AppOpenAdLoadCallback(
      onAdLoaded: (ad) {
        _appOpen = ad;
        _appOpenLoadedAt = DateTime.now();
        _appOpenLoading = false;
      },
      onAdFailedToLoad: (error) {
        _appOpenLoading = false;
      },
    ),
  );
}

/// Called when the app comes back to the foreground after [away]. Shows the
/// ad over a brief loading screen, as AdMob requires.
Future<void> maybeShowAppOpenAd(BuildContext context, Duration away, int launches) async {
  if (!_adsOn || !AdPacing.appOpenAllowed(away, launches: launches)) return;
  final ad = _appOpen;
  final loadedAt = _appOpenLoadedAt;
  // App open ads expire after 4 hours.
  if (ad == null || loadedAt == null || DateTime.now().difference(loadedAt) > const Duration(hours: 4)) {
    ad?.dispose();
    _appOpen = null;
    _preloadAppOpenAd();
    return;
  }
  _appOpen = null;

  final navigator = Navigator.of(context, rootNavigator: true);
  var overlayUp = true;
  void closeOverlay() {
    if (!overlayUp) return;
    overlayUp = false;
    navigator.pop();
  }

  ad.fullScreenContentCallback = FullScreenContentCallback(
    onAdClicked: (_) => AdPacing.adClicked(),
    onAdDismissedFullScreenContent: (shown) {
      shown.dispose();
      AdPacing.fullScreenEnded();
      closeOverlay();
      _preloadAppOpenAd();
    },
    onAdFailedToShowFullScreenContent: (shown, error) {
      shown.dispose();
      AdPacing.fullScreenEnded();
      closeOverlay();
      _preloadAppOpenAd();
    },
  );
  AdPacing.fullScreenStarted();
  unawaited(
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black,
      pageBuilder: (_, _, _) => const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator(color: RwColors.accent)),
      ),
    ),
  );
  await Future<void>.delayed(const Duration(milliseconds: 400));
  await ad.show();
}

// ------------------------------------------------------------------ banner

/// Large anchored adaptive banner: full screen width, higher earnings than
/// the fixed 320 x 50 size. Takes no space until an ad has loaded.
class BannerAdSlot extends StatefulWidget {
  const BannerAdSlot({super.key});

  @override
  State<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<BannerAdSlot> {
  BannerAd? _ad;
  AdSize? _size;
  bool _loaded = false;
  bool _requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_supported || _requested) return;
    _requested = true;
    _load(MediaQuery.sizeOf(context).width.truncate());
  }

  Future<void> _load(int width) async {
    if (!await _ready.future || !mounted || !RemoteConfig.instance.flag('ads.banner')) return;
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width) ?? AdSize.banner;
    if (!mounted) return;
    _size = size;
    _ad = BannerAd(
      adUnitId: _bannerId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdClicked: (_) => AdPacing.adClicked(),
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (mounted) setState(() => _ad = null);
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    final size = _size;
    if (!_loaded || ad == null || size == null) return const SizedBox.shrink();
    return Container(
      height: size.height.toDouble(),
      color: RwColors.surface,
      alignment: Alignment.center,
      child: SizedBox(
        width: size.width.toDouble(),
        height: size.height.toDouble(),
        child: AdWidget(ad: ad),
      ),
    );
  }
}
