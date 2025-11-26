import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/auth/ui/bloc/signup_bloc.dart';
import 'package:moviles252/features/checkin/ui/bloc/checkin_bloc.dart';
import 'package:moviles252/features/checkin/ui/screens/checkin_form_screen.dart';
import 'package:moviles252/features/profile/ui/bloc/profile_bloc.dart';
import 'package:moviles252/features/auth/ui/screens/login_screen.dart';
import 'package:moviles252/features/profile/ui/screens/my_profile_page.dart';
import 'package:moviles252/features/profile/ui/screens/profile_screen.dart';
import 'package:moviles252/features/auth/ui/screens/signup_screen.dart';
import 'package:moviles252/features/profile/ui/screens/home_screen.dart';
import 'package:moviles252/features/recovery/data/repositories/recovery_repository_impl.dart';
import 'package:moviles252/features/recovery/domain/usecases/advance_recovery_day.dart';
import 'package:moviles252/features/recovery/domain/usecases/complete_recovery_task.dart';
import 'package:moviles252/features/recovery/domain/usecases/get_phases_by_plan.dart';
import 'package:moviles252/features/recovery/domain/usecases/get_recovery_overview.dart';
import 'package:moviles252/features/recovery/domain/usecases/get_tasks_by_phase.dart';
import 'package:moviles252/features/recovery/ui/bloc/recovery_bloc.dart';
import 'package:moviles252/features/recovery/ui/screens/recovery_overview_screen.dart';
import 'package:moviles252/features/recovery/ui/screens/recovery_phase_screen.dart';
import 'features/auth/ui/screens/splash_screen.dart';
import 'features/auth/ui/screens/welcome_screen.dart';
import 'features/auth/ui/bloc/splash_bloc.dart';
import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/domain/usecases/check_user_logged_in_usecase.dart';
import 'features/profile/ui/screens/complete_profile_screen.dart';
import 'features/profile/ui/bloc/complete_profile_bloc.dart';
import 'features/profile/domain/usecases/profile_usecases.dart';
import 'features/profile/data/repository/profile_repository_impl.dart';
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
import 'features/education/ui/screens/encyclopedia_screen.dart';
import 'features/education/ui/screens/common_injuries_screen.dart';
import 'features/education/ui/screens/prevention_tips_screen.dart';
import 'features/education/ui/screens/myths_screen.dart';
import 'features/education/ui/screens/glossary_screen.dart';
import 'features/education/ui/bloc/common_injuries_bloc.dart';
import 'features/education/ui/bloc/prevention_tips_bloc.dart';
import 'features/education/ui/bloc/myths_bloc.dart';
import 'features/education/ui/bloc/glossary_bloc.dart';
import 'features/education/domain/usecases/view_common_injuries_flow_usecase.dart';
import 'features/education/domain/usecases/view_prevention_tips_flow_usecase.dart';
import 'features/education/domain/usecases/view_myths_flow_usecase.dart';
import 'features/education/domain/usecases/view_glossary_flow_usecase.dart';
import 'features/education/data/repositories/education_repository_impl.dart';
import 'features/education/data/datasources/education_datasource_impl.dart';

final repo = RecoveryRepositoryImpl();
final recoveryBloc = RecoveryBloc(
  getOverview: GetRecoveryOverviewUseCase(repo),
  getPhasesByPlan: GetPhasesByPlan(repo),
  getTasksByPhase: GetTasksByPhase(repo),
  completeTask: CompleteRecoveryTaskUseCase(repo),
  advanceDay: AdvanceRecoveryDayUseCase(repo),
);

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
        '/complete_profile': (_) => BlocProvider(
          create: (_) => CompleteProfileBloc(
            CompleteProfileUsecase(ProfileRepositoryImpl()),
          ),
          child: CompleteProfileScreen(),
        ),
        '/login': (_) =>
            BlocProvider(create: (_) => LoginBloc(), child: LoginScreen()),
        '/my_profile': (_) => BlocProvider(
          create: (_) => ProfileBloc(),
          child: const MyProfilePage(),
        ),
        '/home': (_) => BlocProvider(
          create: (_) => ProfileBloc(),
          child: const HomeScreen(),
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
            startInjuryEvaluationFlowUseCase:
                StartInjuryEvaluationFlowUseCase(),
            injuryRepository: InjuryRepositoryImpl(
              injuryDataSource: InjuryDataSourceImpl(
                supabaseClient: Supabase.instance.client,
              ),
            ),
          ),
          child: const InjuryAssessmentSummaryScreen(),
        ),
        '/checkin_form': (_) => BlocProvider(
          create: (_) => CheckinBloc(),
          child: const CheckinFormScreen(),
        ),
        // Rutas de Educación/Enciclopedia
        '/education': (_) => const EncyclopediaScreen(),
        '/education/common-injuries': (_) {
          final repository = EducationRepositoryImpl(
            educationDataSource: EducationDataSourceImpl(
              supabaseClient: Supabase.instance.client,
              useMockData: true,
            ),
          );
          return BlocProvider(
            create: (_) => CommonInjuriesBloc(
              useCase: ViewCommonInjuriesFlowUseCase(repository: repository),
            ),
            child: const CommonInjuriesScreen(),
          );
        },
        '/education/prevention-tips': (_) {
          final repository = EducationRepositoryImpl(
            educationDataSource: EducationDataSourceImpl(
              supabaseClient: Supabase.instance.client,
              useMockData: true,
            ),
          );
          return BlocProvider(
            create: (_) => PreventionTipsBloc(
              useCase: ViewPreventionTipsFlowUseCase(repository: repository),
            ),
            child: const PreventionTipsScreen(),
          );
        },
        '/education/myths': (_) {
          final repository = EducationRepositoryImpl(
            educationDataSource: EducationDataSourceImpl(
              supabaseClient: Supabase.instance.client,
              useMockData: true,
            ),
          );
          return BlocProvider(
            create: (_) => MythsBloc(
              useCase: ViewMythsFlowUseCase(repository: repository),
            ),
            child: const MythsScreen(),
          );
        },

        '/education/glossary': (_) {
          final repository = EducationRepositoryImpl(
            educationDataSource: EducationDataSourceImpl(
              supabaseClient: Supabase.instance.client,
              useMockData: true,
            ),
          );

          return BlocProvider(
            create: (_) => GlossaryBloc(
              useCase: ViewGlossaryFlowUseCase(repository: repository),
            ),
            child: const GlossaryScreen(),
          );
        },
        '/recovery_overview': (_) => BlocProvider.value(
          value: recoveryBloc,
          child: const RecoveryOverviewScreen(),
        ),
        '/recovery_phase': (_) => BlocProvider.value(
          value: recoveryBloc,
          child: const RecoveryPhaseScreen(),
        ),
      },
    );
  }
}
