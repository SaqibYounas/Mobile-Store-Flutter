import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/core/app_typography.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:e_commerce_flutter/src/view/widget/gradient_button.dart';

/// Bottom sticky bar on the product detail screen — shows the effective
/// price on the left and a full-width Add-to-Cart button on the right.
/// Disabled when the product is out of stock or unavailable.
class ProductBuyBar extends StatelessWidget {
  const ProductBuyBar({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  final Product product;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final canAdd = product.isAvailable && product.inStock;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(28),
          topLeft: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Best Price',
                  style: TextStyle(
                    color: AppColor.textTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Rs.${product.effectivePrice.toStringAsFixed(0)}',
                  style: AppText.priceLarge.copyWith(fontSize: 22),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: GradientButton(
                text: canAdd ? 'Add to Cart' : 'Unavailable',
                icon: canAdd ? Icons.shopping_bag_outlined : null,
                height: 52,
                borderRadius: 16,
                onPressed: canAdd ? onAddToCart : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
