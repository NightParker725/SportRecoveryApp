import '../repositories/recovery_repository.dart';
import '../entities/recovery_task.dart';

class GetTasksByPhase {
  final RecoveryRepository repository;
  GetTasksByPhase(this.repository);

  Future<List<RecoveryTask>> execute(String phaseId) async {
    return await repository.getTasksByPhase(phaseId);
  }
}
