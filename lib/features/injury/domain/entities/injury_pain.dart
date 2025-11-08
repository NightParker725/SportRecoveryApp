class InjuryPain {
  final int intensity;
  final List<String> painTypes;
  final List<String> triggerFactors;

  InjuryPain({
    required this.intensity,
    required this.painTypes,
    required this.triggerFactors,
  });

  static final List<String> validPainTypes = [
    'Agudo (como un pinchazo)',
    'Sordo (constante y profundo)',
    'Punzante (va y viene)',
    'Ardiente/Quemante',
    'Pulsátil (late como el corazón)',
  ];

  static final List<String> validTriggerFactors = [
    'Movimiento',
    'Reposo/Estar quieto',
    'Tacto/Presión',
    'Por las mañanas',
    'Por las noches',
  ];

  bool isValid() {
    return intensity >= 1 &&
        intensity <= 10 &&
        painTypes.isNotEmpty &&
        painTypes.every((type) => validPainTypes.contains(type)) &&
        triggerFactors.every(
            (factor) => validTriggerFactors.contains(factor));
  }

  @override
  String toString() =>
      'InjuryPain(intensity: $intensity, painTypes: $painTypes, triggerFactors: $triggerFactors)';
}
