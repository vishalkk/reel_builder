import 'package:flutter/material.dart';
import 'package:mis_mobile/core/theme/premium_colors.dart';
import 'package:mis_mobile/core/theme/premium_spacing.dart';

class PremiumBadge extends StatelessWidget {
  final String label;

  const PremiumBadge({
    super.key,
    this.label = 'PREMIUM',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PremiumSpacing.x1,
        vertical: PremiumSpacing.x1,
      ),
      decoration: BoxDecoration(
        gradient: PremiumColors.goldGradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: PremiumColors.background,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
