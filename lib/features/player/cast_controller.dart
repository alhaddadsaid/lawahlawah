import 'dart:async';

import 'package:bonsoir/bonsoir.dart';
import 'package:cast/device.dart';
import 'package:cast/session.dart';
import 'package:cast/session_manager.dart';
import 'package:flutter/foundation.dart';

/// Plays a video on a Chromecast (or a TV with Chromecast built in) on the same
/// Wi-Fi, through Google's Default Media Receiver.
///
/// The TV downloads the video itself, so it cannot send the website's Referer
/// and an HLS stream must allow other players (CORS). Videos that need either
/// keep playing on the phone and the TV shows an error.
class CastController extends ChangeNotifier {
  static const _receiverApp = 'CC1AD845';
  static const _serviceType = '_googlecast._tcp';

  BonsoirDiscovery? _discovery;
  StreamSubscription<BonsoirDiscoveryEvent>? _events;
  final Map<String, CastDevice> _devices = {};
  CastSession? _session;
  StreamSubscription<Map<String, dynamic>>? _messages;
  StreamSubscription<CastSessionState>? _states;
  int _requestId = 0;
  bool _disposed = false;
  int? _mediaSessionId;
  ({Uri url, String title, Uri? poster, Duration startAt})? _pending;

  /// Chromecasts found on the Wi-Fi so far.
  List<CastDevice> get devices => _devices.values.toList()..sort((a, b) => a.name.compareTo(b.name));

  /// The device the video plays on, or null when playing on the phone.
  CastDevice? device;

  /// Shown under the device name: connecting, playing, paused or an error.
  String status = '';
  bool playing = false;

  /// Where the TV was at its last status update.
  Duration position = Duration.zero;
  bool get isCasting => device != null;

  Future<void> startDiscovery() async {
    if (_discovery != null) return;
    final discovery = BonsoirDiscovery(type: _serviceType, printLogs: false);
    _discovery = discovery;
    try {
      await discovery.initialize();
      _events = discovery.eventStream?.listen((event) {
        switch (event) {
          case BonsoirDiscoveryServiceFoundEvent(:final service):
            discovery.serviceResolver.resolveService(service);
          case BonsoirDiscoveryServiceResolvedEvent(:final service):
          case BonsoirDiscoveryServiceUpdatedEvent(:final service):
            final address =
                service.hostAddresses.where((a) => !a.contains(':')).firstOrNull ?? service.hostAddresses.firstOrNull;
            if (address == null) return;
            _devices[service.name] = CastDevice(
              serviceName: service.name,
              name: service.attributes['fn'] ?? service.name,
              host: address,
              port: service.port,
              extras: service.attributes,
            );
            notifyListeners();
          case BonsoirDiscoveryServiceLostEvent(:final service):
            if (_devices.remove(service.name) != null) notifyListeners();
          default:
        }
      });
      await discovery.start();
    } catch (_) {
      _discovery = null; // Local network access refused or unavailable.
    }
  }

  Future<void> stopDiscovery() async {
    final discovery = _discovery;
    _discovery = null;
    await _events?.cancel();
    _events = null;
    if (discovery != null && !discovery.isStopped) await discovery.stop();
  }

  /// Starts [url] on [target] at [startAt].
  Future<void> cast(
    CastDevice target, {
    required Uri url,
    required String title,
    Uri? poster,
    Duration startAt = Duration.zero,
  }) async {
    await stop();
    device = target;
    status = 'Connecting…';
    playing = false;
    notifyListeners();
    try {
      final session = await CastSessionManager().startSession(target, const Duration(seconds: 8));
      _session = session;
      _pending = (url: url, title: title, poster: poster, startAt: startAt);
      _states = session.stateStream.listen((state) {
        if (state == CastSessionState.connected) {
          _load();
        } else if (state == CastSessionState.closed && device == target) {
          _ended('Disconnected');
        }
      });
      _messages = session.messageStream.listen(_onMessage, onError: (_) => _ended('Connection lost'));
      _send(CastSession.kNamespaceReceiver, {'type': 'LAUNCH', 'appId': _receiverApp});
    } catch (_) {
      _ended('Could not connect to ${target.name}');
    }
  }

