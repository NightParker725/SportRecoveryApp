import '../../domain/entities/recovery_phase.dart';

class RecoveryPhaseModel extends RecoveryPhase {
  RecoveryPhaseModel({
    required String id,
    required String planId,
    required String name,
    String? description,
    required int phaseIndex,
    required int durationDays,
    required DateTime createdAt,
  }) : super(
         id: id,
         planId: planId,
         name: name,
         description: description,
         phaseIndex: phaseIndex,
         durationDays: durationDays,
         createdAt: createdAt,
       );

  factory RecoveryPhaseModel.fromJson(Map<String, dynamic> json) {
    return RecoveryPhaseModel(
      id: json['id'] as String,
      planId: json['plan_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      phaseIndex: (json['phase_index'] as num).toInt(),
      durationDays: (json['duration_days'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'plan_id': planId,
    'name': name,
    'description': description,
    'phase_index': phaseIndex,
    'duration_days': durationDays,
    'created_at': createdAt.toIso8601String(),
  };
}
