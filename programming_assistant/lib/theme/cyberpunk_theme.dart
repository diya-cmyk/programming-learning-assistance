import 'package:flutter/material.dart';

class CyberpunkTheme {
  static const Color bg = Color(0xFF0D0D1A);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color primary = Color(0xFF00F5FF);
  static const Color secondary = Color(0xFF7C3AED);
  static const Color accent = Color(0xFFFF2D78);
  static const Color text = Color(0xFFE2E8F0);
  static const Color textMuted = Color(0xFF64748B);

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.dark(
      surface: surface,
      primary: primary,
      secondary: secondary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      foregroundColor: primary,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: Color(0xFF475569),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    cardTheme: CardThemeData(
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
    ),
  );
}
