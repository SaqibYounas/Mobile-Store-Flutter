import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';

/// Square 84×84 product thumbnail used inside cart items. Falls back to
/// a generic icon when no image is available or the asset fails to load.
class CartProductThumb extends StatelessWidget {
  const CartProductThumb({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fallbackColor =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
    return Container(
      height: 84,
      width: 84,
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurfaceGrey : AppColor.surfaceGrey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: hasImage
            ? Image.asset(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported_outlined,
                  color: fallbackColor,
                ),
              )
            : Icon(
                Icons.shopping_bag_outlined,
                color: fallbackColor,
              ),
      ),
    );
  }
}
