import 'package:flutter/material.dart';
import 'package:mis_mobile/core/theme/premium_colors.dart';

class PremiumTheme {
  static ThemeData get theme {
    final colorScheme = const ColorScheme.dark().copyWith(
      primary: PremiumColors.gold,
      onPrimary: PremiumColors.background,
      secondary: PremiumColors.softGold,
      onSecondary: PremiumColors.background,
      surface: PremiumColors.surface,
      onSurface: PremiumColors.textPrimary,
      error: const Color(0xFFE57373),
      onError: PremiumColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Plus Jakarta',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: PremiumColors.background,
      canvasColor: PremiumColors.background,
      cardColor: PremiumColors.card,
      dividerColor: PremiumColors.border,
      appBarTheme: const AppBarTheme(
        backgroundColor: PremiumColors.background,
        foregroundColor: PremiumColors.textPrimary,
        elevation: 0,
      ),
      iconTheme: const IconThemeData(color: PremiumColors.softGold),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PremiumColors.gold,
          foregroundColor: PremiumColors.background,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: PremiumColors.surface,
        selectedColor: PremiumColors.gold,
        disabledColor: PremiumColors.border,
        labelStyle: const TextStyle(
          color: PremiumColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: const TextStyle(
          color: PremiumColors.background,
          fontWeight: FontWeight.w600,
        ),
        side: const BorderSide(color: PremiumColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: PremiumColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 30,
          color: PremiumColors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: PremiumColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: PremiumColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: PremiumColors.textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 18,
          color: PremiumColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: PremiumColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 12,
          color: PremiumColors.textSecondary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PremiumColors.surface,
        hintStyle: const TextStyle(color: PremiumColors.textSecondary),
        labelStyle: const TextStyle(color: PremiumColors.textSecondary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PremiumColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PremiumColors.gold),
        ),
      ),
    );
  }
}
