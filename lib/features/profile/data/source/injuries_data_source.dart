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

    // Normalize date fields: the UI may send a map like {year:..., month:..., date:...}
    // Convert it to a SQL date string 'YYYY-MM-DD' which Postgres accepts for date columns.
    if (data.containsKey('injury_date')) {
      final raw = data['injury_date'];
      if (raw is Map) {
        final y = (raw['year'] as int?) ?? (raw['year'] as num?)?.toInt();
        final m = (raw['month'] as int?) ?? (raw['month'] as num?)?.toInt();
        final d = (raw['date'] as int?) ?? (raw['date'] as num?)?.toInt();
        if (y != null && m != null && d != null) {
          final dt = DateTime(y, m, d);
          data['injury_date'] = dt
              .toIso8601String()
              .split('T')
              .first; // YYYY-MM-DD
        } else {
          // If parsing failed, remove the field to avoid invalid input
          data.remove('injury_date');
        }
      } else if (raw is DateTime) {
        data['injury_date'] = raw.toIso8601String().split('T').first;
      }
      // if it's already a string, assume it's in acceptable format
    }

    // Debug log: show user id and payload being sent to Supabase
    try {
      print('[InjuriesDataSource] inserting for user_id=$userId payload=$data');
    } catch (_) {}

    await _db.from(tableName).insert(data);
  }
}
