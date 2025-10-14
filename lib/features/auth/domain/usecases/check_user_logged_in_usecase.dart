import '../repository/auth_repository.dart';

class CheckUserLoggedInUseCase {
  final AuthRepository repository;
  CheckUserLoggedInUseCase(this.repository);

  Future<bool> execute() async {
    return await repository.isUserLoggedIn();
  }
}
