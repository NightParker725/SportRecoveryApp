import 'package:moviles252/domain/model/profile.dart';

abstract class AuthRepository {
  Future<void> registerUser(Profile profile, String password);
  Future<void> createProfile(Profile profile);
  Future<Profile?> getProfileById(String userId);
  Future<Profile?> loginUser(String email, String password);
  Future<bool> isUserLoggedIn();
  Future<Profile?> getCurrentProfile();
}
