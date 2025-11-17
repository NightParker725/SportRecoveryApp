import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/injury_education.dart';
import '../../domain/usecases/view_common_injuries_flow_usecase.dart';

// Events
abstract class CommonInjuriesEvent {}

class LoadCommonInjuries extends CommonInjuriesEvent {
  final String? bodyLocation;

  LoadCommonInjuries({this.bodyLocation});
}

// States
abstract class CommonInjuriesState {}

class CommonInjuriesIdle extends CommonInjuriesState {}

class CommonInjuriesLoading extends CommonInjuriesState {}

class CommonInjuriesLoaded extends CommonInjuriesState {
  final List<InjuryEducation> injuries;

  CommonInjuriesLoaded(this.injuries);
}

class CommonInjuriesError extends CommonInjuriesState {
  final String message;

  CommonInjuriesError(this.message);
}

// BLoC
class CommonInjuriesBloc extends Bloc<CommonInjuriesEvent, CommonInjuriesState> {
  final ViewCommonInjuriesFlowUseCase useCase;

  CommonInjuriesBloc({required this.useCase}) : super(CommonInjuriesIdle()) {
    on<LoadCommonInjuries>(_onLoadCommonInjuries);
  }

  Future<void> _onLoadCommonInjuries(
    LoadCommonInjuries event,
    Emitter<CommonInjuriesState> emit,
  ) async {
    emit(CommonInjuriesLoading());
    try {
      final injuries = await useCase.execute(event.bodyLocation);
      emit(CommonInjuriesLoaded(injuries));
    } catch (e) {
      emit(CommonInjuriesError(e.toString()));
    }
  }
}
