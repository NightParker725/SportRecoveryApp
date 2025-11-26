import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/bloc/recovery_bloc.dart';
import '../../domain/entities/recovery_task.dart';
import '../../domain/usecases/get_tasks_by_phase.dart';
import '../../domain/repositories/recovery_repository.dart';
import '../../data/repositories/recovery_repository_impl.dart';
import '../../domain/usecases/complete_recovery_task.dart';

class RecoveryPhaseScreen extends StatefulWidget {
  const RecoveryPhaseScreen({super.key});

  @override
  State<RecoveryPhaseScreen> createState() => _RecoveryPhaseScreenState();
}

class _RecoveryPhaseScreenState extends State<RecoveryPhaseScreen> {
  late String planId;
  late String phaseId;
  late int phaseIndex;
  bool _loading = true;
  List<RecoveryTask> _tasks = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null) return;
    planId = args['planId'] as String;
    phaseId = args['phaseId'] as String;
    phaseIndex = args['phaseIndex'] as int;
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _loading = true);
    final repo = RecoveryRepositoryImpl();
    final getTasks = GetTasksByPhase(repo);
    _tasks = await getTasks.execute(phaseId);
    setState(() => _loading = false);
  }

  Future<void> _completeTask(String taskId) async {
    final repo = RecoveryRepositoryImpl();
    final complete = CompleteRecoveryTaskUseCase(repo);
    // UI optimistic: show snackbar then call
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Marcando tarea...')));
    await complete.execute(taskId, planId);
    // Notify bloc to refresh overview
    context.read<RecoveryBloc>().add(
      RefreshOverview(
        (context.read<RecoveryBloc>().state is RecoveryLoaded)
            ? (context.read<RecoveryBloc>().state as RecoveryLoaded)
                      .injury
                      ?.userId ??
                  ''
            : '',
      ),
    );
    await _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fase $phaseIndex')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, i) {
                  final t = _tasks[i];
                  return Card(
                    child: ListTile(
                      title: Text(t.title),
                      subtitle: Text(
                        'Día ${t.dayIndex} • ${t.description ?? ''}',
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => _completeTask(t.id),
                        child: const Text('Marcar hecha'),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
