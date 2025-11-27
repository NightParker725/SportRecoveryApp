import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/ui/theme/app_colors.dart';
import '../bloc/common_injuries_bloc.dart';

class CommonInjuriesScreen extends StatefulWidget {
  const CommonInjuriesScreen({super.key});

  @override
  State<CommonInjuriesScreen> createState() => _CommonInjuriesScreenState();
}

class _CommonInjuriesScreenState extends State<CommonInjuriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CommonInjuriesBloc>().add(LoadCommonInjuries());
  }

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF019193);
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          // Background with gradient
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      accent.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<CommonInjuriesBloc, CommonInjuriesState>(
            builder: (context, state) {
              if (state is CommonInjuriesLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF019193)),
                  ),
                );
              } else if (state is CommonInjuriesLoaded) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(top: topInset + kToolbarHeight + 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  const SizedBox(height: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Enciclopedia de',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: accent,
                                        ),
                                      ),
                                      const SizedBox(height: 0),
                                      const Text(
                                        'Lesiones Comunes',
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Información detallada sobre las lesiones musculoesqueléticas más frecuentes en el deporte.',
                              style: TextStyle(
                                color: Colors.black87,
                                height: 1.4,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Dark container with list
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 30,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Lesiones Comunes',
                              style: TextStyle(
                                color: AppColors.pureWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.injuries.length,
                              itemBuilder: (context, index) {
                                final injury = state.injuries[index];
                                return InjuryCard(injury: injury);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is CommonInjuriesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class InjuryCard extends StatefulWidget {
  final dynamic injury;

  const InjuryCard({required this.injury, super.key});

  @override
  State<InjuryCard> createState() => _InjuryCardState();
}

class _InjuryCardState extends State<InjuryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF019193);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.greySurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        onExpansionChanged: (expanded) {
          setState(() => _isExpanded = expanded);
        },
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.injury.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.injury.bodyLocation,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        children: [
          _buildSection('Descripción', widget.injury.description, accent),
          const SizedBox(height: 16),
          _buildBulletSection('Causas', widget.injury.causes, accent),
          const SizedBox(height: 16),
          _buildBulletSection('Síntomas', widget.injury.symptoms, accent),
          const SizedBox(height: 16),
          _buildBulletSection(
            'Recomendaciones',
            widget.injury.recommendations,
            accent,
          ),
          const SizedBox(height: 16),
          _buildInfoBox(
            'Recuperación estimada: ${widget.injury.recoveryDays} días\nSeveridad: ${widget.injury.severity}',
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: accent,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildBulletSection(String title, List<String> items, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: accent,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: TextStyle(
                          color: accent,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildInfoBox(String content) {
    final isSevere = content.contains('ALTO');
    final isMedium = content.contains('MEDIO');

    final Color boxColor = isSevere
        ? Colors.red
        : isMedium
            ? Colors.orange
            : Colors.green;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: boxColor.withOpacity(0.15),
        border: Border.all(
          color: boxColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        content,
        style: TextStyle(
          color: boxColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
