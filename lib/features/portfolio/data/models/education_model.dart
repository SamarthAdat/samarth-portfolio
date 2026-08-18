import '../../../../core/utils/json_reader.dart';
import '../../domain/entities/education.dart';

/// Data-layer representation of an [Education] entry.
class EducationModel {
  final String degree;
  final String institute;
  final String duration;
  final String result;

  const EducationModel({
    required this.degree,
    required this.institute,
    required this.duration,
    required this.result,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      degree: json.requireString('degree'),
      institute: json.requireString('institute'),
      duration: json.requireString('duration'),
      result: json.requireString('result'),
    );
  }

  Education toEntity() => Education(
    degree: degree,
    institute: institute,
    duration: duration,
    result: result,
  );
}
