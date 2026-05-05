import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/controller/favorites_controller.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/core/app_typography.dart';
import 'package:e_commerce_flutter/src/view/widget/empty_state.dart';
import 'package:e_commerce_flutter/src/view/widget/product_grid_view.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productCtrl = Get.find<ProductController>();
    final favCtrl = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('My Wishlist', style: AppText.headingLarge),
        centerTitle: true,
      ),
      body: Obx(() {
        final products = favCtrl.favoriteProducts;
        if (products.isEmpty) {
          return const EmptyState(
            icon: Icons.favorite_border_rounded,
            title: 'Your wishlist is empty',
            subtitle: 'Tap the heart icon on a product to save it here.',
          );
        }
        return RefreshIndicator(
          onRefresh: () async => Future.value(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
            children: [
              ProductGridView(
                items: products,
                likeButtonPressed: (i) => favCtrl.toggleFavorite(products[i]),
                isPriceOff: productCtrl.isPriceOff,
              ),
            ],
          ),
        );
      }),
    );
  }
}
