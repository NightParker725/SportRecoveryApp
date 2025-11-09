import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/profile/ui/bloc/profile_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
//V1 copie la misma estructura de my_profile_page para tener una estructura sobre la cual trabajar
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
      backgroundColor: const Color(0xFF1F242A),
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (prev, curr) => curr is! ProfileSaving, // minimizar rebuilds
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
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                  child: Row(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(
                            'https://cdn-icons-png.flaticon.com/512/847/847969.png',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              displayName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              displayEmail,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Inicio",
                                  style: TextStyle(color: Colors.black87),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Resumen y accesos rápidos",
                                  style: TextStyle(color: Colors.black54),
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                          children: const [
                            _HomeStatCard(
                              title: "Progreso",
                              icon: Icons.show_chart,
                            ),
                            _HomeStatCard(
                              title: "Tareas de hoy",
                              icon: Icons.checklist_outlined,
                            ),
                            _HomeStatCard(
                              title: "Recomendaciones",
                              icon: Icons.lightbulb_outline,
                            ),
                            _HomeStatCard(
                              title: "Última sesión",
                              icon: Icons.access_time,
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),
                        const Text(
                          "Acciones rápidas",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _HomeActionItem(
                          icon: Icons.person_outline,
                          label: "Mi perfil",
                          onTap: () => Navigator.pushNamed(context, '/my_profile'),
                        ),
                        _HomeActionItem(
                          icon: Icons.assignment_outlined,
                          label: "Mis tareas",
                          onTap: () {
                            // TODO: Navegar a tareas cuando exista la ruta
                          },
                        ),
                        _HomeActionItem(
                          icon: Icons.library_books_outlined,
                          label: "Historial",
                          onTap: () {
                            // TODO: Navegar a historial cuando exista la ruta
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // ---------- NAV BAR ----------
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
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
                    children: [
                      IconButton(
                          icon: const Icon(Icons.home, color: Colors.black87),
                          onPressed: () => Navigator.pushNamed(context, '/home')
                      ),
                      const Icon(Icons.library_books_outlined, color: Colors.black87),
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black87,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                      const Icon(Icons.favorite_border, color: Colors.black87),
                      IconButton(
                          icon: const Icon(Icons.person_outline, color: Colors.black87),
                          onPressed: () => Navigator.pushNamed(context, '/my_profile')
                      ),
                    ],
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

class _HomeStatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? image;
  const _HomeStatCard({required this.title, required this.icon, this.image});

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