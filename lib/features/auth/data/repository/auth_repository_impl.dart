import 'package:moviles252/domain/model/profile.dart';
import 'package:moviles252/features/auth/data/source/auth_data_source.dart';
import 'package:moviles252/features/auth/domain/repository/auth_repository.dart';
import 'package:moviles252/features/profile/data/source/profile_data_source.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource _authDataSource = AuthDataSourceImpl();
  final ProfileDataSource _profileDataSource = ProfileDataSourceImpl();

  @override
  Future<void> registerUser(Profile profile, String password) async {
    await _authDataSource.signUp(profile.email, password);
  }

  @override
  Future<Profile?> loginUser(String email, String password) async {
    final String? userId = await _authDataSource.signIn(email, password);
    if (userId == null) return null;

    Profile? profile = await _profileDataSource.getProfileById(userId);

    if (profile == null) {
      final newProfile = Profile(
        id: userId,
        name: email.split('@').first,
        email: email,
        createdAt: DateTime.now(),
      );
      await _profileDataSource.createProfile(newProfile);
      profile = newProfile;
    }

    return profile;
  }
}
