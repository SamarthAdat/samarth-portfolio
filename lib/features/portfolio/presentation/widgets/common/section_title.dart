import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// Heading of a tab: an optional eyebrow line, the title, and the accent rule.
class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionTitle({super.key, required this.title, this.subtitle = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (subtitle.isNotEmpty) ...<Widget>[
          Text(
            subtitle.toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.softMuted,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        Container(
          width: 42,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ],
    );
  }
}
