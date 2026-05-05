import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:e_commerce_flutter/src/view/widget/product_grid/product_grid_badges.dart';
import 'package:e_commerce_flutter/src/view/widget/product_grid/product_grid_footer.dart';
import 'package:e_commerce_flutter/src/view/widget/product_grid/product_grid_image.dart';

/// One card inside the product grid. Composes image, sale/stock/heart
/// badges, and the price-and-name footer.
class ProductGridItem extends StatelessWidget {
  const ProductGridItem({
    super.key,
    required this.product,
    required this.isOnSale,
    required this.onLikePressed,
  });

  final Product product;
  final bool isOnSale;
  final VoidCallback onLikePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ProductGridImage(imageUrl: product.imageUrl),
                ProductGridBadges(
                  showSaleBadge: isOnSale,
                  isFavorite: product.isFavorite,
                  onLikePressed: onLikePressed,
                  inStock: product.isAvailable && product.inStock,
                ),
              ],
            ),
          ),
          ProductGridFooter(product: product),
        ],
      ),
    );
  }
}
