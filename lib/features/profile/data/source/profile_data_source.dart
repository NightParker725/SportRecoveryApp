import 'package:moviles252/domain/model/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileDataSource {
  Future<void> createProfile(Profile profile);
  Future<Profile?> getProfileById(String userId);
  Future<void> updateProfile(Profile profile);
}

class ProfileDataSourceImpl extends ProfileDataSource {
  static const tableName = 'profiles';
  final _db = Supabase.instance.client;

  @override
  Future<void> createProfile(Profile profile) async {
    final payload = profile.toJson();
    try {
      print('[ProfileDataSource] create payload=$payload');
    } catch (_) {}
    await _db.from(tableName).insert(payload);
  }

  @override
  Future<Profile?> getProfileById(String userId) async {
    final data = await _db
        .from(tableName)
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (data == null) return null;
    return Profile.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<void> updateProfile(Profile profile) async {
    final data = profile.toJson();
    data.remove('created_at');
    try {
      print('[ProfileDataSource] update id=${profile.id} payload=$data');
    } catch (_) {}
    await _db.from(tableName).update(data).eq('id', profile.id);
  }
}
