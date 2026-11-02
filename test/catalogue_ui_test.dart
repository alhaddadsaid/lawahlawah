import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reelway/data/repositories/app_state.dart';
import 'package:reelway/main.dart';
import 'package:reelway/sources/page_source.dart';
import 'package:reelway/sources/source_verification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _CatalogueSource extends PageSource {
  final requests = <Uri>[];
  static final base = Uri.parse('https://narto-drama.com/featured?lang=es-ES');

  @override
  Future<SourcePage> read(Uri input) async {
    requests.add(input);
    if (input.path == '/search') {
      final q = input.queryParameters['q'];
      return SourcePage(
        url: input,
        title: 'Narto-Drama search',
        searchQuery: q,
        titles: q == 'missing' ? [] : [PageTitle(title: 'Ocean & Sun', url: base.resolve('/detail/watch/ocean'))],
      );
    }
    if (input.queryParameters['page'] == '2') {
      return SourcePage(
        url: input,
        title: 'Featured dramas',
        titles: [
          PageTitle(title: 'Duplicate', url: base.resolve('/detail/watch/dragon')),
          PageTitle(title: 'Another series', url: base.resolve('/detail/watch/another')),
        ],
      );
    }
    return SourcePage(
      url: base,
      title: 'Featured dramas',
      titles: [PageTitle(title: 'Featured Dragon', url: base.resolve('/detail/watch/dragon'))],
      nextPage: base.replace(queryParameters: {'lang': 'es-ES', 'page': '2'}),
    );
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<AppState> pump(WidgetTester tester, _CatalogueSource source) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final state = AppState(useSampleData: false, pageSource: source);
    await tester.runAsync(state.load);
    state.acceptLinksDisclaimer();
    await tester.pumpWidget(ReelwayApp(state: state));
    await tester.pumpAndSettle();
    return state;
  }

  Future<void> open(WidgetTester tester) async {
    await tester.tap(find.text('Browse').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Paste a website, series, episode or video URL'),
      'https://narto-drama.com/',
    );
    await tester.tap(find.byTooltip('Read source'));
    await tester.pumpAndSettle();
  }

  testWidgets('website search returns new titles outside the loaded page and handles zero matches', (tester) async {
    final source = _CatalogueSource();
    await pump(tester, source);
    await open(tester);
    expect(find.text('Featured Dragon'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextField, 'Search all Narto-Drama titles'), 'ocean & sun');
    await tester.tap(find.byTooltip('Search website'));
    await tester.pumpAndSettle();
    expect(find.text('Ocean & Sun'), findsOneWidget);
    expect(find.text('Featured Dragon'), findsNothing);
    expect(source.requests.last.path, '/search');
    expect(source.requests.last.queryParameters['q'], 'ocean & sun');
    await tester.enterText(find.widgetWithText(TextField, 'Search all Narto-Drama titles'), 'missing');
    await tester.tap(find.byTooltip('Search website'));
    await tester.pumpAndSettle();
    expect(find.text('No titles found. Try another search.'), findsOneWidget);
    expect(find.byTooltip('Search website'), findsOneWidget);
  });

  testWidgets('load more appends unique series without discarding the previous page', (tester) async {
    await pump(tester, _CatalogueSource());
    await open(tester);
    await tester.ensureVisible(find.text('Load more series'));
    await tester.tap(find.text('Load more series'));
    await tester.pumpAndSettle();
    expect(find.text('Featured Dragon'), findsOneWidget);
    expect(find.text('Another series'), findsOneWidget);
    expect(find.text('Duplicate'), findsNothing);
    expect(find.text('Load more series'), findsNothing);
  });

  testWidgets('blocked source offers user verification without opening a browser automatically', (tester) async {
    final state = AppState(useSampleData: false, pageSource: _BlockedSource());
    await tester.runAsync(state.load);
    await tester.pumpWidget(ReelwayApp(state: state));
    await tester.tap(find.text('Browse').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Paste a website, series, episode or video URL'),
      'https://source.example/',
    );
    await tester.tap(find.byTooltip('Read source'));
    await tester.pumpAndSettle();
    expect(find.text('Complete website verification'), findsOneWidget);
    expect(find.text('Continue in Reelway'), findsNothing);
    expect(find.textContaining('does not yet recognize'), findsNothing);
  });

  testWidgets('website pasted in Library is saved and opens its native catalog', (tester) async {
    final state = await pump(tester, _CatalogueSource());
    await tester.tap(find.text('Library').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add a link'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'https://'), 'https://narto-drama.com/');
    await tester.pump();
    await tester.tap(find.text('Browse website'));
    await tester.pumpAndSettle();
    expect(find.text('Featured Dragon'), findsOneWidget);
    expect(state.websites.single.host, 'narto-drama.com');
    expect(state.links, isEmpty);
  });
}

class _BlockedSource extends PageSource {
  @override
  Future<SourcePage> read(Uri input) async => throw SourceVerificationRequired(input);
}
