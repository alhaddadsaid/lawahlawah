import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/design/theme.dart';
import 'data/repositories/app_state.dart';
import 'features/shell/shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  final app = AppState();
  await app.load();
  runApp(ReelwayApp(state: app));
}

class ReelwayApp extends StatelessWidget {
  const ReelwayApp({super.key, required this.state});
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
      home: const AppShell(),
    ),
  );
}
