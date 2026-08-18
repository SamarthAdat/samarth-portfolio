import '../../../../core/utils/json_reader.dart';
import '../../domain/entities/about_overview.dart';
import 'metric_model.dart';
import 'value_proposition_model.dart';

/// Data-layer representation of the About tab payload.
class AboutOverviewModel {
  final String badgeLabel;
  final String headline;
  final String summary;

  /// How many skills, from the top of the resume's skill list, are shown as
  /// the "Core Toolchain".
  final int coreSkillCount;

  final List<MetricModel> metrics;
  final List<ValuePropositionModel> valuePropositions;

  const AboutOverviewModel({
    required this.badgeLabel,
    required this.headline,
    required this.summary,
    required this.coreSkillCount,
    required this.metrics,
    required this.valuePropositions,
  });

  factory AboutOverviewModel.fromJson(Map<String, dynamic> json) {
    return AboutOverviewModel(
      badgeLabel: json.requireString('badgeLabel'),
      headline: json.requireString('headline'),
      summary: json.requireString('summary'),
      coreSkillCount: json.requireInt('coreSkillCount'),
      metrics: json
          .requireObjectList('metrics')
          .map(MetricModel.fromJson)
          .toList(growable: false),
      valuePropositions: json
          .requireObjectList('valuePropositions')
          .map(ValuePropositionModel.fromJson)
          .toList(growable: false),
    );
  }

  /// [coreSkills] comes from the resume payload, so the repository supplies it.
  AboutOverview toEntity({required List<String> coreSkills}) => AboutOverview(
    badgeLabel: badgeLabel,
    headline: headline,
    summary: summary,
    metrics: metrics
        .map((MetricModel model) => model.toEntity())
        .toList(growable: false),
    valuePropositions: valuePropositions
        .map((ValuePropositionModel model) => model.toEntity())
        .toList(growable: false),
    coreSkills: coreSkills,
  );
}
