import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cast/device.dart';
import 'package:video_player/video_player.dart';

import '../../core/design/tokens.dart';
import '../../data/models/models.dart';
import '../../data/models/user_settings.dart';
import '../../sources/subtitle_track.dart';
import '../../ads/ad_pacing.dart';
import '../../ads/ads.dart';
import 'cast_controller.dart';
import 'subtitle_loader.dart';
import 'episode_picker.dart';
import '../../data/repositories/app_state.dart';

/// Reelway's own player, for episodes from links the user added (MP4 or HLS).
/// Saves progress while playing and moves on to the next episode at the end.
class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    super.key,
    required this.content,
    required this.episodes,
    this.index = 0,
    this.startAt,
    this.onOpenPage,
  });

  final Content content;
  final List<Episode> episodes;
  final int index;
  final Duration? startAt;

  /// For titles from a website: an episode without a video yet closes the
  /// player and opens its page, where the website's player starts it.
  final void Function(Episode episode)? onOpenPage;

  static Future<void> open(
    BuildContext context,
    Content content,
    List<Episode> episodes, {
    int index = 0,
    Duration? startAt,
    void Function(Episode episode)? onOpenPage,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) =>
            PlayerScreen(content: content, episodes: episodes, index: index, startAt: startAt, onOpenPage: onOpenPage),
      ),
    );
  }

  /// Opens the player where the user stopped: the last episode watched, at
  /// its position, or the first episode when nothing was watched yet.
  static Future<void> resume(BuildContext context, Content content) {
    final app = context.read<AppState>();
    final episodes = app.episodesFor(content.id).where((e) => e.isPlayable).toList();
    if (episodes.isEmpty) return Future.value();
    final h = app.historyFor(content.id);
    final i = h == null ? -1 : episodes.indexWhere((e) => e.id == h.episodeId);
    if (i < 0) return open(context, content, episodes);
    final start = h!.isFinished ? Duration.zero : h.playbackPosition;
    return open(context, content, episodes, index: i, startAt: start);
  }

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  static const _failed = 'This video could not be played. Check your connection and that the link is public.';
  static const _speeds = [1.0, 1.25, 1.5, 2.0, 0.75];

  late final AppState _app;
  late int _index;
  final _cast = CastController();
  VideoPlayerController? _video;
  bool _controls = true;
  bool _ended = false;
  int _playRequest = 0;
  int _subtitleRequest = 0;
  List<SubtitleTrack> _subtitleTracks = const [];
  String? _preferredSubtitleLanguage;
  Uri? _selectedSubtitle;
  String? _error;
  double _speed = 1;
  Timer? _hide;
  DateTime _savedAt = DateTime.fromMillisecondsSinceEpoch(0);

  Episode get _episode => widget.episodes[_index];

  String get _title {
    final ep = _episode;
    if (widget.episodes.length < 2) return widget.content.title;
    return '${widget.content.title} · Episode ${ep.episodeNumber}';
  }

  @override
  void initState() {
    super.initState();
    _app = context.read<AppState>();
    _index = widget.index;
    _speed = _app.settings.preferredPlaybackSpeed;
    _cast.addListener(_onCast);
    _preferredSubtitleLanguage = _app.settings.subtitlesEnabled ? null : '__off__';
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _play(widget.startAt ?? Duration.zero);
  }

  @override
  void dispose() {
    _playRequest++;
    _subtitleRequest++;
    _hide?.cancel();
    final c = _video;
    if (c != null && c.value.isInitialized) {
      final ep = _episode;
      final position = c.value.position;
      final duration = c.value.duration;
      // After this frame: the app state must not notify while the tree is locked.
      Future.microtask(() => _app.recordProgress(widget.content, ep, position, duration));
    }
    c?.removeListener(_tick);
    c?.dispose();
    _cast
      ..removeListener(_onCast)
      ..dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _play(Duration startAt) async {
    final request = ++_playRequest;
    _subtitleRequest++;
    final episode = _episode;
    final old = _video;
    old?.removeListener(_tick);
    setState(() {
      _video = null;
      _error = null;
      _ended = false;
      _subtitleTracks = const [];
      _selectedSubtitle = null;
    });
    await old?.dispose();
    VideoPlayerController? controller;
    try {
      final source = await _app.playbackSourceFor(episode);
      final url = source.videoUrl;
      if (!mounted || request != _playRequest) return;
      final c = VideoPlayerController.networkUrl(url, httpHeaders: _app.playbackHeadersFor(url));
      controller = c;
      await c.initialize();
      if (!mounted || request != _playRequest) {
        await c.dispose();
        return;
      }
      await c.setPlaybackSpeed(_speed);
      if (startAt > Duration.zero && startAt < c.value.duration) await c.seekTo(startAt);
      if (!mounted || request != _playRequest) {
        await c.dispose();
        return;
      }
      c.addListener(_tick);
      setState(() {
        _video = c;
        _subtitleTracks = source.subtitles;
      });
      if (_cast.isCasting) {
        // The TV follows the player to the next episode; the phone stays paused.
        _cast.load(url: url, title: _title, poster: _poster);
      } else {
        await c.play();
      }
      _showControls();
      if (_preferredSubtitleLanguage != '__off__' && _subtitleTracks.isNotEmpty) {
        final preferred = _subtitleTracks.where((track) => track.language == _preferredSubtitleLanguage).firstOrNull;
        final defaultTrack = _subtitleTracks.where((track) => track.isDefault).firstOrNull;
        unawaited(_selectSubtitle(preferred ?? defaultTrack ?? _subtitleTracks.first, remember: false));
      }
    } catch (error) {
      controller?.removeListener(_tick);
      await controller?.dispose();
      if (!mounted || request != _playRequest) return;
      setState(() {
        _video = null;
        _error = error is FormatException ? error.message : _failed;
      });
    }
  }

  Uri? get _poster {
    final p = widget.content.poster;
    return p == null ? null : Uri.tryParse(p);
  }

  void _onCast() {
    if (mounted) setState(() {});
  }

  /// Lists Chromecasts on the Wi-Fi; choosing one moves the video to the TV.
  Future<void> _chooseCastDevice() async {
    _hide?.cancel();
    if (_cast.isCasting) {
      await _cast.stop();
      _showControls();
      return;
    }
    unawaited(_cast.startDiscovery());
    final chosen = await showModalBottomSheet<CastDevice>(
      context: context,
      showDragHandle: true,
      builder: (context) => ListenableBuilder(
        listenable: _cast,
        builder: (context, _) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(RwSpace.lg, 0, RwSpace.lg, RwSpace.sm),
                child: Text('Play on TV', style: RwType.title),
              ),
              if (_cast.devices.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(RwSpace.lg),
                  child: Text(
                    'Looking for Chromecast devices on this Wi-Fi…\nThe TV must be on and on the same network.',
                    style: RwType.caption,
                  ),
                ),
              for (final d in _cast.devices)
                ListTile(
                  leading: const Icon(Icons.tv),
                  title: Text(d.name),
                  subtitle: Text(d.extras['md'] ?? 'Chromecast'),
                  onTap: () => Navigator.pop(context, d),
                ),
              const SizedBox(height: RwSpace.md),
            ],
          ),
        ),
      ),
    );
    final c = _video;
    if (!mounted || chosen == null || c == null) {
      _showControls();
      return;
    }
    await c.pause();
    await _cast.cast(chosen, url: Uri.parse(c.dataSource), title: _title, poster: _poster, startAt: c.value.position);
    _showControls();
  }

  Future<void> _selectSubtitle(SubtitleTrack? track, {bool remember = true}) async {
    final controller = _video;
    if (controller == null) return;
    final request = ++_subtitleRequest;
    if (remember) {
      _preferredSubtitleLanguage = track?.language ?? '__off__';
      _app.updateSettings((settings) => settings.copyWith(subtitlesEnabled: track != null));
    }
    setState(() => _selectedSubtitle = track?.url);
    try {
      await controller.setClosedCaptionFile(null);
      if (track == null) return;
      final captions = await SubtitleLoader().load(track, headersFor: _app.playbackHeadersFor);
      if (!mounted || controller != _video || request != _subtitleRequest) return;
      await controller.setClosedCaptionFile(Future.value(captions));
    } catch (_) {
      if (!mounted || controller != _video || request != _subtitleRequest) return;
      setState(() => _selectedSubtitle = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This subtitle track could not be loaded. Video playback will continue.')),
      );
    }
  }

  Widget _subtitleMenu() => PopupMenuButton<String>(
    tooltip: 'Subtitles',
    icon: Icon(
      _selectedSubtitle == null ? Icons.closed_caption_off_outlined : Icons.closed_caption,
      color: Colors.white,
    ),
    onOpened: () => _hide?.cancel(),
    onCanceled: _showControls,
    onSelected: (value) {
      final track = _subtitleTracks.where((item) => item.url.toString() == value).firstOrNull;
      unawaited(_selectSubtitle(track));
      _showControls();
    },
    itemBuilder: (_) => [
      CheckedPopupMenuItem(value: 'off', checked: _selectedSubtitle == null, child: const Text('Off')),
      if (_subtitleTracks.isEmpty) const PopupMenuItem(enabled: false, child: Text('No selectable subtitle tracks')),
      for (final track in _subtitleTracks)
        CheckedPopupMenuItem(
          value: track.url.toString(),
          checked: _selectedSubtitle == track.url,
          child: Text(track.label),
        ),
    ],
  );

  Widget _captions(VideoPlayerController? controller) {
    final text = controller?.value.caption.text ?? '';
    if (text.isEmpty) return const SizedBox.shrink();
    final size = switch (_app.settings.subtitleSize) {
      SubtitleSize.small => 16.0,
      SubtitleSize.medium => 20.0,
      SubtitleSize.large => 24.0,
    };
    return Positioned(
      left: 24,
      right: 24,
      bottom: MediaQuery.paddingOf(context).bottom + (_controls ? 150 : 32),
      child: IgnorePointer(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.black.withValues(alpha: 0.7),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: size),
            ),
          ),
        ),
      ),
    );
  }

  void _tick() {
    final c = _video;
    if (c == null || !mounted) return;
    final v = c.value;
    if (v.hasError && _error == null) {
      setState(() => _error = _failed);
      return;
    }
    if (DateTime.now().difference(_savedAt) > const Duration(seconds: 5)) _save();
    if (v.isCompleted && !_ended) {
      _ended = true;
      _save();
      if (_app.settings.autoplayNext && _index + 1 < widget.episodes.length) unawaited(_goTo(_index + 1));
    }
    setState(() {});
  }

  void _save() {
    final c = _video;
    if (c == null || !c.value.isInitialized) return;
    _savedAt = DateTime.now();
    _app.recordProgress(widget.content, _episode, c.value.position, c.value.duration);
  }

  Future<void> _goTo(int index) async {
    if (index < 0 || index >= widget.episodes.length) return;
    _save();
    // Every few episodes, an interstitial between them (paced in AdPacing).
    // Not while the video plays on a TV.
    if (!_cast.isCasting && AdPacing.episodeStarted()) {
      await _video?.pause();
      if (!mounted) return;
      await showInterstitialAd(context);
      if (!mounted) return;
    }
    final openPage = widget.onOpenPage;
    if (openPage != null && !widget.episodes[index].isPlayable) {
      final episode = widget.episodes[index];
      Navigator.of(context).maybePop();
      openPage(episode);
      return;
    }
    setState(() => _index = index);
    _play(Duration.zero);
  }

  void _showControls() {
    _hide?.cancel();
    if (!mounted) return;
    setState(() => _controls = true);
    _hide = Timer(const Duration(seconds: 3), () {
      if (mounted && (_video?.value.isPlaying ?? false)) setState(() => _controls = false);
    });
  }

  void _toggleControls() {
    if (_controls) {
      _hide?.cancel();
      setState(() => _controls = false);
    } else {
      _showControls();
    }
  }

  void _togglePlay() {
    if (_cast.isCasting) {
      _cast.togglePlay();
      _showControls();
      return;
    }
    final c = _video;
    if (c == null) return;
    c.value.isPlaying ? c.pause() : c.play();
    _showControls();
  }

  void _seekBy(int seconds) {
    if (_cast.isCasting) {
      _cast.seekTo(_cast.position + Duration(seconds: seconds));
      _showControls();
      return;
    }
    final c = _video;
    if (c == null) return;
    c.seekTo(c.value.position + Duration(seconds: seconds));
    _showControls();
  }

  Future<void> _chooseEpisode() async {
    _hide?.cancel();
    final selected = await showEpisodePicker(
      context,
      numbers: widget.episodes.map((episode) => episode.episodeNumber).toList(),
      selected: _index,
    );
    if (!mounted) return;
    if (selected != null && selected != _index) unawaited(_goTo(selected));
    _showControls();
  }

  void _cycleSpeed() {
    final next = _speeds[(_speeds.indexOf(_speed) + 1) % _speeds.length];
    setState(() => _speed = next);
    _video?.setPlaybackSpeed(next);
    _showControls();
  }

  String get _speedLabel => _speed == _speed.roundToDouble() ? '${_speed.toInt()}x' : '${_speed}x';

  static String _clock(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return d.inHours > 0 ? '${d.inHours}:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final c = _video;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleControls,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(child: _picture(c)),
            if (c != null && c.value.isBuffering) const Center(child: CircularProgressIndicator()),
            if (_controls || c == null) _overlay(c),
            _captions(c),
          ],
        ),
      ),
    );
  }

  Widget _picture(VideoPlayerController? c) {
    if (c != null) return AspectRatio(aspectRatio: c.value.aspectRatio, child: VideoPlayer(c));
    final error = _error;
    if (error == null) return const CircularProgressIndicator();
    return Padding(
      padding: const EdgeInsets.all(RwSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: RwColors.danger, size: 40),
          const SizedBox(height: RwSpace.sm),
          Text(error, textAlign: TextAlign.center, style: RwType.body),
          const SizedBox(height: RwSpace.sm),
          FilledButton(onPressed: () => _play(Duration.zero), child: const Text('Try again')),
        ],
      ),
    );
  }

  Widget _overlay(VideoPlayerController? c) {
    final position = c?.value.position ?? Duration.zero;
    final duration = c?.value.duration ?? Duration.zero;
    final total = duration.inMilliseconds;
    final fraction = total <= 0 ? 0.0 : (position.inMilliseconds / total).clamp(0.0, 1.0);
    final playing = _cast.isCasting ? _cast.playing : (c?.value.isPlaying ?? false);
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black87, Colors.transparent, Colors.transparent, Colors.black87],
          stops: [0, .3, .6, 1],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: Text(_title, maxLines: 1, overflow: TextOverflow.ellipsis, style: RwType.subtitle),
                ),
                IconButton(
                  tooltip: _cast.isCasting ? 'Stop playing on TV' : 'Play on TV',
                  onPressed: c == null ? null : _chooseCastDevice,
                  icon: Icon(_cast.isCasting ? Icons.cast_connected : Icons.cast, color: Colors.white),
                ),
                if (c != null) _subtitleMenu(),
                TextButton(onPressed: c == null ? null : _cycleSpeed, child: Text(_speedLabel)),
              ],
            ),
            const Spacer(),
            if (_cast.isCasting || _cast.status.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: RwSpace.md),
                child: Text(
                  _cast.isCasting ? 'On ${_cast.device!.name} · ${_cast.status}' : _cast.status,
                  textAlign: TextAlign.center,
                  style: RwType.caption.copyWith(color: Colors.white),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 36,
                  color: Colors.white,
                  tooltip: 'Back 10 seconds',
                  onPressed: c == null ? null : () => _seekBy(-10),
                  icon: const Icon(Icons.replay_10),
                ),
                const SizedBox(width: RwSpace.lg),
                IconButton(
                  iconSize: 64,
                  color: Colors.white,
                  tooltip: playing ? 'Pause' : 'Play',
                  onPressed: c == null ? null : _togglePlay,
                  icon: Icon(playing ? Icons.pause_circle_filled : Icons.play_circle_filled),
                ),
                const SizedBox(width: RwSpace.lg),
                IconButton(
                  iconSize: 36,
                  color: Colors.white,
                  tooltip: 'Forward 10 seconds',
                  onPressed: c == null ? null : () => _seekBy(10),
                  icon: const Icon(Icons.forward_10),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RwSpace.md),
              child: Row(
                children: [
                  Text(_clock(position), style: RwType.caption),
                  Expanded(
                    child: Slider(
                      value: fraction,
                      activeColor: RwColors.accent,
                      onChanged: c == null || _cast.isCasting ? null : (f) => c.seekTo(duration * f),
                    ),
                  ),
                  Text(_clock(duration), style: RwType.caption),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Previous episode',
                    onPressed: _index > 0 ? () => _goTo(_index - 1) : null,
                    icon: const Icon(Icons.skip_previous),
                  ),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _chooseEpisode,
                      icon: const Icon(Icons.grid_view_rounded, size: 18),
                      label: Text('Episode ${_episode.episodeNumber} / ${widget.episodes.length}'),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Next episode',
                    onPressed: _index + 1 < widget.episodes.length ? () => _goTo(_index + 1) : null,
                    icon: const Icon(Icons.skip_next),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
