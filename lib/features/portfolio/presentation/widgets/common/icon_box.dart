import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// A rounded square holding an accent icon, used beside resume headings.
class IconBox extends StatelessWidget {
  final IconData icon;

  const IconBox({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.subtleShadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.accent, size: 21),
    );
  }
}
