import 'package:flutter/material.dart';

import '../../../domain/entities/about_overview.dart';
import '../../../domain/entities/metric.dart';
import '../../../domain/entities/value_proposition.dart';
import '../../state/view_state.dart';
import '../common/skill_chip_wrap.dart';
import '../common/view_state_builder.dart';
import 'about_intro_card.dart';
import 'metric_tile.dart';
import 'value_proposition_card.dart';

/// Body of the About tab.
///
/// Nothing here uses [Expanded]: the panel's scroll view provides the height,
/// so the grid shrink-wraps with a fixed extent instead.
class AboutSection extends StatelessWidget {
  final ViewState<AboutOverview> state;

  const AboutSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ViewStateBuilder<AboutOverview>(
      state: state,
      builder: (BuildContext context, AboutOverview overview) =>
          _AboutBody(overview: overview),
    );
  }
}

class _AboutBody extends StatelessWidget {
  final AboutOverview overview;

  const _AboutBody({required this.overview});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool twoColumns = constraints.maxWidth > 560;
        final bool wideMetrics = constraints.maxWidth > 860;
        final double metricWidth = wideMetrics
            ? (constraints.maxWidth - 24) / 4
            : twoColumns
            ? (constraints.maxWidth - 12) / 2
            : constraints.maxWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AboutIntroCard(
              badgeLabel: overview.badgeLabel,
              headline: overview.headline,
              summary: overview.summary,
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: overview.metrics
                  .map(
                    (Metric metric) => SizedBox(
                      width: metricWidth,
                      child: MetricTile(metric: metric),
                    ),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: 30),
            Text(
              'How I Create Value',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: overview.valuePropositions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: twoColumns ? 2 : 1,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                mainAxisExtent: twoColumns ? 152 : 136,
              ),
              itemBuilder: (BuildContext context, int index) {
                final ValueProposition proposition =
                    overview.valuePropositions[index];
                return ValuePropositionCard(proposition: proposition);
              },
            ),
            const SizedBox(height: 30),
            Text(
              'Core Toolchain',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            SkillChipWrap(items: overview.coreSkills),
          ],
        );
      },
    );
  }
}
