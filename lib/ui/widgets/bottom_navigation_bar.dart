import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Widget reutilizable para la barra de navegación inferior de la aplicación
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.home_outlined,
              color: Colors.black87,
            ),
            onPressed: () => Navigator.pushNamed(context, '/home'),
          ),
          IconButton(
            icon: const Icon(
              Icons.library_books_outlined,
              color: Colors.black87,
            ),
            onPressed: () => Navigator.pushNamed(
              context,
              '/pain_map',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/checkin_form',
              );
            },
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black87,
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
          GestureDetector(
            onTap: () {
              final userId =
                  Supabase
                      .instance
                      .client
                      .auth
                      .currentUser
                      ?.id ??
                  '';
              if (userId.isNotEmpty) {
                Navigator.pushNamed(
                  context,
                  '/recovery_overview',
                );
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Error: Usuario no autenticado',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Icon(
              Icons.favorite_border,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.black87,
            ),
            onPressed: () => Navigator.pushNamed(
              context,
              '/my_profile',
            ),
          ),
        ],
      ),
    );
  }
}

