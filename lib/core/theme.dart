import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  static const bg = Color(0xFF030A06);
  static const bgDeep = Color(0xFF010604);
  static const surface = Color(0xFF091410);
  static const surfaceHover = Color(0xFF0D1D15);
  static const elevated = Color(0xFF0F2018);

  static const accent = Color(0xFF00FFD1);
  static Color accentDim = const Color(0xFF00FFD1).withValues(alpha: 0.15);
  static Color accentGlow = const Color(0xFF00FFD1).withValues(alpha: 0.18);
  static Color chip = const Color(0xFF00FFD1).withValues(alpha: 0.11);

  static const text = Color(0xFFE4F5EE);
  static const textSec = Color(0xFF5E9278);
  static const textMuted = Color(0xFF284038);

  static Color border = const Color(0xFF00FFD1).withValues(alpha: 0.12);
  static Color accentBorder = const Color(0xFF00FFD1).withValues(alpha: 0.32);
  static Color navBorder = const Color(0xFF00FFD1).withValues(alpha: 0.20);

  static const navBg = Color(0xFF020905);

  static const heart = Color(0xFFFF5F87);
  static const danger = Color(0xFFFF4D6A);
  static const warn = Color(0xFFFFD166);
}

abstract class AppShadows {
  static List<BoxShadow> get card => [
    BoxShadow(color: const Color(0xFF00FFD1).withValues(alpha: 0.12), blurRadius: 0, spreadRadius: 1),
    BoxShadow(color: Colors.black.withValues(alpha: 0.55), blurRadius: 24, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get fab => [
    BoxShadow(color: const Color(0xFF00FFD1).withValues(alpha: 0.45), blurRadius: 24),
    BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 16, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get dotPulse => [
    BoxShadow(color: const Color(0xFF00FFD1).withValues(alpha: 0.15), blurRadius: 0, spreadRadius: 4),
    BoxShadow(color: const Color(0xFF00FFD1).withValues(alpha: 0.40), blurRadius: 12),
  ];

  static List<BoxShadow> get chipActive => [
    BoxShadow(color: const Color(0xFF00FFD1).withValues(alpha: 0.25), blurRadius: 12),
  ];

  static List<BoxShadow> get sheet => [
    BoxShadow(color: const Color(0xFF00FFD1).withValues(alpha: 0.12), blurRadius: 40, offset: const Offset(0, -4)),
  ];

  static List<BoxShadow> get ctaButton => [
    BoxShadow(color: const Color(0xFF00FFD1).withValues(alpha: 0.45), blurRadius: 24, offset: const Offset(0, 4)),
  ];
}

abstract class AppRadius {
  static const card = BorderRadius.all(Radius.circular(14));
  static const chip = BorderRadius.all(Radius.circular(20));
  static const button = BorderRadius.all(Radius.circular(16));
  static const collection = BorderRadius.all(Radius.circular(16));
  static const thumb = BorderRadius.all(Radius.circular(10));
  static const colIcon = BorderRadius.all(Radius.circular(12));
  static const fab = BorderRadius.all(Radius.circular(16));
  static const sheetTop = BorderRadius.vertical(top: Radius.circular(22));
  static const settings = BorderRadius.all(Radius.circular(16));
  static const badge = BorderRadius.all(Radius.circular(8));
  static const proIcon = BorderRadius.all(Radius.circular(24));
}

abstract class AppSpacing {
  static const pagePad = 16.0;
  static const cardGap = 8.0;
  static const sectionGap = 20.0;
}

abstract class AppTextStyles {
  static TextStyle get appBar => GoogleFonts.plusJakartaSans(
    fontSize: 22, fontWeight: FontWeight.w800,
    color: AppColors.text, letterSpacing: -0.5,
  );
  static TextStyle get screenTitle => GoogleFonts.plusJakartaSans(
    fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.text, letterSpacing: -0.5,
  );
  static TextStyle get onboardingTitle => GoogleFonts.plusJakartaSans(
    fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.text, height: 1.2,
  );
  static TextStyle get onboardingSub => GoogleFonts.plusJakartaSans(
    fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textSec, height: 1.65,
  );
  static TextStyle get cardTitle => GoogleFonts.plusJakartaSans(
    fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.text, height: 1.35,
  );
  static TextStyle get cardMeta => GoogleFonts.plusJakartaSans(
    fontSize: 11.5, fontWeight: FontWeight.w400, color: AppColors.textSec,
  );
  static TextStyle get cardDate => GoogleFonts.plusJakartaSans(
    fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textMuted,
  );
  static TextStyle get chipActive => GoogleFonts.plusJakartaSans(
    fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF020A07),
  );
  static TextStyle get chipInactive => GoogleFonts.plusJakartaSans(
    fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSec,
  );
  static TextStyle get collectionName => GoogleFonts.plusJakartaSans(
    fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.text,
  );
  static TextStyle get collectionCount => GoogleFonts.plusJakartaSans(
    fontSize: 12.5, fontWeight: FontWeight.w400, color: AppColors.textSec,
  );
  static TextStyle get sheetTitle => GoogleFonts.plusJakartaSans(
    fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text, height: 1.4,
  );
  static TextStyle get sheetDesc => GoogleFonts.plusJakartaSans(
    fontSize: 13.5, fontWeight: FontWeight.w400, color: AppColors.textSec, height: 1.6,
  );
  static TextStyle get button => GoogleFonts.plusJakartaSans(
    fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF020A07), letterSpacing: 0.2,
  );
  static TextStyle get sectionHeader => GoogleFonts.plusJakartaSans(
    fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1.2,
  );
  static TextStyle get navLabel => GoogleFonts.plusJakartaSans(
    fontSize: 10, fontWeight: FontWeight.w400, color: AppColors.textMuted,
  );
  static TextStyle get navLabelActive => GoogleFonts.plusJakartaSans(
    fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.accent,
  );
  static TextStyle get paywallHeadline => GoogleFonts.plusJakartaSans(
    fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.text, height: 1.25,
  );
  static TextStyle get proBadge => GoogleFonts.plusJakartaSans(
    fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF020A07), letterSpacing: 1,
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.surface,
      primary: AppColors.accent,
      onPrimary: Color(0xFF020A07),
      onSurface: AppColors.text,
      error: AppColors.danger,
    ),
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    // The default M3 zoom transition paints a surface-coloured scrim while
    // pushing a route (e.g. the paywall), which reads as a background flash.
    // FadeUpwards transitions cleanly over the existing background.
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    }),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: AppTextStyles.appBar,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.navBg,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.textMuted,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: AppRadius.card,
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.card,
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.card,
        borderSide: BorderSide(color: AppColors.accentBorder),
      ),
      hintStyle: GoogleFonts.plusJakartaSans(color: AppColors.textMuted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
    ),
  );
}
