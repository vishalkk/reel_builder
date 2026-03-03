import 'package:flutter/material.dart';
import 'package:mis_mobile/core/theme/premium_colors.dart';
import 'package:mis_mobile/core/theme/premium_spacing.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: PremiumSpacing.x2,
          vertical: PremiumSpacing.x1,
        ),
        decoration: BoxDecoration(
          color: selected ? PremiumColors.gold : PremiumColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? PremiumColors.gold : PremiumColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? PremiumColors.background
                : PremiumColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
