import 'package:flutter/material.dart';
import 'package:mis_mobile/core/theme/premium_colors.dart';
import 'package:mis_mobile/core/theme/premium_spacing.dart';

class DurationBadge extends StatelessWidget {
  final String duration;

  const DurationBadge({
    super.key,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PremiumSpacing.x1,
        vertical: PremiumSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: PremiumColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: PremiumColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule,
            size: 16,
            color: PremiumColors.softGold,
          ),
          const SizedBox(width: PremiumSpacing.x1),
          Text(
            duration,
            style: const TextStyle(
              color: PremiumColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
