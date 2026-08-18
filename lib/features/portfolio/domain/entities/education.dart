/// A qualification earned.
class Education {
  final String degree;
  final String institute;
  final String duration;
  final String result;

  const Education({
    required this.degree,
    required this.institute,
    required this.duration,
    required this.result,
  });

  /// Duration and result, combined for the timeline's meta line.
  String get durationWithResult => '$duration · $result';
}
