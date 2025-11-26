import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../ui/bloc/recovery_bloc.dart';
import '../../domain/entities/recovery_phase.dart';
import '../../domain/entities/recovery_plan.dart';

class RecoveryOverviewScreen extends StatefulWidget {
  const RecoveryOverviewScreen({super.key});

  @override
  State<RecoveryOverviewScreen> createState() => _RecoveryOverviewScreenState();
}

class _RecoveryOverviewScreenState extends State<RecoveryOverviewScreen> {
  @override
  void initState() {
    super.initState();
    // Disparar la carga del overview al entrar a la pantalla
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid != null) {
      context.read<RecoveryBloc>().add(LoadRecoveryOverview(uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperación')),
      body: BlocBuilder<RecoveryBloc, RecoveryState>(
        builder: (context, state) {
          if (state is RecoveryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecoveryError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is RecoveryLoaded) {
            final injury = state.injury;
            final plan = state.plan;
            final phases = state.phases;
            final progress = state.progress;

            if (injury == null || plan == null) {
              return const Center(child: Text('No hay lesión activa o plan.'));
            }

            // Safety when finding current phase (avoid generic type mismatch)
            RecoveryPhase? currentPhase;
            if (progress != null && phases.isNotEmpty) {
              final idx = phases.indexWhere(
                (p) => p.phaseIndex == progress.currentPhase,
              );
              currentPhase = idx >= 0 ? phases[idx] : phases[0];
            } else {
              currentPhase = phases.isNotEmpty ? phases[0] : null;
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lesión: ${injury.location ?? "-"}'),
                  const SizedBox(height: 8),
                  Text(
                    'Plan creado: ${plan.createdAt.toLocal().toString().split(" ")[0]}',
                  ),
                  const SizedBox(height: 12),
                  if (progress != null)
                    Text(
                      'Fase actual: ${progress.currentPhase} - Día ${progress.currentDay}',
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    'Fases:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: phases.length,
                      itemBuilder: (context, i) {
                        final p = phases[i];
                        final isCurrent = (currentPhase != null && currentPhase.id == p.id);
                        return ListTile(
                          title: Text('${p.phaseIndex}. ${p.name}'),
                          subtitle: Text(p.description ?? ''),
                          trailing: isCurrent ? const Icon(Icons.play_arrow) : null,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/recovery_phase',
                              arguments: {
                                'planId': plan.id,
                                'phaseId': p.id,
                                'phaseIndex': p.phaseIndex,
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
