import 'package:moviles252/features/recovery/domain/entities/injury_evaluation.dart';

class InjuryEvaluationModel extends InjuryEvaluation {
  InjuryEvaluationModel({
    required String id,
    required String? userId,
    required String? location,
    required String? side,
    required String? timing,
    required String? mechanism,
    required bool? hasPopping,
    required int? painIntensity,
    required Map<String, dynamic>? painTypes,
    required Map<String, dynamic>? painTriggers,
    required String? weightBearingCapacity,
    required Map<String, dynamic>? basicActivities,
    required String? stabilityLevel,
    required Map<String, dynamic>? symptoms,
    required bool? hasCriticalSymptoms,
    required String? activityType,
    required Map<String, dynamic>? preexistingConditions,
    required Map<String, dynamic>? additionalFactors,
    required String? preliminaryDiagnosis,
    required String? urgencyLevel,
    required int? estimatedRecoveryDays,
    required Map<String, dynamic>? initialRecommendations,
    required DateTime createdAt,
  }) : super(
         id: id,
         userId: userId,
         location: location,
         side: side,
         timing: timing,
         mechanism: mechanism,
         hasPopping: hasPopping,
         painIntensity: painIntensity,
         painTypes: painTypes,
         painTriggers: painTriggers,
         weightBearingCapacity: weightBearingCapacity,
         basicActivities: basicActivities,
         stabilityLevel: stabilityLevel,
         symptoms: symptoms,
         hasCriticalSymptoms: hasCriticalSymptoms,
         activityType: activityType,
         preexistingConditions: preexistingConditions,
         additionalFactors: additionalFactors,
         preliminaryDiagnosis: preliminaryDiagnosis,
         urgencyLevel: urgencyLevel,
         estimatedRecoveryDays: estimatedRecoveryDays,
         initialRecommendations: initialRecommendations,
         createdAt: createdAt,
       );

  factory InjuryEvaluationModel.fromJson(Map<String, dynamic> json) {
    return InjuryEvaluationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      location: json['location'] as String?,
      side: json['side'] as String?,
      timing: json['timing'] as String?,
      mechanism: json['mechanism'] as String?,
      hasPopping: json['has_popping'] as bool?,
      painIntensity: (json['pain_intensity'] as int?)?.toInt(),
      painTypes: (json['pain_types'] as Map<String, dynamic>?)
          ?.cast<String, dynamic>(),
      painTriggers: (json['pain_triggers'] as Map<String, dynamic>?)
          ?.cast<String, dynamic>(),
      weightBearingCapacity: json['weight_bearing_capacity'] as String?,
      basicActivities: (json['basic_activities'] as Map<String, dynamic>?)
          ?.cast<String, dynamic>(),
      stabilityLevel: json['stability_level'] as String?,
      symptoms: (json['symptoms'] as Map<String, dynamic>?)
          ?.cast<String, dynamic>(),
      hasCriticalSymptoms: json['has_critical_symptoms'] as bool?,
      activityType: json['activity_type'] as String?,
      preexistingConditions:
          (json['preexisting_conditions'] as Map<String, dynamic>?)
              ?.cast<String, dynamic>(),
      additionalFactors: (json['additional_factors'] as Map<String, dynamic>?)
          ?.cast<String, dynamic>(),
      preliminaryDiagnosis: json['preliminary_diagnosis'] as String?,
      urgencyLevel: json['urgency_level'] as String?,
      estimatedRecoveryDays: (json['estimated_recovery_days'] as int?)?.toInt(),
      initialRecommendations:
          (json['initial_recommendations'] as Map<String, dynamic>?)
              ?.cast<String, dynamic>(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
