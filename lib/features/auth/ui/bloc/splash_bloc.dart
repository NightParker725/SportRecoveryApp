import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/check_user_logged_in_usecase.dart';

abstract class SplashEvent {}

class CheckSessionEvent extends SplashEvent {}

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoggedIn extends SplashState {}

class SplashLoggedOut extends SplashState {}

class SplashError extends SplashState {}

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final CheckUserLoggedInUseCase checkUserLoggedInUseCase;

  SplashBloc(this.checkUserLoggedInUseCase) : super(SplashInitial()) {
    on<CheckSessionEvent>(_onCheckSession);
  }

  Future<void> _onCheckSession(
    CheckSessionEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 4));
    try {
      final isLoggedIn = await checkUserLoggedInUseCase.execute();
      if (isLoggedIn) {
        emit(SplashLoggedIn());
      } else {
        emit(SplashLoggedOut());
      }
    } catch (_) {
      emit(SplashError());
    }
  }
}
