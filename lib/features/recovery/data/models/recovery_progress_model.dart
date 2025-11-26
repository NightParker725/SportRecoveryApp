import '../../domain/entities/recovery_progress.dart';

class RecoveryProgressModel extends RecoveryProgress {
  RecoveryProgressModel({
    required String id,
    required String planId,
    required int currentPhase,
    required int currentDay,
    required DateTime lastUpdate,
    required DateTime createdAt,
  }) : super(
         id: id,
         planId: planId,
         currentPhase: currentPhase,
         currentDay: currentDay,
         lastUpdate: lastUpdate,
         createdAt: createdAt,
       );

  factory RecoveryProgressModel.fromJson(Map<String, dynamic> json) {
    return RecoveryProgressModel(
      id: json['id'] as String,
      planId: json['plan_id'] as String,
      currentPhase: (json['current_phase'] as num).toInt(),
      currentDay: (json['current_day'] as num).toInt(),
      lastUpdate: DateTime.parse(json['last_update'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'plan_id': planId,
    'current_phase': currentPhase,
    'current_day': currentDay,
    'last_update': lastUpdate.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
  };
}
