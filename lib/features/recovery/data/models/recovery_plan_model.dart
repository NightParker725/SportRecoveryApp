import '../../domain/entities/recovery_plan.dart';

class RecoveryPlanModel extends RecoveryPlan {
  RecoveryPlanModel({
    required String id,
    required String injuryId,
    required String userId,
    required DateTime createdAt,
  }) : super(id: id, injuryId: injuryId, userId: userId, createdAt: createdAt);

  factory RecoveryPlanModel.fromJson(Map<String, dynamic> json) {
    return RecoveryPlanModel(
      id: json['id'] as String,
      injuryId: json['injury_id'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'injury_id': injuryId,
    'user_id': userId,
    'created_at': createdAt.toIso8601String(),
  };
}
