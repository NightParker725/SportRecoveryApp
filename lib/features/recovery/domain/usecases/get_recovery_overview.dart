import '../repositories/recovery_repository.dart';
import '../entities/injury_evaluation.dart';
import '../entities/recovery_plan.dart';
import '../entities/recovery_phase.dart';
import '../entities/recovery_progress.dart';

class RecoveryOverview {
  final InjuryEvaluation? injury;
  final RecoveryPlan? plan;
  final List<RecoveryPhase> phases;
  final RecoveryProgress? progress;

  RecoveryOverview({
    required this.injury,
    required this.plan,
    required this.phases,
    required this.progress,
  });
}

class GetRecoveryOverviewUseCase {
  final RecoveryRepository repository;
  GetRecoveryOverviewUseCase(this.repository);

  Future<RecoveryOverview> execute(String userId) async {
    print("🔵 UC: buscando lesión para $userId");
    final injury = await repository.getInjuryForUser(userId);
    print("🟣 UC: injury = $injury");

    if (injury == null) {
      print("⚠️ UC: NO hay lesión activa");
      return RecoveryOverview(
        injury: null,
        plan: null,
        phases: [],
        progress: null,
      );
    }

    print("🔵 UC: buscando plan para lesion ${injury.id}");
    final plan = await repository.getPlanByInjury(injury.id);
    print("🟣 UC: plan = $plan");

    print("🔵 UC: buscando fases del plan");
    final phases = await repository.getPhasesByPlan(plan!.id);
    print("🟣 UC: fases = ${phases.length}");

    print("🔵 UC: buscando progreso");
    final progress = await repository.getProgressForPlan(plan.id);
    print("🟣 UC: progress = $progress");

    return RecoveryOverview(
      injury: injury,
      plan: plan,
      phases: phases,
      progress: progress,
    );
  }
}
