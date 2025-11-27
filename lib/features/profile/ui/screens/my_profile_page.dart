import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/domain/model/profile.dart';
import 'package:moviles252/features/profile/ui/bloc/profile_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviles252/ui/theme/app_colors.dart';
import 'package:moviles252/ui/widgets/feature_grid_with_image.dart';


class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadMyProfile());
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileIdle) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              return Center(child: Text("Error: ${state.message}"));
            } else if (state is ProfileLoaded || state is ProfileSaved) {
              final profile = (state is ProfileLoaded)
                  ? state.profile
                  : (state as ProfileSaved).profile;

              return Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/recovery/recovery_back.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 24,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryBlue,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white24,
                            child: ClipOval(
                              child: profile.profilePicture != null &&
                                      profile.profilePicture!.isNotEmpty
                                  ? Image.network(
                                      profile.profilePicture!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.white,
                                        );
                                      },
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
                              Text(
                                profile.name ?? 'Usuario',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Email
                              Text(
                                profile.email ?? '',
                                style: const TextStyle(
                                  color: AppColors.darkSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 12),
                              

                              // Sport and Age side by side
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Sport section
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Deportista",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.darkSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        profile.sex ?? "N/A",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: AppColors.darkSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 24),
                                  // Age section
                                  if (profile.birthDate != null)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _calculateAge(
                                            profile.birthDate!,
                                          ).toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.darkSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          "años",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: AppColors.darkSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---------- BODY ----------
                  Positioned(
                    top: 210,
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
                          horizontal: 20,
                          vertical: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            // --- Estadísticas ---
                            const Text(
                              "Estadísticas",
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
                                FeatureGridOption(
                                  label: "Información",
                                  icon: Icons.info_outline,
                                  onTap: () => Navigator.pushNamed(context, '/complete_profile'),
                                ),
                                const FeatureGridOption(
                                  label: "Lesiones",
                                  icon: Icons.healing_outlined,
                                ),
                                const FeatureGridOption(
                                  label: "Historial",
                                  icon: Icons.history_outlined,
                                ),
                                const FeatureGridOption(
                                  label: "Mis tareas",
                                  icon: Icons.assignment_outlined,
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            const Text(
                              "Configuración",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            _ConfigItem(
                              icon: Icons.edit_outlined,
                              label: "Completar información",
                              onTap: () =>
                                  Navigator.pushNamed(context, '/complete_profile'),
                            ),
                            _ConfigItem(
                              icon: Icons.lock_outline,
                              label: "Cambiar contraseña",
                              onTap: () {},
                            ),
                            const SizedBox(height: 8),
                            _ConfigItem(
                              icon: Icons.logout_outlined,
                              label: "Cerrar sesión",
                              onTap: () async {
                                await Supabase.instance.client.auth.signOut();
                                if (context.mounted) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/login',
                                  );
                                }
                              },
                              color: Colors.redAccent,
                            ),

                            const SizedBox(height: 90),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// ---------- Widgets Auxiliares ----------

class _ConfigItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ConfigItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDanger = color == Colors.redAccent;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDanger ? Colors.transparent : Colors.white,
          border: Border.all(
            color: Colors.white,
            width: isDanger ? 1.5 : 0,
          ),
        ),
        child: Icon(
          icon,
          color: isDanger ? Colors.white : AppColors.darkSurface,
          size: 20,
        ),
      ),
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
