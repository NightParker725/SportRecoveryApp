import 'package:moviles252/domain/model/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileDataSource {
  Future<void> createProfile(Profile profile);

  Future<Profile?> getProfileById(String userId) async {}
}

class ProfileDataSourceImpl extends ProfileDataSource {
  @override
  Future<void> createProfile(Profile profile) async {
    await Supabase.instance.client.from("profiles").insert(profile.toJson());
  }

  @override
  Future<Profile?> getProfileById(String userId) async {
    final response = await Supabase.instance.client
        .from("profiles")
        .select()
        .eq('id', userId)
        .single();
    
    return Profile.fromJson(response);
  }
}
