import '../entities/injury_pain.dart';

class ValidateInjuryPainUseCase {
  ValidateInjuryPainUseCase();

  Future<InjuryPain> call({
    required int intensity,
    required List<String> painTypes,
    required List<String> triggerFactors,
  }) async {
    if (intensity < 1 || intensity > 10) {
      throw Exception('La intensidad del dolor debe estar entre 1 y 10');
    }

    if (painTypes.isEmpty) {
      throw Exception('Debe seleccionar al menos un tipo de dolor');
    }

    final injuryPain = InjuryPain(
      intensity: intensity,
      painTypes: painTypes,
      triggerFactors: triggerFactors,
    );

    if (!injuryPain.isValid()) {
      throw Exception('Los datos del dolor no son válidos.');
    }

    return injuryPain;
  }
}
