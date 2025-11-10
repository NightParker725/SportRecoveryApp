import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/profile/ui/bloc/profile_bloc.dart';

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

            return Stack(
              children: [

                Positioned.fill(
                  child: Image.asset(
                    'assets/images/user&home/fondomain.jpg',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),


                Positioned(
                  top: 60,
                  left: 24,
                  child: Image.asset('assets/images/logo.png', width: 140),
                ),


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
                    child: Column(
                      children: [
                        // Contenido scrolleable
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),

                                //Main content :b
                                const Text(
                                  "Favoritos",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [

                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(30),
                                        bottomRight: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                        topLeft: Radius.circular(30),
                                       ),
                                      child:
                                    Image.asset("assets/images/user&home/inscreen.jpg",
                                      width: 105,
                                      height: 200,
                                      fit: BoxFit.cover,

                                    ),
                                    ),
                                    Expanded(
                                  child:
                                  GridView.count(
                                    crossAxisCount: 2,
                                    shrinkWrap: true,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5,
                                    children: const [
                                      _HomeStatCard(
                                        title: "Progreso",
                                        icon: Icons.show_chart,
                                      ),
                                      _HomeStatCard(
                                        title: "Mis tareas",
                                        icon: Icons.checklist_outlined,
                                      ),
                                      _HomeStatCard(
                                        title: "Tutoriales",
                                        icon: Icons.lightbulb_outline,
                                      ),
                                      _HomeStatCard(
                                        title: "Timer",
                                        icon: Icons.access_time,
                                      ),
                                  ],
                                      ),

                                  ),
                                  ],

                                ),

                                const SizedBox(height: 5),
                                //Boton de agregar lesion
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/injury_register');
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                    color: Color(0xFF019193) ,
                                    ),
                                    child: Row(
                                      children: [

                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.medical_services_outlined,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Nueva lesión",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "Registra aquí tu nueva lesión y recibe tu plan de recuperación.",
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.white70,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const _RecoveryPhaseCard(),



                              ],

                            ),
                          ),
                        ),

                        // NAV BAR
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
// ---------- Nuevo Widget Auxiliar ----------

class _RecoveryPhaseCard extends StatelessWidget {
  const _RecoveryPhaseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24), // Espaciado superior para separarlo
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C), // Fondo oscuro de las tarjetas
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Imagen y Botón de Favorito
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/images/user&home/piemalo.png", // Debes reemplazar esto con la ruta de tu imagen real
                  width: 140, // Ancho de la imagen para que encaje
                  height: 120, // Altura adecuada para este card
                  fit: BoxFit.cover,
                ),
              ),
              // Icono de corazón (Favorito)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 3,
                        )
                      ]
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Color(0xFF2C2C2C), // Color oscuro para el corazón
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // 2. Contenido de Texto y Botón "Ver más"
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Fase de desinflamación",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Continúa explorando sobre tu fase actual.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Botón "Ver más"
                Align(
                  alignment: Alignment.bottomLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción al presionar "Ver más"
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C897), // El color verde brillante de tu diseño
                      foregroundColor: Colors.black, // Color del texto
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Ver más",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}