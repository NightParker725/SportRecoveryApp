import '../entities/injury_assessment.dart';

class StartInjuryEvaluationFlowUseCase {
  StartInjuryEvaluationFlowUseCase();

  Future<InjuryAssessment> generateAssessment({
    required String userId,
    required String location,
    required String side,
    required String timing,
    required String mechanism,
    required bool hasPopping,
    required String frequency,
    required int painIntensity,
    required List<String> painTypes,
    required List<String> painTriggers,
    required String weightBearingCapacity,
    required List<String> basicActivities,
    required String stabilityLevel,
    required List<String> symptoms,
    required bool hasCriticalSymptoms,
    required String activityType,
    required List<String> preexistingConditions,
    required List<String> additionalFactors,
  }) async {
    // Validar que el userId no esté vacío
    if (userId.isEmpty) {
      throw Exception('El ID del usuario es obligatorio');
    }

    // Generar diagnóstico preliminar basado en los datos
    final preliminaryDiagnosis =
        _generatePreliminaryDiagnosis(location, painIntensity, symptoms);

    // Determinar el nivel de urgencia
    final urgencyLevel = _determineUrgencyLevel(
      painIntensity,
      hasCriticalSymptoms,
      symptoms,
      stabilityLevel,
    );

    // Estimar días de recuperación
    final estimatedRecoveryDays =
        _estimateRecoveryDays(location, painIntensity, frequency);

    // Generar recomendaciones iniciales
    final recommendations = _generateRecommendations(
      location,
      painIntensity,
      urgencyLevel,
      hasCriticalSymptoms,
    );

    // Crear el objeto de evaluación
    final assessment = InjuryAssessment(
      userId: userId,
      location: location,
      side: side,
      timing: timing,
      mechanism: mechanism,
      hasPopping: hasPopping,
      frequency: frequency,
      painIntensity: painIntensity,
      painTypes: painTypes,
      painTriggers: painTriggers,
      weightBearingCapacity: weightBearingCapacity,
      basicActivities: basicActivities,
      stabilityLevel: stabilityLevel,
      symptoms: symptoms,
      hasCriticalSymptoms: hasCriticalSymptoms,
      activityType: activityType,
      preexistingConditions: preexistingConditions,
      additionalFactors: additionalFactors,
      preliminaryDiagnosis: preliminaryDiagnosis,
      urgencyLevel: urgencyLevel,
      estimatedRecoveryDays: estimatedRecoveryDays,
      initialRecommendations: recommendations,
      createdAt: DateTime.now(),
    );

    return assessment;
  }

  String _generatePreliminaryDiagnosis(
    String location,
    int painIntensity,
    List<String> symptoms,
  ) {
    // Lógica básica para diagnóstico preliminar basado en ubicación y síntomas
    final hasDeformity = symptoms.contains('Deformidad visible (cambio de forma)');
    final hasSwelling = symptoms.contains('Hinchazón/Inflamación visible');
    final hasBruising = symptoms.contains('Moretones/Hematomas');
    final hasRigidity = symptoms.contains('Rigidez/Pérdida de movimiento');

    if (hasDeformity) {
      return 'Posible fractura o luxación en $location';
    }

    if (location == 'Rodilla' && (hasSwelling || hasBruising) && painIntensity >= 7) {
      return 'Posible esguince de rodilla severo o lesión meniscal en $location';
    }

    if (location == 'Tobillo/Pie' && (hasSwelling || hasBruising) && painIntensity >= 6) {
      return 'Posible esguince de tobillo en $location';
    }

    if (location == 'Hombro/Brazo' && hasRigidity && painIntensity >= 6) {
      return 'Posible lesión rotatoriana o dislocación en $location';
    }

    if (location == 'Espalda/Columna' && painIntensity >= 7) {
      return 'Posible distensión muscular severa o lesión discal en $location';
    }

    if (hasSwelling && painIntensity >= 5) {
      return 'Posible esguince o distensión muscular en $location';
    }

    if (painIntensity >= 8) {
      return 'Lesión severa no especificada en $location - requiere evaluación profesional';
    }

    return 'Posible distensión muscular o lesión leve en $location';
  }

