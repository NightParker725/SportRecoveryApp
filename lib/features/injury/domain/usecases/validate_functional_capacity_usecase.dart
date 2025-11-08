import '../entities/functional_capacity.dart';

class ValidateFunctionalCapacityUseCase {
  ValidateFunctionalCapacityUseCase();

  Future<FunctionalCapacity> call({
    required String weightBearingCapacity,
    required List<String> basicActivities,
    required String stabilityLevel,
  }) async {
    if (weightBearingCapacity.isEmpty) {
      throw Exception('La capacidad de carga de peso es obligatoria');
    }

    if (stabilityLevel.isEmpty) {
      throw Exception('El nivel de estabilidad es obligatorio');
    }

    final functionalCapacity = FunctionalCapacity(
      weightBearingCapacity: weightBearingCapacity,
      basicActivities: basicActivities,
      stabilityLevel: stabilityLevel,
    );

    if (!functionalCapacity.isValid()) {
      throw Exception(
        'Los datos de capacidad funcional no son válidos. '
        'Verifica que sean coherentes (ej: no puedo mover pero seleccioné actividades).',
      );
    }

    return functionalCapacity;
  }
}
