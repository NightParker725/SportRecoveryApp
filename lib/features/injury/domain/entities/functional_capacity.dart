class FunctionalCapacity {
  final String weightBearingCapacity;
  final List<String> basicActivities;
  final String stabilityLevel;

  FunctionalCapacity({
    required this.weightBearingCapacity,
    required this.basicActivities,
    required this.stabilityLevel,
  });

  static final List<String> validWeightBearingCapacities = [
    'Sí, sin problemas',
    'Sí, pero con molestia',
    'Solo un poco, duele mucho',
    'No puedo moverla para nada',
  ];

  static final List<String> validBasicActivities = [
    'Caminar normalmente',
    'Subir/bajar escaleras',
    'Levantar objetos ligeros',
    'Girar o rotar la zona',
    'Flexionar/extender',
    'Ninguna de las anteriores',
  ];

  static final List<String> validStabilityLevels = [
    'No, me siento estable',
    'Un poco inestable',
    'Muy inestable, como si fuera a ceder',
  ];

  bool isValid() {
    return validWeightBearingCapacities.contains(weightBearingCapacity) &&
        basicActivities.every((activity) => validBasicActivities.contains(activity)) &&
        validStabilityLevels.contains(stabilityLevel) &&
        _checkConsistency();
  }

  bool _checkConsistency() {
    // Verificar consistencia: si dice "No puedo moverla" no debería tener actividades
    if (weightBearingCapacity == 'No puedo moverla para nada' &&
        basicActivities.isNotEmpty &&
        !basicActivities.contains('Ninguna de las anteriores')) {
      return false;
    }
    return true;
  }

  @override
  String toString() =>
      'FunctionalCapacity(weightBearingCapacity: $weightBearingCapacity, basicActivities: $basicActivities, stabilityLevel: $stabilityLevel)';
}
