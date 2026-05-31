import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Industrial Slate Scale
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // Safety Orange Scale
  static const Color orange50 = Color(0xFFFFF7ED);
  static const Color orange500 = Color(0xFFF97316);
  static const Color orange600 = Color(0xFFEA580C);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: slate500,
        primary: slate700,
        secondary: orange500,
        surface: slate50,
        onSurface: slate900,
        outline: slate200,
      ),
      scaffoldBackgroundColor: slate50,
      textTheme: GoogleFonts.firaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.firaSans(
          fontWeight: FontWeight.bold,
          color: slate900,
        ),
        displayMedium: GoogleFonts.firaSans(
          fontWeight: FontWeight.bold,
          color: slate900,
        ),
        titleLarge: GoogleFonts.firaSans(
          fontWeight: FontWeight.w600,
          color: slate900,
        ),
        bodyLarge: GoogleFonts.firaSans(color: slate800),
        bodyMedium: GoogleFonts.firaSans(color: slate700),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: slate900,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.firaSans(
          color: slate900,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        shape: Border(bottom: BorderSide(color: slate200, width: 1)),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: slate200, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: orange500,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.firaSans(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: slate200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: slate200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: orange500, width: 2),
        ),
        labelStyle: TextStyle(color: slate500),
      ),
    );
  }
}
