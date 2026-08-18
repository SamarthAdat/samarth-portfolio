import 'metric.dart';
import 'project.dart';

/// Everything the Portfolio tab renders: one featured project, the remaining
/// case studies, and the impact numbers shown beside the featured card.
class ProjectsOverview {
  final String intro;
  final Project? featured;
  final List<Project> caseStudies;
  final List<Metric> impactMetrics;

  const ProjectsOverview({
    required this.intro,
    required this.featured,
    required this.caseStudies,
    required this.impactMetrics,
  });
}
