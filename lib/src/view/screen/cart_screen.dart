import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/core/app_typography.dart';
import 'package:e_commerce_flutter/src/view/widget/cart/cart_bottom_section.dart';
import 'package:e_commerce_flutter/src/view/widget/cart/cart_item_card.dart';
import 'package:e_commerce_flutter/src/view/widget/empty_state.dart';

/// Cart screen shell. Composes the empty state / cart list and the
/// bottom subtotal + checkout panel.
class CartScreen extends GetView<ProductController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text('My Cart', style: AppText.headingLarge),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => controller.cartProducts.isEmpty
                  ? const EmptyState(
                      icon: Icons.shopping_cart_outlined,
                      title: 'Your cart is empty',
                      subtitle: 'Add products to get started.',
                    )
                  : _CartListView(controller: controller),
            ),
          ),
          CartBottomSection(controller: controller),
        ],
      ),
    );
  }
}

class _CartListView extends StatelessWidget {
  const _CartListView({required this.controller});

  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: controller.cartProducts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => CartItemCard(
        controller: controller,
        product: controller.cartProducts[index],
      ),
    );
  }
}
