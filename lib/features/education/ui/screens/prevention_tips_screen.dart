import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/prevention_tips_bloc.dart';

class PreventionTipsScreen extends StatefulWidget {
  const PreventionTipsScreen({super.key});

  @override
  State<PreventionTipsScreen> createState() => _PreventionTipsScreenState();
}

class _PreventionTipsScreenState extends State<PreventionTipsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PreventionTipsBloc>().add(LoadPreventionTips());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F242A),
      body: SafeArea(
        child: BlocBuilder<PreventionTipsBloc, PreventionTipsState>(
          builder: (context, state) {
            if (state is PreventionTipsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00C897)),
                ),
              );
            } else if (state is PreventionTipsLoaded) {
              return Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF1F242A),
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Prevención',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Tips para evitar lesiones',
                                style: TextStyle(
                                  color: Color(0xFFB0B5BA),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: state.tips.length,
                      itemBuilder: (context, index) {
                        final tip = state.tips[index];
                        return PreventionTipCard(tip: tip);
                      },
                    ),
                  ),
                ],
              );
            } else if (state is PreventionTipsError) {
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
      ),
    );
  }
}

class PreventionTipCard extends StatefulWidget {
  final dynamic tip;

  const PreventionTipCard({required this.tip, super.key});

  @override
  State<PreventionTipCard> createState() => _PreventionTipCardState();
}

class _PreventionTipCardState extends State<PreventionTipCard> {
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
              widget.tip.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF00C897).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.tip.sport,
                style: const TextStyle(
                  color: Color(0xFF00C897),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
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
                _buildSection('Descripción', widget.tip.description),
                const SizedBox(height: 16),
                _buildBulletSection('Consejos', widget.tip.tips),
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
            color: Color(0xFF00C897),
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
            color: Color(0xFF00C897),
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
                        '✓ ',
                        style: TextStyle(
                          color: Color(0xFF00C897),
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
}
