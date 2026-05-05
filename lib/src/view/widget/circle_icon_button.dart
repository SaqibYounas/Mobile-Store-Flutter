import 'package:flutter/material.dart';

/// Round white icon button used as floating action button in app bars
/// (back / favorite). Reusable on product detail and any other hero
/// screen with a translucent app bar.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor = Colors.black,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: Colors.white.withValues(alpha: 0.92),
        child: IconButton(
          icon: Icon(icon, size: 18, color: iconColor),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
