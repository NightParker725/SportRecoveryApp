import '../repositories/recovery_repository.dart';
import '../entities/recovery_progress.dart';
import 'package:uuid/uuid.dart';

class AdvanceRecoveryDayUseCase {
  final RecoveryRepository repository;
  final _uuid = const Uuid();

  AdvanceRecoveryDayUseCase(this.repository);

  /// Avanza el día. Si llega al durationDays de la fase, avanza la fase.
  Future<void> execute(String planId) async {
    final progress = await repository.getProgressForPlan(planId);
    if (progress == null) {
      // crea progreso inicial si no existe
      final newProgress = RecoveryProgress(
        id: _uuid.v4(),
        planId: planId,
        currentPhase: 1,
        currentDay: 1,
        lastUpdate: DateTime.now(),
        createdAt: DateTime.now(),
      );
      await repository.createProgress(newProgress);
      return;
    }

    // obtener fases para saber duración de la fase actual
    final phases = await repository.getPhasesByPlan(progress.planId);
    final currentPhaseIndex = progress.currentPhase;
    final currentPhase = phases.firstWhere(
      (p) => p.phaseIndex == currentPhaseIndex,
      orElse: () =>
          phases.isNotEmpty ? phases[0] : throw Exception('No phases'),
    );

    int nextDay = progress.currentDay + 1;
    int nextPhase = progress.currentPhase;
    if (nextDay > currentPhase.durationDays) {
      // avanzar fase
      nextPhase = (progress.currentPhase + 1);
      nextDay = 1;
    }

    final updated = RecoveryProgress(
      id: progress.id,
      planId: progress.planId,
      currentPhase: nextPhase,
      currentDay: nextDay,
      lastUpdate: DateTime.now(),
      createdAt: progress.createdAt,
    );
    await repository.updateProgress(updated);
  }
}
