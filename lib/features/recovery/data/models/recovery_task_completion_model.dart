import '../../domain/entities/recovery_task_completion.dart';

class RecoveryTaskCompletionModel extends RecoveryTaskCompletion {
  RecoveryTaskCompletionModel({
    required String id,
    required String taskId,
    required String planId,
    required DateTime completedAt,
  }) : super(id: id, taskId: taskId, planId: planId, completedAt: completedAt);

  factory RecoveryTaskCompletionModel.fromJson(Map<String, dynamic> json) {
    return RecoveryTaskCompletionModel(
      id: json['id'] as String,
      taskId: json['task_id'] as String,
      planId: json['plan_id'] as String,
      completedAt: DateTime.parse(json['completed_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'task_id': taskId,
    'plan_id': planId,
    'completed_at': completedAt.toIso8601String(),
  };
}
