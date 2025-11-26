import '../repositories/recovery_repository.dart';
import '../entities/recovery_task_completion.dart';
import 'package:uuid/uuid.dart';

class CompleteRecoveryTaskUseCase {
  final RecoveryRepository repository;
  final _uuid = const Uuid();

  CompleteRecoveryTaskUseCase(this.repository);

  /// Completa la tarea (crea record en completions) y devuelve void.
  Future<void> execute(String taskId, String planId) async {
    final completion = RecoveryTaskCompletion(
      id: _uuid.v4(),
      taskId: taskId,
      planId: planId,
      completedAt: DateTime.now(),
    );
    await repository.createTaskCompletion(completion);
  }
}
