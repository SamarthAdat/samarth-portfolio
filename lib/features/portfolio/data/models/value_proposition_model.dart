import '../../../../core/utils/json_reader.dart';
import '../../domain/entities/value_proposition.dart';

/// Data-layer representation of a [ValueProposition].
class ValuePropositionModel {
  final ExpertiseArea area;
  final String title;
  final String description;

  const ValuePropositionModel({
    required this.area,
    required this.title,
    required this.description,
  });

  factory ValuePropositionModel.fromJson(Map<String, dynamic> json) {
    return ValuePropositionModel(
      area: json.requireEnum('area', ExpertiseArea.values),
      title: json.requireString('title'),
      description: json.requireString('description'),
    );
  }

  ValueProposition toEntity() =>
      ValueProposition(area: area, title: title, description: description);
}
