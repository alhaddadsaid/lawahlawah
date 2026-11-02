import 'package:flutter/material.dart';
import 'package:reelway/core/widgets/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reelway/features/shell/shell.dart';
import 'package:reelway/sources/page_source.dart';
import 'package:reelway/data/repositories/app_state.dart';
import 'package:reelway/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Steps animations frame by frame. Used instead of pumpAndSettle where a
/// focused text field's blinking cursor would keep it from ever settling.
Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 12; i++) {
    await t.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('AppState', () {
    test('addWebsite validates and dedupes, and persists', () async {
      final a = AppState(useSampleData: false);
      await a.load();
      expect(a.addWebsite('javascript:alert(1)'), isNotNull);
      expect(a.addWebsite('hello world'), isNotNull);
      expect(a.addWebsite('www.example.com'), isNull);
      expect(a.addWebsite('https://www.example.com/'), 'That website is already saved.');
      expect(a.websites.single.name, 'Example');
      expect(a.websites.single.url, 'https://www.example.com/');
      await Future<void>.delayed(Duration.zero);

      final b = AppState(useSampleData: false);
      await b.load();
      expect(b.websites, hasLength(1));
    });

    test('history respects the saveHistory setting', () async {
      final a = AppState(useSampleData: false);
      await a.load();
      a.markVisited(Uri.parse('https://a.com/1'), 'One');
      a.markVisited(Uri.parse('https://a.com/1'), 'One again');
      expect(a.visited, hasLength(1));
      a.updateSettings((s) => s.copyWith(saveHistory: false));
      a.markVisited(Uri.parse('https://a.com/2'), 'Two');
      expect(a.visited, hasLength(1));
    });

    test('allowing popups updates the protection engine', () async {
      final a = AppState(useSampleData: false);
      await a.load();
      a.allowPopupsFor(Uri.parse('https://m.site.com'));
      expect(a.popupProtection.allowedSites, contains('site.com'));
      a.disallowPopupsFor('site.com');
      expect(a.popupProtection.allowedSites, isEmpty);
    });

    test('clearAllData wipes everything', () async {
      final a = AppState(useSampleData: true);
      await a.load();
      a.addWebsite('example.com');
      a.toggleBookmark('https://example.com', 'Ex');
      await a.clearAllData();
      expect(a.websites, isEmpty);
      expect(a.bookmarks, isEmpty);
      expect(a.watchHistory, isEmpty);
    });

    test('sample data is off when not requested', () async {
      final a = AppState(useSampleData: false);
      await a.load();
      expect(a.content, isEmpty);
    });
  });

  group('UI', () {
    Future<void> pumpApp(WidgetTester t, {bool sample = true}) async {
      t.view.physicalSize = const Size(1170, 2532);
      t.view.devicePixelRatio = 3;
      addTearDown(t.view.reset);
      final s = AppState(useSampleData: sample);
      await t.runAsync(s.load);
      await t.pumpWidget(ReelwayApp(state: s));
      await t.pump();
    }

    testWidgets('empty state invites adding a website', (t) async {
      await pumpApp(t, sample: false);
      expect(find.text('Search or enter website'), findsOneWidget);
      await t.tap(find.text('Add'));
      await settle(t);
      expect(find.text('Add a website'), findsOneWidget);
      await t.enterText(find.widgetWithText(TextField, 'example.com'), 'example.com');
      await t.tap(find.text('Save website'));
      await settle(t);
      expect(find.text('Save website'), findsNothing);
    });

    testWidgets('home shows browser, saved websites and compact continue watching', (t) async {
      await pumpApp(t);
      expect(find.text('Search or enter website'), findsOneWidget);
      expect(find.text('YouTube'), findsOneWidget);
      await t.tap(find.byTooltip('Show more'));
      await t.pump();
      expect(find.text('Continue watching'), findsOneWidget);
      expect(find.text('NEW ON YOUR SITES'), findsNothing);
    });

    testWidgets('four main tabs render', (t) async {
      await pumpApp(t);
      for (final (tab, expected) in [
        ('Library', 'TV Series'),
        ('History', 'Watched'),
        ('Settings', 'Native playback'),
      ]) {
        await t.tap(find.text(tab).last);
        await t.pumpAndSettle();
        expect(find.text(expected), findsWidgets, reason: tab);
      }
    });

    testWidgets('native source explorer imports a public episode without website ads', (t) async {
      final source = _FixtureSource(
        '<h1>Public series</h1><script>const episodeItemsRaw = '
        '[{"number":1,"play_url":"https://cdn.example/episode.m3u8",'
        '"watch_url":"https://narto-drama.com/detail/watch/test/1"}];'
        'window.open("https://ads.example/");</script>',
      );
      final requests = source.requests;
      final state = AppState(useSampleData: false, pageSource: source);
      await t.runAsync(state.load);
      await t.pumpWidget(ReelwayApp(state: state, browserBuilder: (_, tab) => Text('Browser: ${tab.url.host}')));
      t.element(find.byType(Scaffold).first).read<ShellController>().go(AppTab.browse);
      await t.pumpAndSettle();
      expect(find.text('Paste a website, series, episode or video URL'), findsOneWidget);
      await t.enterText(
        find.widgetWithText(TextField, 'Paste a website, series, episode or video URL'),
        'https://narto-drama.com/detail/watch/test/1',
      );
      await t.runAsync(() async {
        await t.tap(find.byTooltip('Read source'));
        await Future<void>.delayed(Duration.zero);
      });
      await t.pumpAndSettle();
      expect(find.text('1 episodes found'), findsOneWidget);
      await t.tap(find.text('Add to Library & watch'));
      await t.pumpAndSettle();
      expect(find.text('Links you add'), findsOneWidget);
      await t.runAsync(() async {
        await t.tap(find.text('I understand'));
        await Future<void>.delayed(Duration.zero);
      });
      await t.pumpAndSettle();
      expect(state.linksDisclaimerAccepted, isTrue);
      expect(state.content.single.title, 'Public series');
      expect(state.episodesFor(state.content.single.id).single.isPlayable, isTrue);
      expect(requests, hasLength(2));
      expect(requests.every((url) => url.host == 'narto-drama.com'), isTrue);
    });

    testWidgets('content detail opens and can be saved', (t) async {
      await pumpApp(t);
      await t.tap(find.text('Library').last);
      await t.pumpAndSettle();
      await t.tap(find.byType(ContentCard).first);
      await t.pumpAndSettle();
      expect(find.text('Season 1').evaluate().isNotEmpty || find.text('Movie').evaluate().isNotEmpty, isTrue);
      await t.tap(find.byTooltip('Save'));
      await t.pump();
      expect(find.byTooltip('Remove from saved'), findsOneWidget);
    });
  });
}

class _FixtureSource extends PageSource {
  _FixtureSource(this.body);
  final String body;
  final requests = <Uri>[];

  @override
  Future<SourcePage> read(Uri input) async {
    requests.add(input);
    return PageSource.parse(input, body);
  }
}
