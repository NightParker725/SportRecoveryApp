class RecoveryProgress {
  final String id;
  final String planId;
  final int currentPhase; // 1-based
  final int currentDay; // 1-based
  final DateTime lastUpdate;
  final DateTime createdAt;

  RecoveryProgress({
    required this.id,
    required this.planId,
    required this.currentPhase,
    required this.currentDay,
    required this.lastUpdate,
    required this.createdAt,
  });
}
