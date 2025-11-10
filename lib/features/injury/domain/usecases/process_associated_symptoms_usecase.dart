import '../entities/associated_symptoms.dart';

class ProcessAssociatedSymptomsUseCase {
  ProcessAssociatedSymptomsUseCase();

  Future<AssociatedSymptoms> call({
    required List<String> symptoms,
  }) async {
    if (symptoms.isEmpty) {
      throw Exception('Debe seleccionar al menos un síntoma');
    }

    final criticalSymptomsList = symptoms
        .where((symptom) => AssociatedSymptoms.criticalSymptoms.contains(symptom))
        .toList();

    final associatedSymptoms = AssociatedSymptoms(
      symptoms: symptoms,
      hasCriticalSymptoms: criticalSymptomsList.isNotEmpty,
      criticalSymptomsList: criticalSymptomsList,
    );

    if (!associatedSymptoms.isValid()) {
      throw Exception('Los síntomas proporcionados no son válidos.');
    }

    // Si hay síntomas críticos, se lanza una excepción para alertar
    if (associatedSymptoms.hasCriticalSymptoms) {
      throw Exception(
        'ALERTA: Algunos síntomas requieren atención médica inmediata. '
        'Síntomas críticos detectados: ${criticalSymptomsList.join(', ')}',
      );
    }

    return associatedSymptoms;
  }
}
