import '../repositories/recovery_repository.dart';
import '../entities/injury_evaluation.dart';
import '../entities/recovery_phase.dart';
import '../entities/user_recovery_progress.dart';

class GetRecoveryOverview {
  final RecoveryRepository repository;
  GetRecoveryOverview(this.repository);

  /// Returns a tuple-like map:
  /// { 'injury': InjuryEvaluation?, 'phases': List<RecoveryPhase>, 'progress': UserRecoveryProgress? }
  Future<Map<String, dynamic>> execute(String userId) async {
    final injury = await repository.getInjuryForUser(userId);
    if (injury == null) {
      return {'injury': null, 'phases': <RecoveryPhase>[], 'progress': null};
    }
    final phases = await repository.getPhasesByInjury(injury.id);
    final progress = await repository.getProgressForUser(userId, injury.id);
    return {'injury': injury, 'phases': phases, 'progress': progress};
  }
}
