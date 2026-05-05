import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/config/app_routes.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/core/app_typography.dart';
import 'package:e_commerce_flutter/src/view/widget/gradient_button.dart';

/// Sticky bottom panel of the cart screen — shows the running subtotal
/// and the "Proceed to Checkout" button. Disabled when the cart is empty.
class CartBottomSection extends StatelessWidget {
  const CartBottomSection({super.key, required this.controller});

  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Obx(() {
      final isEnabled = controller.cartProducts.isNotEmpty;
      return Container(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.06),
              blurRadius: 20,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    'Rs.${controller.totalPrice.value}',
                    style: AppText.priceLarge,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: 'Proceed to Checkout',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: isEnabled
                      ? () => Get.toNamed(AppRoutes.payment)
                      : null,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
