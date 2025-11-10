import 'package:moviles252/domain/model/daily_checkin.dart';

abstract class CheckinEvent {}

class SubmitCheckinEvent extends CheckinEvent {
  final DailyCheckin checkin;
  SubmitCheckinEvent(this.checkin);
}
