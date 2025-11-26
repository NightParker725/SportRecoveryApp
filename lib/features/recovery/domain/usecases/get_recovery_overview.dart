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
    final injury = await repository.getInjuryForUser(userId);
    if (injury == null) {
      return RecoveryOverview(
        injury: null,
        plan: null,
        phases: [],
        progress: null,
      );
    }

    final plan = await repository.getPlanByInjury(injury.id);
    if (plan == null) {
      return RecoveryOverview(
        injury: injury,
        plan: null,
        phases: [],
        progress: null,
      );
    }

    final phases = await repository.getPhasesByPlan(plan.id);
    final progress = await repository.getProgressForPlan(plan.id);

    return RecoveryOverview(
      injury: injury,
      plan: plan,
      phases: phases,
      progress: progress,
    );
  }
}
