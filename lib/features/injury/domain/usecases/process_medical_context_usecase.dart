import '../entities/medical_context.dart';

class ProcessMedicalContextUseCase {
  ProcessMedicalContextUseCase();

  Future<MedicalContext> call({
    required String activityType,
    required List<String> preexistingConditions,
    required List<String> additionalFactors,
  }) async {
    if (activityType.isEmpty) {
      throw Exception('El tipo de actividad es obligatorio');
    }

    if (preexistingConditions.isEmpty) {
      throw Exception('Debe indicar si tiene condiciones médicas preexistentes');
    }

    final medicalContext = MedicalContext(
      activityType: activityType,
      preexistingConditions: preexistingConditions,
      additionalFactors: additionalFactors,
    );

    if (!medicalContext.isValid()) {
      throw Exception(
        'Los datos del contexto médico no son válidos. '
        'Verifique los valores proporcionados.',
      );
    }

    return medicalContext;
  }
}
