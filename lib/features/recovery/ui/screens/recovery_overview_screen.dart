import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../ui/bloc/recovery_bloc.dart';
import '../../domain/entities/recovery_phase.dart';
import '../../domain/entities/recovery_plan.dart';
import 'recovery_phase_screen.dart';

class RecoveryOverviewScreen extends StatefulWidget {
  const RecoveryOverviewScreen({super.key});

  @override
  State<RecoveryOverviewScreen> createState() => _RecoveryOverviewScreenState();
}

class _RecoveryOverviewScreenState extends State<RecoveryOverviewScreen> {
  static const phase1Color = Color(0xFFE87C38);
  static const phase2Color = Color(0xFFD3EE3D);
  static const phase3Color = Color(0xFF00DFC1);
  static const darkBg = Color(0xFF1F242A);
  static const greyBg = Color(0xFF37404C);

  bool _showMonth = false;
  DateTime _selectedDay = DateTime.now();

  List<RecoveryPhase> _phases = const [];
  RecoveryPlan? _plan;
  int _currentPhaseIndex1Based = 1;
  int _currentDayInPhase1Based = 1;

  @override
  void initState() {
    super.initState();
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid != null) {
      context.read<RecoveryBloc>().add(LoadRecoveryOverview(uid));
    }
  }

  int _totalDays() => _phases.fold(0, (s, p) => s + p.durationDays);

  int _daysCompletedTotal() {
    final before = _phases
        .where((p) => p.phaseIndex < _currentPhaseIndex1Based)
        .fold(0, (s, p) => s + p.durationDays);
    return before + _currentDayInPhase1Based.clamp(0, 1000);
  }

  Color _colorForPhaseIndex(int idx) {
    if (idx == 1) return phase1Color;
    if (idx == 2) return phase2Color;
    return phase3Color;
  }

  String _phaseDisplayLabel(int idx) {
    switch (idx) {
      case 1:
        return 'Recuperación';
      case 2:
        return 'Rehabilitación';
      case 3:
        return 'Prevención';
      default:
        return 'Fase $idx';
    }
  }

  int? _phaseForOffset(int offsetFromStart) {
    int acc = 0;
    for (final p in _phases) {
      final end = acc + p.durationDays;
      if (offsetFromStart >= acc && offsetFromStart < end) return p.phaseIndex;
      acc = end;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> _loadTodayTasks(String phaseId, int day) async {
    final db = Supabase.instance.client;
    final tasks = await db
        .from('recovery_tasks')
        .select()
        .eq('phase_id', phaseId)
        .eq('day_index', day)
        .order('created_at');
    return (tasks as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<Set<String>> _loadCompletedTaskIds(String planId) async {
    final db = Supabase.instance.client;
    final rows = await db
        .from('recovery_task_completions')
        .select('task_id')
        .eq('plan_id', planId);
    return (rows as List).map((e) => e['task_id'] as String).toSet();
  }

  Future<void> _toggleTaskCompletion(String planId, String taskId, bool nowChecked) async {
    final db = Supabase.instance.client;
    if (nowChecked) {
      await db.from('recovery_task_completions').insert({
        'plan_id': planId,
        'task_id': taskId,
      });
    } else {
      await db
          .from('recovery_task_completions')
          .delete()
          .eq('plan_id', planId)
          .eq('task_id', taskId);
    }
    setState(() {});
  }

  // ---------- UI Pieces ----------
  Widget _weekStrip(DateTime startOfWeek) {
    final days = List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
    final start = DateTime(_plan!.createdAt.year, _plan!.createdAt.month, _plan!.createdAt.day);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final d in days) _dayCell(d, start),
      ],
    );
  }

  Widget _dayCell(DateTime day, DateTime planStart) {
    final onlyDate = DateTime(day.year, day.month, day.day);
    final now = DateTime.now();
    final todayOnly = DateTime(now.year, now.month, now.day);
    final selected = onlyDate == todayOnly;

    return Column(
      children: [
        Text(_weekdayShort(day.weekday), style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            '${day.day}',
            style: TextStyle(
              color: selected ? Colors.black : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _weekdayShort(int weekday) {
    const labels = ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa', 'Do'];
    return labels[(weekday - 1) % 7];
  }

  Widget _monthContinuationOverlay(DateTime startOfWeek) {
    final planStart = DateTime(_plan!.createdAt.year, _plan!.createdAt.month, _plan!.createdAt.day);
    final days = List.generate(28, (i) => startOfWeek.add(Duration(days: i))); // 4 filas
    final monthRef = startOfWeek.month;

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
      ),
      itemCount: days.length,
      itemBuilder: (_, i) {
        final date = days[i];
        final only = DateTime(date.year, date.month, date.day);
        final diff = only.difference(planStart).inDays;
        final phaseIdx = diff >= 0 ? _phaseForOffset(diff) : null;
        final baseColor = phaseIdx != null ? _colorForPhaseIndex(phaseIdx) : Colors.white54;
        final color = (date.month == monthRef) ? baseColor : Colors.white38;
        final now = DateTime.now();
        final todayOnly = DateTime(now.year, now.month, now.day);
        final selected = only == todayOnly;
        return Container(
          alignment: Alignment.center,
          child: Text(
            '${date.day}',
            style: TextStyle(
              color: selected ? Colors.white : color,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }

  Widget _headerCalendar(RecoveryPhase currentPhase, DateTime monday) {
    final color = _colorForPhaseIndex(currentPhase.phaseIndex);
    return Container(
      decoration: BoxDecoration(
        color: darkBg,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('Fase ', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('${currentPhase.phaseIndex}:', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                  SizedBox(width: 8),
                  Text(
                    '${_phaseDisplayLabel(currentPhase.phaseIndex)} ',
                    style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => setState(() => _showMonth = !_showMonth),
                color: Colors.white,
                icon: Icon(_showMonth ? Icons.expand_less : Icons.expand_more),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (!_showMonth) _weekStrip(monday),
          if (_showMonth) _monthContinuationOverlay(monday),
        ],
      ),
    );
  }

  Widget _progressRing() {
    final total = _totalDays();
    final done = _daysCompletedTotal().clamp(0, total);
    final percent = total == 0 ? 0.0 : done / total;

    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: CustomPaint(
              size: const Size.square(180),
              painter: _ProgressRingPainter(
                percent: percent,
                progressColor: _colorForPhaseIndex(_currentPhaseIndex1Based),
                trackColor: Colors.grey.shade200,
                strokeWidth: 18,
              ),
            ),
          ),
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$done días', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                Text(' / $total días', style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _phaseCard(RecoveryPhase current) {
    final color = _colorForPhaseIndex(current.phaseIndex);
    final start = _plan!.createdAt;
    final endOfPhase = _phases
        .where((p) => p.phaseIndex <= current.phaseIndex)
        .fold<DateTime>(start, (date, p) => date.add(Duration(days: p.durationDays)));
    final remaining = endOfPhase.difference(DateTime.now());
    final timeLeft = remaining.isNegative
        ? '00:00:00'
        : '${remaining.inHours.remainder(100).toString().padLeft(2, '0')}:${remaining.inMinutes.remainder(60).toString().padLeft(2, '0')}:${remaining.inSeconds.remainder(60).toString().padLeft(2, '0')}'
        ;

    final cardWidth = MediaQuery.of(context).size.width * 0.8;

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: cardWidth,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: const Color(0xFF37404C), borderRadius: BorderRadius.circular(20)),
          child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fase ${current.phaseIndex}', style: const TextStyle(color: Color(0xFFA2A2A2), fontWeight: FontWeight.w400)),
                  const SizedBox(height: 4),
                  Text('${_currentDayInPhase1Based}/${current.durationDays} días', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Container(
              width: 4,
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF00DFC1),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Siguiente fase', style: TextStyle(color: Color(0xFFA2A2A2), fontWeight: FontWeight.w400)),
                  const SizedBox(height: 4),
                  Text(timeLeft, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Recuperación')),
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
                child: Center(
                child: Image.asset(
                  'assets/images/recovery/recovery_back.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                ),
            ),
          ),
          BlocBuilder<RecoveryBloc, RecoveryState>(
            builder: (context, state) {
              if (state is RecoveryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RecoveryError) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is RecoveryLoaded) {
                final injury = state.injury;
                _plan = state.plan;
                _phases = state.phases..sort((a, b) => a.phaseIndex.compareTo(b.phaseIndex));
                final progress = state.progress;

                if (injury == null || _plan == null) {
                  return const Center(child: Text('No hay lesión activa o plan.'));
                }

                _currentPhaseIndex1Based = progress?.currentPhase ?? 1;
                _currentDayInPhase1Based = progress?.currentDay ?? 1;

                final today = DateTime.now();
                final monday = today.subtract(Duration(days: (today.weekday - 1)));

                final cpIdx = _phases.indexWhere((p) => p.phaseIndex == _currentPhaseIndex1Based);
                final currentPhase = cpIdx >= 0 ? _phases[cpIdx] : _phases.first;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _headerCalendar(currentPhase, monday),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Mi progreso',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(child: _progressRing()),
                          ],
                        ),
                      ),

                      const SizedBox(height: 60),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: darkBg,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(28, 64, 28, 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: greyBg,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 28,
                                            height: 28,
                                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                            child: const Icon(Icons.checklist_outlined, color: Colors.black87, size: 18),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('Tareas de hoy', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      FutureBuilder<List<Map<String, dynamic>>>(
                                        future: _loadTodayTasks(currentPhase.id, _currentDayInPhase1Based),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Center(child: CircularProgressIndicator());
                                          }
                                          final tasks = snapshot.data!;
                                          if (tasks.isEmpty) {
                                            return const Text('No hay tareas asignadas para hoy.', style: TextStyle(color: Colors.white70));
                                          }
                                          return FutureBuilder<Set<String>>(
                                            future: _loadCompletedTaskIds(_plan!.id),
                                            builder: (context, completedSnap) {
                                              final completed = completedSnap.data ?? <String>{};
                                              return Column(
                                                children: tasks.map((t) {
                                                  final id = t['id'] as String;
                                                  final title = t['title'] as String? ?? '';
                                                  final desc = t['description'] as String? ?? '';
                                                  final checked = completed.contains(id);
                                                  return Container(
                                                    margin: const EdgeInsets.symmetric(vertical: 6),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Theme(
                                                          data: Theme.of(context).copyWith(
                                                            checkboxTheme: CheckboxThemeData(
                                                              side: const BorderSide(color: Color(0xFF00DFC1), width: 1),
                                                              fillColor: MaterialStateProperty.resolveWith((states) {
                                                                if (states.contains(MaterialState.selected)) return const Color(0xFF00DFC1);
                                                                return Colors.transparent;
                                                              }),
                                                              checkColor: MaterialStateProperty.all(Colors.white),
                                                            ),
                                                          ),
                                                          child: Checkbox(
                                                            value: checked,
                                                            onChanged: (v) => _toggleTaskCompletion(_plan!.id, id, v == true),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                                                              if (desc.isNotEmpty) ...[
                                                                const SizedBox(height: 4),
                                                                Text(desc, style: const TextStyle(color: Colors.white70)),
                                                              ],
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: greyBg,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                        child: const Icon(Icons.notifications_active_outlined, color: Colors.black87, size: 18),
                                      ),
                                      const SizedBox(width: 12),
                                      const Expanded(child: Text('Configurar recordatorios diarios', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))),
                                      TextButton(
                                        onPressed: () {},
                                        child: const Text('Configurar', style: TextStyle(color: Color(0xFF00DFC1), fontSize: 14, fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: greyBg,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                        child: const Icon(Icons.info_outline, color: Colors.black87, size: 18),
                                      ),
                                      const SizedBox(width: 12),
                                      const Expanded(child: Text('Conocer más de esta fase', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))),
                                      TextButton(
                                        onPressed: () {
                                          final phaseNamesArg = {
                                            for (final ph in _phases) ph.phaseIndex: ph.name,
                                          };
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => const RecoveryPhaseScreen(),
                                              settings: RouteSettings(arguments: {
                                                'planId': _plan!.id,
                                                'phaseId': currentPhase.id,
                                                'phaseIndex': currentPhase.phaseIndex,
                                                'phaseName': currentPhase.name,
                                                'phaseNames': phaseNamesArg,
                                              }),
                                            ),
                                          );
                                        },
                                        child: const Text('Abrir', style: TextStyle(color: Color(0xFF00DFC1), fontSize: 14, fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: -45,
                            left: 0,
                            right: 0,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: _phaseCard(currentPhase),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.percent,
    required this.progressColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double percent;
  final Color progressColor;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - strokeWidth / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final sweepAngle = 2 * math.pi * percent;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.percent != percent ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
