import 'package:flutter/material.dart';
import '/ui/widgets/bottom_navigation_bar.dart';

/// Pantalla genérica para mostrar información sobre una parte específica del cuerpo
class BodyPartScreen extends StatelessWidget {
  final String partKey;
  final String partName;

  const BodyPartScreen({
    super.key,
    required this.partKey,
    required this.partName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F242A),
      body: SafeArea(
        child: Column(
          children: [
            // Contenido principal
            Expanded(
              child: Stack(
                children: [
                  // Botón de volver en la esquina superior izquierda
                  Positioned(
                    top: 20,
                    left: 24,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
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
                  ),
                  // Contenido de la pantalla (por ahora vacío)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            partName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Información sobre $partName',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Barra de navegación inferior
            Container(
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF1F242A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
            const AppBottomNavigationBar(),
          ],
        ),
      ),
    );
  }
}

