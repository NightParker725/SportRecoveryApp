import 'dart:math' as math;
import 'package:flutter/material.dart';

class PainMapScreen extends StatefulWidget {
  const PainMapScreen({super.key});

  @override
  State<PainMapScreen> createState() => _PainMapScreenState();
}

class _PainMapScreenState extends State<PainMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F242A),
      body: SafeArea(
        child: Column(
          children: [
            // Cuerpo fondo(despues añado los botones)
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

                    Positioned.fill(
                      child: Container(
                        color: Colors.white,
                        child: CustomPaint(
                          painter: _WavePainter(),
                          child: Container(),
                        ),
                      ),
                    ),

                    Positioned.fill(
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: Image.asset(
                            'assets/images/mapdolor/muscular.jpeg',
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                    // Título en la parte superior izquierda
                    Positioned(
                      top: 20,
                      left: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enciclopedia de',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'dolor',
                            style: const TextStyle(
                              color: Color(0xFF00CED1),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      bottom: 24,
                      right: 24,
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
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: const Text(
                          'Biblioteca',
                          style: TextStyle(
                            color: Color(0xFF00CED1),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
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

