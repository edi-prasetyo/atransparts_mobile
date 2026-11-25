import 'package:flutter/material.dart';

/// Semua warna app didefinisikan di sini. Kalau nanti mau ganti
/// brand color, cukup ubah di satu tempat ini — tidak perlu cari
/// satu-satu di setiap widget.
class AppColors {
  AppColors._();

  // Base
  static const background = Color(0xFFF5F6FA);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF14162B);
  static const muted = Color(0xFF8A8DA6);
  static const divider = Color(0xFFE3E5F0);
  static const fieldDark = Color.fromARGB(255, 41, 41, 41);
  static const fieldLight = Color.fromARGB(255, 255, 255, 255);
  static const cardDark = Color.fromARGB(255, 41, 41, 41);
  static const cardLight = Color.fromARGB(255, 255, 255, 255);
  static const textDark = Color.fromARGB(255, 41, 41, 41);
  static const textLight = Color.fromARGB(255, 255, 255, 255);

  // Brand
  static const primary = Color(0xFF1565C0);
  static const warning = Color.fromARGB(255, 255, 111, 14);
  static const success = Color(0xFF1FAA6D);
  static const danger = Color.fromARGB(255, 255, 0, 0);
  static const secondary = Color.fromARGB(255, 85, 85, 85);

  static const primarySoft = Color(0xFFBBDEFB);
  static const warningSoft = Color.fromARGB(255, 255, 215, 188);
  static const successSoft = Color(0xFFCDE4D5);
  static const dangerSoft = Color.fromARGB(255, 243, 179, 179);
  static const secondarySoft = Color.fromARGB(255, 185, 184, 184);

  static const primaryDark = Color(0xFF0D47A1);
  static const accent = Color(0xFF1E88E5);
  static const bgHomeColor = Color(0xFF1565C0);
  static const bgAfternoon = Color.fromARGB(255, 43, 34, 29);
  static const bgMorning = Color.fromARGB(255, 68, 63, 59);

  static const dark = Color.fromARGB(255, 0, 0, 0);
  static const transparent = Colors.transparent;

  // Basic
  static const white = Color.fromARGB(255, 255, 255, 255);
  static const grey = Color.fromARGB(255, 168, 168, 168);
  static const darkGreen = Color.fromARGB(31, 0, 118, 39);

  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, accent],
  );
}
