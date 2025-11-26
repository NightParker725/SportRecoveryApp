import '../repositories/recovery_repository.dart';
import '../entities/user_recovery_progress.dart';

class AdvanceRecoveryDay {
  final RecoveryRepository repository;
  AdvanceRecoveryDay(this.repository);

  /// Advances current_day by 1 and updates current phase if needed.
  Future<UserRecoveryProgress?> execute(
    UserRecoveryProgress progress,
    List phases,
  ) async {
    final nextDay = progress.currentDay + 1;
    // Simple algorithm: find a phase where day_start<=nextDay<=day_end
    String? nextPhaseId = progress.currentPhaseId;
    for (var p in phases) {
      final start = p.dayStart ?? 0;
      final end = p.dayEnd ?? 9999;
      if (nextDay >= start && nextDay <= end) {
        nextPhaseId = p.id;
        break;
      }
    }

    final updated = progress.copyWith(
      currentDay: nextDay,
      currentPhaseId: nextPhaseId,
      lastCheckinDate: DateTime.now(),
    );
    await repository.updateProgress(updated);
    return updated;
  }
}
