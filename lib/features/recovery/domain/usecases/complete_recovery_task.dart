import '../repositories/recovery_repository.dart';
import '../entities/user_recovery_progress.dart';

class CompleteRecoveryTask {
  final RecoveryRepository repository;
  CompleteRecoveryTask(this.repository);

  /// Marks a task as completed: appends taskId to completedTasks (if missing)
  Future<UserRecoveryProgress?> execute(
    String userId,
    String injuryId,
    String taskId,
  ) async {
    final progress = await repository.getProgressForUser(userId, injuryId);
    if (progress == null) {
      // Create a new progress baseline
      final newProgress = UserRecoveryProgress(
        id: '', // server will gen - but we need an id; create placeholder and repository should handle server-side id generation if allowed.
        userId: userId,
        injuryId: injuryId,
        currentDay: 1,
        currentPhaseId: null,
        completedTasks: [taskId],
        lastCheckinDate: DateTime.now(),
        createdAt: DateTime.now(),
      );
      await repository.createProgress(newProgress);
      return await repository.getProgressForUser(userId, injuryId);
    } else {
      final list = List<String>.from(progress.completedTasks);
      if (!list.contains(taskId)) list.add(taskId);
      final updated = progress.copyWith(
        completedTasks: list,
        lastCheckinDate: DateTime.now(),
      );
      await repository.updateProgress(updated);
      return updated;
    }
  }
}
