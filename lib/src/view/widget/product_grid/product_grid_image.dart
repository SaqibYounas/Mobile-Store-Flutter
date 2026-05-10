import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/core/services/image_resolver.dart';

/// Image area at the top of a product grid card. Light grey background,
/// rounded top corners, contains the network image with a fallback icon.
class ProductGridImage extends StatelessWidget {
  const ProductGridImage({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolved = ProductImageResolver.resolve(imageUrl);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurfaceGrey : AppColor.surfaceGrey,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: resolved == null
              ? const Center(
                  child: Icon(Icons.image_outlined,
                      color: AppColor.textTertiary),
                )
              : Image.network(
                  resolved,
                  fit: BoxFit.contain,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.image_outlined,
                        color: AppColor.textTertiary),
                  ),
                ),
        ),
      ),
    );
  }
}
