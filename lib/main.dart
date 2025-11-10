import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/auth/ui/bloc/signup_bloc.dart';
import 'package:moviles252/features/profile/ui/bloc/profile_bloc.dart';
import 'package:moviles252/features/auth/ui/screens/login_screen.dart';
import 'package:moviles252/features/profile/ui/screens/my_profile_page.dart';
import 'package:moviles252/features/profile/ui/screens/profile_screen.dart';
import 'package:moviles252/features/auth/ui/screens/signup_screen.dart';
import 'features/auth/ui/screens/splash_screen.dart';
import 'features/auth/ui/screens/welcome_screen.dart';
import 'features/auth/ui/bloc/splash_bloc.dart';
import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/domain/usecases/check_user_logged_in_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviles252/features/auth/ui/bloc/login_bloc.dart';
import 'features/injury/ui/screens/injury_location_screen.dart';
import 'features/injury/ui/screens/injury_mechanism_screen.dart';
import 'features/injury/ui/screens/injury_pain_screen.dart';
import 'features/injury/ui/screens/injury_functional_capacity_screen.dart';
import 'features/injury/ui/screens/injury_symptoms_screen.dart';
import 'features/injury/ui/screens/injury_medical_context_screen.dart';
import 'features/injury/ui/screens/injury_assessment_summary_screen.dart';
import 'features/injury/ui/bloc/injury_location_bloc.dart';
import 'features/injury/ui/bloc/injury_mechanism_bloc.dart';
import 'features/injury/ui/bloc/injury_pain_bloc.dart';
import 'features/injury/ui/bloc/injury_functional_capacity_bloc.dart';
import 'features/injury/ui/bloc/injury_symptoms_bloc.dart';
import 'features/injury/ui/bloc/injury_medical_context_bloc.dart';
import 'features/injury/ui/bloc/injury_assessment_bloc.dart';
import 'features/injury/domain/usecases/start_injury_evaluation_flow_usecase.dart';
import 'features/injury/data/repositories/injury_repository_impl.dart';
import 'features/injury/data/datasources/injury_data_source.dart';

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
      initialRoute: '/splash',
      routes: {
        '/welcome': (_) => WelcomeScreen(),
        '/splash': (_) => BlocProvider(
          create: (_) =>
              SplashBloc(CheckUserLoggedInUseCase(AuthRepositoryImpl())),
          child: SplashScreen(),
        ),
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
        // Rutas de evaluación de lesiones
        '/injury_location': (_) => BlocProvider(
          create: (_) => InjuryLocationBloc(),
          child: const InjuryLocationScreen(userId: 'fetch_from_auth'),
        ),
        '/injury_mechanism': (_) => BlocProvider(
          create: (_) => InjuryMechanismBloc(),
          child: const InjuryMechanismScreen(),
        ),
        '/injury_pain': (_) => BlocProvider(
          create: (_) => InjuryPainBloc(),
          child: const InjuryPainScreen(),
        ),
        '/injury_functional_capacity': (_) => BlocProvider(
          create: (_) => InjuryFunctionalCapacityBloc(),
          child: const InjuryFunctionalCapacityScreen(),
        ),
        '/injury_symptoms': (_) => BlocProvider(
          create: (_) => InjurySymptomsBloc(),
          child: const InjurySymptomsScreen(),
        ),
        '/injury_medical_context': (_) => BlocProvider(
          create: (_) => InjuryMedicalContextBloc(),
          child: const InjuryMedicalContextScreen(),
        ),
        '/injury_assessment_summary': (_) => BlocProvider(
          create: (_) => InjuryAssessmentBloc(
            startInjuryEvaluationFlowUseCase: StartInjuryEvaluationFlowUseCase(),
            injuryRepository: InjuryRepositoryImpl(
              injuryDataSource: InjuryDataSourceImpl(
                supabaseClient: Supabase.instance.client,
              ),
            ),
          ),
          child: const InjuryAssessmentSummaryScreen(),
        ),
      },
    );
  }
}
