class InjuryEvaluation {
  final String id;
  final String? userId;
  final String? location;
  final String? side;
  final String? timing;
  final String? mechanism;
  final bool? hasPopping;
  final String? frequency;
  final int? painIntensity;
  final Map<String, dynamic>? painTypes;
  final Map<String, dynamic>? painTriggers;
  final String? weightBearingCapacity;
  final Map<String, dynamic>? basicActivities;
  final String? stabilityLevel;
  final Map<String, dynamic>? symptoms;
  final bool? hasCriticalSymptoms;
  final String? activityType;
  final Map<String, dynamic>? preexistingConditions;
  final Map<String, dynamic>? additionalFactors;
  final String? preliminaryDiagnosis;
  final String? urgencyLevel;
  final int? estimatedRecoveryDays;
  final Map<String, dynamic>? initialRecommendations;
  final DateTime createdAt;

  InjuryEvaluation({
    required this.id,
    this.userId,
    this.location,
    this.side,
    this.timing,
    this.mechanism,
    this.hasPopping,
    this.frequency,
    this.painIntensity,
    this.painTypes,
    this.painTriggers,
    this.weightBearingCapacity,
    this.basicActivities,
    this.stabilityLevel,
    this.symptoms,
    this.hasCriticalSymptoms,
    this.activityType,
    this.preexistingConditions,
    this.additionalFactors,
    this.preliminaryDiagnosis,
    this.urgencyLevel,
    this.estimatedRecoveryDays,
    this.initialRecommendations,
    required this.createdAt,
  });
}
