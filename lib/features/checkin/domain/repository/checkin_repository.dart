import 'package:moviles252/domain/model/daily_checkin.dart';

abstract class CheckinRepository {
  Future<DailyCheckin?> getTodayCheckin();
  Future<void> saveCheckin(DailyCheckin checkin);
}
