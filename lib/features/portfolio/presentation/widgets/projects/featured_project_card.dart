import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/metric.dart';
import '../../../domain/entities/project.dart';
import '../common/pill_badge.dart';
import 'impact_metric_tile.dart';
import 'stack_chip.dart';

/// The large card for the headline project, with impact numbers alongside.
class FeaturedProjectCard extends StatelessWidget {
  /// Highlights shown on the card; the rest stay in the case-study view.
  static const int _visibleHighlights = 3;

  final Project project;
  final List<Metric> metrics;

  const FeaturedProjectCard({
    super.key,
    required this.project,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth > 760;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(wide ? 26 : 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.featuredGradient,
              stops: <double>[0.0, 0.45, 1.0],
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.35)),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 30,
                offset: Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const PillBadge(
                label: 'Featured Production Build',
                emphasized: true,
              ),
              const SizedBox(height: 14),
              Text(
                project.name,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                project.roleWithDuration,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                project.summary,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.text,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: _FeaturedProjectDetails(project: project)),
                    const SizedBox(width: 20),
                    SizedBox(width: 250, child: _buildMetricColumn()),
                  ],
                )
              else ...<Widget>[
                _FeaturedProjectDetails(project: project),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: metrics
                      .map((Metric metric) => ImpactMetricTile(metric: metric))
                      .toList(growable: false),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricColumn() {
    return Column(
      children: metrics
          .map((Metric metric) => ImpactMetricTile(metric: metric))
          .toList(growable: false),
    );
  }
}

class _FeaturedProjectDetails extends StatelessWidget {
  final Project project;

  const _FeaturedProjectDetails({required this.project});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardLight.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
          ),
          child: Text(
            project.outcome,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.text),
          ),
        ),
        const SizedBox(height: 16),
        ...project.highlights
            .take(FeaturedProjectCard._visibleHighlights)
            .map(
              (String highlight) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        highlight,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: project.stack
              .map((String item) => StackChip(label: item))
              .toList(growable: false),
        ),
      ],
    );
  }
}
