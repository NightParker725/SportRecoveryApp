class RecoveryTask {
  final String id;
  final String phaseId;
  final String title;
  final String? description;
  final String? taskType; // "video", "timer", "custom"
  final int? duration; // minutes
  final int? series;
  final String? videoId;

  RecoveryTask({
    required this.id,
    required this.phaseId,
    required this.title,
    required this.description,
    required this.taskType,
    required this.duration,
    required this.series,
    required this.videoId,
  });
}
