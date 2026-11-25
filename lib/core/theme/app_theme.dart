import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Theme terpusat. Pasang di MaterialApp.router(theme: AppTheme.light()).
///
/// Font: Fira Sans untuk semua teks.
class AppTheme {
  AppTheme._();

  // Dibuat menerima parameter warna tinta teks agar adaptif saat gelap/terang
  static TextTheme _buildTextTheme(Color textColor, Color mutedColor) =>
      TextTheme(
        headlineMedium: GoogleFonts.firaSans(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.firaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
        titleMedium: GoogleFonts.firaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        bodyLarge: GoogleFonts.firaSans(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textColor,
        ),
        bodyMedium: GoogleFonts.firaSans(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: mutedColor,
        ),
        labelLarge: GoogleFonts.firaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      );

  /// Font khusus untuk kode voucher / nominal — dipakai manual lewat
  /// AppTheme.mono(...), bukan lewat TextTheme bawaan Flutter.
  static TextStyle mono({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.ink,
    double? letterSpacing,
  }) {
    return GoogleFonts.firaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing ?? 1.2,
    );
  }

  // ================= TEMA TERANG (LIGHT MODE) =================
  static ThemeData light() {
    final textTheme = _buildTextTheme(AppColors.ink, AppColors.muted);

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.ink,
        titleTextStyle: textTheme.titleLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.firaSans(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  // ================= TEMA GELAP (DARK MODE) =================
  static ThemeData dark() {
    // Balik skema warna teks (Teks utama putih/abu terang, muted abu-abu pudar)
    final textTheme = _buildTextTheme(Colors.grey[100]!, Colors.grey[400]!);

    // Default warna background gelap bawaan material atau kustom di sini
    const darkBg = Color(0xFF121212);
    const darkSurface = Color(0xFF1E1E1E);
    const darkDivider = Color(0xFF2C2C2C);

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: darkSurface,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: darkBg,
      textTheme: textTheme,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: darkBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey[100],
        titleTextStyle: textTheme.titleLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.firaSans(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: darkDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: darkDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
