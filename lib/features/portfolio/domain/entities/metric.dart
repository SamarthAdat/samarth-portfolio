/// What a headline number represents, so the UI can pick a matching icon.
enum MetricKind { audience, performance, leadership, award }

/// A single headline number, e.g. `10k+ farmers using production app`.
class Metric {
  final MetricKind kind;
  final String value;
  final String label;

  const Metric({
    required this.kind,
    required this.value,
    required this.label,
  });
}
