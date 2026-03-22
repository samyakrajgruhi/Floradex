import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// FloraDex Design System — "The 8-Bit Botanist"
/// Generated from DESIGN.md
///
/// Key rules from the design system:
///   - 0px border radius everywhere (Digital Brutalism / 8-bit integrity)
///   - No Material elevation shadows — use tonal color layering instead
///   - Press Start 2P for display/headlines only (≤5 words)
///   - Manrope for body text, Space Grotesk for labels
///   - 8px base spacing unit — all padding/gaps are multiples of 8
///   - Color blocks define boundaries, never divider lines

class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────
  // COLOR TOKENS
  // ─────────────────────────────────────────────

  // Primary — "Life Force" greens
  static const Color primary          = Color(0xFF007523);
  static const Color onPrimary        = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF8EFE91);
  static const Color onPrimaryContainer = Color(0xFF002109);
  static const Color primaryDim       = Color(0xFF00671E); // used in CTA gradients

  // Secondary — "Field Equipment" brown
  static const Color secondary           = Color(0xFF9A511E);
  static const Color onSecondary         = Color(0xFFFFFFFF);
  static const Color secondaryContainer  = Color(0xFFFFDBC8);
  static const Color onSecondaryContainer= Color(0xFF380E00);

  // Tertiary — deep earthy gold
  static const Color tertiary            = Color(0xFF7B6100);
  static const Color onTertiary          = Color(0xFFFFFFFF);
  static const Color tertiaryContainer   = Color(0xFFFFE08A);
  static const Color onTertiaryContainer = Color(0xFF261A00);

  // Surface hierarchy — "PCB layers"
  // surface = chassis base
  static const Color surface                  = Color(0xFFFDFFDA);
  static const Color onSurface               = Color(0xFF383833);
  static const Color surfaceContainerLowest  = Color(0xFFFFFFFF); // floating "glass" cards
  static const Color surfaceContainerLow     = Color(0xFFF6F3EB); // inset content areas
  static const Color surfaceContainer        = Color(0xFFEFECDE);
  static const Color surfaceContainerHigh    = Color(0xFFE8E5D8); // section separator (no lines)
  static const Color surfaceContainerHighest = Color(0xFFE2DFCF); // progress track

  // Outline / ghost border
  static const Color outline        = Color(0xFF73796E);
  static const Color outlineVariant = Color(0xFFC2C9BC); // use at 20% opacity for ghost border

  // Error
  static const Color error   = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);

  // ─────────────────────────────────────────────
  // SPACING — 8pt grid (the 8-bit grid rule)
  // ─────────────────────────────────────────────

  static const double space1 = 4.0;   // half unit — use sparingly
  static const double space2 = 8.0;   // base unit
  static const double space3 = 12.0;
  static const double space4 = 16.0;  // spacing-4 from DESIGN.md (≈0.9rem default padding)
  static const double space5 = 20.0;
  static const double space6 = 24.0;  // 1.3rem — card section gap
  static const double space8 = 32.0;
  static const double space10= 40.0;
  static const double space12= 48.0;
  static const double space16= 64.0;

  // Default page/card padding
  static const EdgeInsets pagePadding = EdgeInsets.all(space4);
  static const EdgeInsets cardPadding = EdgeInsets.all(space4);

  // ─────────────────────────────────────────────
  // SHAPE — 0px radius (the core 8-bit rule)
  // ─────────────────────────────────────────────

  static final OutlinedBorder sharpRect = RoundedRectangleBorder(
    borderRadius: BorderRadius.zero,
  );

  // ─────────────────────────────────────────────
  // TYPOGRAPHY
  // ─────────────────────────────────────────────

  static TextTheme _buildTextTheme() {
    return TextTheme(
      // "The Machine" — Press Start 2P
      // display-lg: species name on scan result
      displayLarge: GoogleFonts.pressStart2p(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: onSurface,
        height: 1.4,
      ),
      // display-md: screen titles, appbar
      displayMedium: GoogleFonts.pressStart2p(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onSurface,
        height: 1.4,
      ),
      // display-sm: section headlines
      displaySmall: GoogleFonts.pressStart2p(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: onSurface,
        height: 1.5,
      ),
      // headline: button labels
      headlineMedium: GoogleFonts.pressStart2p(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: onPrimary,
        height: 1.4,
      ),

      // "The Researcher" — Manrope for body
      // title-md: sub-headers within plant profile
      titleLarge: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: onSurface,
        height: 1.3,
      ),
      titleMedium: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: onSurface,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: onSurface,
        height: 1.4,
      ),

      // body — plant descriptions, facts
      bodyLarge: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onSurface,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onSurface,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: onSurface,
        height: 1.5,
      ),

      // Space Grotesk — metadata labels (label-sm)
      // e.g. "Sunlight Required", "Edible", confidence %
      labelLarge: GoogleFonts.spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: onSurface,
        letterSpacing: 0.5,
      ),
      labelMedium: GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: onSurface,
        letterSpacing: 0.4,
      ),
      labelSmall: GoogleFonts.spaceGrotesk(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: onSurface,
        letterSpacing: 0.4,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // COMPONENT THEMES
  // ─────────────────────────────────────────────

  // Buttons — "Tactile Switch"
  // Primary: solid green, Press Start 2P label, press = shift to primaryDim
  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: sharpRect,
          padding: const EdgeInsets.symmetric(
            horizontal: space6,
            vertical: space4,
          ),
          textStyle: GoogleFonts.pressStart2p(fontSize: 11),
        ).copyWith(
          // "Push" effect: shift to primaryDim on press
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) return primaryDim;
            return primary;
          }),
          // 2px offset "push" feel via elevation trick
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) return 0;
            return 0;
          }),
        ),
      );

  static OutlinedButtonThemeData get _outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: secondaryContainer,
          foregroundColor: onSecondaryContainer,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: sharpRect,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(
            horizontal: space6,
            vertical: space4,
          ),
          textStyle: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  // Cards — "Data Chip"
  // Header block: tertiaryContainer, body: surfaceContainerLowest
  // No dividers, no elevation, no border radius
  static CardThemeData get _cardTheme => CardThemeData(
        elevation: 0,
        shadowColor: Colors.transparent,
        color: surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        margin: EdgeInsets.zero,
      );

  // Input fields — "Command Line"
  // Background: surfaceContainerLow
  // Bottom-only ghost border using primary at 40% opacity
  // Press Start 2P for label, Manrope for input text
  static InputDecorationTheme get _inputTheme => InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerLow,
        border: const UnderlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0x66007523), // primary at 40%
            width: 1.5,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0x66007523),
            width: 1.5,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: primary,
            width: 2,
          ),
        ),
        labelStyle: GoogleFonts.pressStart2p(
          fontSize: 9,
          color: primary,
        ),
        hintStyle: GoogleFonts.manrope(
          fontSize: 14,
          color: Color(0xFF73796E),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: space4,
          vertical: space3,
        ),
      );

  // AppBar — always shows "FloraDex" in Press Start 2P
  static AppBarTheme get _appBarTheme => AppBarTheme(
        backgroundColor: primaryContainer,
        foregroundColor: onPrimaryContainer,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.pressStart2p(
          fontSize: 16,
          color: onPrimaryContainer,
          fontWeight: FontWeight.w400,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      );

  // Bottom Navigation Bar — 3 tabs: Home · Scan · Collection
  static BottomNavigationBarThemeData get _bottomNavTheme =>
      BottomNavigationBarThemeData(
        backgroundColor: surfaceContainerHigh,
        selectedItemColor: primary,
        unselectedItemColor: outline,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.spaceGrotesk(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.spaceGrotesk(
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      );

  // Progress indicator — "Botanical Progress Bar"
  // Pixelated feel: use ShaderMask with primary_fixed→primary in your widget
  static ProgressIndicatorThemeData get _progressTheme =>
      ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: surfaceContainerHighest,
        linearMinHeight: 8.0, // chunky pixel bar
      );

  // Chip — used for plant tags (edible, medicinal, etc.)
  static ChipThemeData get _chipTheme => ChipThemeData(
        backgroundColor: surfaceContainerLow,
        selectedColor: primaryContainer,
        labelStyle: GoogleFonts.spaceGrotesk(fontSize: 11),
        side: BorderSide(
          color: outlineVariant.withOpacity(0.2),
          width: 1,
        ),
        shape: sharpRect,
        padding: const EdgeInsets.symmetric(
          horizontal: space2,
          vertical: space1,
        ),
      );

  // Divider — strictly forbidden per DESIGN.md "No-Line Rule"
  // Set transparent so any accidental Divider() is invisible
  static DividerThemeData get _dividerTheme => const DividerThemeData(
        color: Colors.transparent,
        thickness: 0,
        space: 0,
      );

  // Snackbar — CRT glow feel
  static SnackBarThemeData get _snackBarTheme => SnackBarThemeData(
        backgroundColor: surfaceContainerHighest,
        contentTextStyle: GoogleFonts.manrope(
          fontSize: 13,
          color: onSurface,
        ),
        elevation: 0,
        shape: sharpRect,
        behavior: SnackBarBehavior.floating,
      );

  // ─────────────────────────────────────────────
  // MAIN THEME
  // ─────────────────────────────────────────────

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: primary,
          onPrimary: onPrimary,
          primaryContainer: primaryContainer,
          onPrimaryContainer: onPrimaryContainer,
          secondary: secondary,
          onSecondary: onSecondary,
          secondaryContainer: secondaryContainer,
          onSecondaryContainer: onSecondaryContainer,
          tertiary: tertiary,
          onTertiary: onTertiary,
          tertiaryContainer: tertiaryContainer,
          onTertiaryContainer: onTertiaryContainer,
          surface: surface,
          onSurface: onSurface,
          surfaceContainerLowest: surfaceContainerLowest,
          surfaceContainerLow: surfaceContainerLow,
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          surfaceContainerHighest: surfaceContainerHighest,
          outline: outline,
          outlineVariant: outlineVariant,
          error: error,
          onError: onError,
        ),
        textTheme: _buildTextTheme(),
        elevatedButtonTheme: _elevatedButtonTheme,
        outlinedButtonTheme: _outlinedButtonTheme,
        cardTheme: _cardTheme,
        inputDecorationTheme: _inputTheme,
        appBarTheme: _appBarTheme,
        bottomNavigationBarTheme: _bottomNavTheme,
        progressIndicatorTheme: _progressTheme,
        chipTheme: _chipTheme,
        dividerTheme: _dividerTheme,
        snackBarTheme: _snackBarTheme,
        scaffoldBackgroundColor: surface,
        // Global 0px shape override
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );
}

