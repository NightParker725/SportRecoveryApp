import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/associated_symptoms.dart';
import '../../data/services/injury_evaluation_service.dart';
import '../bloc/injury_symptoms_bloc.dart';

class InjurySymptomsScreen extends StatefulWidget {
  const InjurySymptomsScreen({super.key});

  @override
  State<InjurySymptomsScreen> createState() => _InjurySymptomsScreenState();
}

class _InjurySymptomsScreenState extends State<InjurySymptomsScreen> {
  Set<String> selectedSymptoms = {};

  bool get isFormValid => selectedSymptoms.isNotEmpty;

  bool get hasCriticalSymptoms {
    return selectedSymptoms.any(
      (symptom) => AssociatedSymptoms.criticalSymptoms.contains(symptom),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F242A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F242A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Qué otros síntomas tienes?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Puedes seleccionar varios',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressBar(),
              const SizedBox(height: 24),

              // Título del paso
              const Text(
                'Paso 5 de 6',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Pregunta
              const Text(
                'Marca todos los síntomas que presentas:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Síntomas
              ..._buildSymptomOptions(),

              // Alerta automática si hay síntomas críticos
              if (hasCriticalSymptoms)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5252).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFFF5252),
                        width: 2,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.warning,
                          color: Color(0xFFFF5252),
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'IMPORTANTE',
                                style: TextStyle(
                                  color: Color(0xFFFF5252),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Algunos síntomas requieren atención médica inmediata. Te recomendamos consultar un especialista.',
                                style: TextStyle(
                                  color: Color(0xFFFF5252),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              // Botones de navegación
              _buildNavigationButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: 5 / 6,
        minHeight: 6,
        backgroundColor: Colors.grey[700],
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00FFFF)),
      ),
    );
  }

  List<Widget> _buildSymptomOptions() {
    return AssociatedSymptoms.validSymptoms
        .map((symptom) {
          final isSelected = selectedSymptoms.contains(symptom);
          final isCritical =
              AssociatedSymptoms.criticalSymptoms.contains(symptom);

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedSymptoms.contains(symptom)) {
                    selectedSymptoms.remove(symptom);
                  } else {
                    selectedSymptoms.add(symptom);
                  }
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isCritical
                          ? const Color(0xFFFF5252).withValues(alpha: 0.2)
                          : const Color(0xFF00FFFF).withValues(alpha: 0.2))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? (isCritical ? const Color(0xFFFF5252) : const Color(0xFF00FFFF))
                        : Colors.grey[600]!,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isSelected
                              ? (isCritical
                                  ? const Color(0xFFFF5252)
                                  : const Color(0xFF00FFFF))
                              : Colors.grey[600]!,
                          width: 2,
                        ),
                        color: isSelected
                            ? (isCritical
                                ? const Color(0xFFFF5252)
                                : const Color(0xFF00FFFF))
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? Center(
                              child: Icon(
                                Icons.check,
                                color: isCritical ? const Color(0xFFFF5252) : Colors.black,
                                size: 14,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        symptom,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (isCritical)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.warning,
                          color: const Color(0xFFFF5252),
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        })
        .toList();
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'ANTERIOR',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: isFormValid
                ? () {
                    // Guardar datos en el singleton
                    final service = InjuryEvaluationService();
                    service.symptoms = selectedSymptoms.toList();
                    service.hasCriticalSymptoms = hasCriticalSymptoms;

                    context.read<InjurySymptomsBloc>().add(
                          SaveInjurySymptomsEvent(
                            symptoms: selectedSymptoms.toList(),
                          ),
                        );
                    Navigator.of(context).pushNamed('/injury_medical_context');
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FFFF),
              disabledBackgroundColor: Colors.grey[600],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'SIGUIENTE',
              style: TextStyle(
                color: isFormValid ? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
