import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../ui/theme/app_colors.dart';
import '../../data/services/injury_evaluation_service.dart';
import '../../domain/entities/associated_symptoms.dart';
import '../bloc/injury_functional_capacity_bloc.dart';
import '../bloc/injury_location_bloc.dart';
import '../bloc/injury_mechanism_bloc.dart';
import '../bloc/injury_medical_context_bloc.dart';
import '../bloc/injury_pain_bloc.dart';
import '../bloc/injury_symptoms_bloc.dart';

class InjuryEvaluationFormScreen extends StatefulWidget {
  const InjuryEvaluationFormScreen({super.key});

  @override
  State<InjuryEvaluationFormScreen> createState() =>
      _InjuryEvaluationFormScreenState();
}

class _InjuryEvaluationFormScreenState
    extends State<InjuryEvaluationFormScreen> {
  static const int _totalSteps = 6;
  int _step = 1;
  bool _showIntro = true;
  double _introSlideValue = 8.0;
  double _introMaxWidth = 0.0;
  final double _introButtonWidth = 120.0;

  // Step 1
  final TextEditingController _locationController = TextEditingController();

  // Step 2
  String? _selectedTiming;
  String? _selectedMechanism;
  String? _selectedPopping;
  String? _selectedFrequency;

  // Step 3
  int? _selectedIntensity;
  final Set<String> _selectedPainTypes = {};
  final Set<String> _selectedPainTriggers = {};

  // Step 4
  String? _selectedWeightBearing;
  final Set<String> _selectedActivities = {};
  String? _selectedStability;

  // Step 5
  final Set<String> _selectedSymptoms = {};

  // Step 6
  final TextEditingController _sportController = TextEditingController();
  final Set<String> _selectedConditions = {};
  final Set<String> _selectedFactors = {};

  final List<String> _timings = const [
    'Ahora mismo (menos de 1 hora)',
    'Hace algunas horas (1-6 horas)',
    'Ayer',
    'Hace varios días',
    'Hace más de una semana',
  ];

  final List<String> _mechanisms = const [
    'Caída',
    'Torsión/Movimiento repentino',
    'Impacto directo',
    'Sobreuso repetitivo',
    'Movimiento forzado',
    'No estoy seguro',
  ];

  final List<String> _poppingOptions = const ['Sí', 'No', 'No estoy seguro'];

  final List<String> _frequencies = const [
    'Primera vez',
    'Ya había pasado antes',
    'Es recurrente',
  ];

  final List<MapEntry<int, String>> _intensityLevels = const [
    MapEntry(1, '1-2: Muy leve, casi no molesta'),
    MapEntry(2, '3-4: Leve, puedo continuar actividades'),
    MapEntry(3, '5-6: Moderado, dificulta movimiento'),
    MapEntry(4, '7-8: Fuerte, limita actividades diarias'),
    MapEntry(5, '9-10: Severo, insoportable'),
  ];

  final List<String> _painTypes = const [
    'Agudo (como un pinchazo)',
    'Sordo (constante y profundo)',
    'Punzante (va y viene)',
    'Ardiente/Quemante',
    'Pulsátil (late como el corazón)',
  ];

  final List<String> _painTriggers = const [
    'Movimiento',
    'Reposo/Estar quieto',
    'Tacto/Presión',
    'Por las mañanas',
    'Por las noches',
  ];

  final List<String> _weightBearingOptions = const [
    'Sí, sin problemas',
    'Sí, pero con molestia',
    'Solo un poco, duele mucho',
    'No puedo moverla para nada',
  ];

  final List<String> _basicActivities = const [
    'Caminar normalmente',
    'Subir/bajar escaleras',
    'Levantar objetos ligeros',
    'Girar o rotar la zona',
    'Flexionar/extender',
    'Ninguna de las anteriores',
  ];

  final List<String> _stabilityOptions = const [
    'No, me siento estable',
    'Un poco inestable',
    'Muy inestable, como si fuera a ceder',
  ];

  final List<String> _preexistingConditions = const [
    'Ninguna',
    'Artritis',
    'Diabetes',
    'Problemas óseos',
    'Problemas de coagulación',
    'Tomo medicamentos anticoagulantes',
  ];

  final List<String> _additionalFactors = const [
    'Entrenamiento sin calentamiento previo',
    'Estaba deshidratado/a',
    'Entrenamiento muy intenso recientemente',
    'Lesión previa en esta zona',
    'Ninguno aplica',
  ];

  List<String> get _stepTitles => const [
        'Ubicación de la molestia',
        '¿Cómo y cuándo ocurrió?',
        'Describe tu dolor',
        'Impacto en tu movimiento',
        'Síntomas asociados',
        'Información adicional',
      ];

  double get _progress => _step / _totalSteps;

  bool get _hasCriticalSymptoms => _selectedSymptoms.any(
        (symptom) => AssociatedSymptoms.criticalSymptoms.contains(symptom),
      );

  bool get _canGoNext {
    switch (_step) {
      case 1:
        return _locationController.text.trim().isNotEmpty;
      case 2:
        return _selectedTiming != null &&
            _selectedMechanism != null &&
            _selectedPopping != null &&
            _selectedFrequency != null;
      case 3:
        return _selectedIntensity != null && _selectedPainTypes.isNotEmpty;
      case 4:
        return _selectedWeightBearing != null && _selectedStability != null;
      case 5:
        return _selectedSymptoms.isNotEmpty;
      case 6:
        return _sportController.text.trim().isNotEmpty &&
            _selectedConditions.isNotEmpty;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildFormBackground(
        title: 'Agrega tu lesión',
        child: _showIntro ? _buildIntroCard() : _buildStepperCard(),
      ),
    );
  }

  Widget _buildStepperCard() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressHeader(),
          const SizedBox(height: 16),
          Expanded(child: _buildStepContent()),
          const SizedBox(height: 16),
          _buildNavigation(),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/feel.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.75),
                ],
                stops: const [0.35, 1],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Agrega tu lesión',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Cuéntanos qué ocurrió para adaptar tu plan de recuperación.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  _buildIntroSlider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: _progress,
          minHeight: 6,
          backgroundColor: AppColors.lightChipGrey.withOpacity(0.4),
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Paso $_step de $_totalSteps',
          style: const TextStyle(
            color: AppColors.darkSurface,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _stepTitles[_step - 1],
          style: const TextStyle(
            color: AppColors.darkSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 1:
        return _buildScrollableStep(_buildLocationStep());
      case 2:
        return _buildScrollableStep(_buildMechanismStep());
      case 3:
        return _buildScrollableStep(_buildPainStep());
      case 4:
        return _buildScrollableStep(_buildFunctionStep());
      case 5:
        return _buildScrollableStep(_buildSymptomsStep());
      case 6:
        return _buildScrollableStep(_buildMedicalContextStep());
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildScrollableStep(Widget child) {
    return SingleChildScrollView(
      child: child,
    );
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('¿En qué zona sientes la molestia?'),
        const SizedBox(height: 12),
        TextField(
          controller: _locationController,
          decoration: _inputDecoration('Describe la zona, ej. rodilla derecha'),
        ),
      ],
    );
  }

  Widget _buildMechanismStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('¿Cuándo ocurrió la lesión?'),
        const SizedBox(height: 12),
        ..._timings.map(
          (option) => _buildRadioTile(
            label: option,
            isSelected: _selectedTiming == option,
            onTap: () => setState(() => _selectedTiming = option),
          ),
        ),
        const SizedBox(height: 24),
        _sectionLabel('¿Cómo ocurrió exactamente?'),
        const SizedBox(height: 12),
        ..._mechanisms.map(
          (option) => _buildRadioTile(
            label: option,
            isSelected: _selectedMechanism == option,
            onTap: () => setState(() => _selectedMechanism = option),
          ),
        ),
        const SizedBox(height: 24),
        _sectionLabel('¿Escuchaste o sentiste un pop o chasquido?'),
        const SizedBox(height: 12),
        ..._poppingOptions.map(
          (option) => _buildRadioTile(
            label: option,
            isSelected: _selectedPopping == option,
            onTap: () => setState(() => _selectedPopping = option),
          ),
        ),
        const SizedBox(height: 24),
        _sectionLabel('¿Has tenido esta molestia antes?'),
        const SizedBox(height: 12),
        ..._frequencies.map(
          (option) => _buildRadioTile(
            label: option,
            isSelected: _selectedFrequency == option,
            onTap: () => setState(() => _selectedFrequency = option),
          ),
        ),
      ],
    );
  }

  Widget _buildPainStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('¿Qué tan intenso es el dolor del 1 al 10?'),
        const SizedBox(height: 12),
        ..._intensityLevels.map(
          (entry) => _buildRadioTile(
            label: entry.value,
            isSelected: _selectedIntensity == entry.key,
            onTap: () => setState(() => _selectedIntensity = entry.key),
          ),
        ),
        const SizedBox(height: 24),
        _sectionLabel('¿Cómo describes el tipo de dolor?'),
        const SizedBox(height: 12),
        ..._painTypes.map(
          (option) => _buildCheckboxTile(
            label: option,
            isSelected: _selectedPainTypes.contains(option),
            onToggle: () {
              setState(() {
                if (_selectedPainTypes.contains(option)) {
                  _selectedPainTypes.remove(option);
                } else {
                  _selectedPainTypes.add(option);
                }
              });
            },
          ),
        ),
        const SizedBox(height: 24),
        _sectionLabel('¿El dolor empeora con...?'),
        const SizedBox(height: 12),
        ..._painTriggers.map(
          (option) => _buildCheckboxTile(
            label: option,
            isSelected: _selectedPainTriggers.contains(option),
            onToggle: () {
              setState(() {
                if (_selectedPainTriggers.contains(option)) {
                  _selectedPainTriggers.remove(option);
                } else {
                  _selectedPainTriggers.add(option);
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFunctionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(
          '¿Puedes poner peso o mover la zona sin dolor extremo?',
        ),
        const SizedBox(height: 12),
        ..._weightBearingOptions.map(
          (option) => _buildRadioTile(
            label: option,
            isSelected: _selectedWeightBearing == option,
            onTap: () => setState(() => _selectedWeightBearing = option),
          ),
        ),
        const SizedBox(height: 24),
        _sectionLabel('¿Puedes realizar actividades básicas?'),
        const SizedBox(height: 12),
        ..._basicActivities.map(
          (option) => _buildCheckboxTile(
            label: option,
            isSelected: _selectedActivities.contains(option),
            onToggle: () {
              setState(() {
                if (_selectedActivities.contains(option)) {
                  _selectedActivities.remove(option);
                } else {
                  _selectedActivities.add(option);
                }
              });
            },
          ),
        ),
        const SizedBox(height: 24),
        _sectionLabel('¿Sientes inestabilidad o debilidad?'),
        const SizedBox(height: 12),
        ..._stabilityOptions.map(
          (option) => _buildRadioTile(
            label: option,
            isSelected: _selectedStability == option,
            onTap: () => setState(() => _selectedStability = option),
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Marca todos los síntomas que presentas'),
        const SizedBox(height: 12),
        ...AssociatedSymptoms.validSymptoms.map(
          (symptom) {
            final isSelected = _selectedSymptoms.contains(symptom);
            final isCritical =
                AssociatedSymptoms.criticalSymptoms.contains(symptom);
            return _buildCheckboxTile(
              label: symptom,
              isSelected: isSelected,
              highlightColor:
                  isCritical ? Colors.redAccent : AppColors.primaryBlue,
              onToggle: () {
                setState(() {
                  if (isSelected) {
                    _selectedSymptoms.remove(symptom);
                  } else {
                    _selectedSymptoms.add(symptom);
                  }
                });
              },
              trailing: isCritical
                  ? const Icon(Icons.warning, color: Colors.redAccent, size: 16)
                  : null,
            );
          },
        ),
        if (_hasCriticalSymptoms)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent),
              ),
              child: const Text(
                'Detectamos síntomas que requieren atención médica inmediata. '
                'Te recomendamos consultar un especialista.',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMedicalContextStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('¿Qué deporte o actividad practicabas?'),
        const SizedBox(height: 12),
        TextField(
          controller: _sportController,
          decoration:
              _inputDecoration('Ej. fútbol, running, gimnasio, actividades diarias'),
        ),
        const SizedBox(height: 24),
        _sectionLabel('¿Tienes condiciones médicas preexistentes?'),
        const SizedBox(height: 12),
        ..._preexistingConditions.map(
          (option) => _buildCheckboxTile(
            label: option,
            isSelected: _selectedConditions.contains(option),
            onToggle: () {
              setState(() {
                if (_selectedConditions.contains(option)) {
                  _selectedConditions.remove(option);
                } else {
                  _selectedConditions.add(option);
                }
              });
            },
          ),
        ),
        const SizedBox(height: 24),
        _sectionLabel('Factores adicionales'),
        const SizedBox(height: 12),
        ..._additionalFactors.map(
          (option) => _buildCheckboxTile(
            label: option,
            isSelected: _selectedFactors.contains(option),
            onToggle: () {
              setState(() {
                if (_selectedFactors.contains(option)) {
                  _selectedFactors.remove(option);
                } else {
                  _selectedFactors.add(option);
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNavigation() {
    final isLast = _step == _totalSteps;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _handleBack,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.primaryBlue),
              foregroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: const Text('Atrás'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _canGoNext ? () => _handleNext(isLast) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: Text(isLast ? 'Finalizar' : 'Siguiente'),
          ),
        ),
      ],
    );
  }

  void _handleBack() {
    if (_showIntro) return;
    if (_step == 1) {
      setState(() {
        _showIntro = true;
        _introSlideValue = 8.0;
      });
      return;
    }
    setState(() => _step--);
  }

  void _handleNext(bool isLast) {
    final service = InjuryEvaluationService();
    switch (_step) {
      case 1:
        final location = _locationController.text.trim();
        service.location = location;
        service.side = 'N/D';
        context.read<InjuryLocationBloc>().add(
              SaveInjuryLocationEvent(
                location: location,
                side: 'N/D',
              ),
            );
        break;
      case 2:
        service.timing = _selectedTiming;
        service.mechanism = _selectedMechanism;
        service.hasPopping = _selectedPopping == 'Sí';
        service.frequency = _selectedFrequency;
        context.read<InjuryMechanismBloc>().add(
              SaveInjuryMechanismEvent(
                timing: _selectedTiming!,
                mechanism: _selectedMechanism!,
                hasPopping: _selectedPopping == 'Sí',
                frequency: _selectedFrequency!,
              ),
            );
        break;
      case 3:
        service.painIntensity = _selectedIntensity;
        service.painTypes = _selectedPainTypes.toList();
        service.painTriggers = _selectedPainTriggers.toList();
        context.read<InjuryPainBloc>().add(
              SaveInjuryPainEvent(
                intensity: _selectedIntensity!,
                painTypes: _selectedPainTypes.toList(),
                triggerFactors: _selectedPainTriggers.toList(),
              ),
            );
        break;
      case 4:
        service.weightBearingCapacity = _selectedWeightBearing;
        service.basicActivities = _selectedActivities.toList();
        service.stabilityLevel = _selectedStability;
        context.read<InjuryFunctionalCapacityBloc>().add(
              SaveFunctionalCapacityEvent(
                weightBearingCapacity: _selectedWeightBearing!,
                basicActivities: _selectedActivities.toList(),
                stabilityLevel: _selectedStability!,
              ),
            );
        break;
      case 5:
        service.symptoms = _selectedSymptoms.toList();
        service.hasCriticalSymptoms = _hasCriticalSymptoms;
        context.read<InjurySymptomsBloc>().add(
              SaveInjurySymptomsEvent(
                symptoms: _selectedSymptoms.toList(),
              ),
            );
        break;
      case 6:
        final activity = _sportController.text.trim();
        service.activityType = activity;
        service.preexistingConditions = _selectedConditions.toList();
        service.additionalFactors = _selectedFactors.toList();
        context.read<InjuryMedicalContextBloc>().add(
              SaveMedicalContextEvent(
                activityType: activity,
                preexistingConditions: _selectedConditions.toList(),
                additionalFactors: _selectedFactors.toList(),
              ),
            );
        break;
    }

    if (isLast) {
      Navigator.pushNamed(context, '/injury_assessment_summary');
    } else if (_step < _totalSteps) {
      setState(() => _step++);
    }
  }

  Widget _buildSectionLabelWithHelper(String text, {String? helper}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(text),
        if (helper != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              helper,
              style: const TextStyle(
                color: AppColors.greySurface,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRadioTile({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryBlue.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primaryBlue : AppColors.lightChipGrey,
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
                        ? AppColors.primaryBlue
                        : AppColors.lightChipGrey,
                    width: 2,
                  ),
                  color:
                      isSelected ? AppColors.primaryBlue : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.darkSurface.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxTile({
    required String label,
    required bool isSelected,
    required VoidCallback onToggle,
    Color highlightColor = AppColors.primaryBlue,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onToggle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color:
                isSelected ? highlightColor.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? highlightColor : AppColors.lightChipGrey,
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
                    color: isSelected ? highlightColor : AppColors.lightChipGrey,
                    width: 2,
                  ),
                  color: isSelected ? highlightColor : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.darkSurface.withOpacity(0.9),
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.darkSurface,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.lightChipGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.lightChipGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildIntroSlider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        _introMaxWidth = constraints.maxWidth;
        final maxLeft = _introMaxWidth - _introButtonWidth - 8.0;
        if (_introSlideValue > maxLeft && maxLeft > 8.0) {
          _introSlideValue = maxLeft;
        }
        return Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(35),
          ),
          child: Stack(
            children: [
              const Positioned.fill(
                child: Center(
                  child: Text(
                    '      >>>',
                    style: TextStyle(
                      color: Colors.white70,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 120),
                top: 8,
                left: _introSlideValue,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _introSlideValue += details.delta.dx;
                      if (_introSlideValue < 8) _introSlideValue = 8;
                      if (_introSlideValue > maxLeft) {
                        _introSlideValue = maxLeft;
                      }
                    });
                  },
                  onHorizontalDragEnd: (_) {
                    if (_introSlideValue >= maxLeft) {
                      setState(() => _showIntro = false);
                    } else {
                      setState(() => _introSlideValue = 8.0);
                    }
                  },
                  child: Container(
                    width: _introButtonWidth,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Empezar',
                      style: TextStyle(
                        color: AppColors.darkSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormBackground({
    required String title,
    required Widget child,
  }) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/recovery/recovery_back.png',
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 500,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: child,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _sportController.dispose();
    super.dispose();
  }
}

