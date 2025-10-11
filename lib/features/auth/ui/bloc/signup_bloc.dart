//Eventos
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/domain/model/profile.dart';
import 'package:moviles252/features/auth/domain/usecases/register_user_usecase.dart';

abstract class SignupEvent {}

class SubmmitSignupEvent extends SignupEvent {
  String name;
  String email;
  String password;
  SubmmitSignupEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

//States
abstract class SignupState {}

class SignupIdleState extends SignupState {}

class SignupErrorState extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupSuccessState extends SignupState {}

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  RegisterUserUsecase _registerUserUsecase = RegisterUserUsecase();

  SignupBloc() : super(SignupIdleState()) {
    on<SubmmitSignupEvent>(_registerUser);
  }

  Future<void> _registerUser(
    SubmmitSignupEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoadingState());
    try {
      await _registerUserUsecase.execute(
        Profile(
          id: "",
          name: event.name,
          email: event.email,
          createdAt: DateTime.now(),
        ),
        event.password,
      );
      emit(SignupSuccessState());
    } on Exception catch (e) {
      emit(SignupErrorState());
    }
  }
}
