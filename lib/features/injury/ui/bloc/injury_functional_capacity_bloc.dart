import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/validate_functional_capacity_usecase.dart';

// Events
abstract class InjuryFunctionalCapacityEvent {}

class SaveFunctionalCapacityEvent extends InjuryFunctionalCapacityEvent {
  final String weightBearingCapacity;
  final List<String> basicActivities;
  final String stabilityLevel;

  SaveFunctionalCapacityEvent({
    required this.weightBearingCapacity,
    required this.basicActivities,
    required this.stabilityLevel,
  });
}

// States
abstract class InjuryFunctionalCapacityState {}

class InjuryFunctionalCapacityInitial extends InjuryFunctionalCapacityState {}

class InjuryFunctionalCapacityLoading extends InjuryFunctionalCapacityState {}

class InjuryFunctionalCapacitySuccess extends InjuryFunctionalCapacityState {
  final String weightBearingCapacity;
  final List<String> basicActivities;
  final String stabilityLevel;

  InjuryFunctionalCapacitySuccess({
    required this.weightBearingCapacity,
    required this.basicActivities,
    required this.stabilityLevel,
  });
}

class InjuryFunctionalCapacityError extends InjuryFunctionalCapacityState {
  final String message;

  InjuryFunctionalCapacityError(this.message);
}

// BLoC
class InjuryFunctionalCapacityBloc
    extends Bloc<InjuryFunctionalCapacityEvent, InjuryFunctionalCapacityState> {
  final ValidateFunctionalCapacityUseCase
      _validateFunctionalCapacityUseCase =
      ValidateFunctionalCapacityUseCase();

  InjuryFunctionalCapacityBloc()
      : super(InjuryFunctionalCapacityInitial()) {
    on<SaveFunctionalCapacityEvent>(_onSaveFunctionalCapacity);
  }

  Future<void> _onSaveFunctionalCapacity(
    SaveFunctionalCapacityEvent event,
    Emitter<InjuryFunctionalCapacityState> emit,
  ) async {
    emit(InjuryFunctionalCapacityLoading());
    try {
      await _validateFunctionalCapacityUseCase(
        weightBearingCapacity: event.weightBearingCapacity,
        basicActivities: event.basicActivities,
        stabilityLevel: event.stabilityLevel,
      );
      emit(InjuryFunctionalCapacitySuccess(
        weightBearingCapacity: event.weightBearingCapacity,
        basicActivities: event.basicActivities,
        stabilityLevel: event.stabilityLevel,
      ));
    } catch (e) {
      emit(InjuryFunctionalCapacityError(e.toString()));
    }
  }
}
