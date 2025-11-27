import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/interactive_body_map.dart';

class PainMapScreen extends StatelessWidget {
  const PainMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F242A),
      body: SafeArea(
        child: Column(
          children: [
            // Cuerpo fondo con el mapa interactivo
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    // Fondo con líneas onduladas
                    Positioned.fill(
                      child: Container(
                        color: Colors.white,
                        child: CustomPaint(
                          painter: _WavePainter(),
                          child: Container(),
                        ),
                      ),
                    ),
                    // Widget del mapa de dolor (debe estar antes del texto para que el texto esté encima)
                    Positioned.fill(
                      child: InteractiveBodyMap(
                        imagePath: 'assets/images/mapdolor/muscular.jpeg',
                        onBodyPartSelected: (partKey) {
                          // Navegar a la pantalla de afecciones de esa parte del cuerpo
                          Navigator.pushNamed(
                            context,
                            '/body_part/$partKey',
                          );
                        },
                      ),
                    ),
                    // Título en la parte superior izquierda (con IgnorePointer para no bloquear el mapa)
                    Positioned(
                      top: 8,
                      left: 24,
                      child: IgnorePointer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // "Enciclopedia" - grande, light blue
                            const Text(
                              'Enciclopedia',
                              style: TextStyle(
                                color: Color(0xFF00CED1), // Light blue
                                fontSize: 28,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.5,
                                height: 1.0,
                              ),
                            ),
                            // " de dolor" en la misma línea
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // " de " - más pequeño, light gray
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    'de',
                                    style: TextStyle(
                                      color: Colors.grey[500], // Light gray
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                                // "dolor" - grande, light blue con outline
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Capa de outline (fondo)
                                    Text(
                                      'dolor',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: -0.5,
                                        height: 1.0,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 2.5
                                          ..color = const Color(0xFF00CED1),
                                      ),
                                    ),
                                    // Capa de relleno (frente)
                                    const Text(
                                      'dolor',
                                      style: TextStyle(
                                        color: Color(0xFF00CED1), // Light blue
                                        fontSize: 28,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: -0.5,
                                        height: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Botón Biblioteca
                    Positioned(
                      bottom: 24,
                      right: 24,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/education');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF00CED1),
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: const Text(
                            'Biblioteca',
                            style: TextStyle(
                              color: Color(0xFF00CED1),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          
            Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1F242A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Selecciona la parte del cuerpo afectada. También podrás consultar por deporte o tipo de lesión en la ',
                      ),
                      TextSpan(
                        text: 'biblioteca',
                        style: const TextStyle(
                          color: Color(0xFF00CED1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Custom painter para las líneas onduladas de fondo
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00CED1).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Línea ondulada desde la parte inferior izquierda hacia arriba y derecha
    final path = Path();
    path.moveTo(0, size.height * 0.85);
    
    // Crear una curva suave ondulada
    for (double x = 0; x <= size.width; x += 1) {
      final progress = x / size.width;
      final y = size.height * 0.85 - 
          (size.height * 0.15) * progress * 
          (1 + 0.3 * math.sin(progress * math.pi * 2));
      path.lineTo(x, y);
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

