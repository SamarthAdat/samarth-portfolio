import 'metric.dart';
import 'value_proposition.dart';

/// Everything the About tab needs, assembled by the repository so the UI makes
/// a single request instead of stitching pieces together itself.
class AboutOverview {
  final String badgeLabel;
  final String headline;
  final String summary;
  final List<Metric> metrics;
  final List<ValueProposition> valuePropositions;

  /// The subset of skills shown as the "Core Toolchain".
  final List<String> coreSkills;

  const AboutOverview({
    required this.badgeLabel,
    required this.headline,
    required this.summary,
    required this.metrics,
    required this.valuePropositions,
    required this.coreSkills,
  });
}
