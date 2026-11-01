import 'package:flutter/material.dart';

/// Reelway design tokens. Every colour, spacing, radius and duration used in
/// the app comes from here so the look stays consistent and is easy to retune
/// (and to mirror in FlutterFlow's theme settings).
abstract final class RwColors {
  static const background = Color(0xFF101014);
  static const surface = Color(0xFF191920);
  static const card = Color(0xFF22222A);
  static const cardHigh = Color(0xFF2C2C36);
  static const accent = Color(0xFFE85D35);
  static const accentSoft = Color(0x33E85D35);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFA0A0AA);
  static const textTertiary = Color(0xFF6C6C76);
  static const divider = Color(0xFF2A2A33);
  static const success = Color(0xFF3DBE7A);
  static const warning = Color(0xFFF2B33D);
  static const danger = Color(0xFFE5484D);

  /// Bottom-up scrim used over artwork so text stays readable.
  static const scrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00101014), Color(0xCC101014), background],
    stops: [0.0, 0.7, 1.0],
  );
}

abstract final class RwSpace {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;

  /// Horizontal page gutter.
  static const gutter = 16.0;
}

abstract final class RwRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const pill = 999.0;
}

abstract final class RwMotion {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 400);
  static const curve = Curves.easeOutCubic;
}

abstract final class RwType {
  static const fontFamily = 'Inter';
  static const _base = TextStyle(fontFamily: fontFamily, color: RwColors.textPrimary, height: 1.25);

  static final display = _base.copyWith(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5);
  static final headline = _base.copyWith(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.3);
  static final title = _base.copyWith(fontSize: 18, fontWeight: FontWeight.w700);
  static final subtitle = _base.copyWith(fontSize: 15, fontWeight: FontWeight.w600);
  static final body = _base.copyWith(fontSize: 14, fontWeight: FontWeight.w400, height: 1.45);
  static final caption = _base.copyWith(fontSize: 12, color: RwColors.textSecondary);
  static final label = _base.copyWith(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.6);
}
