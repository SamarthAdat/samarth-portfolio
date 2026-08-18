import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// A rounded accent label, e.g. "Engineering Profile".
class PillBadge extends StatelessWidget {
  final String label;

  /// Featured surfaces use a stronger fill and a visible outline.
  final bool emphasized;

  const PillBadge({super.key, required this.label, this.emphasized = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: emphasized ? 12 : 11,
        vertical: emphasized ? 7 : 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: emphasized ? 0.16 : 0.13),
        borderRadius: BorderRadius.circular(99),
        border: emphasized
            ? Border.all(color: AppColors.accent.withValues(alpha: 0.45))
            : null,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.accent,
          fontSize: 11.5,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
