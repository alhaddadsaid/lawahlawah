import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/models/models.dart';
import '../design/tokens.dart';

/// Artwork for a content item. Uses the authorised poster URL when the
/// adapter supplies one; otherwise draws original generated artwork so no
/// third-party imagery is needed during development.
class PosterArt extends StatelessWidget {
  const PosterArt({super.key, required this.content, this.showTitle = true, this.radius = RwRadius.md});

  final Content content;
  final bool showTitle;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final seed = content.title.codeUnits.fold<int>(7, (a, b) => (a * 31 + b) & 0x7fffffff);
    final hue = (seed % 360).toDouble();
    final c1 = HSLColor.fromAHSL(1, hue, 0.55, 0.32).toColor();
    final c2 = HSLColor.fromAHSL(1, (hue + 40) % 360, 0.6, 0.14).toColor();

    final generated = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [c1, c2]),
      ),
      child: CustomPaint(painter: _ArtPainter(seed)),
    );

    final poster = content.poster;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          poster == null ? generated : Image.network(poster, fit: BoxFit.cover, errorBuilder: (_, _, _) => generated),
          if (showTitle && poster == null) ...[
            const DecoratedBox(decoration: BoxDecoration(gradient: RwColors.scrim)),
            Positioned(
              left: RwSpace.sm,
              right: RwSpace.sm,
              bottom: RwSpace.sm,
              child: Text(
                content.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: RwType.subtitle.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ],
          // Top-right so it never collides with back buttons; hidden on tiny
          // thumbnails where it cannot fit.
          if (content.isSample)
            LayoutBuilder(
              builder: (_, c) => c.maxWidth < 80
                  ? const SizedBox.shrink()
                  : const Align(
                      alignment: Alignment.topRight,
                      child: Padding(padding: EdgeInsets.all(RwSpace.xs), child: RwBadge('SAMPLE')),
                    ),
            ),
        ],
      ),
    );
  }
}

class _ArtPainter extends CustomPainter {
  _ArtPainter(this.seed);
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final r = math.Random(seed);
    final paint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 5; i++) {
      paint.color = Colors.white.withValues(alpha: 0.03 + r.nextDouble() * 0.06);
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height * 0.7),
        size.width * (0.2 + r.nextDouble() * 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ArtPainter old) => old.seed != seed;
}

class RwBadge extends StatelessWidget {
  const RwBadge(this.text, {super.key, this.color = RwColors.accent});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(RwRadius.sm / 2)),
    child: Text(text, style: RwType.label.copyWith(fontSize: 9, color: Colors.white)),
  );
}

class RwProgressBar extends StatelessWidget {
  const RwProgressBar({super.key, required this.value, this.height = 3});
  final double value;
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(height),
    child: LinearProgressIndicator(
      value: value,
      minHeight: height,
      backgroundColor: Colors.white24,
      valueColor: const AlwaysStoppedAnimation(RwColors.accent),
    ),
  );
}

/// Poster card used in carousels and grids.
class ContentCard extends StatelessWidget {
  const ContentCard({super.key, required this.content, this.sourceName, this.progress, this.onTap, this.width = 128});

  final Content content;
  final String? sourceName;
  final double? progress;
  final VoidCallback? onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final meta = [
      if (content.releaseYear != null) '${content.releaseYear}',
      if (content.genres.isNotEmpty) content.genres.first,
    ].join(' · ');

    return SizedBox(
      width: width,
      child: Semantics(
        button: true,
        label: content.title,
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 2 / 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PosterArt(content: content, showTitle: false),
                    if (progress != null)
                      Positioned(left: 8, right: 8, bottom: 8, child: RwProgressBar(value: progress!)),
                  ],
                ),
              ),
              const SizedBox(height: RwSpace.xs),
              Text(
                content.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: RwType.subtitle.copyWith(fontSize: 13),
              ),
              if (meta.isNotEmpty || sourceName != null)
                Text(
                  [if (meta.isNotEmpty) meta, ?sourceName].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: RwType.caption,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(RwSpace.gutter, RwSpace.lg, RwSpace.xs, RwSpace.sm),
    child: Row(
      children: [
        Expanded(child: Text(title, style: RwType.title)),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              action!,
              style: RwType.caption.copyWith(color: RwColors.accent, fontWeight: FontWeight.w700),
            ),
          ),
      ],
    ),
  );
}

/// Horizontal carousel with consistent gutters.
class Carousel extends StatelessWidget {
  const Carousel({super.key, required this.height, required this.itemCount, required this.itemBuilder});
  final double height;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: RwSpace.gutter),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(width: RwSpace.sm),
      itemBuilder: itemBuilder,
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(RwSpace.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [RwColors.accent.withValues(alpha: 0.35), RwColors.card]),
            ),
            child: Icon(icon, size: 40, color: RwColors.textPrimary),
          ),
          const SizedBox(height: RwSpace.lg),
          Text(title, style: RwType.headline, textAlign: TextAlign.center),
          const SizedBox(height: RwSpace.xs),
          Text(
            message,
            style: RwType.body.copyWith(color: RwColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            const SizedBox(height: RwSpace.lg),
            FilledButton.icon(onPressed: onAction, icon: const Icon(Icons.add), label: Text(action!)),
          ],
        ],
      ),
    ),
  );
}

/// Circular site avatar: favicon when available, otherwise a monogram.
class SiteAvatar extends StatelessWidget {
  const SiteAvatar({super.key, required this.name, this.favicon, this.size = 48});
  final String name;
  final String? favicon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final letter = name.isEmpty ? '?' : name[0].toUpperCase();
    final fallback = Center(
      child: Text(letter, style: RwType.title.copyWith(fontSize: size * 0.4)),
    );
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: RwColors.cardHigh,
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(color: RwColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: favicon == null
          ? fallback
          : Image.network(favicon!, fit: BoxFit.cover, errorBuilder: (_, _, _) => fallback),
    );
  }
}

class IntegrationBadge extends StatelessWidget {
  const IntegrationBadge(this.status, {super.key});
  final IntegrationStatus status;

  @override
  Widget build(BuildContext context) => switch (status) {
    IntegrationStatus.integrated => const RwBadge('INTEGRATED', color: RwColors.success),
    IntegrationStatus.pendingPermission => const RwBadge('PENDING', color: RwColors.warning),
    IntegrationStatus.devTesting => const RwBadge('DEV TEST', color: Color(0xFF7C5CFF)),
    IntegrationStatus.browserOnly => const RwBadge('BROWSER', color: RwColors.cardHigh),
  };
}

/// Pulsing placeholder used while content loads.
class Skeleton extends StatefulWidget {
  const Skeleton({super.key, this.width, this.height, this.radius = RwRadius.md});
  final double? width;
  final double? height;
  final double radius;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: Tween(begin: 0.4, end: 0.9).animate(_c),
    child: Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(color: RwColors.card, borderRadius: BorderRadius.circular(widget.radius)),
    ),
  );
}

String formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  return h > 0 ? '${h}h ${m}m' : '${m}m';
}

String timeAgo(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'Just now';
  if (d.inMinutes < 60) return '${d.inMinutes} min ago';
  if (d.inHours < 24) return '${d.inHours} h ago';
  if (d.inDays == 1) return 'Yesterday';
  return '${d.inDays} days ago';
}
