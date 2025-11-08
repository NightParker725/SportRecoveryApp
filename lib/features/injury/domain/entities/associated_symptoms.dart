class AssociatedSymptoms {
  final List<String> symptoms;
  final bool hasCriticalSymptoms;
  final List<String> criticalSymptomsList;

  AssociatedSymptoms({
    required this.symptoms,
    required this.hasCriticalSymptoms,
    required this.criticalSymptomsList,
  });

  static final List<String> validSymptoms = [
    'Hinchazón/Inflamación visible',
    'Moretones/Hematomas',
    'Rigidez/Pérdida de movimiento',
    'Entumecimiento/Hormigueo',
    'Chasquidos/Sonidos extraños al mover',
    'Deformidad visible (cambio de forma)',
    'Moretones que se extienden rápidamente',
    'Fiebre o náuseas',
    'Confusión o mareos',
    'Ninguno de los anteriores',
  ];

  static final List<String> criticalSymptoms = [
    'Deformidad visible (cambio de forma)',
    'Moretones que se extienden rápidamente',
    'Fiebre o náuseas',
    'Confusión o mareos',
  ];

  bool isValid() {
    return symptoms.every((symptom) => validSymptoms.contains(symptom));
  }

  bool hasSeriousAlert() {
    return symptoms.any((symptom) => criticalSymptoms.contains(symptom));
  }

  @override
  String toString() =>
      'AssociatedSymptoms(symptoms: $symptoms, hasCriticalSymptoms: $hasCriticalSymptoms)';
}
