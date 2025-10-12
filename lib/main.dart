import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/auth/ui/bloc/signup_bloc.dart';
import 'package:moviles252/ui/screens/login_screen.dart';
import 'package:moviles252/ui/screens/profile_screen.dart';
import 'package:moviles252/features/auth/ui/screens/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviles252/features/auth/ui/bloc/login_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://badsghvoqgnepezakrmt.supabase.co',
    anonKey: 'sb_publishable_CnJibsSasgTs_BbFPshk8A_doYfZigk',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        '/login': (_) => BlocProvider(create: (_) => LoginBloc(), child: LoginScreen(),),
        '/profile': (_) => ProfileScreen(),
      },
    );
  }
}
