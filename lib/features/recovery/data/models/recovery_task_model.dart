import 'package:moviles252/features/recovery/domain/entities/recovery_task.dart';

class RecoveryTaskModel extends RecoveryTask {
  RecoveryTaskModel({
    required String id,
    required String phaseId,
    required String title,
    String? description,
    String? taskType,
    int? duration,
    int? series,
    String? videoId,
  }) : super(
         id: id,
         phaseId: phaseId,
         title: title,
         description: description,
         taskType: taskType,
         duration: duration,
         series: series,
         videoId: videoId,
       );

  factory RecoveryTaskModel.fromJson(Map<String, dynamic> json) {
    return RecoveryTaskModel(
      id: json['id'] as String,
      phaseId: json['phase_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      taskType: json['task_type'] as String?,
      duration: (json['duration'] as int?)?.toInt(),
      series: (json['series'] as int?)?.toInt(),
      videoId: json['video_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'phase_id': phaseId,
    'title': title,
    'description': description,
    'task_type': taskType,
    'duration': duration,
    'series': series,
    'video_id': videoId,
  };
}
