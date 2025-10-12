import 'package:moviles252/domain/model/profile.dart';
import 'package:moviles252/features/auth/data/repository/auth_repository_impl.dart';
import 'package:moviles252/features/auth/domain/repository/auth_repository.dart';

class LoginUserUsecase {
  AuthRepository _authRepository = AuthRepositoryImpl();

  Future<Profile?> execute(String email, String password) async {
    return await _authRepository.loginUser(email, password);
  }
}