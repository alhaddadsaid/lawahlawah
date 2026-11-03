import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ads/ads.dart';
import 'data/remote_config.dart';
import 'features/announcements/announcement_screen.dart';
import 'analytics/analytics_service.dart';
import 'push/push_service.dart';
import 'downloads/download_manager.dart';

import 'core/design/theme.dart';
import 'data/repositories/app_state.dart';
import 'features/shell/shell.dart';
import 'browser/tab_manager.dart';
import 'browser/popup_protection.dart';
import 'browser/browser_user_agent.dart';
import 'browser/site_profiles.dart';
import 'browser/website_ad_rules.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  final app = AppState();
  unawaited(RemoteConfig.instance.load());
  unawaited(DownloadManager.instance.load());
  await Future.wait([app.load(), AdDomains.load(), BrowserUserAgent.load()]);
  var launches = 1;
  try {
    final prefs = await SharedPreferences.getInstance();
    launches = (prefs.getInt('ads.launches') ?? 0) + 1;
    await prefs.setInt('ads.launches', launches);
  } catch (_) {
    /* Counting launches only paces app open ads. */
  }
  PopupProtection.exemptSite = (site) => SiteProfiles.forUrl(Uri(scheme: 'https', host: site)).adsAllowedHere;
  runApp(ReelwayApp(state: app, launches: launches, push: true));
  // After the first frame: Google's consent form and Apple's tracking prompt
  // need the app on screen.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await initAds();
    // Usage statistics start only when the server switch is on and consent allows.
    await RemoteConfig.instance.ready.timeout(const Duration(seconds: 4), onTimeout: () {});
    unawaited(AnalyticsService.instance.apply(analyticsConsentGiven));
  });
}

class ReelwayApp extends StatefulWidget {
  const ReelwayApp({super.key, required this.state, this.browserBuilder, this.launches = 1, this.push = false});
  final Widget Function(BuildContext, BrowserTab)? browserBuilder;
  final AppState state;

  /// Starts push notifications (off in tests).
  final bool push;

  /// How many times the app was opened on this device (app open ad pacing).
  final int launches;

  @override
  State<ReelwayApp> createState() => _ReelwayAppState();
}

class _ReelwayAppState extends State<ReelwayApp> with WidgetsBindingObserver {
  final _navigator = GlobalKey<NavigatorState>();
  DateTime? _leftAt;
  late final _announcements = AnnouncementPresenter(_navigator);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // After the first frame, so the page can be pushed on the navigator.
    WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_start()));
  }

  /// A notification that opened the app wins; otherwise the newest unseen
  /// announcement shows. Then, on a later launch, ask about notifications.
  Future<void> _start() async {
    Map<String, dynamic>? opened;
    if (widget.push) {
      opened = await PushService.instance.start((data) => unawaited(_announcements.openFromPush(data)));
    }
    if (opened != null) {
      await _announcements.openFromPush(opened);
    } else {
      await _announcements.check();
    }
    if (!widget.push || !await PushService.instance.shouldAsk(widget.launches)) return;
    final context = _navigator.currentContext;
    if (context != null && context.mounted) await askAboutNotifications(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Shows an app open ad when the user comes back (paced in AdPacing) and
  /// picks up switches changed on the server meanwhile.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _leftAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      unawaited(
        RemoteConfig.instance.refresh().then((_) {
          unawaited(AnalyticsService.instance.apply(analyticsConsentGiven));
          return _announcements.check();
        }),
      );
      final left = _leftAt;
      _leftAt = null;
      final context = _navigator.currentContext;
      if (left != null && context != null) {
        maybeShowAppOpenAd(context, DateTime.now().difference(left), widget.launches);
      }
    }
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: widget.state),
      ChangeNotifierProvider(create: (_) => ShellController()),
    ],
    child: MaterialApp(
      navigatorKey: _navigator,
      title: 'Reelway',
      debugShowCheckedModeBanner: false,
      theme: buildReelwayTheme(),
      darkTheme: buildReelwayTheme(),
      themeMode: ThemeMode.dark,
      home: AppShell(browserBuilder: widget.browserBuilder),
    ),
  );
}
