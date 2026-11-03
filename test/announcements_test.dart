import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reelway/data/announcements.dart';
import 'package:reelway/data/remote_config.dart';
import 'package:reelway/features/announcements/announcement_screen.dart';
import 'package:reelway/features/shell/shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _list = [
  {
    'id': 'a2',
    'title': 'New feature',
    'body': 'Long text here.',
    'date': '2026-11-03',
    'action': {'type': 'url', 'value': 'https://example.com/x', 'label': 'Go'},
  },
  {'id': 'a1', 'title': 'Old news', 'body': ''},
  {'id': '', 'title': 'No id'},
  {
    'id': 'bad',
    'title': 'Bad link',
    'action': {'type': 'url', 'value': 'javascript:alert(1)'},
  },
];

/// Flutter tests run as Android, so both stores get the same list here.
Map<String, dynamic> _config() => {
  'announcements': _list,
  'android': {'announcements': _list},
};

Map<String, dynamic> _split() => {
  'announcements': _list,
  'android': {
    'announcements': [
      {'id': 'p1', 'title': 'Play only'},
    ],
  },
};

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Announcements.instance.debugReset();
    RemoteConfig.instance.debugSet(_config());
  });

  test('parses valid entries, drops unusable ones, keeps order', () {
    final all = Announcements.instance.all;
    expect(all.map((a) => a.id), ['a2', 'a1', 'bad']);
    expect(all.first.actionType, AnnouncementTarget.url);
    expect(all.first.actionLabel, 'Go');
    expect(all.last.actionType, isNull, reason: 'non-web links are dropped');
  });

  test('Android reads only its own block', () {
    RemoteConfig.instance.debugSet(_split());
    try {
      expect(Announcements.instance.all.map((a) => a.id), ['p1']);
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(Announcements.instance.all.map((a) => a.id), ['a2', 'a1', 'bad']);
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      RemoteConfig.instance.debugSet({
        'announcements': [
          {'id': 'x', 'title': 'iPhone only'},
        ],
        'android': {'ads': {}},
      });
      expect(Announcements.instance.all, isEmpty);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  test('seen state is kept and firstUnseen moves on', () async {
    await Announcements.instance.load();
    expect(Announcements.instance.firstUnseen?.id, 'a2');
    await Announcements.instance.markSeen('a2');
    expect(Announcements.instance.firstUnseen?.id, 'a1');
    Announcements.instance.debugReset();
    await Announcements.instance.load();
    expect(Announcements.instance.isSeen('a2'), isTrue);
  });

  testWidgets('presenter shows the newest unseen page once', (t) async {
    final nav = GlobalKey<NavigatorState>();
    await t.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ShellController(),
        child: MaterialApp(
          navigatorKey: nav,
          home: const Scaffold(body: Text('home')),
        ),
      ),
    );
    final presenter = AnnouncementPresenter(nav);
    unawaited(presenter.check());
    await t.pumpAndSettle();
    expect(find.text('New feature'), findsOneWidget);
    expect(find.text('Go'), findsOneWidget);
    nav.currentState!.pop();
    await t.pumpAndSettle();
    unawaited(presenter.check());
    await t.pumpAndSettle();
    expect(find.text('Old news'), findsOneWidget, reason: 'next unseen, not the same one again');
  });

  testWidgets('push tap opens the announcement, or a chosen place', (t) async {
    final nav = GlobalKey<NavigatorState>();
    final shell = ShellController();
    await t.pumpWidget(
      ChangeNotifierProvider.value(
        value: shell,
        child: MaterialApp(
          navigatorKey: nav,
          home: const Scaffold(body: Text('home')),
        ),
      ),
    );
    final presenter = AnnouncementPresenter(nav);
    unawaited(presenter.openFromPush({'target': 'announcement', 'id': 'a1'}));
    await t.pumpAndSettle();
    expect(find.text('Old news'), findsOneWidget);

    await presenter.openFromPush({'target': 'url', 'value': 'https://example.com/'});
    await t.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
    expect(shell.takePendingBrowserUrl().toString(), 'https://example.com/');

    await presenter.openFromPush({'target': 'settings'});
    expect(shell.tab, AppTab.settings);
  });
}
