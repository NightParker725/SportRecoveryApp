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

// States
abstract class SignupState {}

class SignupIdleState extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupSuccessState extends SignupState {}

class SignupErrorState extends SignupState {
  final String message;
  SignupErrorState(this.message);
}

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final RegisterUserUsecase _registerUserUsecase = RegisterUserUsecase();

  SignupBloc() : super(SignupIdleState()) {
    on<SubmmitSignupEvent>(_registerUser);
  }

  Future<void> _registerUser(
    SubmmitSignupEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoadingState());
    try {
      final name = event.name.trim();
      final email = event.email.trim();
      final pass = event.password;

      if (name.isEmpty || email.isEmpty || pass.isEmpty) {
        emit(SignupErrorState("Todos los campos son obligatorios"));
        return;
      }

      await _registerUserUsecase.execute(
        Profile(id: "", name: name, email: email, createdAt: DateTime.now()),
        pass,
      );
      emit(SignupSuccessState());
    } catch (e, st) {
      print("No se puedo registra, razon: $st");
      emit(SignupErrorState(e.toString()));
    }
  }
}
