import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/auth/ui/bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Widget _content() => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Iniciar Sesión",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            label: Text("Correo electrónico"),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            label: Text("Contraseña"),
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        _submitButton(),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
          child: const Text("¿No tienes cuenta? Regístrate"),
        ),
      ],
    ),
  );

  Widget _submitButton() => BlocBuilder<LoginBloc, LoginState>(
    builder: (context, state) {
      final isLoading = state is LoginLoadingState;
      return ElevatedButton(
        onPressed: isLoading
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
          minimumSize: const Size(double.infinity, 50),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text("Iniciar Sesión"),
      );
    },
  );

  Widget _dynamicContent() => BlocConsumer<LoginBloc, LoginState>(
    listener: (context, state) {
      if (state is LoginSuccessState) {
        Navigator.pushReplacementNamed(context, '/my_profile');
      } else if (state is LoginErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Error al iniciar sesión. Verifica tus credenciales.",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    },
    builder: (context, state) {
      if (state is LoginLoadingState)
        return const Center(child: CircularProgressIndicator());
      return _content();
    },
  );

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: SafeArea(child: _dynamicContent()));
}
