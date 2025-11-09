import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/injury_medical_context_bloc.dart';

class InjuryMedicalContextScreen extends StatefulWidget {
  const InjuryMedicalContextScreen({super.key});

  @override
  State<InjuryMedicalContextScreen> createState() =>
      _InjuryMedicalContextScreenState();
}

class _InjuryMedicalContextScreenState extends State<InjuryMedicalContextScreen> {
  String? selectedActivity;
  Set<String> selectedConditions = {};
  Set<String> selectedFactors = {};

  final List<String> activityTypes = [
    'Corriendo/Trotar',
    'Fútbol',
    'Baloncesto',
    'Ejercicio en gimnasio',
    'Ciclismo',
    'Natación',
    'Actividad diaria (no deportiva)',
    'Otro deporte',
  ];

  final List<String> preexistingConditions = [
    'Ninguna',
    'Artritis',
    'Diabetes',
    'Problemas óseos',
    'Problemas de coagulación',
    'Tomo medicamentos anticoagulantes',
  ];

  final List<String> additionalFactors = [
    'Entrenamiento sin calentamiento previo',
    'Estaba deshidratado/a',
    'Entrenamiento muy intenso recientemente',
    'Lesión previa en esta zona',
    'Ninguno aplica',
  ];

  bool get isFormValid =>
      selectedActivity != null && selectedConditions.isNotEmpty;

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
              'Información adicional',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Paso 6 de 6',
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

              // Pregunta 1: Activity type
              _buildQuestion('¿Qué actividad realizabas cuando ocurrió?'),
              const SizedBox(height: 12),
              ..._buildOptionButtons(activityTypes, selectedActivity, (value) {
                setState(() => selectedActivity = value);
              }),
              const SizedBox(height: 24),

              // Pregunta 2: Preexisting conditions
              _buildQuestion('¿Tienes condiciones médicas preexistentes?'),
              const SizedBox(height: 12),
              ..._buildCheckboxOptions(
                  preexistingConditions, selectedConditions, (value) {
                setState(() {
                  if (selectedConditions.contains(value)) {
                    selectedConditions.remove(value);
                  } else {
                    selectedConditions.add(value);
                  }
                });
              }),
              const SizedBox(height: 24),

              // Pregunta 3: Additional factors
              _buildQuestion('Factores adicionales:'),
              const SizedBox(height: 12),
              ..._buildCheckboxOptions(additionalFactors, selectedFactors, (value) {
                setState(() {
                  if (selectedFactors.contains(value)) {
                    selectedFactors.remove(value);
                  } else {
                    selectedFactors.add(value);
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
        value: 6 / 6,
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

  List<Widget> _buildOptionButtons(
    List<String> options,
    String? selected,
    Function(String) onSelect,
  ) {
    return options
        .map((option) {
          final isSelected = selected == option;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => onSelect(option),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? const Color(0xFF00FFFF)
                      : Colors.grey[800],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF00FFFF)
                          : Colors.grey[700]!,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
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
                    context.read<InjuryMedicalContextBloc>().add(
                          SaveMedicalContextEvent(
                            activityType: selectedActivity!,
                            preexistingConditions:
                                selectedConditions.toList(),
                            additionalFactors: selectedFactors.toList(),
                          ),
                        );
                    Navigator.of(context)
                        .pushNamed('/injury_assessment_summary');
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
              'FINALIZAR EVALUACIÓN',
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
