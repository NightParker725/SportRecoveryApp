import 'package:flutter/material.dart';

class EncyclopediaScreen extends StatelessWidget {
  const EncyclopediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F242A),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Centro de\nConocimiento',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Aprende sobre lesiones, prevención y recuperación',
                    style: TextStyle(
                      color: Color(0xFFB0B5BA),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildOptionCard(
                    context,
                    title: 'Lesiones Comunes',
                    description: 'Información sobre tipos de lesiones deportivas',
                    icon: Icons.medical_information_outlined,
                    color: const Color(0xFF019193),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/education/common-injuries',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildOptionCard(
                    context,
                    title: 'Prevención',
                    description: 'Tips y consejos para prevenir lesiones',
                    icon: Icons.shield_outlined,
                    color: const Color(0xFF00C897),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/education/prevention-tips',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildOptionCard(
                    context,
                    title: 'Mitos y Realidades',
                    description: 'Descubre la verdad sobre lesiones deportivas',
                    icon: Icons.lightbulb_outline,
                    color: const Color(0xFFE67F0D),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/education/myths',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildOptionCard(
                    context,
                    title: 'Glosario Médico',
                    description: 'Términos médicos y sus definiciones',
                    icon: Icons.book_outlined,
                    color: const Color(0xFF9B59B6),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/education/glossary',
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildRecommendationCard(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2F36),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFFB0B5BA),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: color,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F3A3A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00CED1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00CED1).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.health_and_safety_outlined,
                  color: Color(0xFF00CED1),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recomendación Importante',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Consulta con un especialista',
                      style: const TextStyle(
                        color: Color(0xFF00CED1),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Recuerda que esta información es educativa. Para un diagnóstico certero y un plan de recuperación personalizado, es fundamental que consultes con un especialista médico o fisioterapeuta calificado.',
            style: TextStyle(
              color: Color(0xFFB0B5BA),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
