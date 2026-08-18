/// The area of engineering a value proposition belongs to.
enum ExpertiseArea { mobile, backend, cloud, analytics }

/// One "How I Create Value" card: an area plus what is delivered in it.
class ValueProposition {
  final ExpertiseArea area;
  final String title;
  final String description;

  const ValueProposition({
    required this.area,
    required this.title,
    required this.description,
  });
}
