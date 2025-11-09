import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/checkin/ui/bloc/checkin_bloc.dart';

class CheckinFormScreen extends StatefulWidget {
  const CheckinFormScreen({super.key});

  @override
  State<CheckinFormScreen> createState() => _CheckinFormScreenState();
}

class _CheckinFormScreenState extends State<CheckinFormScreen> {
  // Intro
  bool _showIntro = true;

  double _introSlideValue = 8.0;
  double _introMaxWidth = 0.0;
  double _introButtonWidth = 120.0;

  void _onIntroDragUpdate(DragUpdateDetails d) {
    setState(() {
      _introSlideValue += d.delta.dx;
      double maxLimit = _introMaxWidth - _introButtonWidth - 8.0;
      if (_introSlideValue < 8.0) _introSlideValue = 8.0;
      if (_introSlideValue > maxLimit) _introSlideValue = maxLimit;
    });
  }

  void _onIntroDragEnd() {
    double maxLimit = _introMaxWidth - _introButtonWidth - 8.0;
    if (_introSlideValue >= maxLimit) {
      setState(() => _showIntro = false);
    } else {
      setState(() => _introSlideValue = 8.0);
    }
  }

  // Paso actual (1..6)
  int _step = 1;

  // Estado de respuestas
  double _q1 = 3;
  String? _q2; // ✅ ahora single choice
  String? _q3; // ✅ ahora single choice
  double _q4 = 3;
  final TextEditingController _q5Ctrl = TextEditingController();
  String? _q6;

  // Opciones
  final _q2Options = const [
    'Reposo total',
    'Actividad leve',
    'Actividad moderada',
    'Actividad plena',
    'La sobrecargué',
  ];

  final _q3Options = const [
    'Sí, completé todo',
    'Hice la mayoría',
    'No pude hacer casi nada',
    'No tenía tareas asignadas para hoy',
  ];

  final _q6Options = const [
    'Más artículos o tips sobre mi lesión',
    'Una rutina alternativa o ejercicios nuevos',
    'Ejercicios de relajación o manejo del estrés',
    'Información sobre cuándo consultar a un especialista',
    'Nada por ahora, estoy bien.',
  ];

  @override
  void dispose() {
    _q5Ctrl.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_step < 6) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _goBack() {
    if (_showIntro) {
      Navigator.pop(context);
      return;
    }
    if (_step > 1) {
      setState(() => _step--);
    } else {
      setState(() => _showIntro = true);
    }
  }

  void _start() {
    setState(() {
      _showIntro = false;
      _step = 1;
    });
  }

  void _submit() {
    context.read<CheckinBloc>().add(
      SubmitCheckinEvent(
        q1: _q1.round(),
        q2: _q2 ?? "",
        q3: _q3 ?? "",
        q4: _q4.round(),
        q5: _q5Ctrl.text.trim().isEmpty ? null : _q5Ctrl.text.trim(),
        q6: _q6 ?? 'Sin respuesta',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in de Hoy'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<CheckinBloc, CheckinState>(
        listener: (context, state) {
          if (state is CheckinSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('¡Check-in enviado!')));
            Navigator.pushReplacementNamed(context, '/my_profile');
          } else if (state is CheckinError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (_showIntro) return _buildIntro(context);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProgressHeader(),
                const SizedBox(height: 12),
                Expanded(child: _buildStep()),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: _goBack, child: const Text('Atrás')),
                    ElevatedButton(
                      onPressed: state is CheckinLoading ? null : _goNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00DFC1),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: state is CheckinLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_step == 6 ? 'Terminar' : 'Siguiente'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
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
              'assets/images/feel.jpg', // <= AQUÍ LA IMAGEN QUE ME PEDISTE
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
                  colors: [Colors.transparent, Colors.black.withOpacity(0.55)],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
          ),
          // Contenido inferior
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
                      '¿Cómo te sientes hoy?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Check–in de hoy. Tómate 1 minuto para contarnos cómo va tu recuperación.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),

                    // ***** SLIDER BUTTON *****
                    LayoutBuilder(
                      builder: (context, constraints) {
                        _introMaxWidth = constraints.maxWidth;

                        final maxLeftNow =
                            _introMaxWidth - _introButtonWidth - 8.0;
                        if (_introSlideValue > maxLeftNow && maxLeftNow > 8.0) {
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
                                  onHorizontalDragUpdate: (d) =>
                                      _onIntroDragUpdate(d),
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

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    const primary = Color(0xFF019193);
    final inactive = Colors.grey.shade300;
    final total = 6;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(total, (i) {
            final active = i < _step;
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
        const SizedBox(height: 8),
        Text(
          'Pregunta $_step',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 1:
        return _q1Step();
      case 2:
        return _q2Step();
      case 3:
        return _q3Step();
      case 4:
        return _q4Step();
      case 5:
        return _q5Step();
      case 6:
        return _q6Step();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _q1Step() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comparado con ayer, ¿cómo está tu dolor o molestia principal?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          'Selecciona en la escala de 1 a 5',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        Slider(
          value: _q1,
          min: 1,
          max: 5,
          divisions: 4,
          label: _q1.round().toString(),
          onChanged: (v) => setState(() => _q1 = v),
          activeColor: const Color(0xFF00DFC1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('1'),
            Text('2'),
            Text('3'),
            Text('4'),
            Text('5'),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(
              child: Text(
                'Desapareció',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              child: Text(
                'Mejoró',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              child: Text(
                'Igual',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              child: Text(
                'Peor',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              child: Text(
                'Mucho peor',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _q2Step() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('¿Cómo fue tu actividad hoy? (elige una)'),
        ..._q2Options.map(
          (o) => RadioListTile<String>(
            value: o,
            groupValue: _q2,
            onChanged: (v) => setState(() => _q2 = v),
            title: Text(o),
            activeColor: const Color(0xFF00DFC1),
          ),
        ),
      ],
    );
  }

  Widget _q3Step() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('¿Pudiste realizar tus ejercicios? (elige una)'),
        ..._q3Options.map(
          (o) => RadioListTile<String>(
            value: o,
            groupValue: _q3,
            onChanged: (v) => setState(() => _q3 = v),
            title: Text(o),
            activeColor: const Color(0xFF00DFC1),
          ),
        ),
      ],
    );
  }

  Widget _q4Step() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¿Cómo te sientes anímicamente con tu recuperación?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          'Selecciona en la escala de 1 a 5',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        Slider(
          value: _q4,
          min: 1,
          max: 5,
          divisions: 4,
          label: _q4.round().toString(),
          onChanged: (v) => setState(() => _q4 = v),
          activeColor: const Color(0xFF00DFC1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('1'),
            Text('2'),
            Text('3'),
            Text('4'),
            Text('5'),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(
              child: Text(
                'Frustrado',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              child: Text(
                'Desmotivado',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              child: Text(
                'Neutral',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              child: Text(
                'Motivado',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              child: Text(
                'Muy motivado',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _q5Step() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('¿Algo que quieras contarnos? (Opcional)'),
        const SizedBox(height: 8),
        TextField(
          controller: _q5Ctrl,
          minLines: 3,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'Ej: “Sentí menos dolor hoy”…',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _q6Step() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('¿Qué te gustaría recibir ahora? (elige una)'),
        ..._q6Options.map(
          (o) => RadioListTile<String>(
            value: o,
            groupValue: _q6,
            onChanged: (v) => setState(() => _q6 = v),
            title: Text(o),
            activeColor: const Color(0xFF00DFC1),
          ),
        ),
      ],
    );
  }
}
