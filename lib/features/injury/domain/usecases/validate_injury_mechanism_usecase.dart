import '../entities/injury_mechanism.dart';

class ValidateInjuryMechanismUseCase {
  ValidateInjuryMechanismUseCase();

  Future<InjuryMechanism> call({
    required String timing,
    required String mechanism,
    required bool hasPopping,
    required String frequency,
  }) async {
    if (timing.isEmpty) {
      throw Exception('El timing de la lesión es obligatorio');
    }

    if (mechanism.isEmpty) {
      throw Exception('El mecanismo de la lesión es obligatorio');
    }

    if (frequency.isEmpty) {
      throw Exception('La frecuencia de la lesión es obligatoria');
    }

    final injuryMechanism = InjuryMechanism(
      timing: timing,
      mechanism: mechanism,
      hasPopping: hasPopping,
      frequency: frequency,
    );

    if (!injuryMechanism.isValid()) {
      throw Exception(
        'Los datos del mecanismo no son válidos. '
        'Verificar: timing, mechanism, y frequency.',
      );
    }

    return injuryMechanism;
  }
}
