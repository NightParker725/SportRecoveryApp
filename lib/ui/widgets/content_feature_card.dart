import 'package:flutter/material.dart';
import 'package:moviles252/ui/theme/app_colors.dart';

class ContentFeatureCard extends StatelessWidget {
  const ContentFeatureCard({
    super.key,
    required this.imageProvider,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onButtonPressed,
    this.badgeIcon = Icons.play_arrow,
    this.badgeBackground = Colors.white,
    this.badgeIconColor = Colors.black,
    this.backgroundColor = AppColors.greySurface,
    this.textColor = Colors.white,
    this.imageWidth = 120,
  });

  final ImageProvider imageProvider;
  final double imageWidth;
  final IconData badgeIcon;
  final Color badgeBackground;
  final Color badgeIconColor;
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onButtonPressed;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: imageWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(image: imageProvider, fit: BoxFit.cover),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: badgeBackground,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(badgeIcon, size: 20, color: badgeIconColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 12, height: 1.3),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: onButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      child: Text(buttonLabel),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

