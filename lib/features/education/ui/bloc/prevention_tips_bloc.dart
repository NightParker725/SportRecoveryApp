import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/prevention_tip.dart';
import '../../domain/usecases/view_prevention_tips_flow_usecase.dart';

// Events
abstract class PreventionTipsEvent {}

class LoadPreventionTips extends PreventionTipsEvent {
  final String? sport;

  LoadPreventionTips({this.sport});
}

// States
abstract class PreventionTipsState {}

class PreventionTipsIdle extends PreventionTipsState {}

class PreventionTipsLoading extends PreventionTipsState {}

class PreventionTipsLoaded extends PreventionTipsState {
  final List<PreventionTip> tips;

  PreventionTipsLoaded(this.tips);
}

class PreventionTipsError extends PreventionTipsState {
  final String message;

  PreventionTipsError(this.message);
}

// BLoC
class PreventionTipsBloc extends Bloc<PreventionTipsEvent, PreventionTipsState> {
  final ViewPreventionTipsFlowUseCase useCase;

  PreventionTipsBloc({required this.useCase}) : super(PreventionTipsIdle()) {
    on<LoadPreventionTips>(_onLoadPreventionTips);
  }

  Future<void> _onLoadPreventionTips(
    LoadPreventionTips event,
    Emitter<PreventionTipsState> emit,
  ) async {
    emit(PreventionTipsLoading());
    try {
      final tips = await useCase.execute(event.sport);
      emit(PreventionTipsLoaded(tips));
    } catch (e) {
      emit(PreventionTipsError(e.toString()));
    }
  }
}
