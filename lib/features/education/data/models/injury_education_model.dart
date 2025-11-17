import '../../domain/entities/injury_education.dart';

class InjuryEducationModel {
  final String id;
  final String bodyLocation;
  final String name;
  final String description;
  final List<String> causes;
  final List<String> symptoms;
  final List<String> recommendations;
  final int recoveryDays;
  final String severity;

  InjuryEducationModel({
    required this.id,
    required this.bodyLocation,
    required this.name,
    required this.description,
    required this.causes,
    required this.symptoms,
    required this.recommendations,
    required this.recoveryDays,
    required this.severity,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'body_location': bodyLocation,
    'name': name,
    'description': description,
    'causes': causes,
    'symptoms': symptoms,
    'recommendations': recommendations,
    'recovery_days': recoveryDays,
    'severity': severity,
  };

  factory InjuryEducationModel.fromJson(Map<String, dynamic> json) {
    return InjuryEducationModel(
      id: json['id'] as String,
      bodyLocation: json['body_location'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      causes: List<String>.from(json['causes'] as List? ?? []),
      symptoms: List<String>.from(json['symptoms'] as List? ?? []),
      recommendations: List<String>.from(json['recommendations'] as List? ?? []),
      recoveryDays: json['recovery_days'] as int,
      severity: json['severity'] as String,
    );
  }

  /// Convert model to entity
  InjuryEducation toEntity() {
    return InjuryEducation(
      id: id,
      bodyLocation: bodyLocation,
      name: name,
      description: description,
      causes: causes,
      symptoms: symptoms,
      recommendations: recommendations,
      recoveryDays: recoveryDays,
      severity: severity,
    );
  }
}
