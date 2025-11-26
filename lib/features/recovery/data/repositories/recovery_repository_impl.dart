import 'package:moviles252/features/recovery/domain/entities/injury_evaluation.dart';
import 'package:moviles252/features/recovery/domain/entities/recovery_phase.dart';
import 'package:moviles252/features/recovery/domain/entities/recovery_task.dart';
import 'package:moviles252/features/recovery/domain/entities/recovery_video.dart';
import 'package:moviles252/features/recovery/domain/entities/user_recovery_progress.dart';
import 'package:moviles252/features/recovery/domain/repositories/recovery_repository.dart';
import 'package:moviles252/features/recovery/data/datasources/recovery_remote_data_source.dart';
import 'package:moviles252/features/recovery/data/models/user_recovery_progress_model.dart';

class RecoveryRepositoryImpl implements RecoveryRepository {
  final _remote = RecoveryRemoteDataSource();

  @override
  Future<InjuryEvaluation?> getInjuryForUser(String userId) =>
      _remote.getInjuryForUser(userId);

  @override
  Future<List<RecoveryPhase>> getPhasesByInjury(String injuryId) async {
    final models = await _remote.getPhasesByInjury(injuryId);

    return models
        .map(
          (m) => RecoveryPhase(
            id: m.id,
            injuryId: m.injuryId,
            title: m.title,
            description: m.description,
            dayStart: m.dayStart,
            dayEnd: m.dayEnd,
          ),
        )
        .toList();
  }

  @override
  Future<List<RecoveryTask>> getTasksByPhase(String phaseId) async {
    final res = await _remote.getTasksByPhase(phaseId);
    return res;
  }

  @override
  Future<RecoveryVideo?> getVideoById(String id) async {
    return await _remote.getVideoById(id);
  }

  @override
  Future<UserRecoveryProgress?> getProgressForUser(
    String userId,
    String injuryId,
  ) async {
    return await _remote.getProgressForUser(userId, injuryId);
  }

  @override
  Future<void> createProgress(UserRecoveryProgress progress) async {
    final model = UserRecoveryProgressModel(
      id: progress.id,
      userId: progress.userId,
      injuryId: progress.injuryId,
      currentDay: progress.currentDay,
      currentPhaseId: progress.currentPhaseId,
      completedTasks: progress.completedTasks,
      lastCheckinDate: progress.lastCheckinDate,
      createdAt: progress.createdAt,
    );
    await _remote.createProgress(model);
  }

  @override
  Future<void> updateProgress(UserRecoveryProgress progress) async {
    final model = UserRecoveryProgressModel(
      id: progress.id,
      userId: progress.userId,
      injuryId: progress.injuryId,
      currentDay: progress.currentDay,
      currentPhaseId: progress.currentPhaseId,
      completedTasks: progress.completedTasks,
      lastCheckinDate: progress.lastCheckinDate,
      createdAt: progress.createdAt,
    );
    await _remote.updateProgress(model);
  }
}