  String _determineUrgencyLevel(
    int painIntensity,
    bool hasCriticalSymptoms,
    List<String> symptoms,
    String stabilityLevel,
  ) {
    // Si hay síntomas críticos, es urgencia alta
    if (hasCriticalSymptoms) {
      return 'CRÍTICO - BUSCAR ATENCIÓN MÉDICA INMEDIATA';
    }

    // Si hay muy inestable y dolor alto
    if (stabilityLevel == 'Muy inestable, como si fuera a ceder' &&
        painIntensity >= 7) {
      return 'ALTO';
    }

    // Si el dolor es muy severo
    if (painIntensity >= 9) {
      return 'ALTO';
    }

    // Si hay deformidad
    if (symptoms.contains('Deformidad visible (cambio de forma)')) {
      return 'ALTO';
    }

    // Si el dolor es moderado-alto
    if (painIntensity >= 6) {
      return 'MEDIO';
    }

    // Si el dolor es leve-moderado
    if (painIntensity >= 4) {
      return 'BAJO';
    }

    return 'LEVE';
  }

  int _estimateRecoveryDays(
    String location,
    int painIntensity,
    String frequency,
  ) {
    // Base estimada por ubicación
    int baseDays = switch (location) {
      'Cabeza/Cuello' => 7,
      'Hombro/Brazo' => 14,
      'Muñeca/Mano' => 10,
      'Espalda/Columna' => 21,
      'Cadera/Pelvis' => 21,
      'Rodilla' => 28,
      'Tobillo/Pie' => 14,
      _ => 10,
    };

    // Ajustar por intensidad del dolor
    if (painIntensity >= 8) {
      baseDays = (baseDays * 1.5).toInt();
    } else if (painIntensity >= 6) {
      baseDays = (baseDays * 1.2).toInt();
    }

    // Ajustar por frecuencia
    if (frequency == 'Es recurrente') {
      baseDays = (baseDays * 0.8).toInt(); // Menos días si es recurrente
    }

    return baseDays;
  }

  List<String> _generateRecommendations(
    String location,
    int painIntensity,
    String urgencyLevel,
    bool hasCriticalSymptoms,
  ) {
    final recommendations = <String>[];

    if (hasCriticalSymptoms || urgencyLevel == 'CRÍTICO - BUSCAR ATENCIÓN MÉDICA INMEDIATA') {
      recommendations.add('CONSULTE INMEDIATAMENTE A UN ESPECIALISTA');
      recommendations.add('Visite una clínica o hospital de emergencia');
      recommendations.add('No intente automedicarse');
      return recommendations;
    }

    if (urgencyLevel == 'ALTO') {
      recommendations.add('Consulte a un especialista en las próximas 24 horas');
    } else if (urgencyLevel == 'MEDIO') {
      recommendations.add('Consulte a un especialista esta semana');
    }

    // Recomendaciones generales RICE
    if (painIntensity >= 6) {
      recommendations.add('Aplicar hielo durante 15-20 minutos cada 2-3 horas');
      recommendations.add('Mantener el área elevada si es posible');
      recommendations.add('Usar vendaje o soporte para inmovilizar');
      recommendations.add('Evitar actividades que causen dolor');
    }

    // Recomendaciones por ubicación
    if (location.contains('Rodilla') || location.contains('Tobillo')) {
      recommendations.add('Evitar actividades de alto impacto');
      recommendations.add('Realizar ejercicios suaves de rango de movimiento');
    }

    if (location.contains('Espalda')) {
      recommendations.add('Mantener buena postura al sentarse');
      recommendations.add('Evitar levantar objetos pesados');
      recommendations.add('Realizar estiramientos suaves');
    }

    recommendations.add('Descansar adecuadamente');
    recommendations.add('Mantener el área protegida durante las actividades');

    return recommendations;
  }
}
