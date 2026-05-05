import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/config/app_routes.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/core/app_toast.dart';
import 'package:e_commerce_flutter/src/core/app_typography.dart';
import 'package:e_commerce_flutter/src/core/services/session_service.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:e_commerce_flutter/src/view/widget/circle_icon_button.dart';
import 'package:e_commerce_flutter/src/view/widget/product_detail/product_buy_bar.dart';
import 'package:e_commerce_flutter/src/view/widget/product_detail/product_category_tag.dart';
import 'package:e_commerce_flutter/src/view/widget/product_detail/product_detail_image.dart';
import 'package:e_commerce_flutter/src/view/widget/product_detail/product_feature_tile.dart';
import 'package:e_commerce_flutter/src/view/widget/product_detail/product_rating_row.dart';

/// Product detail screen — composes hero image, category tag, rating,
/// description, feature tiles, and a sticky buy bar at the bottom.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CircleIconButton(
          icon: Icons.arrow_back_ios_new,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          GetBuilder<ProductController>(
            builder: (_) => CircleIconButton(
              icon: product.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              iconColor: product.isFavorite ? Colors.red : Colors.black,
              onPressed: () => controller.toggleFavorite(product),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductDetailImage(product: product, height: size.height * 0.48),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 130),
                  child: _ProductBody(product: product),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ProductBuyBar(
              product: product,
              onAddToCart: () => _handleAddToCart(controller),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAddToCart(ProductController controller) {
    if (!SessionService.isLoggedIn) {
      AppToast.error('Login Required', 'Please login to purchase items');
      Get.toNamed(AppRoutes.auth);
      return;
    }
    controller.addToCart(product);
    AppToast.success('Added to Cart', '${product.name} added successfully');
    // Auto-pop back to the previous screen — no manual close button needed.
    Get.back();
  }
}

class _ProductBody extends StatelessWidget {
  const _ProductBody({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductCategoryTag(
          label: (product.category ?? 'PRODUCT').toUpperCase(),
        ),
        const SizedBox(height: 14),
        Text(product.name, style: AppText.displayLarge),
        const SizedBox(height: 8),
        ProductRatingRow(
          rating: product.rating,
          isAvailable: product.isAvailable && product.inStock,
        ),
        const SizedBox(height: 28),
        const Text('Specifications', style: AppText.titleLarge),
        const SizedBox(height: 10),
        Text(
          product.about,
          style: AppText.bodyMedium.copyWith(height: 1.55),
        ),
        const SizedBox(height: 24),
        const ProductFeatureTile(
          icon: Icons.battery_charging_full,
          title: 'Long Battery Life',
        ),
        const ProductFeatureTile(
          icon: Icons.camera_alt_outlined,
          title: 'Pro Camera System',
        ),
        const ProductFeatureTile(
          icon: Icons.speed,
          title: 'Fastest Processor',
        ),
      ],
    );
  }
}
