import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/injury_assessment.dart';
import '../bloc/injury_assessment_bloc.dart';

class InjuryAssessmentSummaryScreen extends StatefulWidget {
  const InjuryAssessmentSummaryScreen({super.key});

  @override
  State<InjuryAssessmentSummaryScreen> createState() =>
      _InjuryAssessmentSummaryScreenState();
}

class _InjuryAssessmentSummaryScreenState
    extends State<InjuryAssessmentSummaryScreen> {
  @override
  void initState() {
    super.initState();
    // Dispara el evento automáticamente con datos de prueba
    _generateAssessment();
  }

  void _generateAssessment() {
    final userId = Supabase.instance.client.auth.currentUser?.id ?? 'test-user';

    context.read<InjuryAssessmentBloc>().add(
      GenerateAssessmentEvent(
        userId: userId,
        location: 'Rodilla',
        side: 'Derecho',
        timing: 'Hace 2 días',
        mechanism: 'Movimiento brusco',
        hasPopping: false,
        frequency: 'Ocasional',
        painIntensity: 7,
        painTypes: ['Dolor agudo'],
        painTriggers: ['Movimiento'],
        weightBearingCapacity: 'Sí, pero con molestia',
        basicActivities: ['Caminar normalmente'],
        stabilityLevel: 'Un poco inestable',
        symptoms: ['Inflamación'],
        hasCriticalSymptoms: false,
        activityType: 'Fútbol',
        preexistingConditions: ['Ninguna'],
        additionalFactors: ['Ninguno aplica'],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InjuryAssessmentBloc, InjuryAssessmentState>(
      listener: (context, state) {
        if (state is InjuryAssessmentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: const Color(0xFFFF5252),
            ),
          );
        }
      },
      child: BlocBuilder<InjuryAssessmentBloc, InjuryAssessmentState>(
        builder: (context, state) {
          if (state is InjuryAssessmentSuccess) {
            return _buildSummaryScreen(context, state.assessment);
          }

          if (state is InjuryAssessmentError) {
            return _buildErrorScreen(context, state.message);
          }

          return Scaffold(
            backgroundColor: const Color(0xFF1F242A),
            body: const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xFF00FFFF)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryScreen(
    BuildContext context,
    InjuryAssessment assessment,
  ) {
    final isCritical = assessment.urgencyLevel
        .contains('CRÍTICO');
    final isHigh = assessment.urgencyLevel.contains('ALTO');

    return Scaffold(
      backgroundColor: const Color(0xFF1F242A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F242A),
        elevation: 0,
        leading: const SizedBox.shrink(),
        title: const Text(
          'Resumen de Evaluación',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Alerta crítica si es necesario
              if (isCritical) _buildCriticalAlert(),
              if (isHigh && !isCritical) _buildHighUrgencyAlert(),

              const SizedBox(height: 24),

              // Información de la lesión
              _buildSection(
                'Ubicación de la Lesión',
                [
                  _buildInfoRow('Zona:', assessment.location),
                  _buildInfoRow('Lado:', assessment.side),
                ],
              ),

              const SizedBox(height: 16),

              // Mecanismo
              _buildSection(
                'Mecanismo de la Lesión',
                [
                  _buildInfoRow('Cuándo:', assessment.timing),
                  _buildInfoRow('Cómo:', assessment.mechanism),
                  _buildInfoRow(
                    'Pop/Chasquido:',
                    assessment.hasPopping ? 'Sí' : 'No',
                  ),
                  _buildInfoRow('Frecuencia:', assessment.frequency),
                ],
              ),

              const SizedBox(height: 16),

              // Dolor
              _buildSection(
                'Características del Dolor',
                [
                  _buildInfoRow('Intensidad:', '${assessment.painIntensity}/10'),
                  _buildInfoRow('Tipos:', assessment.painTypes.join(', ')),
                  if (assessment.painTriggers.isNotEmpty)
                    _buildInfoRow('Factores:', assessment.painTriggers.join(', ')),
                ],
              ),

              const SizedBox(height: 16),

              // Capacidad funcional
              _buildSection(
                'Capacidad Funcional',
                [
                  _buildInfoRow('Soporte de peso:', assessment.weightBearingCapacity),
                  if (assessment.basicActivities.isNotEmpty)
                    _buildInfoRow('Actividades:', assessment.basicActivities.join(', ')),
                  _buildInfoRow('Estabilidad:', assessment.stabilityLevel),
                ],
              ),

              const SizedBox(height: 16),

              // Síntomas
              _buildSection(
                'Síntomas Reportados',
                [
                  _buildInfoRow('Síntomas:', assessment.symptoms.join(', ')),
                ],
              ),

              const SizedBox(height: 24),

              // Diagnóstico preliminar
              _buildSection(
                'Diagnóstico Preliminar',
                [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      assessment.preliminaryDiagnosis,
                      style: const TextStyle(
                        color: Color(0xFF00FFFF),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Nivel de urgencia
              _buildSection(
                'Nivel de Urgencia',
                [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: _getUrgencyColor(assessment.urgencyLevel)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getUrgencyColor(assessment.urgencyLevel),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      assessment.urgencyLevel,
                      style: TextStyle(
                        color: _getUrgencyColor(assessment.urgencyLevel),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Tiempo estimado de recuperación
              _buildSection(
                'Tiempo Estimado de Recuperación',
                [
                  _buildInfoRow(
                    'Aproximadamente:',
                    '${assessment.estimatedRecoveryDays} días',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Recomendaciones
              _buildSection(
                'Recomendaciones Iniciales',
                assessment.initialRecommendations
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key + 1;
                      final recommendation = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$index. ',
                              style: const TextStyle(
                                color: Color(0xFF00FFFF),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                recommendation,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                    .toList(),
              ),

              const SizedBox(height: 32),

              // Botones de acción
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FFFF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'VOLVER AL INICIO',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/my_profile');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'IR A MI PERFIL',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context, String error) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F242A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F242A),
        elevation: 0,
        title: const Text('Error en la Evaluación'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFFF5252),
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FFFF),
                ),
                child: const Text(
                  'Intentar de Nuevo',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCriticalAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF5252).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFFF5252),
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning,
            color: Color(0xFFFF5252),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ATENCIÓN MÉDICA INMEDIATA REQUERIDA',
                  style: TextStyle(
                    color: Color(0xFFFF5252),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Por favor, consulta a un especialista o acude a un servicio de emergencia lo antes posible.',
                  style: TextStyle(
                    color: Color(0xFFFF5252),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighUrgencyAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.orange,
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info,
            color: Colors.orange[300],
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'URGENCIA ALTA',
                  style: TextStyle(
                    color: Colors.orange[300],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Consulta a un especialista en las próximas 24 horas.',
                  style: TextStyle(
                    color: Colors.orange[300],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF00FFFF),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getUrgencyColor(String urgency) {
    if (urgency.contains('CRÍTICO')) {
      return const Color(0xFFFF5252);
    }
    if (urgency.contains('ALTO')) {
      return Colors.orange;
    }
    if (urgency.contains('MEDIO')) {
      return Colors.amber;
    }
    return const Color(0xFF00FFFF);
  }
}
