import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/core/app_typography.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:e_commerce_flutter/src/view/widget/app_card.dart';
import 'package:e_commerce_flutter/src/view/widget/cart/cart_product_thumb.dart';
import 'package:e_commerce_flutter/src/view/widget/price_text.dart';
import 'package:e_commerce_flutter/src/view/widget/quantity_stepper.dart';

/// Single row inside the cart list. Swipe-left to remove (with confirm),
/// tap +/- to adjust quantity. Calls into [ProductController] for state.
class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.product,
    required this.controller,
  });

  final Product product;
  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: _DismissBackground(),
      confirmDismiss: (_) => _confirmRemove(),
      onDismissed: (_) => controller.removeFromCart(product),
      child: AppCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CartProductThumb(imageUrl: product.imageUrl),
            const SizedBox(width: 14),
            Expanded(child: _Details(product: product, controller: controller)),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmRemove() async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Remove Item?'),
        content: const Text('Do you want to remove this product from cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return ok ?? false;
  }
}

class _DismissBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 25),
      decoration: BoxDecoration(
        color: Colors.red.shade400,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.product, required this.controller});

  final Product product;
  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        if ((product.category ?? '').isNotEmpty)
          Text(product.category!, style: AppText.bodySmall),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PriceText(
              price: product.price,
              discountPrice: product.discountPrice,
            ),
            QuantityStepper(
              quantity: product.cartQuantity,
              onIncrease: () => controller.increaseItemQuantity(product),
              onDecrease: () {
                if (product.cartQuantity > 1) {
                  controller.decreaseItemQuantity(product);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
