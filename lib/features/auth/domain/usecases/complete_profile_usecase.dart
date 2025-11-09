import '../../domain/repository/auth_repository.dart';
import 'package:moviles252/domain/model/profile.dart';

class CompleteProfileUsecase {
  final AuthRepository repository;
  CompleteProfileUsecase(this.repository);

  Future<void> execute(Profile partial) async {
    // Obtener perfil actual y mezclar campos
    final current = await repository.getCurrentProfile();
    if (current != null) {
      final merged = current.copyWith(
        birthDate: partial.birthDate ?? current.birthDate,
        sex: partial.sex ?? current.sex,
        heightCm: partial.heightCm ?? current.heightCm,
        weightKg: partial.weightKg ?? current.weightKg,
      );
      await repository.updateProfile(merged);
    } else {
      // Si no existe perfil, enviamos el parcial y repository se encargará de asignar el id
      await repository.updateProfile(partial);
    }
  }
}
