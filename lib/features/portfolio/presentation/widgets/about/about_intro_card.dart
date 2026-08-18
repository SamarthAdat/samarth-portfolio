import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../common/pill_badge.dart';

/// The gradient panel introducing the engineering profile.
class AboutIntroCard extends StatelessWidget {
  final String badgeLabel;
  final String headline;
  final String summary;

  const AboutIntroCard({
    super.key,
    required this.badgeLabel,
    required this.headline,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.introGradient,
          stops: <double>[0.0, 0.48, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.34)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PillBadge(label: badgeLabel),
          const SizedBox(height: 14),
          Text(
            headline,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontSize: 28, height: 1.25),
          ),
          const SizedBox(height: 12),
          Text(
            summary,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14.5,
              height: 1.65,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