// ─────────────────────────────────────────────
// HELPER WIDGETS & CONSTANTS
// ─────────────────────────────────────────────

/// Card with tertiaryContainer header block + surfaceContainerLowest body
/// Matches "Data Chip" spec from DESIGN.md
class FloraDataCard extends StatelessWidget {
  const FloraDataCard({
    super.key,
    required this.header,
    required this.body,
  });

  final Widget header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header block: solid tertiaryContainer
        Container(
          color: AppTheme.tertiaryContainer,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space4,
            vertical: AppTheme.space3,
          ),
          child: DefaultTextStyle(
            style: GoogleFonts.pressStart2p(
              fontSize: 10,
              color: AppTheme.onTertiaryContainer,
            ),
            child: header,
          ),
        ),
        // Body block: surfaceContainerLowest
        Container(
          color: AppTheme.surfaceContainerLowest,
          padding: const EdgeInsets.all(AppTheme.space4),
          child: body,
        ),
      ],
    );
  }
}

/// Botanical progress bar with pixel gradient feel
/// Usage: FloraProgressBar(value: 0.72)
class FloraProgressBar extends StatelessWidget {
  const FloraProgressBar({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF4CAF50), AppTheme.primary], // primary_fixed → primary
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: AppTheme.surfaceContainerHighest,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        minHeight: 8,
      ),
    );
  }
}

/// Ghost border container — for high-density data sections
/// outlineVariant at 20% opacity, no radius
class FloraGhostBorder extends StatelessWidget {
  const FloraGhostBorder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.outlineVariant.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}