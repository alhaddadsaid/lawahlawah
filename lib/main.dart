import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
  runApp(ReelwayApp(state: app));
}

class ReelwayApp extends StatelessWidget {
  const ReelwayApp({super.key, required this.state, this.browserBuilder});
  final Widget Function(BuildContext, BrowserTab)? browserBuilder;
  final AppState state;

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: state),
      ChangeNotifierProvider(create: (_) => ShellController()),
    ],
    child: MaterialApp(
      title: 'Reelway',
      debugShowCheckedModeBanner: false,
      theme: buildReelwayTheme(),
      darkTheme: buildReelwayTheme(),
      themeMode: ThemeMode.dark,
      home: AppShell(browserBuilder: browserBuilder),
    ),
  );
}
