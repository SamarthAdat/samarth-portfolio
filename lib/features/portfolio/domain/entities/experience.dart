/// A professional role held, with its delivery highlights.
class Experience {
  final String role;
  final String company;
  final String duration;
  final String location;
  final List<String> points;

  const Experience({
    required this.role,
    required this.company,
    required this.duration,
    required this.location,
    required this.points,
  });

  /// Line rendered under the role in the timeline.
  String get subtitle => '$company — $location';
}
