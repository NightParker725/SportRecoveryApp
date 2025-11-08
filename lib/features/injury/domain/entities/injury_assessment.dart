class InjuryAssessment {
  final String userId;
  final String location;
  final String side;
  final String timing;
  final String mechanism;
  final bool hasPopping;
  final String frequency;
  final int painIntensity;
  final List<String> painTypes;
  final List<String> painTriggers;
  final String weightBearingCapacity;
  final List<String> basicActivities;
  final String stabilityLevel;
  final List<String> symptoms;
  final bool hasCriticalSymptoms;
  final String activityType;
  final List<String> preexistingConditions;
  final List<String> additionalFactors;
  final String preliminaryDiagnosis;
  final String urgencyLevel;
  final int estimatedRecoveryDays;
  final List<String> initialRecommendations;
  final DateTime createdAt;

  InjuryAssessment({
    required this.userId,
    required this.location,
    required this.side,
    required this.timing,
    required this.mechanism,
    required this.hasPopping,
    required this.frequency,
    required this.painIntensity,
    required this.painTypes,
    required this.painTriggers,
    required this.weightBearingCapacity,
    required this.basicActivities,
    required this.stabilityLevel,
    required this.symptoms,
    required this.hasCriticalSymptoms,
    required this.activityType,
    required this.preexistingConditions,
    required this.additionalFactors,
    required this.preliminaryDiagnosis,
    required this.urgencyLevel,
    required this.estimatedRecoveryDays,
    required this.initialRecommendations,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'location': location,
      'side': side,
      'timing': timing,
      'mechanism': mechanism,
      'hasPopping': hasPopping,
      'frequency': frequency,
      'painIntensity': painIntensity,
      'painTypes': painTypes,
      'painTriggers': painTriggers,
      'weightBearingCapacity': weightBearingCapacity,
      'basicActivities': basicActivities,
      'stabilityLevel': stabilityLevel,
      'symptoms': symptoms,
      'hasCriticalSymptoms': hasCriticalSymptoms,
      'activityType': activityType,
      'preexistingConditions': preexistingConditions,
      'additionalFactors': additionalFactors,
      'preliminaryDiagnosis': preliminaryDiagnosis,
      'urgencyLevel': urgencyLevel,
      'estimatedRecoveryDays': estimatedRecoveryDays,
      'initialRecommendations': initialRecommendations,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory InjuryAssessment.fromJson(Map<String, dynamic> json) {
    return InjuryAssessment(
      userId: json['userId'],
      location: json['location'],
      side: json['side'],
      timing: json['timing'],
      mechanism: json['mechanism'],
      hasPopping: json['hasPopping'],
      frequency: json['frequency'],
      painIntensity: json['painIntensity'],
      painTypes: List<String>.from(json['painTypes']),
      painTriggers: List<String>.from(json['painTriggers']),
      weightBearingCapacity: json['weightBearingCapacity'],
      basicActivities: List<String>.from(json['basicActivities']),
      stabilityLevel: json['stabilityLevel'],
      symptoms: List<String>.from(json['symptoms']),
      hasCriticalSymptoms: json['hasCriticalSymptoms'],
      activityType: json['activityType'],
      preexistingConditions: List<String>.from(json['preexistingConditions']),
      additionalFactors: List<String>.from(json['additionalFactors']),
      preliminaryDiagnosis: json['preliminaryDiagnosis'],
      urgencyLevel: json['urgencyLevel'],
      estimatedRecoveryDays: json['estimatedRecoveryDays'],
      initialRecommendations: List<String>.from(json['initialRecommendations']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  String toString() =>
      'InjuryAssessment(location: $location, preliminaryDiagnosis: $preliminaryDiagnosis, urgencyLevel: $urgencyLevel)';
}
