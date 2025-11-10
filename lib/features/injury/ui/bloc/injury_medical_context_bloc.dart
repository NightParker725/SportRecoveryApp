import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/process_medical_context_usecase.dart';

// Events
abstract class InjuryMedicalContextEvent {}

class SaveMedicalContextEvent extends InjuryMedicalContextEvent {
  final String activityType;
  final List<String> preexistingConditions;
  final List<String> additionalFactors;

  SaveMedicalContextEvent({
    required this.activityType,
    required this.preexistingConditions,
    required this.additionalFactors,
  });
}

// States
abstract class InjuryMedicalContextState {}

class InjuryMedicalContextInitial extends InjuryMedicalContextState {}

class InjuryMedicalContextLoading extends InjuryMedicalContextState {}

class InjuryMedicalContextSuccess extends InjuryMedicalContextState {
  final String activityType;
  final List<String> preexistingConditions;
  final List<String> additionalFactors;

  InjuryMedicalContextSuccess({
    required this.activityType,
    required this.preexistingConditions,
    required this.additionalFactors,
  });
}

class InjuryMedicalContextError extends InjuryMedicalContextState {
  final String message;

  InjuryMedicalContextError(this.message);
}

// BLoC
class InjuryMedicalContextBloc
    extends Bloc<InjuryMedicalContextEvent, InjuryMedicalContextState> {
  final ProcessMedicalContextUseCase _processMedicalContextUseCase =
      ProcessMedicalContextUseCase();

  InjuryMedicalContextBloc() : super(InjuryMedicalContextInitial()) {
    on<SaveMedicalContextEvent>(_onSaveMedicalContext);
  }

  Future<void> _onSaveMedicalContext(
    SaveMedicalContextEvent event,
    Emitter<InjuryMedicalContextState> emit,
  ) async {
    emit(InjuryMedicalContextLoading());
    try {
      await _processMedicalContextUseCase(
        activityType: event.activityType,
        preexistingConditions: event.preexistingConditions,
        additionalFactors: event.additionalFactors,
      );
      emit(InjuryMedicalContextSuccess(
        activityType: event.activityType,
        preexistingConditions: event.preexistingConditions,
        additionalFactors: event.additionalFactors,
      ));
    } catch (e) {
      emit(InjuryMedicalContextError(e.toString()));
    }
  }
}
