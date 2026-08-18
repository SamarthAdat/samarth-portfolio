import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// The raised, rounded panel used for the sidebar and the main content area.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GlassCard({super.key, required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 32,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: child,
    );
  }
}
