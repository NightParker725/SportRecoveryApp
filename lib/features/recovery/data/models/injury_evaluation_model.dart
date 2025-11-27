import '../../domain/entities/injury_evaluation.dart';

class InjuryEvaluationModel extends InjuryEvaluation {
  InjuryEvaluationModel({
    required String id,
    String? userId,
    String? location,
    String? side,
    String? timing,
    String? mechanism,
    bool? hasPopping,
    String? frequency,
    int? painIntensity,
    Map<String, dynamic>? painTypes,
    Map<String, dynamic>? painTriggers,
    String? weightBearingCapacity,
    Map<String, dynamic>? basicActivities,
    String? stabilityLevel,
    Map<String, dynamic>? symptoms,
    bool? hasCriticalSymptoms,
    String? activityType,
    Map<String, dynamic>? preexistingConditions,
    Map<String, dynamic>? additionalFactors,
    String? preliminaryDiagnosis,
    String? urgencyLevel,
    int? estimatedRecoveryDays,
    Map<String, dynamic>? initialRecommendations,
    required DateTime createdAt,
  }) : super(
         id: id,
         userId: userId,
         location: location,
         side: side,
         timing: timing,
         mechanism: mechanism,
         hasPopping: hasPopping,
         frequency: frequency,
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

  // Accept jsonb fields that may arrive as Map or List from Supabase
  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      return Map<String, dynamic>.from(value as Map);
    }
    if (value is List) {
      return {'items': List<dynamic>.from(value)};
    }
    return null;
  }

  factory InjuryEvaluationModel.fromJson(Map<String, dynamic> json) {
    return InjuryEvaluationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      location: json['location'] as String?,
      side: json['side'] as String?,
      timing: json['timing'] as String?,
      mechanism: json['mechanism'] as String?,
      hasPopping: json['has_popping'] as bool?,
      frequency: json['frequency'] as String?,
      painIntensity: (json['pain_intensity'] as num?)?.toInt(),
      painTypes: _asMap(json['pain_types']),
      painTriggers: _asMap(json['pain_triggers']),
      weightBearingCapacity: json['weight_bearing_capacity'] as String?,
      basicActivities: _asMap(json['basic_activities']),
      stabilityLevel: json['stability_level'] as String?,
      symptoms: _asMap(json['symptoms']),
      hasCriticalSymptoms: json['has_critical_symptoms'] as bool?,
      activityType: json['activity_type'] as String?,
      preexistingConditions: _asMap(json['preexisting_conditions']),
      additionalFactors: _asMap(json['additional_factors']),
      preliminaryDiagnosis: json['preliminary_diagnosis'] as String?,
      urgencyLevel: json['urgency_level'] as String?,
      estimatedRecoveryDays: (json['estimated_recovery_days'] as num?)?.toInt(),
      initialRecommendations: _asMap(json['initial_recommendations']),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
