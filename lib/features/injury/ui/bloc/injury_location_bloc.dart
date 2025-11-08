import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/validate_injury_location_usecase.dart';

// Events
abstract class InjuryLocationEvent {}

class SaveInjuryLocationEvent extends InjuryLocationEvent {
  final String location;
  final String side;

  SaveInjuryLocationEvent({
    required this.location,
    required this.side,
  });
}

// States
abstract class InjuryLocationState {}

class InjuryLocationInitial extends InjuryLocationState {}

class InjuryLocationLoading extends InjuryLocationState {}

class InjuryLocationSuccess extends InjuryLocationState {
  final String location;
  final String side;

  InjuryLocationSuccess({
    required this.location,
    required this.side,
  });
}

class InjuryLocationError extends InjuryLocationState {
  final String message;

  InjuryLocationError(this.message);
}

// BLoC
class InjuryLocationBloc extends Bloc<InjuryLocationEvent, InjuryLocationState> {
  final ValidateInjuryLocationUseCase _validateInjuryLocationUseCase =
      ValidateInjuryLocationUseCase();

  InjuryLocationBloc() : super(InjuryLocationInitial()) {
    on<SaveInjuryLocationEvent>(_onSaveLocation);
  }

  Future<void> _onSaveLocation(
    SaveInjuryLocationEvent event,
    Emitter<InjuryLocationState> emit,
  ) async {
    emit(InjuryLocationLoading());
    try {
      await _validateInjuryLocationUseCase(
        location: event.location,
        side: event.side,
      );
      emit(InjuryLocationSuccess(
        location: event.location,
        side: event.side,
      ));
    } catch (e) {
      emit(InjuryLocationError(e.toString()));
    }
  }
}
