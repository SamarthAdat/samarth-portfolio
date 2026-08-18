import '../../../../core/utils/json_reader.dart';
import '../../domain/entities/experience.dart';

/// Data-layer representation of an [Experience].
class ExperienceModel {
  final String role;
  final String company;
  final String duration;
  final String location;
  final List<String> points;

  const ExperienceModel({
    required this.role,
    required this.company,
    required this.duration,
    required this.location,
    required this.points,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      role: json.requireString('role'),
      company: json.requireString('company'),
      duration: json.requireString('duration'),
      location: json.requireString('location'),
      points: json.requireStringList('points'),
    );
  }

  Experience toEntity() => Experience(
    role: role,
    company: company,
    duration: duration,
    location: location,
    points: points,
  );
}
