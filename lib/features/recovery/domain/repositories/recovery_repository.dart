import '../entities/injury_evaluation.dart';
import '../entities/recovery_phase.dart';
import '../entities/recovery_task.dart';
import '../entities/recovery_video.dart';
import '../entities/user_recovery_progress.dart';

abstract class RecoveryRepository {
  Future<InjuryEvaluation?> getInjuryForUser(String userId);
  Future<List<RecoveryPhase>> getPhasesByInjury(String injuryId);
  Future<List<RecoveryTask>> getTasksByPhase(String phaseId);
  Future<RecoveryVideo?> getVideoById(String id);
  Future<UserRecoveryProgress?> getProgressForUser(
    String userId,
    String injuryId,
  );
  Future<void> createProgress(UserRecoveryProgress progress);
  Future<void> updateProgress(UserRecoveryProgress progress);
}
