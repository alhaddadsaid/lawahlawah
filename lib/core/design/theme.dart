import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;

import 'tokens.dart';

ThemeData buildReelwayTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: RwColors.accent, brightness: Brightness.dark).copyWith(
    primary: RwColors.accent,
    onPrimary: Colors.white,
    surface: RwColors.surface,
    onSurface: RwColors.textPrimary,
    surfaceContainerHighest: RwColors.card,
    error: RwColors.danger,
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: RwType.fontFamily,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: RwColors.background,
    canvasColor: RwColors.background,
    dividerColor: RwColors.divider,
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: RwColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: RwType.title,
    ),
    textTheme: TextTheme(
      displaySmall: RwType.display,
      headlineSmall: RwType.headline,
      titleMedium: RwType.title,
      titleSmall: RwType.subtitle,
      bodyMedium: RwType.body,
      bodySmall: RwType.caption,
      labelSmall: RwType.label,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: RwColors.surface,
      indicatorColor: RwColors.accentSoft,
      surfaceTintColor: Colors.transparent,
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => RwType.label.copyWith(
          color: s.contains(WidgetState.selected) ? RwColors.textPrimary : RwColors.textSecondary,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(color: s.contains(WidgetState.selected) ? RwColors.accent : RwColors.textSecondary),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: RwColors.card,
      hintStyle: RwType.body.copyWith(color: RwColors.textTertiary),
      contentPadding: const EdgeInsets.symmetric(horizontal: RwSpace.md, vertical: RwSpace.sm),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(RwRadius.pill), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RwRadius.pill),
        borderSide: const BorderSide(color: RwColors.accent, width: 1.2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: RwColors.accent,
        foregroundColor: Colors.white,
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: RwSpace.lg),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RwRadius.md)),
        textStyle: RwType.subtitle,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: RwColors.textPrimary,
        minimumSize: const Size(48, 48),
        side: const BorderSide(color: RwColors.divider),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RwRadius.md)),
        textStyle: RwType.subtitle,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? Colors.white : RwColors.textSecondary,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? RwColors.accent : RwColors.card,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: RwColors.textSecondary,
      titleTextStyle: RwType.subtitle,
      subtitleTextStyle: RwType.caption,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: RwColors.cardHigh,
      contentTextStyle: RwType.body,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RwRadius.md)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: RwColors.surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
