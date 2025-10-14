import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/auth/ui/bloc/signup_bloc.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool _obscurePassword = true;

  Widget _formContent(bool loading) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(height: 20),
      const Text(
        'Crea tu cuenta',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Estamos para ayudarte en tu proceso de recuperación.\n¿Estás listo?',
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12, height: 1.4),
      ),
      const SizedBox(height: 30),

      // Nombre de usuario
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Nombre de usuario',
          style: TextStyle(
            color: Color(0xFFB0B0B0),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: nameController,
        decoration: const InputDecoration(
          hintText: 'Introduce tu usuario',
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

      // Correo
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

      // Contraseña
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
              color: Color(0xFFB0B0B0),
            ),
            onPressed: () => setState(() {
              _obscurePassword = !_obscurePassword;
            }),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),

      const SizedBox(height: 30),

      // Botón de registro
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: loading
              ? null
              : () {
                  context.read<SignupBloc>().add(
                    SubmmitSignupEvent(
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      password: passwordController.text,
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00FFFF),
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
                  "Empezar ahora",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),

      const SizedBox(height: 48),

      // Separador "Crea tu cuenta con"
      Row(
        children: [
          Expanded(child: Container(height: 1, color: Color(0xFF444444))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Crea tu cuenta con',
              style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
            ),
          ),
          Expanded(child: Container(height: 1, color: Color(0xFF444444))),
        ],
      ),

      const SizedBox(height: 24),

      // Botones de redes sociales CON IMÁGENES
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botón Google
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            child: Image.asset(
              'assets/images/google_logo.png', // Ruta de tu imagen de Google
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Botón Facebook
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            child: Image.asset(
              'assets/images/facebook_logo.png', // Ruta de tu imagen de Facebook
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Botón Apple
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            child: Image.asset(
              'assets/images/apple_logo.png', // Ruta de tu imagen de Apple
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      // Enlace para iniciar sesión
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¿Ya tienes una cuenta?',
            style: TextStyle(color: Color(0xFFB0B0B0)),
          ),
          TextButton(
            onPressed: loading
                ? null
                : () => Navigator.pushReplacementNamed(context, '/login'),
            child: const Text(
              'Inicia sesión',
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
        child: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccessState) {
              Navigator.pushReplacementNamed(context, '/login');
            } else if (state is SignupErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final loading = state is SignupLoadingState;
            return Stack(
              children: [
                // Fondo
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/signup/image_back.png',
                    fit: BoxFit.cover,
                  ),
                ),

                // Logo fuera del contenedor (sobre la imagen de fondo)
                Positioned(
                  top: 60,
                  left: 24, // Agregar padding izquierdo
                  child: Image.asset('assets/images/logo.png', width: 140),
                ),

                // Contenedor sólido para el formulario (comienza más abajo)
                Positioned(
                  top: 180, // Comienza después del logo
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
                      child: _formContent(loading),
                    ),
                  ),
                ),

                // Overlay de loading
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
