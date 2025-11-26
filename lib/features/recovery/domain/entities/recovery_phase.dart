class RecoveryPhase {
  final String id;
  final String planId;
  final String name;
  final String? description;
  final int phaseIndex;
  final int durationDays;
  final DateTime createdAt;

  RecoveryPhase({
    required this.id,
    required this.planId,
    required this.name,
    this.description,
    required this.phaseIndex,
    required this.durationDays,
    required this.createdAt,
  });
}
