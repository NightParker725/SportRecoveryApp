import '../entities/injury_evaluation.dart';
import '../entities/recovery_plan.dart';
import '../entities/recovery_phase.dart';
import '../entities/recovery_task.dart';
import '../entities/recovery_video.dart';
import '../entities/recovery_progress.dart';
import '../entities/recovery_task_completion.dart';

abstract class RecoveryRepository {
  Future<InjuryEvaluation?> getInjuryForUser(String userId);
  Future<RecoveryPlan?> getPlanByInjury(String injuryId);
  Future<List<RecoveryPhase>> getPhasesByPlan(String planId);
  Future<List<RecoveryTask>> getTasksByPhase(String phaseId);
  Future<RecoveryVideo?> getVideoById(String id);
  Future<RecoveryProgress?> getProgressForPlan(String planId);
  Future<void> createProgress(RecoveryProgress progress);
  Future<void> updateProgress(RecoveryProgress progress);
  Future<void> createTaskCompletion(RecoveryTaskCompletion completion);
  Future<List<RecoveryTaskCompletion>> getCompletionsForPlan(String planId);
}
