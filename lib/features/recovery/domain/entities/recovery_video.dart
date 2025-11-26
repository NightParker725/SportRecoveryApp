class RecoveryVideo {
  final String id;
  final String? taskId;
  final String? phaseId;
  final String title;
  final String url;
  final String? thumbnail;
  final DateTime createdAt;

  RecoveryVideo({
    required this.id,
    this.taskId,
    this.phaseId,
    required this.title,
    required this.url,
    this.thumbnail,
    required this.createdAt,
  });
}
