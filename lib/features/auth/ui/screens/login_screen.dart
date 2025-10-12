import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/auth/ui/bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget content() => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Iniciar Sesión",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 32),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            label: Text("Correo electrónico"),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            label: Text("Contraseña"),
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        SizedBox(height: 24),
        submitButton(),
        SizedBox(height: 16),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/signup');
          },
          child: Text("¿No tienes cuenta? Regístrate"),
        ),
      ],
    ),
  );

  Widget submitButton() => BlocBuilder<LoginBloc, LoginState>(
    builder: (context, state) {
      bool isLoading = state is LoginLoadingState;
      
      return ElevatedButton(
        onPressed: isLoading ? null : () {
          context.read<LoginBloc>().add(
            SubmitLoginEvent(
              email: emailController.text,
              password: passwordController.text,
            ),
          );
        },
        child: isLoading 
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text("Iniciar Sesión"),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
        ),
      );
    },
  );

  Widget dynamicContent() => BlocConsumer<LoginBloc, LoginState>(
    listener: (context, state) {
      if (state is LoginSuccessState) {
        Navigator.pushReplacementNamed(context, '/profile');
      } else if (state is LoginErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al iniciar sesión. Verifica tus credenciales."),
            backgroundColor: Colors.red,
          ),
        );
      }
    },
    builder: (context, state) {
      if (state is LoginLoadingState) {
        return Center(child: CircularProgressIndicator());
      }
      return content();
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: dynamicContent(),
      ),
    );
  }
}