import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/validate_injury_pain_usecase.dart';

// Events
abstract class InjuryPainEvent {}

class SaveInjuryPainEvent extends InjuryPainEvent {
  final int intensity;
  final List<String> painTypes;
  final List<String> triggerFactors;

  SaveInjuryPainEvent({
    required this.intensity,
    required this.painTypes,
    required this.triggerFactors,
  });
}

// States
abstract class InjuryPainState {}

class InjuryPainInitial extends InjuryPainState {}

class InjuryPainLoading extends InjuryPainState {}

class InjuryPainSuccess extends InjuryPainState {
  final int intensity;
  final List<String> painTypes;
  final List<String> triggerFactors;

  InjuryPainSuccess({
    required this.intensity,
    required this.painTypes,
    required this.triggerFactors,
  });
}

class InjuryPainError extends InjuryPainState {
  final String message;

  InjuryPainError(this.message);
}

// BLoC
class InjuryPainBloc extends Bloc<InjuryPainEvent, InjuryPainState> {
  final ValidateInjuryPainUseCase _validateInjuryPainUseCase =
      ValidateInjuryPainUseCase();

  InjuryPainBloc() : super(InjuryPainInitial()) {
    on<SaveInjuryPainEvent>(_onSavePain);
  }

  Future<void> _onSavePain(
    SaveInjuryPainEvent event,
    Emitter<InjuryPainState> emit,
  ) async {
    emit(InjuryPainLoading());
    try {
      await _validateInjuryPainUseCase(
        intensity: event.intensity,
        painTypes: event.painTypes,
        triggerFactors: event.triggerFactors,
      );
      emit(InjuryPainSuccess(
        intensity: event.intensity,
        painTypes: event.painTypes,
        triggerFactors: event.triggerFactors,
      ));
    } catch (e) {
      emit(InjuryPainError(e.toString()));
    }
  }
}
