class InjuryEvaluation {
  final String id;
  final String? userId;
  final String? location;
  final String? side;
  final String? timing;
  final String? mechanism;
  final bool? hasPopping;
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
    required this.userId,
    required this.location,
    required this.side,
    required this.timing,
    required this.mechanism,
    required this.hasPopping,
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
}
