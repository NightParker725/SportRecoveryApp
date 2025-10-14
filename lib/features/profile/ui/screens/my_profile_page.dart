import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/domain/model/profile.dart';
import 'package:moviles252/features/profile/ui/bloc/profile_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F242A),
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

              return Column(
                children: [
                  // ---------- HEADER ----------
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 20),
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                        child:CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/512/847/847969.png',
                          ),
                        )
                        ),
                        Expanded(child:
                        Column(
                        children: [ SizedBox(height: 12),

                        Text(
                          profile.name ?? 'Usuario',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          profile.email ?? '',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Deportista",
                              style: const TextStyle(color: Colors.black87),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${profile.birthDate}",
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ]
                        ),
                        ),
                      ],
                    ),
                  ),

                  // ---------- BODY ----------
                  Expanded(

                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Estadísticas ---
                          const Text(
                            "Estadísticas",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.4,
                            children: [
                              _StatCard(
                                  title: "Información",
                                  icon: Icons.info_outline,
                                  image:
                                  "https://cdn-icons-png.flaticon.com/512/992/992651.png"),
                              _StatCard(
                                  title: "Mis lesiones",
                                  icon: Icons.healing_outlined),
                              _StatCard(
                                  title: "Historial",
                                  icon: Icons.history_outlined),
                              _StatCard(
                                  title: "Mis tareas",
                                  icon: Icons.assignment_outlined),
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
                            label: "Editar información",
                            onTap: () => Navigator.pushNamed(
                                context, '/edit_profile'),
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
                                    context, '/login');
                              }
                            },
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ---------- NAV BAR ----------
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, -3),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.home_outlined, color: Colors.black87),
                        Icon(Icons.library_books_outlined, color: Colors.black87),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black87,
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                        Icon(Icons.favorite_border, color: Colors.black87),
                        Icon(Icons.person_outline, color: Colors.black87),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

// ---------- Widgets Auxiliares ----------

class _StatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? image;
  const _StatCard({required this.title, required this.icon, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image != null
              ? Image.network(image!, height: 40)
              : Icon(icon, color: Colors.white, size: 36),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

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
