import 'education.dart';
import 'experience.dart';
import 'resume_highlight.dart';

/// Everything the Resume tab renders.
class ResumeDetails {
  final String intro;
  final List<ResumeHighlight> highlights;
  final List<Experience> experiences;
  final List<Education> education;
  final List<String> skills;
  final List<String> coursework;
  final List<String> achievements;

  const ResumeDetails({
    required this.intro,
    required this.highlights,
    required this.experiences,
    required this.education,
    required this.skills,
    required this.coursework,
    required this.achievements,
  });
}
