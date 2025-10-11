import 'package:moviles252/domain/model/profile.dart';
import 'package:moviles252/features/auth/data/repository/auth_repository_impl.dart';
import 'package:moviles252/features/auth/domain/repository/auth_repository.dart';

class RegisterUserUsecase {
  AuthRepository _authRepository = AuthRepositoryImpl();

  Future<void> execute(Profile profile, String password) async {
    await _authRepository.registerUser(profile, password);
  }
}
