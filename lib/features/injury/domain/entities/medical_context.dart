class MedicalContext {
  final String activityType;
  final List<String> preexistingConditions;
  final List<String> additionalFactors;

  MedicalContext({
    required this.activityType,
    required this.preexistingConditions,
    required this.additionalFactors,
  });

  static final List<String> validActivityTypes = [
    'Corriendo/Trotar',
    'Fútbol',
    'Baloncesto',
    'Ejercicio en gimnasio',
    'Ciclismo',
    'Natación',
    'Actividad diaria (no deportiva)',
    'Otro deporte',
  ];

  static final List<String> validPreexistingConditions = [
    'Ninguna',
    'Artritis',
    'Diabetes',
    'Problemas óseos',
    'Problemas de coagulación',
    'Tomo medicamentos anticoagulantes',
  ];

  static final List<String> validAdditionalFactors = [
    'Entrenamiento sin calentamiento previo',
    'Estaba deshidratado/a',
    'Entrenamiento muy intenso recientemente',
    'Lesión previa en esta zona',
    'Ninguno aplica',
  ];

  bool isValid() {
    return validActivityTypes.contains(activityType) &&
        preexistingConditions.every(
            (condition) => validPreexistingConditions.contains(condition)) &&
        additionalFactors
            .every((factor) => validAdditionalFactors.contains(factor));
  }

  @override
  String toString() =>
      'MedicalContext(activityType: $activityType, preexistingConditions: $preexistingConditions, additionalFactors: $additionalFactors)';
}
