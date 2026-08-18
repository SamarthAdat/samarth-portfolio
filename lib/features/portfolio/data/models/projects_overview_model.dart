import '../../../../core/utils/json_reader.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/projects_overview.dart';
import 'metric_model.dart';
import 'project_model.dart';

/// Data-layer representation of the Portfolio tab payload.
class ProjectsOverviewModel {
  final String intro;
  final List<MetricModel> impactMetrics;
  final List<ProjectModel> items;

  const ProjectsOverviewModel({
    required this.intro,
    required this.impactMetrics,
    required this.items,
  });

  factory ProjectsOverviewModel.fromJson(Map<String, dynamic> json) {
    return ProjectsOverviewModel(
      intro: json.requireString('intro'),
      impactMetrics: json
          .requireObjectList('impactMetrics')
          .map(MetricModel.fromJson)
          .toList(growable: false),
      items: json
          .requireObjectList('items')
          .map(ProjectModel.fromJson)
          .toList(growable: false),
    );
  }

  /// Splits the flat project list into the featured entry and the remaining
  /// case studies, so the UI never has to decide what "featured" means.
  ProjectsOverview toEntity() {
    final List<Project> projects = items
        .map((ProjectModel model) => model.toEntity())
        .toList(growable: false);

    Project? featured;
    for (final Project project in projects) {
      if (project.isFeatured) {
        featured = project;
        break;
      }
    }

    return ProjectsOverview(
      intro: intro,
      featured: featured,
      caseStudies: projects
          .where((Project project) => !identical(project, featured))
          .toList(growable: false),
      impactMetrics: impactMetrics
          .map((MetricModel model) => model.toEntity())
          .toList(growable: false),
    );
  }
}
