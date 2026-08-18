import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../common/bullet_text.dart';

/// One entry in the experience or education timeline.
class TimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String duration;
  final List<String> points;

  const TimelineItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.duration,
    this.points = const <String>[],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardLight.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 3,
            height: points.isEmpty ? 62 : 80,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 5),
                Text(
                  duration,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (points.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 12),
                  ...points.map((String point) => BulletText(text: point)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
