import 'package:flutter/material.dart';

class EncyclopediaScreen extends StatelessWidget {
  const EncyclopediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enciclopedia'),
        backgroundColor: const Color(0xFF1F242A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Centro de Conocimiento',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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
                onTap: () => Navigator.pushNamed(
                  context,
                  '/education/myths',
                ),
              ),
              const SizedBox(height: 16),
              _buildOptionCard(
                context,
                title: 'Glosario',
                description: 'Términos médicos y sus definiciones',
                icon: Icons.book_outlined,
                onTap: () => Navigator.pushNamed(
                  context,
                  '/education/glossary',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2F36),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE67F0D),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE67F0D).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFE67F0D),
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
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFE67F0D),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
