import '../repositories/recovery_repository.dart';
import '../entities/recovery_phase.dart';

class GetPhasesByPlan {
  final RecoveryRepository repository;
  GetPhasesByPlan(this.repository);

  Future<List<RecoveryPhase>> execute(String planId) async {
    return await repository.getPhasesByPlan(planId);
  }
}
