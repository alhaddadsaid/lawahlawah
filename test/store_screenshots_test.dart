// Renders App Store screenshots (1290 x 2796) from the app's real screens.
//
//   flutter test test/store_screenshots_test.dart --dart-define=STORE_SHOTS=true
//
// Skipped otherwise. Images are written to build/store_screenshots/.
// Add --dart-define=STORE_IPAD=true for 13-inch iPad shots (build/store_screenshots/ipad/),
// or --dart-define=STORE_PLAY=true for Play Store phone shots (build/store_screenshots/play/).
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reelway/core/design/theme.dart';
import 'package:reelway/core/design/tokens.dart';
import 'package:reelway/data/remote_config.dart';
import 'package:reelway/data/repositories/app_state.dart';
import 'package:reelway/features/settings/protection_screen.dart';
import 'package:reelway/features/shell/shell.dart';
import 'package:reelway/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _run = bool.fromEnvironment('STORE_SHOTS');

/// 13-inch iPad shots (2048 x 2732) instead of iPhone ones.
const _ipad = bool.fromEnvironment('STORE_IPAD');

/// Play Store phone shots: 1242 x 2208 (9:16; Play allows at most 2:1).
const _play = bool.fromEnvironment('STORE_PLAY');
const _dir = _ipad ? 'ipad/' : (_play ? 'play/' : '');

/// Logical size of the app screen inside the frame.
const _screen = _ipad ? Size(820, 1180) : Size(390, 844);
const _insets = _ipad ? EdgeInsets.only(top: 24, bottom: 20) : EdgeInsets.only(top: 47, bottom: 34);
const _k = _ipad ? 1.9 : 1.0;

Future<void> _loadFonts() async {
  final inter = FontLoader('Inter');
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    inter.addFont(rootBundle.load('assets/fonts/Inter-$w.otf'));
  }
  await inter.load();
  final root = Platform.environment['FLUTTER_ROOT']!;
  final icons = FontLoader('MaterialIcons')
    ..addFont(
      Future.value(
        ByteData.sublistView(
          File('$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf').readAsBytesSync(),
        ),
      ),
    );
  await icons.load();
}

/// A caption above the app screen, like store screenshots usually show.
class _Frame extends StatelessWidget {
  const _Frame({required this.title, required this.subtitle, required this.child});
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.ltr,
    child: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1A12), Color(0xFF0E0C0B)],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 70 * _k),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34 * _k),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 34 * _k,
                height: 1.12,
                fontWeight: FontWeight.w800,
                color: Color(0xFFF6EFE8),
                letterSpacing: -0.6,
              ),
            ),
          ),
          const SizedBox(height: 12 * _k),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40 * _k),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 17 * _k, height: 1.35, color: Color(0xFFB3A79C)),
            ),
          ),
          const SizedBox(height: 34 * _k),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34 * _k),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(44),
                  border: Border.all(color: const Color(0xFF3A302A), width: 8),
                  boxShadow: const [BoxShadow(color: Color(0x99000000), blurRadius: 40, offset: Offset(0, 20))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: _screen.width,
                      height: _screen.height,
                      child: MediaQuery(
                        data: const MediaQueryData(
                          size: _screen,
                          devicePixelRatio: 3,
                          padding: _insets,
                          viewPadding: _insets,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 0),
        ],
      ),
    ),
  );
}

/// A plain example page inside the browser (any website would do).
class _ExamplePage extends StatelessWidget {
  const _ExamplePage();

  @override
  Widget build(BuildContext context) {
    Widget line(double w) => Container(
      width: w,
      height: 12,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: const Color(0xFFE6E2DE), borderRadius: BorderRadius.circular(6)),
    );
    return ColoredBox(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Morning news',
            style: TextStyle(fontFamily: 'Inter', fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1F)),
          ),
          const SizedBox(height: 14),
          Container(
            height: 190,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(colors: [Color(0xFF6B8CC7), Color(0xFF2E4A7D)]),
            ),
            child: const Center(child: Icon(Icons.play_circle_fill, size: 64, color: Colors.white)),
          ),
          const SizedBox(height: 18),
          line(320),
          line(290),
          line(310),
          line(220),
          const SizedBox(height: 14),
          line(300),
          line(260),
          line(280),
        ],
      ),
    );
  }
}

Future<void> _shot(WidgetTester tester, GlobalKey key, String name) async {
  await tester.runAsync(() async {
    final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: _ipad ? 2 : 3);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('build/store_screenshots/$_dir$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(data!.buffer.asUint8List());
  });
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('store screenshots', (tester) async {
    await tester.runAsync(_loadFonts);
    tester.view.physicalSize = _ipad
        ? const Size(2048, 2732)
        : (_play ? const Size(1242, 2208) : const Size(1290, 2796));
    tester.view.devicePixelRatio = _ipad ? 2 : 3;
    addTearDown(tester.view.reset);

    Future<GlobalKey> show(String title, String subtitle, Widget app) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: _Frame(title: title, subtitle: subtitle, child: app),
        ),
      );
      for (var i = 0; i < 6; i++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 700)));
        await tester.pump(const Duration(milliseconds: 300));
      }
      return key;
    }

    // Play Store shots show the Android app as the Play Store settings make
    // it: no Library tab or shortcut.
    if (_play) {
      RemoteConfig.instance.debugSet({
        'android': {
          'features': {'library': false},
        },
      });
      addTearDown(() => RemoteConfig.instance.debugSet(const {}));
    }
    final state = AppState(useSampleData: false);
    await tester.runAsync(state.load);

    // 1. Start page.
    var key = await show(
      _play ? 'Your video sites in one clean browser' : 'Browse without surprise pop-ups',
      _play ? 'Open your favorite websites, one tap away.' : 'A clean browser with your favorite sites one tap away.',
      ReelwayApp(state: state),
    );
    await _shot(tester, key, '1-start');

    // 2. A page with a blocked pop-up.
    key = await show(
      _play ? 'Fewer pop-ups, fewer surprises' : 'Your tap goes where you meant it to go',
      'Pop-ups and redirects that hijack your taps are stopped.',
      ReelwayApp(state: state, browserBuilder: (_, _) => const _ExamplePage()),
    );
    final home = tester.element(find.byType(Scaffold).first);
    home.read<ShellController>().openBrowser(Uri.parse('https://news.example.com/today'));
    await tester.pump(const Duration(milliseconds: 400));
    ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first)).showSnackBar(
      SnackBar(
        content: const Text('Blocked: Pop-up to another site'),
        action: SnackBarAction(label: 'Open anyway', textColor: RwColors.accent, onPressed: () {}),
        duration: const Duration(minutes: 1),
      ),
    );
    for (var i = 0; i < 4; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 500)));
      await tester.pump(const Duration(milliseconds: 300));
    }
    await _shot(tester, key, '2-blocked');

    // 3. Protection settings.
    key = await show(
      _play ? 'You decide what opens' : 'You choose the ads you click on',
      'Strict, balanced or off. Allow pop-ups only on the sites you trust.',
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: state),
          ChangeNotifierProvider(create: (_) => ShellController()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildReelwayTheme(),
          home: const ProtectionScreen(),
        ),
      ),
    );
    await _shot(tester, key, '3-protection');
  }, skip: !_run);
}
