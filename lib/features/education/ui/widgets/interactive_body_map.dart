import 'package:flutter/material.dart';

/// Widget usado para hacer el mapa de puntos... puntos... puntos...
class InteractiveBodyMap extends StatefulWidget {
  final String imagePath;
  final Function(String bodyPart)? onBodyPartSelected;

  const InteractiveBodyMap({
    super.key,
    required this.imagePath,
    this.onBodyPartSelected,
  });

  @override
  State<InteractiveBodyMap> createState() => _InteractiveBodyMapState();
}

class _InteractiveBodyMapState extends State<InteractiveBodyMap> {
  String? _selectedBodyPart;
  Offset? _selectedPosition;

  // Definir las partes del cuerpo con coordenadas y tamaños absolutos
  final Map<String, Map<String, dynamic>> _bodyParts = {
    'cabeza': {
      'name': 'Cabeza',
      'left': 150.0,
      'top': 10.0,
      'width': 70.0,
      'height': 55.0,
    },
    'cuello': {
      'name': 'Cuello',
      'left': 160.0,
      'top': 65.0,
      'width': 50.0,
      'height': 30.0,
    },
    'hombro_izquierdo': {
      'name': 'Hombro',
      'left': 120.0,
      'top': 96.0,
      'width': 30.0,
      'height': 30.0,
    },
    'hombro_derecho': {
      'name': 'Hombro',
      'left': 225.0,
      'top': 96.0,
      'width': 30.0,
      'height': 30.0,
    },
    'pecho': {
      'name': 'Pecho',
      'left': 151.0,
      'top': 97.0,
      'width': 70.0,
      'height': 70.0,
    },
    'brazo_izquierdo': {
      'name': 'Brazo',
      'left': 95.0,
      'top': 127.0,
      'width': 35.0,
      'height': 150.0,
    },
    'brazo_derecho': {
      'name': 'Brazo',
      'left': 225.0,
      'top': 127.0,
      'width': 35.0,
      'height': 150.0,
    },
    'abdomen': {
      'name': 'Abdomen',
      'left': 151.0,
      'top': 170.0,
      'width': 73.0,
      'height': 60.0,
    },
    'cadera_izquierda': {
      'name': 'Cadera',
      'left': 150.0,
      'top': 227.0,
      'width': 85.0,
      'height': 30.0,
    },
    'muslo_izquierdo': {
      'name': 'Muslo',
      'left': 125.0,
      'top': 258.0,
      'width': 55.0,
      'height': 100.0,
    },
    'muslo_derecho': {
      'name': 'Muslo',
      'left': 181.0,
      'top': 258.0,
      'width': 55.0,
      'height': 100.0,
    },
    'rodilla_izquierda': {
      'name': 'Rodilla',
      'left': 140.0,
      'top': 359.0,
      'width': 50.0,
      'height': 30.0,
    },
    'rodilla_derecha': {
      'name': 'Rodilla',
      'left': 187.0,
      'top': 359.0,
      'width': 50.0,
      'height': 30.0,
    },
    'espinilla_izquierda': {
      'name': 'Espinilla',
      'left': 150.0,
      'top': 389.0,
      'width': 30.0,
      'height': 110.0,
    },
    'espinilla_derecha': {
      'name': 'Espinilla',
      'left': 187.0,
      'top': 389.0,
      'width': 30.0,
      'height': 110.0,
    },
  };


  void _onBodyPartTap(String partKey, double left, double top, double width, double height) {
    print('Body part tapped: $partKey');
    print('Position: left=$left, top=$top, width=$width, height=$height');
    setState(() {
      _selectedBodyPart = partKey;
      // Calcular el centro de la zona táctil
      _selectedPosition = Offset(left + (width / 2), top + (height / 2));
      print('Selected position: ${_selectedPosition}');
    });
    
    // NO llamar al callback aquí, solo mostrar el label
    // El callback se llamará cuando se toque el label
  }

  void _dismissSelection() {
    setState(() {
      _selectedBodyPart = null;
      _selectedPosition = null;
    });
  }

  void _onLabelTap(String partKey) {
    // Llamar al callback para navegar a la pantalla de afecciones
    // Esto se ejecuta cuando el usuario toca el label (segunda vez)
    print('Label tapped, navigating to: $partKey');
    widget.onBodyPartSelected?.call(partKey);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth;
        final containerHeight = constraints.maxHeight;

        return GestureDetector(
          // Capturar taps fuera de las áreas del cuerpo
          onTap: () {
            print('Tapped outside body parts');
            _dismissSelection();
          },
          child: Stack(
            children: [
              // Imagen del cuerpo que cubre todo el espacio
              Positioned.fill(
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              // Áreas táctiles sobre la imagen
              // Estas tienen prioridad porque están dentro del Stack
              ..._bodyParts.entries.map((entry) {
                final partKey = entry.key;
                final partData = entry.value;
                final left = (partData['left'] as num?)?.toDouble() ?? 0.0;
                final top = (partData['top'] as num?)?.toDouble() ?? 0.0;
                final width = (partData['width'] as num?)?.toDouble() ?? 0.0;
                final height = (partData['height'] as num?)?.toDouble() ?? 0.0;

                return Positioned(
                  left: left,
                  top: top,
                  width: width,
                  height: height,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      print('Tapped on body part: $partKey at ($left, $top)');
                      _onBodyPartTap(partKey, left, top, width, height);
                    },
                  child: Container(
                    color: Colors.transparent,
                  ),
                  ),
              );
            }),
            // Widget flotante con el nombre de la parte seleccionada
            if (_selectedBodyPart != null && _selectedPosition != null)
              _BodyPartLabel(
                name: _bodyParts[_selectedBodyPart!]!['name'] as String,
                position: _selectedPosition!,
                onTap: () => _onLabelTap(_selectedBodyPart!),
                onDismiss: _dismissSelection,
              ),
          ],
        ),
        );
      },
    );
  }
}

// Widget para mostrar el label de la parte del cuerpo seleccionada
class _BodyPartLabel extends StatelessWidget {
  final String name;
  final Offset position;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _BodyPartLabel({
    required this.name,
    required this.position,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLeftSide = position.dx < screenWidth / 2;

    // Calcular posición del label (arriba o abajo según la posición)
    final labelY = position.dy < screenHeight / 2 
        ? position.dy - 40  // Si está en la mitad superior, mostrar arriba
        : position.dy + 40; // Si está en la mitad inferior, mostrar abajo

    return Stack(
      children: [
        CustomPaint(
          size: Size(screenWidth, screenHeight),
          painter: _LabelLinePainter(
            startPoint: Offset(
              isLeftSide ? 24 : screenWidth - 24,
              labelY,
            ),
            endPoint: position,
          ),
        ),
        Positioned(
          left: isLeftSide ? 24 : null,
          right: isLeftSide ? null : 24,
          top: labelY - 15,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              print('Label tapped: $name');
              onTap();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF00CED1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LabelLinePainter extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;

  _LabelLinePainter({
    required this.startPoint,
    required this.endPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00CED1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);

    final controlPoint1 = Offset(
      startPoint.dx + (endPoint.dx - startPoint.dx) * 0.5,
      startPoint.dy,
    );
    final controlPoint2 = Offset(
      endPoint.dx - (endPoint.dx - startPoint.dx) * 0.3,
      endPoint.dy,
    );

    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint.dx,
      endPoint.dy,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

