import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/domain/model/profile.dart';
import 'package:moviles252/features/profile/data/source/profile_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileEvent {}

class LoadMyProfile extends ProfileEvent {}

class SaveMyProfile extends ProfileEvent {
  final String name;
  final DateTime? birthDate;
  final String? sex;
  final double? heightCm;
  final double? weightKg;
  SaveMyProfile({
    required this.name,
    this.birthDate,
    this.sex,
    this.heightCm,
    this.weightKg,
  });
}

abstract class ProfileState {}

class ProfileIdle extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;
  ProfileLoaded(this.profile);
}

class ProfileSaving extends ProfileState {
  final Profile profile;
  ProfileSaving(this.profile);
}

class ProfileSaved extends ProfileState {
  final Profile profile;
  ProfileSaved(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class SetProfile extends ProfileEvent {
  final Profile profile;
  SetProfile(this.profile);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final _ds = ProfileDataSourceImpl();

  ProfileBloc() : super(ProfileIdle()) {
    on<LoadMyProfile>(_onLoad);
    on<SaveMyProfile>(_onSave);
    on<SetProfile>(_onSetProfile);
  }

  Future<void> _onLoad(LoadMyProfile e, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final uid = Supabase.instance.client.auth.currentUser!.id;
      final profile = await _ds.getProfileById(uid);
      if (profile == null) {
        emit(ProfileError('Perfil no encontrado'));
      } else {
        emit(ProfileLoaded(profile));
      }
    } catch (err) {
      emit(ProfileError(err.toString()));
    }
  }

  Future<void> _onSave(SaveMyProfile e, Emitter<ProfileState> emit) async {
    try {
      final uid = Supabase.instance.client.auth.currentUser!.id;
      final current = await _ds.getProfileById(uid);
      if (current == null) {
        emit(ProfileError('Perfil no encontrado'));
        return;
      }
      final updated = current.copyWith(
        name: e.name.trim(),
        birthDate: e.birthDate,
        sex: (e.sex?.trim().isEmpty ?? true) ? null : e.sex!.trim(),
        heightCm: e.heightCm,
        weightKg: e.weightKg,
      );
      emit(ProfileSaving(updated));
      await _ds.updateProfile(updated);
      emit(ProfileSaved(updated));
      emit(ProfileLoaded(updated));
    } catch (err) {
      emit(ProfileError(err.toString()));
    }
  }

  void _onSetProfile(SetProfile e, Emitter<ProfileState> emit) {
    emit(ProfileLoaded(e.profile));
  }
}
