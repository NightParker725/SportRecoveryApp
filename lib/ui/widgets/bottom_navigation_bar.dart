import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviles252/ui/theme/app_colors.dart';

/// Widget reutilizable para la barra de navegación inferior de la aplicación
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavIconButton(
                icon: Icons.home_outlined,
                onTap: () => Navigator.pushNamed(context, '/home'),
              ),
              _NavIconButton(
                icon: Icons.library_books_outlined,
                onTap: () => Navigator.pushNamed(context, '/pain_map'),
              ),
              _CenterActionButton(
                onTap: () => Navigator.pushNamed(context, '/checkin_form'),
              ),
              _NavIconButton(
                icon: Icons.favorite_border,
                onTap: () {
                  final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
                  if (userId.isNotEmpty) {
                    Navigator.pushNamed(context, '/recovery_overview');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error: Usuario no autenticado'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              _NavIconButton(
                icon: Icons.person_outline,
                onTap: () => Navigator.pushNamed(context, '/my_profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  const _NavIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Center(
          child: Icon(
            icon,
            size: 24,
            color: AppColors.darkSurface,
          ),
        ),
      ),
    );
  }
}

class _CenterActionButton extends StatelessWidget {
  const _CenterActionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.nearBlack,
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}

