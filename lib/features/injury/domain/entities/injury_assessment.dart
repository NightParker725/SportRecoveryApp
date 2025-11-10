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
      'user_id': userId,
      'location': location,
      'side': side,
      'timing': timing,
      'mechanism': mechanism,
      'has_popping': hasPopping,
      'frequency': frequency,
      'pain_intensity': painIntensity,
      'pain_types': painTypes,
      'pain_triggers': painTriggers,
      'weight_bearing_capacity': weightBearingCapacity,
      'basic_activities': basicActivities,
      'stability_level': stabilityLevel,
      'symptoms': symptoms,
      'has_critical_symptoms': hasCriticalSymptoms,
      'activity_type': activityType,
      'preexisting_conditions': preexistingConditions,
      'additional_factors': additionalFactors,
      'preliminary_diagnosis': preliminaryDiagnosis,
      'urgency_level': urgencyLevel,
      'estimated_recovery_days': estimatedRecoveryDays,
      'initial_recommendations': initialRecommendations,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory InjuryAssessment.fromJson(Map<String, dynamic> json) {
    return InjuryAssessment(
      userId: json['user_id'],
      location: json['location'],
      side: json['side'],
      timing: json['timing'],
      mechanism: json['mechanism'],
      hasPopping: json['has_popping'],
      frequency: json['frequency'],
      painIntensity: json['pain_intensity'],
      painTypes: List<String>.from(json['pain_types'] ?? []),
      painTriggers: List<String>.from(json['pain_triggers'] ?? []),
      weightBearingCapacity: json['weight_bearing_capacity'],
      basicActivities: List<String>.from(json['basic_activities'] ?? []),
      stabilityLevel: json['stability_level'],
      symptoms: List<String>.from(json['symptoms'] ?? []),
      hasCriticalSymptoms: json['has_critical_symptoms'],
      activityType: json['activity_type'],
      preexistingConditions: List<String>.from(json['preexisting_conditions'] ?? []),
      additionalFactors: List<String>.from(json['additional_factors'] ?? []),
      preliminaryDiagnosis: json['preliminary_diagnosis'],
      urgencyLevel: json['urgency_level'],
      estimatedRecoveryDays: json['estimated_recovery_days'],
      initialRecommendations: List<String>.from(json['initial_recommendations'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  @override
  String toString() =>
      'InjuryAssessment(location: $location, preliminaryDiagnosis: $preliminaryDiagnosis, urgencyLevel: $urgencyLevel)';
}
