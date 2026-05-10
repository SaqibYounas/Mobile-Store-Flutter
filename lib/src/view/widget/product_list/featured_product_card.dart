import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/core/services/image_resolver.dart';
import 'package:e_commerce_flutter/src/model/product.dart';

/// Wide gradient card for the "Featured" horizontal row on the home
/// screen. Shows a label, product name, price (with strike-through if
/// discounted) and the product image.
class FeaturedProductCard extends StatelessWidget {
  const FeaturedProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: AppColor.gradientPromo,
        boxShadow: [
          BoxShadow(
            color: AppColor.brandIndigoDeep.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(child: _Details(product: product)),
            _FeaturedImage(imageUrl: product.imageUrl),
          ],
        ),
      ),
    );
  }
}

class _FeaturedImage extends StatelessWidget {
  const _FeaturedImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final resolved = ProductImageResolver.resolve(imageUrl);
    const fallback = Icon(
      Icons.image_not_supported,
      color: Colors.white54,
      size: 60,
    );
    if (resolved == null) {
      return const SizedBox(width: 100, child: fallback);
    }
    return Image.network(
      resolved,
      width: 100,
      fit: BoxFit.contain,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return const SizedBox(
          width: 100,
          child: Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => const SizedBox(width: 100, child: fallback),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            product.hasDiscount ? 'FLASH SALE' : 'FEATURED',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Rs.${product.effectivePrice.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 6),
            if (product.hasDiscount)
              Text(
                'Rs.${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white70,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
