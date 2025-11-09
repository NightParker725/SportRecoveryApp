import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/profile/ui/bloc/complete_profile_bloc.dart';

class CompleteProfileScreen extends StatefulWidget {
  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  // Stepper state
  bool _showIntro = true;
  int _step = 0;

  // Intro slider state
  double _introSlideValue = 8.0;
  double _introMaxWidth = 0.0;
  double _introButtonWidth = 120.0;

  // Step 1
  final TextEditingController _preferredNameCtrl = TextEditingController();
  final TextEditingController _profilePictureCtrl = TextEditingController();

  // Step 2
  DateTime? _birthDate;
  String? _sex;

  // Step 3
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();

  // Step 4
  String? _primaryActivity;
  String? _complementaryActivity;

  // Step 5
  String? _activityFrequency;

  // Step 6
  final List<String> _goalsOptions = [
    'Prevenir lesiones',
    'Recuperarme de una lesión actual',
    'Aprender rutinas de calentamiento y estiramiento',
    'Gestionar un dolor crónico',
    'Otros',
  ];
  final Set<String> _selectedGoals = {};
  final TextEditingController _otherGoalCtrl = TextEditingController();

  // Step 7-8 injuries
  bool _hadInjuries = false;
  final TextEditingController _injuryTypeCtrl = TextEditingController();
  String? _injuryStatus;
  DateTime? _injuryDate;

  @override
  void dispose() {
    _preferredNameCtrl.dispose();
    _profilePictureCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _otherGoalCtrl.dispose();
    _injuryTypeCtrl.dispose();
    super.dispose();
  }

