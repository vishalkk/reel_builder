import 'package:flutter/material.dart';

class PremiumColors {
  static const Color background = Color(0xFF0B0B0B);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color card = Color(0xFF1A1A1A);
  static const Color gold = Color(0xFFD4AF37);
  static const Color softGold = Color(0xFFC6A75E);
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFA8A8A8);
  static const Color border = Color(0xFF2A2A2A);

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gold, softGold],
  );
}
