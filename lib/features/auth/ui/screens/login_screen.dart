import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/auth/ui/bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _formContent(bool loading, BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(height: 20),
      const Text(
        '¡Hola de Nuevo!',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        '¿Listo para continuar con tu recuperacion?',
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12, height: 1.4),
      ),
      const SizedBox(height: 30),

      // Campo de correo
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Correo',
          style: TextStyle(
            color: Color(0xFFB0B0B0),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: 'Introduce tu correo',
          hintStyle: TextStyle(color: Color(0xFF666666)),
          filled: true,
          fillColor: Color(0xFF2A2A2A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(color: Colors.white),
      ),

      const SizedBox(height: 16),

      // Campo de contraseña
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Contraseña',
          style: TextStyle(
            color: Color(0xFFB0B0B0),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          hintText: 'Introduce tu contraseña',
          hintStyle: const TextStyle(color: Color(0xFF666666)),
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFFB0B0B0),
            ),
            onPressed: () => setState(() {
              _obscurePassword = !_obscurePassword;
            }),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(color: Colors.white),
      ),

      const SizedBox(height: 30),

      // Botón de inicio de sesión
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: loading
              ? null
              : () {
            context.read<LoginBloc>().add(
              SubmitLoginEvent(
                email: emailController.text.trim(),
                password: passwordController.text,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00FFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: loading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Text(
            "Iniciar sesión",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      const SizedBox(height: 48),
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
              const Text(
                'Recuérdame',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              // Aún no está implementada la recuperación de contraseña lol
            },
            child: const Text(
              '¿Olvidaste tu contraseña?',
              style: TextStyle(color: Color(0xFF00FFFF)),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),


      // Separador
      Row(
        children: [
          Expanded(child: Container(height: 1, color: Color(0xFF444444))),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'O Inicia sesion con',
              style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
            ),
          ),
          Expanded(child: Container(height: 1, color: Color(0xFF444444))),
        ],
      ),

      const SizedBox(height: 24),

      // Botones sociales
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            child: Image.asset('assets/images/google_logo.png'),
          ),
          const SizedBox(width: 16),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            child: Image.asset('assets/images/facebook_logo.png'),
          ),
          const SizedBox(width: 16),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            child: Image.asset('assets/images/apple_logo.png'),
          ),
        ],
      ),

      const SizedBox(height: 16),

      // Ir a registro
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¿Aun no tienes una cuenta?',
            style: TextStyle(color: Color(0xFFB0B0B0)),
          ),
          TextButton(
            onPressed: loading
                ? null
                : () => Navigator.pushReplacementNamed(context, '/register'),
            child: const Text(
              'Regístrate',
              style: TextStyle(
                color: Color(0xFF00FFFF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            final loading = state is LoginLoadingState;

            if (state is LoginSuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, '/my_profile');
              });
            } else if (state is LoginErrorState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Error al iniciar sesión. Intenta nuevamente."),
                    backgroundColor: Colors.red,
                  ),
                );
              });
            }

            return Stack(
              children: [
                // Fondo
                Positioned.fill(
                  child: Image.asset(
                    'assets/signup/image_back.png',
                    fit: BoxFit.cover,
                  ),
                ),

                // Logo superior
                Positioned(
                  top: 60,
                  left: 24,
                  child: Image.asset('assets/images/logo.png', width: 140),
                ),

                // Contenedor curvado con formulario
                Positioned(
                  top: 210,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1F242A),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: _formContent(loading, context),
                    ),
                  ),
                ),

                // Capa de carga
                if (loading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black45,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00FFFF),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
