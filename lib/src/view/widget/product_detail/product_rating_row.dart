import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';

/// Star rating + In-stock / Out-of-stock pill row.
class ProductRatingRow extends StatelessWidget {
  const ProductRatingRow({
    super.key,
    required this.rating,
    required this.isAvailable,
  });

  final double rating;
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBarIndicator(
          rating: rating,
          itemBuilder: (_, __) =>
              const Icon(Icons.star_rounded, color: Colors.amber),
          itemCount: 5,
          itemSize: 20,
        ),
        const SizedBox(width: 8),
        Text(
          '$rating / 5.0',
          style: const TextStyle(
            color: AppColor.textTertiary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        _StockBadge(isAvailable: isAvailable),
      ],
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final color = isAvailable ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isAvailable ? 'In Stock' : 'Out of Stock',
        style: TextStyle(
          color: isAvailable ? Colors.green.shade700 : Colors.red.shade700,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
