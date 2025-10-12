import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/auth/ui/bloc/signup_bloc.dart';
import 'package:moviles252/features/profile/ui/bloc/profile_bloc.dart';
import 'package:moviles252/features/auth/ui/screens/login_screen.dart';
import 'package:moviles252/features/profile/ui/screens/my_profile_page.dart';
import 'package:moviles252/features/profile/ui/screens/profile_screen.dart';
import 'package:moviles252/features/auth/ui/screens/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviles252/features/auth/ui/bloc/login_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zvdkojnqrtqkjjvnjwtl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp2ZGtvam5xcnRxa2pqdm5qd3RsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAyNjU0MzMsImV4cCI6MjA3NTg0MTQzM30.wPOliUVv-augZApkwYrQyx-nI6tLbm7ORAXlQHxlI1I',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/login',
      routes: {
        '/signup': (_) =>
            BlocProvider(create: (_) => SignupBloc(), child: SignupScreen()),
        '/login': (_) =>
            BlocProvider(create: (_) => LoginBloc(), child: LoginScreen()),
        '/my_profile': (_) => BlocProvider(
          create: (_) => ProfileBloc(),
          child: const MyProfilePage(),
        ),
        '/edit_profile': (_) => BlocProvider(
          create: (_) => ProfileBloc(),
          child: const ProfileScreen(),
        ),
      },
    );
  }
}
