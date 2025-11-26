import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/usecases/get_recovery_overview.dart';
import '../../domain/usecases/get_recovery_phases.dart';
import '../../domain/usecases/advance_recovery_day.dart';
import '../../domain/usecases/complete_recovery_task.dart';
import '../../domain/repositories/recovery_repository.dart';
import '../../data/repositories/recovery_repository_impl.dart';
import '../../domain/entities/injury_evaluation.dart';
import '../../domain/entities/recovery_phase.dart';
import '../../domain/entities/user_recovery_progress.dart';

// Events
abstract class RecoveryEvent {}

class LoadRecoveryOverview extends RecoveryEvent {}

class RefreshRecovery extends RecoveryEvent {}

class AdvanceDayEvent extends RecoveryEvent {}

class CompleteTaskEvent extends RecoveryEvent {
  final String taskId;
  CompleteTaskEvent(this.taskId);
}

// States
abstract class RecoveryState {}

class RecoveryLoading extends RecoveryState {}

class RecoveryLoaded extends RecoveryState {
  final InjuryEvaluation? injury;
  final List<RecoveryPhase> phases;
  final UserRecoveryProgress? progress;
  RecoveryLoaded({
    required this.injury,
    required this.phases,
    required this.progress,
  });
}

class RecoveryError extends RecoveryState {
  final String message;
  RecoveryError(this.message);
}

class RecoveryTaskCompleting extends RecoveryState {}

class RecoveryAdvancing extends RecoveryState {}

// Bloc
class RecoveryBloc extends Bloc<RecoveryEvent, RecoveryState> {
  final RecoveryRepository _repo = RecoveryRepositoryImpl();
  late final GetRecoveryOverview _getOverview;
  late final GetRecoveryPhases _getPhases;
  late final AdvanceRecoveryDay _advanceDay;
  late final CompleteRecoveryTask _completeTask;

  RecoveryBloc() : super(RecoveryLoading()) {
    _getOverview = GetRecoveryOverview(_repo);
    _getPhases = GetRecoveryPhases(_repo);
    _advanceDay = AdvanceRecoveryDay(_repo);
    _completeTask = CompleteRecoveryTask(_repo);

    on<LoadRecoveryOverview>(_onLoad);
    on<RefreshRecovery>(_onLoad);
    on<AdvanceDayEvent>(_onAdvance);
    on<CompleteTaskEvent>(_onCompleteTask);
  }

  Future<void> _onLoad(RecoveryEvent event, Emitter<RecoveryState> emit) async {
    emit(RecoveryLoading());
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(RecoveryError('Usuario no autenticado'));
        return;
      }
      final out = await _getOverview.execute(user.id);
      final injury = out['injury'] as InjuryEvaluation?;
      final phases = out['phases'] as List<RecoveryPhase>;
      final progress = out['progress'] as UserRecoveryProgress?;
      // If progress is null but injury present, create initial progress
      if (injury != null && progress == null) {
        final initial = UserRecoveryProgress(
          id: '', // let server gen id
          userId: user.id,
          injuryId: injury.id,
          currentDay: 1,
          currentPhaseId: phases.isNotEmpty ? phases.first.id : null,
          completedTasks: [],
          lastCheckinDate: null,
          createdAt: DateTime.now(),
        );
        await _repo.createProgress(initial);
        final newProgress = await _repo.getProgressForUser(user.id, injury.id);
        emit(
          RecoveryLoaded(injury: injury, phases: phases, progress: newProgress),
        );
      } else {
        emit(
          RecoveryLoaded(injury: injury, phases: phases, progress: progress),
        );
      }
    } catch (e, st) {
      emit(RecoveryError(e.toString()));
    }
  }

  Future<void> _onAdvance(
    AdvanceDayEvent e,
    Emitter<RecoveryState> emit,
  ) async {
    final current = state;
    if (current is RecoveryLoaded) {
      emit(RecoveryAdvancing());
      try {
        final progress = current.progress;
        final phases = current.phases;
        if (progress == null || current.injury == null) {
          emit(RecoveryError('No hay progreso o lesión'));
          return;
        }
        final updated = await _advanceDay.execute(progress, phases);
        final out = await _getOverview.execute(progress.userId);
        final injury = out['injury'] as InjuryEvaluation?;
        final phases2 = out['phases'] as List<RecoveryPhase>;
        final progress2 = out['progress'] as UserRecoveryProgress?;
        emit(
          RecoveryLoaded(injury: injury, phases: phases2, progress: progress2),
        );
      } catch (e) {
        emit(RecoveryError(e.toString()));
      }
    }
  }

  Future<void> _onCompleteTask(
    CompleteTaskEvent e,
    Emitter<RecoveryState> emit,
  ) async {
    final current = state;
    if (current is RecoveryLoaded) {
      emit(RecoveryTaskCompleting());
      try {
        final progress = current.progress;
        final injury = current.injury;
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (progress == null || injury == null || userId == null) {
          emit(RecoveryError('No hay contexto para completar la tarea'));
          return;
        }
        final updated = await _completeTask.execute(
          userId,
          injury.id,
          e.taskId,
        );
        final out = await _getOverview.execute(userId);
        final injury2 = out['injury'] as InjuryEvaluation?;
        final phases2 = out['phases'] as List<RecoveryPhase>;
        final progress2 = out['progress'] as UserRecoveryProgress?;
        emit(
          RecoveryLoaded(injury: injury2, phases: phases2, progress: progress2),
        );
      } catch (e) {
        emit(RecoveryError(e.toString()));
      }
    }
  }
}
