class InjuryMechanism {
  final String timing;
  final String mechanism;
  final bool hasPopping;
  final String frequency;

  InjuryMechanism({
    required this.timing,
    required this.mechanism,
    required this.hasPopping,
    required this.frequency,
  });

  static final List<String> validTimings = [
    'Ahora mismo (menos de 1 hora)',
    'Hace algunas horas (1-6 horas)',
    'Ayer',
    'Hace varios días',
    'Hace más de una semana',
  ];

  static final List<String> validMechanisms = [
    'Caída',
    'Torsión/Movimiento repentino',
    'Impacto directo',
    'Sobreuso repetitivo',
    'Movimiento forzado',
    'No estoy seguro',
  ];

  static final List<String> validFrequencies = [
    'Primera vez',
    'Ya había pasado antes',
    'Es recurrente',
  ];

  bool isValid() {
    return validTimings.contains(timing) &&
        validMechanisms.contains(mechanism) &&
        validFrequencies.contains(frequency);
  }

  @override
  String toString() =>
      'InjuryMechanism(timing: $timing, mechanism: $mechanism, hasPopping: $hasPopping, frequency: $frequency)';
}
