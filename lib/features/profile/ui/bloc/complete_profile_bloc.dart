import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/domain/model/profile.dart';
import 'package:moviles252/features/profile/domain/usecases/profile_usecases.dart';

abstract class CompleteProfileEvent {}

class SubmitCompleteProfileEvent extends CompleteProfileEvent {
  final String? preferredName;
  final String? profilePicture;
  final DateTime? birthDate;
  final String? sex;
  final double? heightCm;
  final double? weightKg;
  final String? primaryPhysicalActivity;
  final String? complementaryPhysicalActivity;
  final String? physicalActivityFrequency;
  final List<String>? mainGoals;
  final Map<String, dynamic>? injuriesLastYear;

  SubmitCompleteProfileEvent({
    this.preferredName,
    this.profilePicture,
    this.birthDate,
    this.sex,
    this.heightCm,
    this.weightKg,
    this.primaryPhysicalActivity,
    this.complementaryPhysicalActivity,
    this.physicalActivityFrequency,
    this.mainGoals,
    this.injuriesLastYear,
  });
}

abstract class CompleteProfileState {}

class CompleteProfileIdle extends CompleteProfileState {}

class CompleteProfileLoading extends CompleteProfileState {}

class CompleteProfileSuccess extends CompleteProfileState {}

class CompleteProfileError extends CompleteProfileState {
  final String message;
  CompleteProfileError(this.message);
}

class CompleteProfileBloc
    extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  final CompleteProfileUsecase usecase;

  CompleteProfileBloc(this.usecase) : super(CompleteProfileIdle()) {
    on<SubmitCompleteProfileEvent>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitCompleteProfileEvent event,
    Emitter<CompleteProfileState> emit,
  ) async {
    emit(CompleteProfileLoading());
    try {
      final profile = Profile(
        id: '',
        name: '',
        email: '',
        preferredName: event.preferredName,
        profilePicture: event.profilePicture,
        birthDate: event.birthDate,
        sex: event.sex,
        heightCm: event.heightCm,
        weightKg: event.weightKg,
        primaryPhysicalActivity: event.primaryPhysicalActivity,
        complementaryPhysicalActivity: event.complementaryPhysicalActivity,
        physicalActivityFrequency: event.physicalActivityFrequency,
        mainGoals: event.mainGoals,
        injuriesLastYear: event.injuriesLastYear,
        createdAt: DateTime.now(),
      );

      await usecase.execute(profile);
      if (event.injuriesLastYear != null) {
        await usecase.createInjury(event.injuriesLastYear!);
      }
      emit(CompleteProfileSuccess());
    } catch (e) {
      emit(CompleteProfileError(e.toString()));
    }
  }
}
