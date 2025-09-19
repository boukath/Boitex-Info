// lib/core/theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BoitexTheme {
  // This is our main method for the light theme.
  static ThemeData lightTheme() {
    // We start with a "seed" color. Material 3 uses this to generate
    // a full, harmonious color palette for the entire app.
    // This beautiful sky blue will be our primary accent color.
    const Color seedColor = Color(0xFF3B82F6);

    // Generate the color scheme from the seed.
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    // This is where we define the full theme data.
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Set the default font for the entire app to Poppins.
      // This gives it a clean, modern, and professional look.
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),

      scaffoldBackgroundColor: const Color(0xFFFDFDFD), // A very light off-white

      // --- COMPONENT THEMES ---
      // We can style specific widgets here to ensure consistency.

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 1,
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        surfaceTintColor: Colors.transparent, // Keeps app bar clean on scroll
        centerTitle: true,
      ),

      // Card Theme
      // FIXED: Used CardThemeData instead of CardTheme
      cardTheme: CardThemeData(
        elevation: 0.5,
        color: colorScheme.surface, // Clean white/off-white surface
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
      ),

      // Input Field Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),

      // Button Themes
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.primary,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        side: BorderSide.none,
        backgroundColor: colorScheme.primary.withOpacity(0.1),
        labelStyle: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600),
      ),
    );
  }
}