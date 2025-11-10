import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/injury_evaluation_service.dart';
import '../bloc/injury_pain_bloc.dart';

class InjuryPainScreen extends StatefulWidget {
  const InjuryPainScreen({super.key});

  @override
  State<InjuryPainScreen> createState() => _InjuryPainScreenState();
}

class _InjuryPainScreenState extends State<InjuryPainScreen> {
  int? selectedIntensity;
  Set<String> selectedPainTypes = {};
  Set<String> selectedTriggerFactors = {};

  final List<String> painTypes = [
    'Agudo (como un pinchazo)',
    'Sordo (constante y profundo)',
    'Punzante (va y viene)',
    'Ardiente/Quemante',
    'Pulsátil (late como el corazón)',
  ];

  final List<String> triggerFactors = [
    'Movimiento',
    'Reposo/Estar quieto',
    'Tacto/Presión',
    'Por las mañanas',
    'Por las noches',
  ];

  final List<MapEntry<int, String>> intensityLevels = [
    const MapEntry(1, '1-2: Muy leve, casi no molesta'),
    const MapEntry(2, '3-4: Leve, puedo continuar actividades'),
    const MapEntry(3, '5-6: Moderado, dificulta movimiento'),
    const MapEntry(4, '7-8: Fuerte, limita actividades diarias'),
    const MapEntry(5, '9-10: Severo, insoportable'),
  ];

  bool get isFormValid =>
      selectedIntensity != null && selectedPainTypes.isNotEmpty;

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
              'Describe tu dolor',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Paso 3 de 6',
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

              // Pregunta 1: Intensidad del dolor
              _buildQuestion('¿Qué tan intenso es el dolor del 1 al 10?'),
              const SizedBox(height: 12),
              ..._buildIntensityButtons(),
              const SizedBox(height: 24),

              // Pregunta 2: Tipo de dolor
              _buildQuestion('¿Cómo describes el tipo de dolor?'),
              const SizedBox(height: 12),
              ..._buildCheckboxOptions(painTypes, selectedPainTypes, (value) {
                setState(() {
                  if (selectedPainTypes.contains(value)) {
                    selectedPainTypes.remove(value);
                  } else {
                    selectedPainTypes.add(value);
                  }
                });
              }),
              const SizedBox(height: 24),

              // Pregunta 3: Factores que empeoran
              _buildQuestion('¿El dolor empeora con...?'),
              const SizedBox(height: 12),
              ..._buildCheckboxOptions(
                  triggerFactors, selectedTriggerFactors, (value) {
                setState(() {
                  if (selectedTriggerFactors.contains(value)) {
                    selectedTriggerFactors.remove(value);
                  } else {
                    selectedTriggerFactors.add(value);
                  }
                });
              }),

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
        value: 3 / 6,
        minHeight: 6,
        backgroundColor: Colors.grey[700],
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00FFFF)),
      ),
    );
  }

  Widget _buildQuestion(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  List<Widget> _buildIntensityButtons() {
    return intensityLevels
        .asMap()
        .entries
        .map((entry) {
          final intensity = entry.value.key;
          final label = entry.value.value;
          final isSelected = selectedIntensity == intensity;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => setState(() => selectedIntensity = intensity),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF00FFFF)
                      : Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF00FFFF)
                        : Colors.grey[700]!,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF00FFFF)
                              : Colors.grey[600]!,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                color: Color(0xFF00FFFF),
                                size: 14,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
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

  List<Widget> _buildCheckboxOptions(
    List<String> options,
    Set<String> selected,
    Function(String) onToggle,
  ) {
    return options
        .map((option) {
          final isSelected = selected.contains(option);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => onToggle(option),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF00FFFF).withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF00FFFF)
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
                              ? const Color(0xFF00FFFF)
                              : Colors.grey[600]!,
                          width: 2,
                        ),
                        color: isSelected
                            ? const Color(0xFF00FFFF)
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.black,
                                size: 14,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
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
                    service.painIntensity = selectedIntensity;
                    service.painTypes = selectedPainTypes.toList();
                    service.painTriggers = selectedTriggerFactors.toList();

                    context.read<InjuryPainBloc>().add(
                          SaveInjuryPainEvent(
                            intensity: selectedIntensity!,
                            painTypes: selectedPainTypes.toList(),
                            triggerFactors: selectedTriggerFactors.toList(),
                          ),
                        );
                    Navigator.of(context)
                        .pushNamed('/injury_functional_capacity');
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
