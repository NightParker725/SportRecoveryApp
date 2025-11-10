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

              return Stack(
                children: [
                  // ---------- HEADER ----------
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      // Subtle teal arc pattern background
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        colors: [
                          Colors.white,
                          Colors.white,
                          const Color(0xFF00CED1).withOpacity(0.05),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar with teal border
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF00CED1),
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.grey[300],
                            child: ClipOval(
                              child: Image.network(
                                'https://cdn-icons-png.flaticon.com/512/847/847969.png',
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 45,
                                    color: Colors.grey[600],
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
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
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Email
                              Text(
                                profile.email ?? '',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 12),
                                  // Botón para completar perfil
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/complete_profile',
                                  );
                                },
                                icon: const Icon(
                                  Icons.person_add_alt_1_outlined,
                                ),
                                label: const Text('Completar perfil'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                                  
                              // Sport and Age side by side
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Sport section
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Deportista",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        profile.sex ?? "N/A",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 24),
                                  // Age section
                                  if (profile.birthDate != null)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _calculateAge(profile.birthDate!).toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          "años",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black54,
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
                            const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30),
                              ),
                              child: Image.asset(
                                "assets/images/user&home/inscreen.jpg",
                                width: 105,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1.0,
                                children: const [
                                _StatCard(
                                  title: "Información",
                                  icon: Icons.info_outline,
                                  image:
                                  "https://cdn-icons-png.flaticon.com/512/992/992651.png",
                                ),
                                _StatCard(
                                  title: "Lesiones",
                                  icon: Icons.healing_outlined,
                                ),
                                _StatCard(
                                  title: "Historial",
                                  icon: Icons.history_outlined,
                                ),
                                _StatCard(
                                  title: "Mis tareas",
                                  icon: Icons.assignment_outlined,
                                ),
                              ],
                            ),
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
                              label: "Editar información",
                              onTap: () =>
                                  Navigator.pushNamed(context, '/edit_profile'),
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
                            const SizedBox(height: 8),
                            _ConfigItem(
                              icon: Icons.settings_outlined, label: '', onTap: () {  },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ---------- NAV BAR ----------
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.home_outlined, color: Colors.black87),
                        const Icon(
                          Icons.library_books_outlined,
                          color: Colors.black87,
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/checkin_form');
                          },
                          child: const CircleAvatar(
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
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.home_outlined,
                              color: Colors.black87,
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/home'),
                          ),
                          const Icon(Icons.library_books_outlined,
                              color: Colors.black87),
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.black87,
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                          const Icon(Icons.favorite_border,
                              color: Colors.black87),
                          IconButton(
                            icon: const Icon(
                              Icons.person,
                              color: Colors.black87,
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/my_profile'),
                          ),
                        ],
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

class _StatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? image;

  const _StatCard({
    required this.title,
    required this.icon,
    this.image,
  });

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
        mainAxisSize: MainAxisSize.min,
        children: [
          image != null
              ? Image.network(image!, height: 40)
              : Icon(icon, color: Colors.white, size: 36),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
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
