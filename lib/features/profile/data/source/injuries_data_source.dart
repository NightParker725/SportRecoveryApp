import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class InjuriesDataSource {
  Future<void> createInjury(String userId, Map<String, dynamic> injury);
}

class InjuriesDataSourceImpl extends InjuriesDataSource {
  // Injuries are stored in the 'user_injuries' table
  static const tableName = 'user_injuries';
  final _db = Supabase.instance.client;

  @override
  Future<void> createInjury(String userId, Map<String, dynamic> injury) async {
    final data = Map<String, dynamic>.from(injury);
    // Ensure user id is present as foreign key
    data['user_id'] = userId;
    await _db.from(tableName).insert(data);
  }
}
