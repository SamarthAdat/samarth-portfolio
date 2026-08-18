import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/projects_overview.dart';
import '../../state/view_state.dart';
import '../common/view_state_builder.dart';
import 'featured_project_card.dart';
import 'project_showcase_card.dart';

/// Body of the Portfolio tab.
class ProjectsSection extends StatelessWidget {
  final ViewState<ProjectsOverview> state;

  const ProjectsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ViewStateBuilder<ProjectsOverview>(
      state: state,
      builder: (BuildContext context, ProjectsOverview overview) =>
          _ProjectsBody(overview: overview),
    );
  }
}

class _ProjectsBody extends StatelessWidget {
  static const double _cardSpacing = 18;

  final ProjectsOverview overview;

  const _ProjectsBody({required this.overview});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool twoColumns = constraints.maxWidth > 860;
        final double cardWidth = twoColumns
            ? (constraints.maxWidth - _cardSpacing) / 2
            : constraints.maxWidth;

        final Project? featured = overview.featured;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              overview.intro,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.muted,
                height: 1.65,
              ),
            ),
            const SizedBox(height: 18),
            if (featured != null) ...<Widget>[
              FeaturedProjectCard(
                project: featured,
                metrics: overview.impactMetrics,
              ),
              const SizedBox(height: 28),
            ],
            Text(
              'Project Case Studies',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: _cardSpacing,
              runSpacing: _cardSpacing,
              children: overview.caseStudies
                  .map(
                    (Project project) => SizedBox(
                      width: cardWidth,
                      child: ProjectShowcaseCard(project: project),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        );
      },
    );
  }
}
