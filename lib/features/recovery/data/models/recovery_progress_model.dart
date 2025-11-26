import 'package:moviles252/features/recovery/domain/entities/user_recovery_progress.dart';

class UserRecoveryProgressModel extends UserRecoveryProgress {
  UserRecoveryProgressModel({
    required String id,
    required String userId,
    required String injuryId,
    required int currentDay,
    required String? currentPhaseId,
    required List<String>? completedTasks,
    required DateTime? lastCheckinDate,
    required DateTime createdAt,
  }) : super(
         id: id,
         userId: userId,
         injuryId: injuryId,
         currentDay: currentDay,
         currentPhaseId: currentPhaseId,
         completedTasks: completedTasks ?? const [],
         lastCheckinDate: lastCheckinDate,
         createdAt: createdAt,
       );

  factory UserRecoveryProgressModel.fromJson(Map<String, dynamic> json) {
    final completed =
        (json['completed_tasks'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [];
    return UserRecoveryProgressModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      injuryId: json['injury_id'] as String,
      currentDay: (json['current_day'] as int?)?.toInt() ?? 0,
      currentPhaseId: json['current_phase_id'] as String?,
      completedTasks: completed,
      lastCheckinDate: json['last_checkin_date'] == null
          ? null
          : DateTime.parse(json['last_checkin_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'injury_id': injuryId,
    'current_day': currentDay,
    'current_phase_id': currentPhaseId,
    'completed_tasks': completedTasks,
    'last_checkin_date': lastCheckinDate?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
  };
}
