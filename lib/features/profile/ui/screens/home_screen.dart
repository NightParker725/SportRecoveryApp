import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/profile/ui/bloc/profile_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviles252/ui/theme/app_colors.dart';
import 'package:moviles252/ui/widgets/feature_grid_with_image.dart';
import 'package:moviles252/ui/widgets/content_feature_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// V2: solo me falta acomodar el fondo y la imagen al lado de los botones "widgets y queda lista la homescreen
class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final maybeBloc = context.read<ProfileBloc?>();
    if (maybeBloc != null) {
      maybeBloc.add(LoadMyProfile());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo, logo y contenedor curvado como en LoginScreen
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (prev, curr) => curr is! ProfileSaving,
          builder: (context, state) {
            String displayName = 'Bienvenido';
            String displayEmail = '';
            if (state is ProfileLoaded) {
              displayName = state.profile.name;
              displayEmail = state.profile.email;
            } else if (state is ProfileSaved) {
              displayName = state.profile.name;
              displayEmail = state.profile.email;
            }

            final profilePicture = (state is ProfileLoaded)
                ? state.profile.profilePicture
                : (state is ProfileSaved ? state.profile.profilePicture : null);

            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _HeroSection(
                    profilePictureUrl: profilePicture,
                  ),
                ),
                Positioned(
                  top: 240,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Favoritos",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Divider(color: Colors.white30, thickness: 1),
                                const SizedBox(height: 16),
                                FeatureGridWithImage(
                                  imageAsset: "assets/images/user&home/inscreen.jpg",
                                  options: [
                                    FeatureGridOption(label: "Progreso", icon: Icons.show_chart, onTap: () {}),
                                    FeatureGridOption(label: "Mis tareas", icon: Icons.checklist_outlined, onTap: () {}),
                                    FeatureGridOption(label: "Tutoriales", icon: Icons.lightbulb_outline, onTap: () {}),
                                    FeatureGridOption(label: "Timer", icon: Icons.access_time, onTap: () {}),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: () => Navigator.pushNamed(context, '/injury_location'),
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: AppColors.primaryBlue,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.medical_services_outlined, color: Colors.white, size: 28),
                                        ),
                                        
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Nueva lesión", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                              SizedBox(height: 4),
                                              Text(
                                                "Registra aquí tu nueva lesión y recibe tu plan de recuperación.",
                                                style: TextStyle(color: Colors.white70, fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                ContentFeatureCard(
                                  imageProvider: const AssetImage("assets/images/user&home/piemalo.png"),
                                  badgeIcon: Icons.favorite_border,
                                  badgeBackground: Colors.white,
                                  badgeIconColor: AppColors.greySurface,
                                  title: "Fase de recuperación",
                                  description: "Explora los mejores ejercicios para calentar y prepárate para tu próxima sesión.",
                                  buttonLabel: "Ver más",
                                  onButtonPressed: () => Navigator.pushNamed(context, '/recovery_phase'),
                                  backgroundColor: AppColors.greySurface,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 90),
                      ],
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

// ---------- Widgets Auxiliares ----------

class _HomeActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _HomeActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? Colors.white),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
// ---------- Nuevo Widget Auxiliar ----------

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.profilePictureUrl});

  final String? profilePictureUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_img.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black54],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _HeroAvatar(photoUrl: profilePictureUrl),
                      Image.asset('assets/images/isotipo.png', height: 48),
                    ],
                  ),
                  const SizedBox(height: 56),
                  const Text(
                    '¡Queremos conocerte!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/complete_profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1.6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Text('Configurar mis datos', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroAvatar extends StatelessWidget {
  const _HeroAvatar({this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipOval(
        child: (photoUrl != null && photoUrl!.isNotEmpty)
            ? Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Colors.white, size: 28),
              )
            : const Icon(Icons.person, color: Colors.white, size: 28),
      ),
    );
  }
}
