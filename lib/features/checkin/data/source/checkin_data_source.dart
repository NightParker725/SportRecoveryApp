import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CheckinDataSource {
  Future<void> createDailyCheckin({
    required String userId,
    required DateTime date, // usaremos solo la parte de fecha
    required int q1,
    required String q2,
    required String q3,
    required int q4,
    required String? q5,
    required String q6,
  });
}

class CheckinDataSourceImpl implements CheckinDataSource {
  final _db = Supabase.instance.client;
  static const table = 'daily_checkins';

  @override
  Future<void> createDailyCheckin({
    required String userId,
    required DateTime date,
    required int q1,
    required String q2,
    required String q3,
    required int q4,
    required String? q5,
    required String q6,
  }) async {
    final isoDate = DateTime.utc(
      date.year,
      date.month,
      date.day,
    ).toIso8601String().split('T').first; // YYYY-MM-DD

    await _db.from(table).insert({
      'user_id': userId,
      'date': isoDate,
      'q1': q1,
      'q2': q2, // ← text[]
      'q3': q3, // ← text[]
      'q4': q4,
      'q5': q5,
      'q6': q6,
    });
  }
}
