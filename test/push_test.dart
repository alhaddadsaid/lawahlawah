import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:reelway/push/push_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Fake implements PushBackend {
  _Fake({this.ok = true, this.allow = true, this.opened});
  final bool ok;
  final bool allow;
  final Map<String, dynamic>? opened;
  final subscribed = <String>[];
  final tapController = StreamController<Map<String, dynamic>>.broadcast();
  bool permission = false;

  @override
  Future<bool> init() async => ok;
  @override
  Future<Map<String, dynamic>?> initialMessage() async => opened;
  @override
  Stream<Map<String, dynamic>> get taps => tapController.stream;
  @override
  Future<bool> requestPermission() async => permission = allow;
  @override
  Future<bool> hasPermission() async => permission;
  @override
  Future<void> subscribe(String topic) async => subscribed.add(topic);
  @override
  Future<void> unsubscribe(String topic) async => subscribed.remove(topic);
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('off when Firebase is not set up: nothing asked, nothing opened', () async {
    final push = PushService(_Fake(ok: false));
    expect(await push.start((_) {}), isNull);
    expect(push.available, isFalse);
    expect(await push.shouldAsk(10), isFalse);
    expect(await push.setEnabled(true), isFalse);
  });

  test('asks only from the third launch, once', () async {
    final push = PushService(_Fake());
    await push.start((_) {});
    expect(await push.shouldAsk(1), isFalse);
    expect(await push.shouldAsk(3), isTrue);
    await push.markAsked();
    expect(await push.shouldAsk(4), isFalse);
  });

  test('enabling asks permission and joins the store topic; denial stays off', () async {
    final fake = _Fake();
    final push = PushService(fake);
    await push.start((_) {});
    expect(await push.setEnabled(true), isTrue);
    expect(fake.subscribed, [PushService.topic]);
    expect(await push.setEnabled(false), isFalse);
    expect(fake.subscribed, isEmpty);

    final denied = PushService(_Fake(allow: false));
    await denied.start((_) {});
    expect(await denied.setEnabled(true), isFalse);
  });

  test('returns the notification that opened the app and forwards later taps', () async {
    final fake = _Fake(opened: {'target': 'settings'});
    final push = PushService(fake);
    final taps = <Map<String, dynamic>>[];
    expect(await push.start(taps.add), {'target': 'settings'});
    fake.tapController.add({'id': 'a1'});
    await Future<void>.delayed(Duration.zero);
    expect(taps, [
      {'id': 'a1'},
    ]);
  });

  test('re-joins the topic on start when it was on before', () async {
    final first = _Fake();
    final p1 = PushService(first);
    await p1.start((_) {});
    await p1.setEnabled(true);
    final second = _Fake()..permission = true;
    final p2 = PushService(second);
    await p2.start((_) {});
    expect(p2.enabled, isTrue);
    expect(second.subscribed, [PushService.topic]);
  });
}
