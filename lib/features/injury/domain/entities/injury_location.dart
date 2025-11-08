class InjuryLocation {
  final String location;
  final String side;

  InjuryLocation({
    required this.location,
    required this.side,
  });

  // Validar que la ubicación sea válida
  static final List<String> validLocations = [
    'Cabeza/Cuello',
    'Hombro/Brazo',
    'Muñeca/Mano',
    'Espalda/Columna',
    'Cadera/Pelvis',
    'Rodilla',
    'Tobillo/Pie',
  ];

  static final List<String> validSides = ['Izquierdo', 'Derecho', 'Ambos'];

  bool isValid() {
    return validLocations.contains(location) && validSides.contains(side);
  }

  @override
  String toString() => 'InjuryLocation(location: $location, side: $side)';
}
