import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesiones Comunes'),
        backgroundColor: const Color(0xFF1F242A),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CommonInjuriesBloc, CommonInjuriesState>(
        builder: (context, state) {
          if (state is CommonInjuriesLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE67F0D)),
              ),
            );
          } else if (state is CommonInjuriesLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: state.injuries.length,
              itemBuilder: (context, index) {
                final injury = state.injuries[index];
                return InjuryCard(injury: injury);
              },
            );
          } else if (state is CommonInjuriesError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFF2A2F36),
      child: ExpansionTile(
        onExpansionChanged: (expanded) {
          setState(() => _isExpanded = expanded);
        },
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
                color: Color(0xFFB0B5BA),
                fontSize: 12,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection('Descripción', widget.injury.description),
                const SizedBox(height: 16),
                _buildBulletSection('Causas', widget.injury.causes),
                const SizedBox(height: 16),
                _buildBulletSection('Síntomas', widget.injury.symptoms),
                const SizedBox(height: 16),
                _buildBulletSection(
                  'Recomendaciones',
                  widget.injury.recommendations,
                ),
                const SizedBox(height: 16),
                _buildInfoBox(
                  'Recuperación estimada: ${widget.injury.recoveryDays} días\nSeveridad: ${widget.injury.severity}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFE67F0D),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: Color(0xFFB0B5BA),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildBulletSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFE67F0D),
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
                      const Text(
                        '• ',
                        style: TextStyle(
                          color: Color(0xFFE67F0D),
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            color: Color(0xFFB0B5BA),
                            fontSize: 13,
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE67F0D).withOpacity(0.1),
        border: Border.all(
          color: const Color(0xFFE67F0D),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        content,
        style: const TextStyle(
          color: Color(0xFFE67F0D),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
