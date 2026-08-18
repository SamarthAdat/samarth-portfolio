import '../../../../core/utils/json_reader.dart';
import '../../domain/entities/project.dart';

/// Data-layer representation of a [Project].
class ProjectModel {
  final String name;
  final ProjectCategory category;
  final String role;
  final String duration;
  final String summary;
  final String outcome;
  final List<String> stack;
  final List<String> highlights;
  final bool isFeatured;

  const ProjectModel({
    required this.name,
    required this.category,
    required this.role,
    required this.duration,
    required this.summary,
    required this.outcome,
    required this.stack,
    required this.highlights,
    required this.isFeatured,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      name: json.requireString('name'),
      category: json.requireEnum('category', ProjectCategory.values),
      role: json.requireString('role'),
      duration: json.requireString('duration'),
      summary: json.requireString('summary'),
      outcome: json.requireString('outcome'),
      stack: json.requireStringList('stack'),
      highlights: json.requireStringList('highlights'),
      isFeatured: json.optionalBool('isFeatured'),
    );
  }

  Project toEntity() => Project(
    name: name,
    category: category,
    role: role,
    duration: duration,
    summary: summary,
    outcome: outcome,
    stack: stack,
    highlights: highlights,
    isFeatured: isFeatured,
  );
}
