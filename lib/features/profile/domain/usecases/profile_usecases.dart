import 'package:moviles252/features/profile/domain/repository/profile_repository.dart';
import 'package:moviles252/domain/model/profile.dart';

class CompleteProfileUsecase {
  final ProfileRepository repository;
  CompleteProfileUsecase(this.repository);

  Future<void> execute(Profile partial) async {
    // Resolve the currently authenticated user's profile via the repository.
    final current = await repository.getCurrentProfile();

    if (current != null) {
      final merged = current.copyWith(
        birthDate: partial.birthDate ?? current.birthDate,
        sex: partial.sex ?? current.sex,
        heightCm: partial.heightCm ?? current.heightCm,
        weightKg: partial.weightKg ?? current.weightKg,
        preferredName: partial.preferredName ?? current.preferredName,
        profilePicture: partial.profilePicture ?? current.profilePicture,
        primaryPhysicalActivity:
            partial.primaryPhysicalActivity ?? current.primaryPhysicalActivity,
        complementaryPhysicalActivity:
            partial.complementaryPhysicalActivity ??
            current.complementaryPhysicalActivity,
        physicalActivityFrequency:
            partial.physicalActivityFrequency ??
            current.physicalActivityFrequency,
        mainGoals: partial.mainGoals ?? current.mainGoals,
      );
      await repository.updateProfile(merged);
    } else {
      throw Exception('No profile found for the current user');
    }
  }

  Future<void> createInjury(Map<String, dynamic> injury) async {
    // Resolve current user's id and create the injury linked to that user.
    final current = await repository.getCurrentProfile();
    final userId = current?.id;
    if (userId == null) throw Exception('No authenticated user');
    await repository.createInjury(userId, injury);
  }
}