  // Input decoration style for white background with light gray stroke
  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDADADA), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDADADA), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF00DFC1), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(color: Color(0xFF666666), fontSize: 13),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required String display,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF666666), fontSize: 13),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDADADA), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(display, style: const TextStyle(color: Colors.black87)),
                const Icon(Icons.calendar_today, color: Color(0xFF666666)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioGroup({
    required String label,
    String? helper,
    required String? value,
    required List<MapEntry<String, String>> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(label),
        if (helper != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              helper,
              style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
            ),
          ),
        ...options.map(
          (opt) => RadioListTile<String>(
            value: opt.key,
            groupValue: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF00DFC1),
            contentPadding: EdgeInsets.zero,
            title: Text(
              opt.value,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            dense: true,
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _pickInjuryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _injuryDate = picked);
  }

  void _next() {
    final maxStep = _hadInjuries ? 7 : 6; // 0-based: steps 0..6 or 0..7
    if (_step < maxStep) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _back() {
    if (_step > 0)
      setState(() => _step--);
    else
      setState(() => _showIntro = true);
  }

  void _start() {
    setState(() {
      _showIntro = false;
      _step = 0;
    });
  }

  void _onIntroDragUpdate(DragUpdateDetails details) {
    setState(() {
      _introSlideValue += details.delta.dx;
      final maxLeft = _introMaxWidth - _introButtonWidth;
      final clampedMax = maxLeft < 8.0 ? 8.0 : maxLeft;
      if (_introSlideValue < 8.0) _introSlideValue = 8.0;
      if (_introSlideValue > clampedMax) _introSlideValue = clampedMax;
    });
  }

  void _onIntroDragEnd() {
    final maxLeft = _introMaxWidth - _introButtonWidth - 8.0;
    if (_introSlideValue >= maxLeft && maxLeft >= 8.0) {
      _start();
    } else {
      setState(() {
        _introSlideValue = 8.0;
      });
    }
  }

  void _submit() {
    final height = double.tryParse(_heightCtrl.text);
    final weight = double.tryParse(_weightCtrl.text);

    final goals = [..._selectedGoals];
    if (goals.contains('Otros') && _otherGoalCtrl.text.isNotEmpty) {
      goals.remove('Otros');
      goals.add(_otherGoalCtrl.text.trim());
    }

    Map<String, dynamic>? injuries;
    if (_hadInjuries) {
      injuries = {
        'injury_type': _injuryTypeCtrl.text.trim(),
        'injury_status': _injuryStatus,
        if (_injuryDate != null)
          'injury_date': _injuryDate!.toIso8601String().split('T').first,
      };
    }

    context.read<CompleteProfileBloc>().add(
      SubmitCompleteProfileEvent(
        preferredName: _preferredNameCtrl.text.trim().isEmpty
            ? null
            : _preferredNameCtrl.text.trim(),
        profilePicture: _profilePictureCtrl.text.trim().isEmpty
            ? null
            : _profilePictureCtrl.text.trim(),
        birthDate: _birthDate,
        sex: _sex,
        heightCm: height,
        weightKg: weight,
        primaryPhysicalActivity: _primaryActivity,
        complementaryPhysicalActivity: _complementaryActivity,
        physicalActivityFrequency: _activityFrequency,
        mainGoals: goals.isEmpty ? null : goals,
        injuriesLastYear: injuries,
      ),
    );
  }

  Widget _stepContent() {
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel('Nombre preferido'),
            TextFormField(
              controller: _preferredNameCtrl,
              decoration: _inputDecoration(hint: ''),
            ),
            const SizedBox(height: 12),
            _buildFieldLabel('URL de la foto de perfil (opcional)'),
            TextFormField(
              controller: _profilePictureCtrl,
              decoration: _inputDecoration(hint: ''),
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateField(
              label: 'Fecha de nacimiento',
              display: _birthDate == null
                  ? 'Selecciona fecha de nacimiento'
                  : _birthDate!.toLocal().toString().split(' ')[0],
              onPressed: _pickDate,
            ),
            const SizedBox(height: 12),
            _buildRadioGroup(
              label: 'Género',
              value: _sex,
              options: const [
                MapEntry('male', 'Masculino'),
                MapEntry('female', 'Femenino'),
                MapEntry('other', 'Otro'),
              ],
              onChanged: (v) => setState(() => _sex = v),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel('Altura (cm)'),
            TextFormField(
              controller: _heightCtrl,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(hint: ''),
            ),
            const SizedBox(height: 12),
            _buildFieldLabel('Peso (kg)'),
            TextFormField(
              controller: _weightCtrl,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(hint: ''),
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel('Actividad física principal'),
            TextFormField(
              controller: TextEditingController(text: _primaryActivity),
              onChanged: (v) => _primaryActivity = v,
              decoration: _inputDecoration(hint: ''),
            ),
            const SizedBox(height: 12),
            _buildFieldLabel('Actividad complementaria (opcional)'),
            TextFormField(
              controller: TextEditingController(text: _complementaryActivity),
              onChanged: (v) => _complementaryActivity = v,
              decoration: _inputDecoration(hint: ''),
            ),
          ],
        );
      case 4:
        return _buildRadioGroup(
          label: 'Frecuencia de actividad física',
          helper: 'Selecciona una sola opción.',
          value: _activityFrequency,
          options: const [
            MapEntry('daily', 'Todos los días'),
            MapEntry('3_times_week', '3-5 veces por semana'),
            MapEntry('2_times_week', '1-2 veces por semana'),
            MapEntry('never', 'Menos de una vez por semana'),
          ],
          onChanged: (v) => setState(() => _activityFrequency = v),
        );
      case 5:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._goalsOptions.map(
              (g) => CheckboxListTile(
                value: _selectedGoals.contains(g),
                title: Text(
                  g,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() {
                  if (v == true)
                    _selectedGoals.add(g);
                  else
                    _selectedGoals.remove(g);
                }),
              ),
            ),
            if (_selectedGoals.contains('Otros'))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Otros (especifica)'),
              TextFormField(
                controller: _otherGoalCtrl,
                decoration: _inputDecoration(hint: ''),
              ),
                ],
              ),
          ],
        );
      case 6:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text(
                '¿Has tenido lesiones relevantes en el último año?',
              ),
              value: _hadInjuries,
              onChanged: (v) => setState(() => _hadInjuries = v),
              activeColor: const Color(0xFF019193),
              activeTrackColor: const Color(0xFF019193).withOpacity(0.4),
            ),
          ],
        );
      case 7:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel('Tipo de lesión'),
            TextFormField(
              controller: _injuryTypeCtrl,
              decoration: _inputDecoration(hint: ''),
            ),
            const SizedBox(height: 12),
            _buildDateField(
              label: 'Fecha de la lesión',
              display: _injuryDate == null
                  ? 'Selecciona la fecha de la lesión'
                  : _injuryDate!.toLocal().toString().split(' ')[0],
              onPressed: _pickInjuryDate,
            ),
            const SizedBox(height: 12),
            _buildRadioGroup(
              label: 'Estado de la lesión',
              value: _injuryStatus,
              options: const [
                MapEntry('recovered', 'Totalmente recuperado'),
                MapEntry('almost_recovered', 'Casi recuperado, molestias leves'),
                MapEntry('in_recovery', 'En proceso de recuperación'),
                MapEntry('not_recovered', 'Nunca me recuperé bien'),
              ],
              onChanged: (v) => setState(() => _injuryStatus = v),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completa tu perfil'),
        // If we're on the intro screen allow the user to go back to profile
        leading: _showIntro
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/my_profile'),
              )
            : null,
      ),
      body: BlocListener<CompleteProfileBloc, CompleteProfileState>(
        listener: (context, state) {
          if (state is CompleteProfileSuccess) {
            Navigator.pushReplacementNamed(context, '/my_profile');
          } else if (state is CompleteProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: _showIntro ? _buildIntro(context) : _buildStepper(context),
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/signup/image_back.png',
              fit: BoxFit.cover,
            ),
          ),
          // Degradado para texto
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.55),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
          ),
          // Contenido inferior con textos y slider
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¡Queremos conocerte!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Este paso es opcional, pero te ayudará a obtener recomendaciones más relevantes.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    // Slider button (similar a welcome)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        _introMaxWidth = constraints.maxWidth;
                        // Asegurar posición válida si cambia el ancho
                        final maxLeftNow = _introMaxWidth - _introButtonWidth - 8.0;
                        if (maxLeftNow > 8.0 && _introSlideValue > maxLeftNow) {
                          _introSlideValue = maxLeftNow;
                        }
                        return Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFF31373F),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Stack(
                            children: [
                              const Positioned.fill(
                                child: Center(
                                  child: Text(
                                    '       > > > ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedPositioned(
                                top: 8,
                                duration: const Duration(milliseconds: 150),
                                left: _introSlideValue,
                                child: GestureDetector(
                                  onHorizontalDragUpdate: (d) => _onIntroDragUpdate(d),
                                  onHorizontalDragEnd: (_) => _onIntroDragEnd(),
                                  child: Container(
                                    width: _introButtonWidth,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(35),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Empezar',
                                        style: TextStyle(
                                          color: Color(0xFF31373F),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper(BuildContext context) {
    final titles = [
      'Configura tu perfil',
      '¿Cuál es tu género?',
      '¿Cuál es tu composición corporal?',
      '¿Cuál es tu actividad física principal?',
      '¿Con qué frecuencia sueles hacer actividad física?',
      '¿Cuáles son tus principales objetivos?',
      '¿Has tenido lesiones relevantes en el último año?',
      '¿Cómo fue la lesión?',
    ];

    final currentTitle = titles[_step];

    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepHeader(context, _step, currentTitle, titles.length),
            const SizedBox(height: 12),
            Expanded(child: SingleChildScrollView(child: _stepContent())),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: _back, child: const Text('Atrás')),
                BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
                  builder: (context, state) {
                    if (state is CompleteProfileLoading)
                      return const CircularProgressIndicator();
                    final isLast = _hadInjuries ? _step == 7 : _step == 6;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00DFC1),
                    foregroundColor: Colors.black,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  ),
                      onPressed: _next,
                      child: Text(isLast ? 'Enviar' : 'Siguiente'),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader(
    BuildContext context,
    int step,
    String title,
    int total,
  ) {
    // Stepper active color
    const primary = Color(0xFF019193);
    final inactive = Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress indicator - each step takes equal width
        Row(
          children: List.generate(total, (i) {
            final active = i <= step;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < total - 1 ? 4.0 : 0.0),
                height: 6,
                decoration: BoxDecoration(
                  color: active ? primary : inactive,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        // Question number small
        Text(
          'Pregunta ${step + 1}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        // Title
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
