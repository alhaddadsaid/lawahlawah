import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ads/ads.dart';

import 'core/design/theme.dart';
import 'data/repositories/app_state.dart';
import 'features/shell/shell.dart';
import 'browser/tab_manager.dart';
import 'browser/website_ad_rules.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  final app = AppState();
  await Future.wait([app.load(), AdDomains.load()]);
  var launches = 1;
  try {
    final prefs = await SharedPreferences.getInstance();
    launches = (prefs.getInt('ads.launches') ?? 0) + 1;
    await prefs.setInt('ads.launches', launches);
  } catch (_) {
    /* Counting launches only paces app open ads. */
  }
  runApp(ReelwayApp(state: app, launches: launches));
  // After the first frame: Google's consent form and Apple's tracking prompt
  // need the app on screen.
  WidgetsBinding.instance.addPostFrameCallback((_) => initAds());
}

class ReelwayApp extends StatefulWidget {
  const ReelwayApp({super.key, required this.state, this.browserBuilder, this.launches = 1});
  final Widget Function(BuildContext, BrowserTab)? browserBuilder;
  final AppState state;

  /// How many times the app was opened on this device (app open ad pacing).
  final int launches;

  @override
  State<ReelwayApp> createState() => _ReelwayAppState();
}

class _ReelwayAppState extends State<ReelwayApp> with WidgetsBindingObserver {
  final _navigator = GlobalKey<NavigatorState>();
  DateTime? _leftAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Shows an app open ad when the user comes back (paced in AdPacing).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _leftAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
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
