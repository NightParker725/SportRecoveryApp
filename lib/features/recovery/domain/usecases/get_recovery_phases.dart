import '../repositories/recovery_repository.dart';
import '../entities/recovery_phase.dart';

class GetRecoveryPhases {
  final RecoveryRepository repository;
  GetRecoveryPhases(this.repository);

  Future<List<RecoveryPhase>> execute(String injuryId) async {
    return repository.getPhasesByInjury(injuryId);
  }
}
