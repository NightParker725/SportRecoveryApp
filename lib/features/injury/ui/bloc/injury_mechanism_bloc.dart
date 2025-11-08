import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/validate_injury_mechanism_usecase.dart';

// Events
abstract class InjuryMechanismEvent {}

class SaveInjuryMechanismEvent extends InjuryMechanismEvent {
  final String timing;
  final String mechanism;
  final bool hasPopping;
  final String frequency;

  SaveInjuryMechanismEvent({
    required this.timing,
    required this.mechanism,
    required this.hasPopping,
    required this.frequency,
  });
}

// States
abstract class InjuryMechanismState {}

class InjuryMechanismInitial extends InjuryMechanismState {}

class InjuryMechanismLoading extends InjuryMechanismState {}

class InjuryMechanismSuccess extends InjuryMechanismState {
  final String timing;
  final String mechanism;
  final bool hasPopping;
  final String frequency;

  InjuryMechanismSuccess({
    required this.timing,
    required this.mechanism,
    required this.hasPopping,
    required this.frequency,
  });
}

class InjuryMechanismError extends InjuryMechanismState {
  final String message;

  InjuryMechanismError(this.message);
}

// BLoC
class InjuryMechanismBloc extends Bloc<InjuryMechanismEvent, InjuryMechanismState> {
  final ValidateInjuryMechanismUseCase _validateInjuryMechanismUseCase =
      ValidateInjuryMechanismUseCase();

  InjuryMechanismBloc() : super(InjuryMechanismInitial()) {
    on<SaveInjuryMechanismEvent>(_onSaveMechanism);
  }

  Future<void> _onSaveMechanism(
    SaveInjuryMechanismEvent event,
    Emitter<InjuryMechanismState> emit,
  ) async {
    emit(InjuryMechanismLoading());
    try {
      await _validateInjuryMechanismUseCase(
        timing: event.timing,
        mechanism: event.mechanism,
        hasPopping: event.hasPopping,
        frequency: event.frequency,
      );
      emit(InjuryMechanismSuccess(
        timing: event.timing,
        mechanism: event.mechanism,
        hasPopping: event.hasPopping,
        frequency: event.frequency,
      ));
    } catch (e) {
      emit(InjuryMechanismError(e.toString()));
    }
  }
}
