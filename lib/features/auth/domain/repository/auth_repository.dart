import 'package:moviles252/domain/model/profile.dart';

abstract class AuthRepository {
  Future<void> registerUser(Profile profile, String password);
  Future<Profile?> loginUser(String email, String password);
  Future<bool> isUserLoggedIn();
  Future<void> updateProfile(Profile profile);
  Future<Profile?> getCurrentProfile();
}
