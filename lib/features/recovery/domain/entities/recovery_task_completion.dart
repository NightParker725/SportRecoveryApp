class RecoveryTaskCompletion {
  final String id;
  final String taskId;
  final String planId;
  final DateTime completedAt;

  RecoveryTaskCompletion({
    required this.id,
    required this.taskId,
    required this.planId,
    required this.completedAt,
  });
}
