/// Product domain a project belongs to; drives its icon in the UI.
enum ProjectCategory {
  agriTech,
  machineLearning,
  healthcare,
  conversationalAi,
  services,
}

/// A piece of work shown on the Portfolio tab.
class Project {
  final String name;
  final ProjectCategory category;
  final String role;
  final String duration;
  final String summary;

  /// The result the work produced, highlighted in its own panel.
  final String outcome;

  final List<String> stack;
  final List<String> highlights;

  /// Whether this is the headline project rendered as the large card.
  final bool isFeatured;

  const Project({
    required this.name,
    required this.category,
    required this.role,
    required this.duration,
    required this.summary,
    required this.outcome,
    required this.stack,
    required this.highlights,
    this.isFeatured = false,
  });

  /// Role and duration, combined for the featured card's meta line.
  String get roleWithDuration => '$role | $duration';
}
