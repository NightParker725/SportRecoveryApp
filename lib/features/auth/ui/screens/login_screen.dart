import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/auth/ui/bloc/login_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';




class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 🔹 Fondo
            Positioned.fill(
              child: Image.asset(
                'assets/fondo.png',
                fit: BoxFit.cover,
              ),
            ),

            // 🔹 Capa oscura
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),

            // 🔹 Contenido desplazable
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 60,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // 🔹 Logo
                      Image.asset('assets/logo.png', height: 80),

                      const SizedBox(height: 30),

                      const Text(
                        '¡Hola de nuevo!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '¿Listo para continuar con tu recuperación?',
                        style: TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 30),

                      // 🔹 Usuario
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Usuario', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Introduce tu usuario',
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🔹 Contraseña
                      const Align(
                        alignment: Alignment.centerLeft,
                        child:
                        Text('Contraseña', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Introduce tu contraseña',
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          suffixIcon:
                          Icon(Icons.visibility_off, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 🔹 Recordarme y Olvidé contraseña
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() => rememberMe = value ?? false);
                                },
                                activeColor: const Color(0xFF00FFFF),
                              ),
                              const Text('Recuérdame',
                                  style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(color: Color(0xFF00FFFF)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // 🔹 Botón principal
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Empezar ahora',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // 🔹 Social login
                      const Text('Inicia sesión con',
                          style: TextStyle(color: Colors.white54)),
                      const SizedBox(height: 10),

                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        children: [
                          SignInButton(Buttons.Google, onPressed: () {}),
                          SignInButton(Buttons.Facebook, onPressed: () {}),
                          SignInButton(Buttons.Apple, onPressed: () {}),
                        ],
                      ),

                      const Spacer(),

                      // 🔹 Registro
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('¿Aún no tienes una cuenta?',
                              style: TextStyle(color: Colors.white70)),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'Regístrate',
                              style: TextStyle(color: Color(0xFF00FFFF)),
                            ),
                          ),
                        ],
                      ),
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
