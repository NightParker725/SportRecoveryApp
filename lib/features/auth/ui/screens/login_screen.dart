import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:moviles252/features/auth/ui/bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool rememberMe = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState?.validate() != true) return;

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    context.read<LoginBloc>().add(
      SubmitLoginEvent(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('¡Bienvenido, ${state.profile.name}!')),
            );
            Navigator.pushNamedAndRemoveUntil(context, '/edit_profile', (route) => false);
          } else if (state is LoginErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error al iniciar sesión. Revisa tus credenciales.'),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoadingState;

          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  // Fondo
                  Positioned.fill(
                    child: Image.asset(
                      'assets/fondo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Capa oscura
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  // Contenido
                  SingleChildScrollView(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 60,
                      ),
                      child: IntrinsicHeight(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('assets/logo.png', height: 80),
                              ),
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

                              // Email (Usuario)
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Usuario (email)',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  final v = value?.trim() ?? '';
                                  if (v.isEmpty) return 'Ingresa tu email';
                                  final emailRegex = RegExp(
                                      r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
                                  if (!emailRegex.hasMatch(v)) {
                                    return 'Email inválido';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Introduce tu email',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Color(0xFF1E1E1E),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),

                              const SizedBox(height: 16),

                              // Contraseña
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Contraseña',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordCtrl,
                                obscureText: _obscurePassword,
                                validator: (value) {
                                  if ((value ?? '').isEmpty) {
                                    return 'Ingresa tu contraseña';
                                  }
                                  if ((value ?? '').length < 6) {
                                    return 'La contraseña debe tener al menos 6 caracteres';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Introduce tu contraseña',
                                  hintStyle:
                                  const TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: const Color(0xFF1E1E1E),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    }),
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),

                              const SizedBox(height: 10),

                              // Recordarme y Olvidé contraseña
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: rememberMe,
                                        onChanged: (value) {
                                          setState(() => rememberMe =
                                              value ?? false);

                                        },
                                        activeColor: const Color(0xFF00FFFF),
                                      ),
                                      const Text('Recuérdame',
                                          style: TextStyle(
                                              color: Colors.white70)),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                    //aun no está implementada la recuperacion de contraseña lol
                                    },
                                    child: const Text(
                                      '¿Olvidaste tu contraseña?',
                                      style: TextStyle(color: Color(0xFF00FFFF)),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),


                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => _onLoginPressed(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade800,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                  ),
                                  child: Text(
                                    isLoading
                                        ? 'Iniciando...'
                                        : 'Empezar ahora',
                                    style: const TextStyle(
                                        color: Colors.white70),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 25),

                              const Text('Inicia sesión con',
                                  style: TextStyle(color: Colors.white54)),
                              const SizedBox(height: 10),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8,
                                children: [
                                  SignInButton(Buttons.Google,
                                      onPressed: () {

                                      }),
                                  SignInButton(Buttons.Facebook,
                                      onPressed: () {}),
                                  SignInButton(Buttons.Apple,
                                      onPressed: () {}),
                                ],
                              ),

                              const Spacer(),

                              // Registro
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('¿Aún no tienes una cuenta?',
                                      style:
                                      TextStyle(color: Colors.white70)),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/signup');
                                    },
                                    child: const Text(
                                      'Regístrate',
                                      style: TextStyle(
                                          color: Color(0xFF00FFFF)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Overlay de loading
                  if (isLoading)
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
              ),
            ),
          );
        },
      ),
    );
  }
}