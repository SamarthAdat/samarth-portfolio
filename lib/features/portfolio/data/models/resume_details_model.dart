import '../../../../core/utils/json_reader.dart';
import '../../domain/entities/resume_details.dart';
import 'education_model.dart';
import 'experience_model.dart';
import 'resume_highlight_model.dart';

/// Data-layer representation of the Resume tab payload.
class ResumeDetailsModel {
  final String intro;
  final List<ResumeHighlightModel> highlights;
  final List<ExperienceModel> experiences;
  final List<EducationModel> education;
  final List<String> skills;
  final List<String> coursework;
  final List<String> achievements;

  const ResumeDetailsModel({
    required this.intro,
    required this.highlights,
    required this.experiences,
    required this.education,
    required this.skills,
    required this.coursework,
    required this.achievements,
  });

  factory ResumeDetailsModel.fromJson(Map<String, dynamic> json) {
    return ResumeDetailsModel(
      intro: json.requireString('intro'),
      highlights: json
          .requireObjectList('highlights')
          .map(ResumeHighlightModel.fromJson)
          .toList(growable: false),
      experiences: json
          .requireObjectList('experiences')
          .map(ExperienceModel.fromJson)
          .toList(growable: false),
      education: json
          .requireObjectList('education')
          .map(EducationModel.fromJson)
          .toList(growable: false),
      skills: json.requireStringList('skills'),
      coursework: json.requireStringList('coursework'),
      achievements: json.requireStringList('achievements'),
    );
  }

  ResumeDetails toEntity() => ResumeDetails(
    intro: intro,
    highlights: highlights
        .map((ResumeHighlightModel model) => model.toEntity())
        .toList(growable: false),
    experiences: experiences
        .map((ExperienceModel model) => model.toEntity())
        .toList(growable: false),
    education: education
        .map((EducationModel model) => model.toEntity())
        .toList(growable: false),
    skills: skills,
    coursework: coursework,
    achievements: achievements,
  );
}
