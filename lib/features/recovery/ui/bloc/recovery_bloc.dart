import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/recovery/domain/usecases/get_tasks_by_phase.dart';
import '../../domain/usecases/get_recovery_overview.dart';
import '../../domain/usecases/get_phases_by_plan.dart';
import '../../domain/usecases/get_tasks_by_phase.dart';
import '../../domain/usecases/complete_recovery_task.dart';
import '../../domain/usecases/advance_recovery_day.dart';

import '../../domain/entities/recovery_phase.dart';
import '../../domain/entities/recovery_task.dart';
import '../../domain/entities/recovery_progress.dart';
import '../../domain/entities/recovery_plan.dart';
import '../../domain/entities/injury_evaluation.dart';

abstract class RecoveryEvent {}

class LoadRecoveryOverview extends RecoveryEvent {
  final String userId;
  LoadRecoveryOverview(this.userId);
}

class RefreshOverview extends RecoveryEvent {
  final String userId;
  RefreshOverview(this.userId);
}

class CompleteTaskEvent extends RecoveryEvent {
  final String taskId;
  final String planId;
  CompleteTaskEvent({required this.taskId, required this.planId});
}

class AdvanceDayEvent extends RecoveryEvent {
  final String planId;
  AdvanceDayEvent(this.planId);
}

abstract class RecoveryState {}

class RecoveryLoading extends RecoveryState {}

class RecoveryError extends RecoveryState {
  final String message;
  RecoveryError(this.message);
}

class RecoveryLoaded extends RecoveryState {
  final InjuryEvaluation? injury;
  final RecoveryPlan? plan;
  final List<RecoveryPhase> phases;
  final RecoveryProgress? progress;

  RecoveryLoaded({
    required this.injury,
    required this.plan,
    required this.phases,
    required this.progress,
  });
}

class RecoveryTaskCompleting extends RecoveryState {}

class RecoveryTaskCompleted extends RecoveryState {}

class RecoveryBloc extends Bloc<RecoveryEvent, RecoveryState> {
  final GetRecoveryOverviewUseCase getOverview;
  final GetPhasesByPlan getPhasesByPlan;
  final GetTasksByPhase getTasksByPhase;
  final CompleteRecoveryTaskUseCase completeTask;
  final AdvanceRecoveryDayUseCase advanceDay;

  RecoveryBloc({
    required this.getOverview,
    required this.getPhasesByPlan,
    required this.getTasksByPhase,
    required this.completeTask,
    required this.advanceDay,
  }) : super(RecoveryLoading()) {
    on<LoadRecoveryOverview>(_onLoad);
    on<RefreshOverview>(_onLoad);
    on<CompleteTaskEvent>(_onCompleteTask);
    on<AdvanceDayEvent>(_onAdvanceDay);
  }

  Future<void> _onLoad(RecoveryEvent event, Emitter<RecoveryState> emit) async {
    final userId = (event is LoadRecoveryOverview)
        ? event.userId
        : (event as RefreshOverview).userId;
    emit(RecoveryLoading());
    try {
      final overview = await getOverview.execute(userId);
      emit(
        RecoveryLoaded(
          injury: overview.injury,
          plan: overview.plan,
          phases: overview.phases,
          progress: overview.progress,
        ),
      );
    } catch (e) {
      emit(RecoveryError(e.toString()));
    }
  }

  Future<void> _onCompleteTask(
    CompleteTaskEvent e,
    Emitter<RecoveryState> emit,
  ) async {
    emit(RecoveryTaskCompleting());
    try {
      await completeTask.execute(e.taskId, e.planId);
      emit(RecoveryTaskCompleted());
      // refresh
      if (state is RecoveryLoaded && (state as RecoveryLoaded).plan != null) {
        final userIdPlaceholder = (state as RecoveryLoaded).injury?.userId;
        if (userIdPlaceholder != null) add(RefreshOverview(userIdPlaceholder));
      }
    } catch (ex) {
      emit(RecoveryError(ex.toString()));
    }
  }

  Future<void> _onAdvanceDay(
    AdvanceDayEvent e,
    Emitter<RecoveryState> emit,
  ) async {
    try {
      await advanceDay.execute(e.planId);
      // refresh
      final userIdPlaceholder = (state is RecoveryLoaded)
          ? (state as RecoveryLoaded).injury?.userId
          : null;
      if (userIdPlaceholder != null) add(RefreshOverview(userIdPlaceholder));
    } catch (ex) {
      emit(RecoveryError(ex.toString()));
    }
  }
}
