import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/injury_evaluation.dart';
import '../../domain/entities/recovery_plan.dart';
import '../../domain/entities/recovery_phase.dart';
import '../../domain/entities/recovery_progress.dart';
import '../../domain/entities/recovery_task.dart';

import '../../domain/usecases/get_recovery_overview.dart';
import '../../domain/usecases/get_phases_by_plan.dart';
import '../../domain/usecases/get_tasks_by_phase.dart';
import '../../domain/usecases/complete_recovery_task.dart';
import '../../domain/usecases/advance_recovery_day.dart';

// ---------------------------------------------------------
// EVENTS
// ---------------------------------------------------------
abstract class RecoveryEvent {}

class LoadRecoveryOverview extends RecoveryEvent {
  final String userId;
  LoadRecoveryOverview(this.userId);
}

class RefreshRecovery extends RecoveryEvent {
  final String userId;
  RefreshRecovery(this.userId);
}

class LoadPhaseTasks extends RecoveryEvent {
  final String phaseId;
  LoadPhaseTasks(this.phaseId);
}

class CompleteTaskEvent extends RecoveryEvent {
  final String taskId;
  final String planId;
  CompleteTaskEvent(this.taskId, this.planId);
}

class AdvanceDayEvent extends RecoveryEvent {
  final String planId;
  AdvanceDayEvent(this.planId);
}

// ---------------------------------------------------------
// STATES
// ---------------------------------------------------------
abstract class RecoveryState {}

class RecoveryLoading extends RecoveryState {}

class RecoveryError extends RecoveryState {
  final String message;
  RecoveryError(this.message);
}

class RecoveryLoaded extends RecoveryState {
  final InjuryEvaluation injury;
  final RecoveryPlan plan;
  final List<RecoveryPhase> phases;
  final RecoveryProgress progress;

  RecoveryLoaded({
    required this.injury,
    required this.plan,
    required this.phases,
    required this.progress,
  });
}

class PhaseTasksLoading extends RecoveryState {}

class PhaseTasksLoaded extends RecoveryState {
  final List<RecoveryTask> tasks;
  PhaseTasksLoaded(this.tasks);
}

class TaskCompleting extends RecoveryState {}

class TaskCompleted extends RecoveryState {}

// ---------------------------------------------------------
// BLOC
// ---------------------------------------------------------
class RecoveryBloc extends Bloc<RecoveryEvent, RecoveryState> {
  final GetRecoveryOverviewUseCase getOverview;
  final GetPhasesByPlan getPhases;
  final GetTasksByPhase getTasks;
  final CompleteRecoveryTaskUseCase completeTask;
  final AdvanceRecoveryDayUseCase advanceDay;

  RecoveryBloc({
    required this.getOverview,
    required this.getPhases,
    required this.getTasks,
    required this.completeTask,
    required this.advanceDay,
  }) : super(RecoveryLoading()) {
    on<LoadRecoveryOverview>(_onLoadOverview);
    on<RefreshRecovery>(_onLoadOverview);
    on<LoadPhaseTasks>(_onLoadTasks);
    on<CompleteTaskEvent>(_onCompleteTask);
    on<AdvanceDayEvent>(_onAdvanceDay);
  }

  // ---------------------------------------------------------
  // LOAD OVERVIEW
  // ---------------------------------------------------------
  Future<void> _onLoadOverview(
    RecoveryEvent event,
    Emitter<RecoveryState> emit,
  ) async {
    final String userId = (event is LoadRecoveryOverview)
        ? event.userId
        : (event as RefreshRecovery).userId;

    emit(RecoveryLoading());

    try {
      final overview = await getOverview.execute(userId);

      if (overview.injury == null || overview.plan == null) {
        emit(RecoveryError("No hay lesión activa ni plan de recuperación."));
        return;
      }

      emit(
        RecoveryLoaded(
          injury: overview.injury!,
          plan: overview.plan!,
          phases: overview.phases,
          progress: overview.progress!,
        ),
      );
    } catch (e) {
      emit(RecoveryError(e.toString()));
    }
  }

  // ---------------------------------------------------------
  // LOAD TASKS OF A PHASE
  // ---------------------------------------------------------
  Future<void> _onLoadTasks(
    LoadPhaseTasks event,
    Emitter<RecoveryState> emit,
  ) async {
    emit(PhaseTasksLoading());
    try {
      final tasks = await getTasks.execute(event.phaseId);
      emit(PhaseTasksLoaded(tasks));
    } catch (e) {
      emit(RecoveryError(e.toString()));
    }
  }

  // ---------------------------------------------------------
  // COMPLETE TASK
  // ---------------------------------------------------------
  Future<void> _onCompleteTask(
    CompleteTaskEvent event,
    Emitter<RecoveryState> emit,
  ) async {
    emit(TaskCompleting());

    try {
      await completeTask.execute(event.taskId, event.planId);

      emit(TaskCompleted());

      // Refresh overview
      if (state is RecoveryLoaded) {
        final loaded = state as RecoveryLoaded;
        if (loaded.injury.userId != null) {
          add(RefreshRecovery(loaded.injury.userId!));
        }
      }
    } catch (e) {
      emit(RecoveryError(e.toString()));
    }
  }

  // ---------------------------------------------------------
  // ADVANCE DAY
  // ---------------------------------------------------------
  Future<void> _onAdvanceDay(
    AdvanceDayEvent event,
    Emitter<RecoveryState> emit,
  ) async {
    try {
      await advanceDay.execute(event.planId);

      if (state is RecoveryLoaded) {
        final loaded = state as RecoveryLoaded;
        if (loaded.injury.userId != null) {
          add(RefreshRecovery(loaded.injury.userId!));
        }
      }
    } catch (e) {
      emit(RecoveryError(e.toString()));
    }
  }
}
