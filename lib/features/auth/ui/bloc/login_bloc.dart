import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/domain/model/profile.dart';
import 'package:moviles252/features/auth/domain/usecases/login_user_usecase.dart';

abstract class LoginEvent{}

class SubmitLoginEvent extends LoginEvent{
  String email;
  String password;

  SubmitLoginEvent({
    required this.email,
    required this.password,
  });
}

abstract class LoginState{}

class LoginIdleState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final Profile profile;

  LoginSuccessState(this.profile);
}

class LoginErrorState extends LoginState {
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginUserUsecase _loginUserUsecase = LoginUserUsecase();

  LoginBloc() : super(LoginIdleState()) {
    on<SubmitLoginEvent>(_loginUser);
  }

  Future<void> _loginUser(
    SubmitLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoadingState());
    
    try {
      Profile? profile = await _loginUserUsecase.execute(
        event.email,
        event.password,
      );
      
      if (profile != null) {
        emit(LoginSuccessState(profile));
      } else {
        emit(LoginErrorState());
      }
    } on Exception catch (e) {
      emit(LoginErrorState());
    }
  }
}




