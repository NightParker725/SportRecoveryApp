/// Servicio singleton para manejar los datos acumulados durante el flujo de evaluación de lesiones
class InjuryEvaluationService {
  static final InjuryEvaluationService _instance =
      InjuryEvaluationService._internal();

  factory InjuryEvaluationService() {
    return _instance;
  }

  InjuryEvaluationService._internal();

  // ===== Pantalla 1: Ubicación =====
  String? location;
  String? side;

  // ===== Pantalla 2: Mecanismo =====
  String? timing;
  String? mechanism;
  bool? hasPopping;
  String? frequency;

  // ===== Pantalla 3: Dolor =====
  int? painIntensity;
  List<String>? painTypes;
  List<String>? painTriggers;

  // ===== Pantalla 4: Capacidad Funcional =====
  String? weightBearingCapacity;
  List<String>? basicActivities;
  String? stabilityLevel;

  // ===== Pantalla 5: Síntomas =====
  List<String>? symptoms;
  bool? hasCriticalSymptoms;

  // ===== Pantalla 6: Contexto Médico =====
  String? activityType;
  List<String>? preexistingConditions;
  List<String>? additionalFactors;

  /// Limpia todos los datos (útil cuando se completa o cancela el flujo)
  void clearAll() {
    location = null;
    side = null;
    timing = null;
    mechanism = null;
    hasPopping = null;
    frequency = null;
    painIntensity = null;
    painTypes = null;
    painTriggers = null;
    weightBearingCapacity = null;
    basicActivities = null;
    stabilityLevel = null;
    symptoms = null;
    hasCriticalSymptoms = null;
    activityType = null;
    preexistingConditions = null;
    additionalFactors = null;
  }

  /// Retorna true si todos los datos están completos
  bool get isComplete =>
      location != null &&
      side != null &&
      timing != null &&
      mechanism != null &&
      hasPopping != null &&
      frequency != null &&
      painIntensity != null &&
      painTypes != null &&
      painTriggers != null &&
      weightBearingCapacity != null &&
      basicActivities != null &&
      stabilityLevel != null &&
      symptoms != null &&
      hasCriticalSymptoms != null &&
      activityType != null &&
      preexistingConditions != null &&
      additionalFactors != null;

  @override
  String toString() =>
      'InjuryEvaluationService(location: $location, side: $side, timing: $timing)';
}
