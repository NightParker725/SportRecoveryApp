abstract class CheckinState {}

class CheckinIdle extends CheckinState {}

class CheckinLoading extends CheckinState {}

class CheckinLoaded extends CheckinState {}

class CheckinSaved extends CheckinState {}

class CheckinError extends CheckinState {
  final String message;
  CheckinError(this.message);
}
