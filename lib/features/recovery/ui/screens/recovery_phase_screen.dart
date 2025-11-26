import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recovery_bloc.dart';
import 'package:moviles252/features/recovery/data/models/recovery_task_model.dart';
import 'package:moviles252/features/recovery/data/datasources/recovery_remote_data_source.dart';
import 'package:moviles252/features/recovery/data/models/recovery_task_model.dart';

class RecoveryPhaseScreen extends StatefulWidget {
  const RecoveryPhaseScreen({super.key});

  @override
  State<RecoveryPhaseScreen> createState() => _RecoveryPhaseScreenState();
}

class _RecoveryPhaseScreenState extends State<RecoveryPhaseScreen> {
  final _remote = RecoveryRemoteDataSource();
  bool _loading = true;
  List<RecoveryTaskModel> _tasks = [];
  String? _phaseId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['phaseId'] != null) {
      _phaseId = args['phaseId'] as String;
      _loadTasks();
    }
  }

  Future<void> _loadTasks() async {
    if (_phaseId == null) return;
    setState(() => _loading = true);
    final list = await _remote.getTasksByPhase(_phaseId!);
    setState(() {
      _tasks = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tareas de la fase')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final t = _tasks[i];
                return ListTile(
                  title: Text(t.title),
                  subtitle: Text(t.description ?? ''),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // marcar completada
                      context.read<RecoveryBloc>().add(CompleteTaskEvent(t.id));
                    },
                    child: const Text('Marcar'),
                  ),
                  onTap: () async {
                    if (t.taskType == 'video' && t.videoId != null) {
                      Navigator.pushNamed(
                        context,
                        '/recovery_video',
                        arguments: {'videoId': t.videoId},
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
