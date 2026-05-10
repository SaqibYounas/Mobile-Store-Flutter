import 'package:flutter/material.dart';

/// Brand header (logo + app name + tagline) shown at the top of the
/// auth screen. Sits above the gradient background.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shopping_bag_rounded,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'TrendNest',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        const Text(
          'Your modern mobile store',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
