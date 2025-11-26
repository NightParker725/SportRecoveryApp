import 'package:moviles252/features/recovery/domain/entities/injury_evaluation.dart';
import 'package:moviles252/features/recovery/domain/entities/recovery_plan.dart';
import 'package:moviles252/features/recovery/domain/entities/recovery_phase.dart';
import 'package:moviles252/features/recovery/domain/entities/recovery_task.dart';
import 'package:moviles252/features/recovery/domain/entities/recovery_video.dart';
import 'package:moviles252/features/recovery/domain/entities/recovery_progress.dart';
import 'package:moviles252/features/recovery/domain/entities/recovery_task_completion.dart';

import '../../domain/repositories/recovery_repository.dart';
import '../datasources/recovery_remote_data_source.dart';
import '../models/recovery_plan_model.dart';
import '../models/recovery_phase_model.dart';
import '../models/recovery_task_model.dart';
import '../models/recovery_video_model.dart';
import '../models/recovery_progress_model.dart';
import '../models/recovery_task_completion_model.dart';
import '../models/injury_evaluation_model.dart';

class RecoveryRepositoryImpl implements RecoveryRepository {
  final _remote = RecoveryRemoteDataSource();

  @override
  Future<InjuryEvaluation?> getInjuryForUser(String userId) =>
      _remote.getLatestInjuryForUser(userId);

  @override
  Future<RecoveryPlan?> getPlanByInjury(String injuryId) async {
    final res = await _remote.getPlanByInjury(injuryId);
    if (res == null) return null;
    return res;
  }

  @override
  Future<List<RecoveryPhase>> getPhasesByPlan(String planId) async {
    final list = await _remote.getPhasesByPlan(planId);
    return list;
  }

  @override
  Future<List<RecoveryTask>> getTasksByPhase(String phaseId) async {
    final list = await _remote.getTasksByPhase(phaseId);
    return list;
  }

  @override
  Future<RecoveryVideo?> getVideoById(String id) => _remote.getVideoById(id);

  @override
  Future<RecoveryProgress?> getProgressForPlan(String planId) async {
    final p = await _remote.getProgressForPlan(planId);
    if (p == null) return null;
    return p;
  }

  @override
  Future<void> createProgress(RecoveryProgress progress) async {
    final model = RecoveryProgressModel(
      id: progress.id,
      planId: progress.planId,
      currentPhase: progress.currentPhase,
      currentDay: progress.currentDay,
      lastUpdate: progress.lastUpdate,
      createdAt: progress.createdAt,
    );
    await _remote.createProgress(model);
  }

  @override
  Future<void> updateProgress(RecoveryProgress progress) async {
    final model = RecoveryProgressModel(
      id: progress.id,
      planId: progress.planId,
      currentPhase: progress.currentPhase,
      currentDay: progress.currentDay,
      lastUpdate: progress.lastUpdate,
      createdAt: progress.createdAt,
    );
    await _remote.updateProgress(model);
  }

  @override
  Future<void> createTaskCompletion(RecoveryTaskCompletion completion) async {
    final model = RecoveryTaskCompletionModel(
      id: completion.id,
      taskId: completion.taskId,
      planId: completion.planId,
      completedAt: completion.completedAt,
    );
    await _remote.createTaskCompletion(model);
  }

  @override
  Future<List<RecoveryTaskCompletion>> getCompletionsForPlan(
    String planId,
  ) async {
    final raw = await _remote.getCompletionsForPlan(planId);
    return raw.map((m) => RecoveryTaskCompletionModel.fromJson(m)).toList();
  }
}
