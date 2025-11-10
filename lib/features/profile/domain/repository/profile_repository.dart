import 'package:moviles252/domain/model/profile.dart';

abstract class ProfileRepository {
  Future<Profile?> getCurrentProfile();
  Future<void> updateProfile(Profile profile);
  Future<void> createInjury(String userId, Map<String, dynamic> injury);
}
