import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/checkin/data/repository/checkin_repository_impl.dart';

abstract class CheckinEvent {}

class SubmitCheckinEvent extends CheckinEvent {
  final int q1;
  final String q2;
  final String q3;
  final int q4;
  final String? q5;
  final String q6;
  SubmitCheckinEvent({
    required this.q1,
    required this.q2,
    required this.q3,
    required this.q4,
    this.q5,
    required this.q6,
  });
}

abstract class CheckinState {}

class CheckinIdle extends CheckinState {}

class CheckinLoading extends CheckinState {}

class CheckinSuccess extends CheckinState {}

class CheckinError extends CheckinState {
  final String message;
  CheckinError(this.message);
}

class CheckinBloc extends Bloc<CheckinEvent, CheckinState> {
  final CheckinRepository _repo = CheckiRepositoryImpl();

  CheckinBloc() : super(CheckinIdle()) {
    on<SubmitCheckinEvent>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitCheckinEvent e,
    Emitter<CheckinState> emit,
  ) async {
    emit(CheckinLoading());
    try {
      await _repo.submit(
        q1: e.q1,
        q2: e.q2,
        q3: e.q3,
        q4: e.q4,
        q5: e.q5,
        q6: e.q6,
      );
      emit(CheckinSuccess());
    } catch (err) {
      emit(CheckinError(err.toString()));
    }
  }
}
