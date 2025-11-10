import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double _slideValue = 8.0;
  double _slideMaxWidth = 0.0;
  double _buttonWidth = 120.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _slideValue += details.delta.dx;
      _slideValue = _slideValue.clamp(8.0, _slideMaxWidth - _buttonWidth);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_slideValue >= _slideMaxWidth - _buttonWidth - 8.0) {
      Navigator.pushReplacementNamed(context, '/signup');
    } else {
      setState(() {
        _slideValue = 8.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    _slideMaxWidth = screenWidth - 72; // 36 + 36 = 72 de padding horizontal

    return Scaffold(
      body: Stack(
        children: [
          // Fondo con imagen
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome/back_welcome.png',
              fit: BoxFit.cover,
            ),
          ),
          // Capa oscura para mejor contraste
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          // Contenido principal alineado abajo
          SafeArea(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: screenWidth,
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo
                    Image.asset('assets/images/logo.png', width: 200),
                    const SizedBox(height: 8),
                    // Descripción - CON LA VERSIÓN SOLICITADA
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: double.infinity,
                        child: const Text(
                          'Guía inmediata para el manejo de lesiones deportivas',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Botón deslizable - ahora ocupa el ancho disponible
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Color(0xFF31373F),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Stack(
                        children: [
                          // Fondo con >>>
                          Container(
                            width:
                            double.infinity, // También ocupa todo el ancho
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Text(
                                  '       > > > ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Botón deslizable con "Empezar"
                          AnimatedPositioned(
                            top: 8,
                            duration: const Duration(milliseconds: 200),
                            left: _slideValue,
                            child: GestureDetector(
                              onHorizontalDragUpdate: _onHorizontalDragUpdate,
                              onHorizontalDragEnd: _onHorizontalDragEnd,
                              child: Container(
                                width: _buttonWidth,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(35),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'Empezar',
                                    style: TextStyle(
                                      color: Color(0xFF31373F),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Texto de "¿Ya tienes cuenta?"
                    Row(
                      children: [
                        const Text(
                          '¿Ya tienes cuenta?',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              color: Colors.cyan,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}