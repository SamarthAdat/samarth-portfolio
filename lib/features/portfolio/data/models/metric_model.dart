import '../../../../core/utils/json_reader.dart';
import '../../domain/entities/metric.dart';

/// Data-layer representation of a [Metric].
class MetricModel {
  final MetricKind kind;
  final String value;
  final String label;

  const MetricModel({
    required this.kind,
    required this.value,
    required this.label,
  });

  factory MetricModel.fromJson(Map<String, dynamic> json) {
    return MetricModel(
      kind: json.requireEnum('kind', MetricKind.values),
      value: json.requireString('value'),
      label: json.requireString('label'),
    );
  }

  Metric toEntity() => Metric(kind: kind, value: value, label: label);
}
