import 'package:flutter/material.dart';
import 'package:moviles252/ui/theme/app_colors.dart';

class FormShell extends StatelessWidget {
  const FormShell({
    super.key,
    required this.title,
    required this.child,
    this.scrollable = true,
    this.contentPadding = const EdgeInsets.all(24),
  });

  final String title;
  final Widget child;
  final bool scrollable;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: contentPadding,
      child: child,
    );

    final body = scrollable
        ? SingleChildScrollView(
            child: card,
          )
        : card;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/recovery/recovery_back.png',
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/isotipo.png',
                      height: 34,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(child: body),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

