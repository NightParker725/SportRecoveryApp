import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/myth.dart';
import '../../domain/usecases/view_myths_flow_usecase.dart';

// Events
abstract class MythsEvent {}

class LoadMyths extends MythsEvent {}

// States
abstract class MythsState {}

class MythsIdle extends MythsState {}

class MythsLoading extends MythsState {}

class MythsLoaded extends MythsState {
  final List<Myth> myths;

  MythsLoaded(this.myths);
}

class MythsError extends MythsState {
  final String message;

  MythsError(this.message);
}

// BLoC
class MythsBloc extends Bloc<MythsEvent, MythsState> {
  final ViewMythsFlowUseCase useCase;

  MythsBloc({required this.useCase}) : super(MythsIdle()) {
    on<LoadMyths>(_onLoadMyths);
  }

  Future<void> _onLoadMyths(
    LoadMyths event,
    Emitter<MythsState> emit,
  ) async {
    emit(MythsLoading());
    try {
      final myths = await useCase.execute();
      emit(MythsLoaded(myths));
    } catch (e) {
      emit(MythsError(e.toString()));
    }
  }
}
