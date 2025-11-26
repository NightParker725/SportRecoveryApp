class RecoveryPhase {
  final String id;
  final String injuryId;
  final String title;
  final String? description;
  final int? dayStart;
  final int? dayEnd;

  RecoveryPhase({
    required this.id,
    required this.injuryId,
    required this.title,
    required this.description,
    required this.dayStart,
    required this.dayEnd,
  });
}
