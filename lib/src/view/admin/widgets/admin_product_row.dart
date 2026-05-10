import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/controller/admin_controller.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/core/app_typography.dart';
import 'package:e_commerce_flutter/src/core/services/image_resolver.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:e_commerce_flutter/src/view/admin/widgets/admin_chip.dart';
import 'package:e_commerce_flutter/src/view/admin/widgets/admin_product_form.dart';
import 'package:e_commerce_flutter/src/view/widget/app_card.dart';

/// One row in the admin product list. Shows thumbnail, name, status chips,
/// price and per-row actions (toggle active, toggle featured, edit, delete).
class AdminProductRow extends StatelessWidget {
  const AdminProductRow({
    super.key,
    required this.product,
    required this.controller,
  });

  final Product product;
  final AdminController controller;

  @override
  Widget build(BuildContext context) {
    final dim = !product.isActive;
    return Opacity(
      opacity: dim ? 0.6 : 1,
      child: AppCard(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductHeader(product: product),
            const Divider(height: 24),
            _ProductActions(product: product, controller: controller),
          ],
        ),
      ),
    );
  }
}

class _ProductHeader extends StatelessWidget {
  const _ProductHeader({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Thumbnail(imageUrl: product.imageUrl),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: AppText.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (product.isFeatured)
                    const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: Colors.orange,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              _StatusChips(product: product),
            ],
          ),
        ),
      ],
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final resolved = ProductImageResolver.resolve(imageUrl);
    final fallback = Container(
      width: 64,
      height: 64,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkSurfaceGrey
          : AppColor.surfaceGrey,
      child: Icon(
        Icons.image_not_supported_outlined,
        color:
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: resolved == null
          ? fallback
          : Image.network(
              resolved,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => fallback,
            ),
    );
  }
}

class _StatusChips extends StatelessWidget {
  const _StatusChips({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        AdminChip(
          text: product.category ?? '—',
          color: AppColor.brandIndigo,
        ),
        AdminChip(
          text: 'Stock: ${product.stockQuantity}',
          color: product.stockQuantity == 0 ? Colors.red : Colors.green,
        ),
        if (product.hasDiscount)
          AdminChip(
            text: product.discountType == DiscountType.percentage
                ? '-${product.discountValue.toStringAsFixed(0)}%'
                : '-Rs.${product.discountValue.toStringAsFixed(0)}',
            color: Colors.redAccent,
          ),
      ],
    );
  }
}

class _ProductActions extends StatelessWidget {
  const _ProductActions({required this.product, required this.controller});

  final Product product;
  final AdminController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rs.${product.effectivePrice.toStringAsFixed(2)}',
              style: AppText.priceMedium,
            ),
            if (product.hasDiscount)
              Text(
                'Rs.${product.price.toStringAsFixed(2)}',
                style: AppText.priceStrike,
              ),
          ],
        ),
        const Spacer(),
        IconButton(
          tooltip: product.isActive ? 'Deactivate' : 'Activate',
          onPressed: () => controller.toggleActive(product),
          icon: Icon(
            product.isActive ? Icons.visibility : Icons.visibility_off,
            color: product.isActive ? Colors.green : Colors.grey,
          ),
        ),
        IconButton(
          tooltip: product.isFeatured ? 'Unfeature' : 'Mark featured',
          onPressed: () => controller.toggleFeatured(product),
          icon: Icon(
            product.isFeatured ? Icons.star : Icons.star_border,
            color: Colors.orange,
          ),
        ),
        IconButton(
          tooltip: 'Edit',
          onPressed: () => AdminProductForm.show(context, product),
          icon: const Icon(Icons.edit, color: AppColor.brandIndigo),
        ),
        IconButton(
          tooltip: 'Delete',
          onPressed: () => _confirmDelete(context, product, controller),
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
        ),
      ],
    );
  }

  void _confirmDelete(
    BuildContext context,
    Product p,
    AdminController controller,
  ) {
    Get.defaultDialog(
      title: 'Delete product?',
      middleText:
          'Permanently remove "${p.name}"? This cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        // Close confirmation dialog immediately — toast handles the result.
        Get.back();
        controller.deleteProduct(p.id, productName: p.name);
      },
    );
  }
}
