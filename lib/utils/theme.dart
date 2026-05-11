// lib/utils/theme.dart
// Centralized theme: Deep Indigo + Slate Gray, rounded 20dp, soft shadows.

import 'package:flutter/material.dart';

class AppColors {
  static const Color deepIndigo = Color(0xFF1A1A40);
  static const Color indigo = Color(0xFF272761);
  static const Color accent = Color(0xFF6C63FF);
  static const Color slate = Color(0xFF64748B);
  static const Color slateLight = Color(0xFFCBD5E1);
  static const Color bg = Color(0xFFF7F8FC);
  static const Color card = Colors.white;
}

ThemeData buildAppTheme() {
  final base = ThemeData.light();
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.light(
      primary: AppColors.deepIndigo,
      secondary: AppColors.accent,
      surface: AppColors.card,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.deepIndigo,
      displayColor: AppColors.deepIndigo,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColors.deepIndigo,
      centerTitle: true,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.card,
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.7),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.slateLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.slateLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.deepIndigo,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

// Reusable cinematic gradient background.
const LinearGradient kAuthGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF1A1A40),
    Color(0xFF272761),
    Color(0xFF6C63FF),
  ],
);
