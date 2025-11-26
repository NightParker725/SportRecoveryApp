import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recovery_bloc.dart';

class RecoveryOverviewScreen extends StatelessWidget {
  const RecoveryOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecoveryBloc()..add(LoadRecoveryOverview()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Recuperación')),
        body: BlocBuilder<RecoveryBloc, RecoveryState>(
          builder: (context, state) {
            if (state is RecoveryLoading)
              return const Center(child: CircularProgressIndicator());
            if (state is RecoveryError)
              return Center(child: Text('Error: ${state.message}'));
            if (state is RecoveryLoaded) {
              final injury = state.injury;
              final phases = state.phases;
              final progress = state.progress;
              if (injury == null) {
                return Center(child: Text('No hay lesiones registradas'));
              }
              final totalPhases = phases.length;
              final currentPhase = phases.isNotEmpty
                  ? phases.firstWhere(
                      (p) => p.id == progress?.currentPhaseId,
                      orElse: () => phases[0],
                    )
                  : null;
              final day = progress?.currentDay ?? 1;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lesión: ${injury.preliminaryDiagnosis ?? injury.location ?? 'Sin nombre'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Progreso: día $day'),
                    const SizedBox(height: 12),
                    if (currentPhase != null) ...[
                      Text(
                        'Fase actual: ${currentPhase.title}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(currentPhase.description ?? ''),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/recovery_phase',
                            arguments: {'phaseId': currentPhase.id},
                          );
                        },
                        child: const Text('Ver tareas de la fase'),
                      ),
                    ],
                    const Spacer(),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.read<RecoveryBloc>().add(AdvanceDayEvent());
                          },
                          child: const Text('Avanzar día'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => context.read<RecoveryBloc>().add(
                            LoadRecoveryOverview(),
                          ),
                          child: const Text('Refrescar'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
