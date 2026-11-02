import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../core/design/tokens.dart';
import '../../data/models/models.dart';
import '../../data/repositories/app_state.dart';

/// Reelway's own player, for episodes from links the user added (MP4 or HLS).
/// Saves progress while playing and moves on to the next episode at the end.
class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, required this.content, required this.episodes, this.index = 0, this.startAt});

  final Content content;
  final List<Episode> episodes;
  final int index;
  final Duration? startAt;

  static Future<void> open(
    BuildContext context,
    Content content,
    List<Episode> episodes, {
    int index = 0,
    Duration? startAt,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => PlayerScreen(content: content, episodes: episodes, index: index, startAt: startAt),
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
  VideoPlayerController? _video;
  bool _controls = true;
  bool _ended = false;
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _play(widget.startAt ?? Duration.zero);
  }

  @override
  void dispose() {
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _play(Duration startAt) async {
    final old = _video;
    if (old != null) {
      old.removeListener(_tick);
      setState(() => _video = null);
      await old.dispose();
    }
    final url = _episode.videoUrl;
    if (url == null) return;
    _ended = false;
    _error = null;
    final c = VideoPlayerController.networkUrl(Uri.parse(url));
    try {
      await c.initialize();
    } catch (_) {
      await c.dispose();
      if (mounted) setState(() => _error = _failed);
      return;
    }
    if (!mounted) {
      await c.dispose();
      return;
    }
    await c.setPlaybackSpeed(_speed);
    if (startAt > Duration.zero && startAt < c.value.duration) await c.seekTo(startAt);
    c.addListener(_tick);
    setState(() => _video = c);
    await c.play();
    _showControls();
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
      if (_index + 1 < widget.episodes.length) _goTo(_index + 1);
    }
    setState(() {});
  }

  void _save() {
    final c = _video;
    if (c == null || !c.value.isInitialized) return;
    _savedAt = DateTime.now();
    _app.recordProgress(widget.content, _episode, c.value.position, c.value.duration);
  }

  void _goTo(int index) {
    if (index < 0 || index >= widget.episodes.length) return;
    _save();
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
    final c = _video;
    if (c == null) return;
    c.value.isPlaying ? c.pause() : c.play();
    _showControls();
  }

  void _seekBy(int seconds) {
    final c = _video;
    if (c == null) return;
    c.seekTo(c.value.position + Duration(seconds: seconds));
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
    final playing = c?.value.isPlaying ?? false;
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.black45),
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
                TextButton(onPressed: c == null ? null : _cycleSpeed, child: Text(_speedLabel)),
              ],
            ),
            const Spacer(),
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
                      onChanged: c == null ? null : (f) => c.seekTo(duration * f),
                    ),
                  ),
                  Text(_clock(duration), style: RwType.caption),
                ],
              ),
            ),
            if (_index + 1 < widget.episodes.length)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _goTo(_index + 1),
                  icon: const Icon(Icons.skip_next),
                  label: const Text('Next episode'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
