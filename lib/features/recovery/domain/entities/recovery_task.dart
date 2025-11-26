class RecoveryTask {
  final String id;
  final String phaseId;
  final String title;
  final String? description;
  final int dayIndex;
  final bool isMandatory;
  final DateTime createdAt;

  RecoveryTask({
    required this.id,
    required this.phaseId,
    required this.title,
    this.description,
    required this.dayIndex,
    required this.isMandatory,
    required this.createdAt,
  });
}
