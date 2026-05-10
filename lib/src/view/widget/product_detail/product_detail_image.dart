import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/core/services/image_resolver.dart';
import 'package:e_commerce_flutter/src/model/product.dart';

/// Hero image at the top of the product detail screen. Wraps the asset
/// in a Hero with the product id as tag so the open-container animation
/// from the grid lines up.
class ProductDetailImage extends StatelessWidget {
  const ProductDetailImage({
    super.key,
    required this.product,
    required this.height,
  });

  final Product product;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Hero(
      tag: product.id,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [theme.colorScheme.surface, theme.scaffoldBackgroundColor]
                : [Colors.grey.shade200, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _buildImage(),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final resolved = ProductImageResolver.resolve(product.imageUrl);
    if (resolved == null) {
      return const Icon(
        Icons.image_not_supported,
        color: Colors.white54,
        size: 60,
      );
    }
    return Image.network(
      resolved,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (_, __, ___) => const Icon(
        Icons.image_not_supported,
        color: Colors.white54,
        size: 60,
      ),
    );
  }
}
