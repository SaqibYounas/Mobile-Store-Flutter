import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/core/app_typography.dart';

/// Card that lists the cart items + subtotal at the top of the checkout
/// screen. Reads cart contents from the active [ProductController].
class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key, required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final products = Get.find<ProductController>().cartProducts;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.04),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Summary', style: AppText.titleMedium),
          const SizedBox(height: 8),
          ...products.map(
            (p) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${p.name}  ×${p.cartQuantity}',
                      style: AppText.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Rs.${(p.effectivePrice * p.cartQuantity).toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 20),
          Row(
            children: [
              const Text('Total', style: AppText.titleMedium),
              const Spacer(),
              Text(
                'Rs.$total',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: AppColor.brandIndigo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
