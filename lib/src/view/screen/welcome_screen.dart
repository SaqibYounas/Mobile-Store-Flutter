import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/config/app_routes.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';

/// First-launch welcome screen. Lets users explore the catalog without
/// signing in — login is only enforced when they try to access the cart.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColor.gradientAuth),
        child: Stack(
          children: [
            Positioned(
              top: -60,
              left: -60,
              child: CircleAvatar(
                radius: 120,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -80,
              child: CircleAvatar(
                radius: 150,
                backgroundColor: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: size.height * 0.08),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(26),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_bag_rounded,
                          size: 84,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'TrendNest',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Discover the latest mobiles & gadgets',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const Spacer(),
                    const _Feature(
                      icon: Icons.local_offer_rounded,
                      label: 'Daily deals & flash sales',
                    ),
                    const SizedBox(height: 14),
                    const _Feature(
                      icon: Icons.verified_rounded,
                      label: 'Genuine products, trusted sellers',
                    ),
                    const SizedBox(height: 14),
                    const _Feature(
                      icon: Icons.local_shipping_rounded,
                      label: 'Fast & reliable delivery',
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColor.brandIndigoDeep,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 6,
                        ),
                        onPressed: () => Get.offAllNamed(AppRoutes.home),
                        child: const Text(
                          "Let's Start",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.auth),
                        child: const Text(
                          'Already have an account? Sign in',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
