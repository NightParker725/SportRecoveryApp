import '../../domain/entities/recovery_task.dart';

class RecoveryTaskModel extends RecoveryTask {
  RecoveryTaskModel({
    required String id,
    required String phaseId,
    required String title,
    String? description,
    required int dayIndex,
    required bool isMandatory,
    required DateTime createdAt,
  }) : super(
         id: id,
         phaseId: phaseId,
         title: title,
         description: description,
         dayIndex: dayIndex,
         isMandatory: isMandatory,
         createdAt: createdAt,
       );

  factory RecoveryTaskModel.fromJson(Map<String, dynamic> json) {
    return RecoveryTaskModel(
      id: json['id'] as String,
      phaseId: json['phase_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dayIndex: (json['day_index'] as num).toInt(),
      isMandatory: (json['is_mandatory'] as bool?) ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'phase_id': phaseId,
    'title': title,
    'description': description,
    'day_index': dayIndex,
    'is_mandatory': isMandatory,
    'created_at': createdAt.toIso8601String(),
  };
}
