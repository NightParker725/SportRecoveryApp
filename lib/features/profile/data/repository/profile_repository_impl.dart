import 'package:moviles252/domain/model/profile.dart';
import 'package:moviles252/features/profile/domain/repository/profile_repository.dart';
import 'package:moviles252/features/profile/data/source/profile_data_source.dart';
import 'package:moviles252/features/profile/data/source/injuries_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileDataSource _ds = ProfileDataSourceImpl();
  final InjuriesDataSource _injuries = InjuriesDataSourceImpl();

  // getProfileById is owned by the auth feature; profile repo exposes currentProfile only

  @override
  Future<Profile?> getCurrentProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    final userId = user?.id;
    if (userId == null) return null;
    return await _ds.getProfileById(userId);
  }

  @override
  Future<void> updateProfile(Profile profile) async {
    await _ds.updateProfile(profile);
  }

  @override
  Future<void> createInjury(String userId, Map<String, dynamic> injury) async {
    await _injuries.createInjury(userId, injury);
  }
}
