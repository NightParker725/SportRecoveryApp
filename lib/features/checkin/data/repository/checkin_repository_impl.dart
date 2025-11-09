import 'package:moviles252/features/checkin/data/source/checkin_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CheckinRepository {
  Future<void> submit({
    required int q1,
    required String q2,
    required String q3,
    required int q4,
    required String? q5,
    required String q6,
  });
}

class CheckiRepositoryImpl implements CheckinRepository {
  final CheckinDataSource _ds = CheckinDataSourceImpl();

  @override
  Future<void> submit({
    required int q1,
    required String q2,
    required String q3,
    required int q4,
    required String? q5,
    required String q6,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('No hay sesión activa');
    }
    await _ds.createDailyCheckin(
      userId: user.id,
      date: DateTime.now(),
      q1: q1,
      q2: q2,
      q3: q3,
      q4: q4,
      q5: q5,
      q6: q6,
    );
  }
}
