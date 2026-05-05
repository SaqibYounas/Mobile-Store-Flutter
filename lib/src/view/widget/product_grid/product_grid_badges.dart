import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';

/// Top-of-card overlay with sale + out-of-stock badges on the left and
/// a favorite heart button on the right.
class ProductGridBadges extends StatelessWidget {
  const ProductGridBadges({
    super.key,
    required this.showSaleBadge,
    required this.isFavorite,
    required this.onLikePressed,
    required this.inStock,
  });

  final bool showSaleBadge;
  final bool isFavorite;
  final VoidCallback onLikePressed;
  final bool inStock;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      right: 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showSaleBadge) const _PillBadge(text: 'SALE', color: Colors.redAccent),
              if (!inStock) ...[
                if (showSaleBadge) const SizedBox(height: 4),
                _PillBadge(
                  text: 'OUT OF STOCK',
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ],
            ],
          ),
          _FavoriteButton(isFavorite: isFavorite, onPressed: onLikePressed),
        ],
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  const _PillBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.isFavorite,
    required this.onPressed,
  });

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
              ),
            ],
          ),
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.redAccent : AppColor.textTertiary,
            size: 18,
          ),
        ),
      ),
    );
  }
}
