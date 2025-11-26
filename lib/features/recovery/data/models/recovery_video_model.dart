import '../../domain/entities/recovery_video.dart';

class RecoveryVideoModel extends RecoveryVideo {
  RecoveryVideoModel({
    required String id,
    String? taskId,
    String? phaseId,
    required String title,
    required String url,
    String? thumbnail,
    required DateTime createdAt,
  }) : super(
         id: id,
         taskId: taskId,
         phaseId: phaseId,
         title: title,
         url: url,
         thumbnail: thumbnail,
         createdAt: createdAt,
       );

  factory RecoveryVideoModel.fromJson(Map<String, dynamic> json) {
    return RecoveryVideoModel(
      id: json['id'] as String,
      taskId: json['task_id'] as String?,
      phaseId: json['phase_id'] as String?,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnail: json['thumbnail'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'task_id': taskId,
    'phase_id': phaseId,
    'title': title,
    'url': url,
    'thumbnail': thumbnail,
    'created_at': createdAt.toIso8601String(),
  };
}
