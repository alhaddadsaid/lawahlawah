import 'package:flutter_test/flutter_test.dart';
import 'package:reelway/analytics/analytics_service.dart';
import 'package:reelway/data/remote_config.dart';

class _Fake implements AnalyticsBackend {
  _Fake({this.ok = true});
  final bool ok;
  int inits = 0;
  bool? collection;
  final events = <String>[];

  @override
  Future<bool> init() async {
    inits++;
    return ok;
  }

  @override
  Future<void> setCollection(bool on) async => collection = on;
  @override
  Future<void> log(String name, Map<String, Object> params) async => events.add(name);
}

/// Flutter tests run as Android, so the switch goes in that store's block.
Map<String, dynamic> _cfg(bool on) => {
  'analytics': {'enabled': on},
  'android': {
    'analytics': {'enabled': on},
  },
};

void main() {
  Future<bool> yes() async => true;
  Future<bool> no() async => false;

  test('stays off by default and without consent: nothing initialised or logged', () async {
    final fake = _Fake();
    final a = AnalyticsService(fake);
    RemoteConfig.instance.debugSet({});
    await a.apply(yes);
    expect(a.enabled, isFalse);
    RemoteConfig.instance.debugSet(_cfg(true));
    await a.apply(no);
    expect(a.enabled, isFalse);
    await a.log('x');
    expect(fake.inits, 0);
    expect(fake.events, isEmpty);
  });

  test('a store without its own switch never borrows the other store\'s', () async {
    final fake = _Fake();
    final a = AnalyticsService(fake);
    RemoteConfig.instance.debugSet({
      'analytics': {'enabled': true},
      'android': {'ads': {}},
    });
    await a.apply(yes);
    expect(a.enabled, isFalse);
  });

  test('server switch plus consent turns it on, and the switch turns it off again', () async {
    final fake = _Fake();
    final a = AnalyticsService(fake);
    RemoteConfig.instance.debugSet(_cfg(true));
    await a.apply(yes);
    expect(a.enabled, isTrue);
    expect(fake.collection, isTrue);
    await a.log('announcement_view', {'id': 'a1'});
    expect(fake.events, ['announcement_view']);

    RemoteConfig.instance.debugSet(_cfg(false));
    await a.apply(yes);
    expect(a.enabled, isFalse);
    expect(fake.collection, isFalse);
    await a.log('after_off');
    expect(fake.events, hasLength(1));
    expect(fake.inits, 1);
  });

  test('a build without Firebase values never turns on', () async {
    final a = AnalyticsService(_Fake(ok: false));
    RemoteConfig.instance.debugSet(_cfg(true));
    await a.apply(yes);
    expect(a.enabled, isFalse);
  });
}
