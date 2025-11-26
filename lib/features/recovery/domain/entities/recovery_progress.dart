class UserRecoveryProgress {
  final String id;
  final String userId;
  final String injuryId;
  final int currentDay;
  final String? currentPhaseId;
  final List<String> completedTasks;
  final DateTime? lastCheckinDate;
  final DateTime createdAt;

  UserRecoveryProgress({
    required this.id,
    required this.userId,
    required this.injuryId,
    required this.currentDay,
    required this.currentPhaseId,
    required this.completedTasks,
    required this.lastCheckinDate,
    required this.createdAt,
  });

  UserRecoveryProgress copyWith({
    String? id,
    String? userId,
    String? injuryId,
    int? currentDay,
    String? currentPhaseId,
    List<String>? completedTasks,
    DateTime? lastCheckinDate,
    DateTime? createdAt,
  }) {
    return UserRecoveryProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      injuryId: injuryId ?? this.injuryId,
      currentDay: currentDay ?? this.currentDay,
      currentPhaseId: currentPhaseId ?? this.currentPhaseId,
      completedTasks: completedTasks ?? this.completedTasks,
      lastCheckinDate: lastCheckinDate ?? this.lastCheckinDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
