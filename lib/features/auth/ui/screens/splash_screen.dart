import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/splash_bloc.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.microtask(() => context.read<SplashBloc>().add(CheckSessionEvent()));

    return BlocBuilder<SplashBloc, SplashState>(
      builder: (context, state) {
        // Navegaciones
        _handleNavigation(state, context);

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', width: 150, height: 150),
                  const SizedBox(height: 20),
                  if (state is SplashLoading || state is SplashInitial)
                    const CircularProgressIndicator(color: Colors.white),
                  if (state is SplashError)
                    const Text(
                      'Error al validar sesión',
                      style: TextStyle(color: Colors.white),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleNavigation(SplashState state, BuildContext context) {
    if (state is SplashLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/my_profile');
      });
    } else if (state is SplashLoggedOut) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/welcome');
      });
    }
  }
}
