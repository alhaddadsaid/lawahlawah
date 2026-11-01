import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
      expect(find.text('Add your first website'), findsOneWidget);
      await t.tap(find.text('Add website'));
      await settle(t);
      expect(find.text('Add a website'), findsOneWidget);
      await t.enterText(find.widgetWithText(TextField, 'example.com'), 'example.com');
      await t.tap(find.text('Save website'));
      await settle(t);
      expect(find.text('Your websites'), findsOneWidget);
    });

    testWidgets('home shows streaming sections with sample data', (t) async {
      await pumpApp(t);
      expect(find.text('Continue watching'), findsOneWidget);
      expect(find.text('NEW ON YOUR SITES'), findsOneWidget);
      expect(find.text('SAMPLE'), findsWidgets);
    });

    testWidgets('all five tabs render', (t) async {
      await pumpApp(t);
      for (final (tab, expected) in [
        ('Library', 'TV Series'),
        ('History', 'Watched'),
        ('Settings', 'Protection level'),
        ('Browse', 'Search or enter address'),
      ]) {
        await t.tap(find.text(tab).last);
        await t.pumpAndSettle();
        expect(find.text(expected), findsWidgets, reason: tab);
      }
    });

    testWidgets('content detail opens and can be saved', (t) async {
      await pumpApp(t);
      await t.tap(find.text('Watch').first);
      await t.pumpAndSettle();
      expect(find.text('Season 1').evaluate().isNotEmpty || find.text('Movie').evaluate().isNotEmpty, isTrue);
      await t.tap(find.byTooltip('Save'));
      await t.pump();
      expect(find.byTooltip('Remove from saved'), findsOneWidget);
    });
  });
}
