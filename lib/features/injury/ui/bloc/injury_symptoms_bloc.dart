import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/process_associated_symptoms_usecase.dart';

// Events
abstract class InjurySymptomsEvent {}

class SaveInjurySymptomsEvent extends InjurySymptomsEvent {
  final List<String> symptoms;

  SaveInjurySymptomsEvent({required this.symptoms});
}

// States
abstract class InjurySymptomsState {}

class InjurySymptomsInitial extends InjurySymptomsState {}

class InjurySymptomsLoading extends InjurySymptomsState {}

class InjurySymptomsSuccess extends InjurySymptomsState {
  final List<String> symptoms;
  final bool hasCriticalSymptoms;

  InjurySymptomsSuccess({
    required this.symptoms,
    required this.hasCriticalSymptoms,
  });
}

class InjurySymptomsError extends InjurySymptomsState {
  final String message;
  final bool hasCriticalSymptoms;

  InjurySymptomsError({
    required this.message,
    this.hasCriticalSymptoms = false,
  });
}

// BLoC
class InjurySymptomsBloc extends Bloc<InjurySymptomsEvent, InjurySymptomsState> {
  final ProcessAssociatedSymptomsUseCase _processAssociatedSymptomsUseCase =
      ProcessAssociatedSymptomsUseCase();

  InjurySymptomsBloc() : super(InjurySymptomsInitial()) {
    on<SaveInjurySymptomsEvent>(_onSaveSymptoms);
  }

  Future<void> _onSaveSymptoms(
    SaveInjurySymptomsEvent event,
    Emitter<InjurySymptomsState> emit,
  ) async {
    emit(InjurySymptomsLoading());
    try {
      final symptoms = await _processAssociatedSymptomsUseCase(
        symptoms: event.symptoms,
      );
      emit(InjurySymptomsSuccess(
        symptoms: event.symptoms,
        hasCriticalSymptoms: symptoms.hasCriticalSymptoms,
      ));
    } catch (e) {
      // Si hay síntomas críticos, permitir continuar pero con bandera
      if (e.toString().contains('ALERTA')) {
        emit(InjurySymptomsError(
          message: e.toString(),
          hasCriticalSymptoms: true,
        ));
      } else {
        emit(InjurySymptomsError(
          message: e.toString(),
          hasCriticalSymptoms: false,
        ));
      }
    }
  }
}
