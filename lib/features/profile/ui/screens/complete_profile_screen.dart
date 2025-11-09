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
            TextFormField(
              controller: _preferredNameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre preferido'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _profilePictureCtrl,
              decoration: const InputDecoration(
                labelText: 'URL de la foto de perfil (opcional)',
              ),
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            ListTile(
              title: Text(
                _birthDate == null
                    ? 'Selecciona fecha de nacimiento'
                    : _birthDate!.toLocal().toString().split(' ')[0],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickDate,
              ),
            ),
            DropdownButtonFormField<String>(
              value: _sex,
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Masculino')),
                DropdownMenuItem(value: 'female', child: Text('Femenino')),
                DropdownMenuItem(value: 'other', child: Text('Otro')),
              ],
              onChanged: (v) => setState(() => _sex = v),
              decoration: const InputDecoration(labelText: 'Género'),
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            TextFormField(
              controller: _heightCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Altura (cm)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _weightCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Peso (kg)'),
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            TextFormField(
              controller: TextEditingController(text: _primaryActivity),
              onChanged: (v) => _primaryActivity = v,
              decoration: const InputDecoration(
                labelText: 'Actividad física principal',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: TextEditingController(text: _complementaryActivity),
              onChanged: (v) => _complementaryActivity = v,
              decoration: const InputDecoration(
                labelText: 'Actividad complementaria (opcional)',
              ),
            ),
          ],
        );
      case 4:
        return DropdownButtonFormField<String>(
          value: _activityFrequency,
          items: const [
            DropdownMenuItem(value: 'never', child: Text('Nunca')),
            DropdownMenuItem(value: '1_time_week', child: Text('1 vez/semana')),
            DropdownMenuItem(
              value: '2_times_week',
              child: Text('2 veces/semana'),
            ),
            DropdownMenuItem(
              value: '3_times_week',
              child: Text('3 veces/semana'),
            ),
            DropdownMenuItem(value: 'daily', child: Text('Diario')),
          ],
          onChanged: (v) => setState(() => _activityFrequency = v),
          decoration: const InputDecoration(
            labelText: 'Frecuencia de actividad física',
          ),
        );
      case 5:
        return Column(
          children: [
            ..._goalsOptions.map(
              (g) => CheckboxListTile(
                value: _selectedGoals.contains(g),
                title: Text(g),
                onChanged: (v) => setState(() {
                  if (v == true)
                    _selectedGoals.add(g);
                  else
                    _selectedGoals.remove(g);
                }),
              ),
            ),
            if (_selectedGoals.contains('Otros'))
              TextFormField(
                controller: _otherGoalCtrl,
                decoration: const InputDecoration(
                  labelText: 'Otros (especifica)',
                ),
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
            ),
          ],
        );
      case 7:
        return Column(
          children: [
            TextFormField(
              controller: _injuryTypeCtrl,
              decoration: const InputDecoration(labelText: 'Tipo de lesión'),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: Text(
                _injuryDate == null
                    ? 'Selecciona la fecha de la lesión'
                    : _injuryDate!.toLocal().toString().split(' ')[0],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickInjuryDate,
              ),
            ),
            DropdownButtonFormField<String>(
              value: _injuryStatus,
              items: const [
                DropdownMenuItem(
                  value: 'recovered',
                  child: Text('Totalmente recuperado'),
                ),
                DropdownMenuItem(
                  value: 'almost_recovered',
                  child: Text('Casi recuperado, molestias leves'),
                ),
                DropdownMenuItem(
                  value: 'in_recovery',
                  child: Text('En proceso de recuperación'),
                ),
                DropdownMenuItem(
                  value: 'not_recovered',
                  child: Text('Nunca me recuperé bien'),
                ),
              ],
              onChanged: (v) => setState(() => _injuryStatus = v),
              decoration: const InputDecoration(
                labelText: 'Estado de la lesión',
              ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _showIntro ? _buildIntro(context) : _buildStepper(context),
        ),
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¡Queremos conocerte!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          'Este paso es opcional, pero te ayudará a obtener recomendaciones más relevantes.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _start,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Comenzar'),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/my_profile'),
          icon: const Icon(Icons.exit_to_app),
          label: const Text('Volver al perfil'),
        ),
      ],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currentTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
                  onPressed: _next,
                  child: Text(isLast ? 'Enviar' : 'Siguiente'),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
