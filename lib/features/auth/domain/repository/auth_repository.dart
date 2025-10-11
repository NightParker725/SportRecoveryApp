import 'package:moviles252/domain/model/profile.dart';

abstract class AuthRepository {
  Future<void> registerUser(Profile profile, String password);
}
