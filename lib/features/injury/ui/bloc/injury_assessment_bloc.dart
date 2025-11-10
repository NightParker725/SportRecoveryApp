import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/injury_assessment.dart';
import '../../domain/repositories/injury_repository.dart';
import '../../domain/usecases/start_injury_evaluation_flow_usecase.dart';

// Events
abstract class InjuryAssessmentEvent {}

class GenerateAssessmentEvent extends InjuryAssessmentEvent {
  final String userId;
  final String location;
  final String side;
  final String timing;
  final String mechanism;
  final bool hasPopping;
  final String frequency;
  final int painIntensity;
  final List<String> painTypes;
  final List<String> painTriggers;
  final String weightBearingCapacity;
  final List<String> basicActivities;
  final String stabilityLevel;
  final List<String> symptoms;
  final bool hasCriticalSymptoms;
  final String activityType;
  final List<String> preexistingConditions;
  final List<String> additionalFactors;

  GenerateAssessmentEvent({
    required this.userId,
    required this.location,
    required this.side,
    required this.timing,
    required this.mechanism,
    required this.hasPopping,
    required this.frequency,
    required this.painIntensity,
    required this.painTypes,
    required this.painTriggers,
    required this.weightBearingCapacity,
    required this.basicActivities,
    required this.stabilityLevel,
    required this.symptoms,
    required this.hasCriticalSymptoms,
    required this.activityType,
    required this.preexistingConditions,
    required this.additionalFactors,
  });
}

// States
abstract class InjuryAssessmentState {}

class InjuryAssessmentInitial extends InjuryAssessmentState {}

class InjuryAssessmentLoading extends InjuryAssessmentState {}

class InjuryAssessmentSuccess extends InjuryAssessmentState {
  final InjuryAssessment assessment;

  InjuryAssessmentSuccess(this.assessment);
}

class InjuryAssessmentError extends InjuryAssessmentState {
  final String message;

  InjuryAssessmentError(this.message);
}

// BLoC
class InjuryAssessmentBloc
    extends Bloc<InjuryAssessmentEvent, InjuryAssessmentState> {
  final StartInjuryEvaluationFlowUseCase _startInjuryEvaluationFlowUseCase;
  final InjuryRepository _injuryRepository;

  InjuryAssessmentBloc({
    required StartInjuryEvaluationFlowUseCase startInjuryEvaluationFlowUseCase,
    required InjuryRepository injuryRepository,
  })  : _startInjuryEvaluationFlowUseCase = startInjuryEvaluationFlowUseCase,
        _injuryRepository = injuryRepository,
        super(InjuryAssessmentInitial()) {
    on<GenerateAssessmentEvent>(_onGenerateAssessment);
  }

  Future<void> _onGenerateAssessment(
    GenerateAssessmentEvent event,
    Emitter<InjuryAssessmentState> emit,
  ) async {
    emit(InjuryAssessmentLoading());
    try {
      final assessment =
          await _startInjuryEvaluationFlowUseCase.generateAssessment(
        userId: event.userId,
        location: event.location,
        side: event.side,
        timing: event.timing,
        mechanism: event.mechanism,
        hasPopping: event.hasPopping,
        frequency: event.frequency,
        painIntensity: event.painIntensity,
        painTypes: event.painTypes,
        painTriggers: event.painTriggers,
        weightBearingCapacity: event.weightBearingCapacity,
        basicActivities: event.basicActivities,
        stabilityLevel: event.stabilityLevel,
        symptoms: event.symptoms,
        hasCriticalSymptoms: event.hasCriticalSymptoms,
        activityType: event.activityType,
        preexistingConditions: event.preexistingConditions,
        additionalFactors: event.additionalFactors,
      );

      await _injuryRepository.saveAssessment(assessment);

      emit(InjuryAssessmentSuccess(assessment));
    } catch (e) {
      emit(InjuryAssessmentError(e.toString()));
    }
  }
}
