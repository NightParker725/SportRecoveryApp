import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/injury_mechanism_bloc.dart';

class InjuryMechanismScreen extends StatefulWidget {
  const InjuryMechanismScreen({Key? key}) : super(key: key);

  @override
  State<InjuryMechanismScreen> createState() => _InjuryMechanismScreenState();
}

class _InjuryMechanismScreenState extends State<InjuryMechanismScreen> {
  String? selectedTiming;
  String? selectedMechanism;
  String? selectedPopping;
  String? selectedFrequency;

  final List<String> timings = [
    'Ahora mismo (menos de 1 hora)',
    'Hace algunas horas (1-6 horas)',
    'Ayer',
    'Hace varios días',
    'Hace más de una semana',
  ];

  final List<String> mechanisms = [
    'Caída',
    'Torsión/Movimiento repentino',
    'Impacto directo',
    'Sobreuso repetitivo',
    'Movimiento forzado',
    'No estoy seguro',
  ];

  final List<String> poppingOptions = ['Sí', 'No', 'No estoy seguro'];

  final List<String> frequencies = [
    'Primera vez',
    'Ya había pasado antes',
    'Es recurrente',
  ];

  bool get isFormValid =>
      selectedTiming != null &&
      selectedMechanism != null &&
      selectedPopping != null &&
      selectedFrequency != null;

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
              '¿Cómo y cuándo ocurrió?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Paso 2 de 6',
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

              // Pregunta 1: Timing
              _buildQuestion('¿Cuándo ocurrió la lesión?'),
              const SizedBox(height: 12),
              ..._buildOptionButtons(timings, selectedTiming, (value) {
                setState(() => selectedTiming = value);
              }),
              const SizedBox(height: 24),

              // Pregunta 2: Mechanism
              _buildQuestion('¿Cómo ocurrió exactamente?'),
              const SizedBox(height: 12),
              ..._buildOptionButtons(mechanisms, selectedMechanism, (value) {
                setState(() => selectedMechanism = value);
              }),
              const SizedBox(height: 24),

              // Pregunta 3: Popping
              _buildQuestion(
                  '¿Escuchaste o sentiste un "pop" o chasquido?'),
              const SizedBox(height: 12),
              ..._buildOptionButtons(poppingOptions, selectedPopping, (value) {
                setState(() => selectedPopping = value);
              }),
              const SizedBox(height: 24),

              // Pregunta 4: Frequency
              _buildQuestion('¿Has tenido esta molestia antes?'),
              const SizedBox(height: 12),
              ..._buildOptionButtons(frequencies, selectedFrequency, (value) {
                setState(() => selectedFrequency = value);
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
        value: 2 / 6,
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
                    context.read<InjuryMechanismBloc>().add(
                          SaveInjuryMechanismEvent(
                            timing: selectedTiming!,
                            mechanism: selectedMechanism!,
                            hasPopping: selectedPopping == 'Sí',
                            frequency: selectedFrequency!,
                          ),
                        );
                    Navigator.of(context).pushNamed('/injury_pain');
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