  /// Moves the TV to another video (the next episode) in the same session.
  void load({required Uri url, required String title, Uri? poster}) {
    if (_session == null) return;
    _pending = (url: url, title: title, poster: poster, startAt: Duration.zero);
    _load();
  }

  void _load() {
    final p = _pending;
    if (p == null) return;
    _pending = null;
    status = 'Starting…';
    notifyListeners();
    _send(CastSession.kNamespaceMedia, {
      'type': 'LOAD',
      'autoplay': true,
      'currentTime': p.startAt.inMilliseconds / 1000,
      'media': {
        'contentId': p.url.toString(),
        'contentType': p.url.path.toLowerCase().endsWith('.m3u8') ? 'application/x-mpegurl' : 'video/mp4',
        'streamType': 'BUFFERED',
        'metadata': {
          'type': 0,
          'metadataType': 0,
          'title': p.title,
          if (p.poster != null)
            'images': [
              {'url': p.poster.toString()},
            ],
        },
      },
    });
  }

  void _onMessage(Map<String, dynamic> message) {
    switch (message['type']) {
      case 'MEDIA_STATUS':
        final list = message['status'];
        if (list is! List || list.isEmpty || list.first is! Map) return;
        final s = list.first as Map;
        if (s['mediaSessionId'] is int) _mediaSessionId = s['mediaSessionId'] as int;
        if (s['currentTime'] is num) position = Duration(milliseconds: ((s['currentTime'] as num) * 1000).round());
        final state = s['playerState'];
        playing = state == 'PLAYING' || state == 'BUFFERING';
        status = switch (state) {
          'PLAYING' => 'Playing',
          'BUFFERING' => 'Loading…',
          'PAUSED' => 'Paused',
          _ => s['idleReason'] == 'ERROR' ? 'The TV could not play this video' : status,
        };
        notifyListeners();
      case 'LOAD_FAILED' || 'LOAD_CANCELLED' || 'INVALID_REQUEST':
        status = 'The TV could not play this video';
        playing = false;
        notifyListeners();
    }
  }

  void togglePlay() {
    final id = _mediaSessionId;
    if (id == null) return;
    _send(CastSession.kNamespaceMedia, {'type': playing ? 'PAUSE' : 'PLAY', 'mediaSessionId': id});
  }

  void seekTo(Duration position) {
    final id = _mediaSessionId;
    if (id == null) return;
    _send(CastSession.kNamespaceMedia, {
      'type': 'SEEK',
      'mediaSessionId': id,
      'currentTime': position.inMilliseconds / 1000,
    });
  }

  /// Stops the TV and goes back to playing on the phone.
  Future<void> stop() async {
    final session = _session;
    _session = null;
    _mediaSessionId = null;
    _pending = null;
    await _messages?.cancel();
    await _states?.cancel();
    _messages = null;
    _states = null;
    if (session != null) {
      try {
        _sendOn(session, CastSession.kNamespaceReceiver, {'type': 'STOP'});
        await CastSessionManager().endSession(session.sessionId);
      } catch (_) {
        /* The TV already went away. */
      }
    }
    if (device != null) {
      device = null;
      status = '';
      playing = false;
      if (!_disposed) notifyListeners();
    }
  }

  void _ended(String reason) {
    _session = null;
    _mediaSessionId = null;
    status = reason;
    playing = false;
    device = null;
    notifyListeners();
  }

  void _send(String namespace, Map<String, dynamic> payload) {
    final session = _session;
    if (session != null) _sendOn(session, namespace, payload);
  }

  void _sendOn(CastSession session, String namespace, Map<String, dynamic> payload) =>
      session.sendMessage(namespace, {...payload, 'requestId': ++_requestId});

  @override
  void dispose() {
    _disposed = true;
    unawaited(stop());
    unawaited(stopDiscovery());
    super.dispose();
  }
}
