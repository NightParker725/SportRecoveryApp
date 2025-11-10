import '../entities/injury_location.dart';

class ValidateInjuryLocationUseCase {
  ValidateInjuryLocationUseCase();

  Future<InjuryLocation> call({
    required String location,
    required String side,
  }) async {
    if (location.isEmpty) {
      throw Exception('La ubicación de la lesión es obligatoria');
    }

    if (side.isEmpty) {
      throw Exception('El lado afectado es obligatorio');
    }

    final injuryLocation = InjuryLocation(
      location: location,
      side: side,
    );

    if (!injuryLocation.isValid()) {
      throw Exception(
        'Los datos proporcionados no son válidos. '
        'Ubicación válidas: ${InjuryLocation.validLocations.join(', ')}. '
        'Lados válidos: ${InjuryLocation.validSides.join(', ')}',
      );
    }

    return injuryLocation;
  }
}
