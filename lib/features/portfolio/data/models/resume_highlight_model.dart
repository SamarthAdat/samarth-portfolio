import '../../../../core/utils/json_reader.dart';
import '../../domain/entities/resume_highlight.dart';

/// Data-layer representation of a [ResumeHighlight].
class ResumeHighlightModel {
  final String title;
  final String value;
  final String detail;

  const ResumeHighlightModel({
    required this.title,
    required this.value,
    required this.detail,
  });

  factory ResumeHighlightModel.fromJson(Map<String, dynamic> json) {
    return ResumeHighlightModel(
      title: json.requireString('title'),
      value: json.requireString('value'),
      detail: json.requireString('detail'),
    );
  }

  ResumeHighlight toEntity() =>
      ResumeHighlight(title: title, value: value, detail: detail);
}
