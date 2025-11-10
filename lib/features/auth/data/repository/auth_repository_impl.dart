import 'package:moviles252/domain/model/profile.dart';
import 'package:moviles252/features/auth/data/source/auth_data_source.dart';
import 'package:moviles252/features/auth/domain/repository/auth_repository.dart';
import 'package:moviles252/features/profile/data/source/profile_data_source.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource _authDataSource = AuthDataSourceImpl();
  final ProfileDataSource _profileDataSource = ProfileDataSourceImpl();

  @override
  Future<void> registerUser(Profile profile, String password) async {
    // Sign up via Supabase and, if successful, create a corresponding profile row
    // using the returned user id. This prevents inserting an empty string as
    // the UUID (which causes the Postgres error you saw).
    final userId = await _authDataSource.signUp(profile.email, password);
    if (userId == null) return;

    // Build a server-side profile object with the canonical user id.
    final toSave = Profile(
      id: userId,
      name: profile.name,
      email: profile.email,
      sex: profile.sex ?? 'O',
      createdAt: DateTime.now(),
    );
    await _profileDataSource.createProfile(toSave);
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final user = Supabase.instance.client.auth.currentUser;
    return user != null;
  }

  @override
  Future<Profile?> getCurrentProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    final userId = user?.id;
    if (userId == null) return null;
    return await _profileDataSource.getProfileById(userId);
  }

  @override
  Future<Profile?> getProfileById(String userId) async {
    return await _profileDataSource.getProfileById(userId);
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
        sex: 'other',
        createdAt: DateTime.now(),
      );
      // Use AuthRepository's createProfile implementation to create the profile
      await createProfile(newProfile);
      profile = newProfile;
    }

    return profile;
  }

  @override
  Future<void> createProfile(Profile profile) async {
    // Ensure we use the authenticated user id if available
    final user = Supabase.instance.client.auth.currentUser;
    final userId = user?.id ?? profile.id;
    // Ensure sex has a safe default to satisfy DB CHECK constraints
    // Use 'O' (other) as default DB code. The Profile.toJson mapper will
    // also normalize various representations to 'M'/'F'/'O'.
    final toSave = profile.copyWith(id: userId, sex: profile.sex ?? 'O');
    await _profileDataSource.createProfile(toSave);
  }
}
