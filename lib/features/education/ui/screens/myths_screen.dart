import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/myths_bloc.dart';

class MythsScreen extends StatefulWidget {
  const MythsScreen({super.key});

  @override
  State<MythsScreen> createState() => _MythsScreenState();
}

class _MythsScreenState extends State<MythsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MythsBloc>().add(LoadMyths());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mitos y Realidades'),
        backgroundColor: const Color(0xFF1F242A),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<MythsBloc, MythsState>(
        builder: (context, state) {
          if (state is MythsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE67F0D)),
              ),
            );
          } else if (state is MythsLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: state.myths.length,
              itemBuilder: (context, index) {
                final myth = state.myths[index];
                return MythCard(myth: myth);
              },
            );
          } else if (state is MythsError) {
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

class MythCard extends StatefulWidget {
  final dynamic myth;

  const MythCard({required this.myth, super.key});

  @override
  State<MythCard> createState() => _MythCardState();
}

class _MythCardState extends State<MythCard> {
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
            const Text(
              'Creencia errónea:',
              style: TextStyle(
                color: Color(0xFFE67F0D),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.myth.myth,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildComparisonBox(
                  title: 'Realidad científica',
                  content: widget.myth.reality,
                  backgroundColor: const Color(0xFF2A5F4A),
                  borderColor: const Color(0xFF4CAF50),
                ),
                const SizedBox(height: 16),
                _buildSection('Explicación', widget.myth.explanation),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonBox({
    required String title,
    required String content,
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.2),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: borderColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
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
}
