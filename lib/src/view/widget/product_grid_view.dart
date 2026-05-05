import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:e_commerce_flutter/src/view/animation/open_container_wrapper.dart';
import 'package:e_commerce_flutter/src/view/widget/product_grid/product_grid_item.dart';

/// Two-column non-scrolling product grid. Each card opens the detail
/// screen via [OpenContainerWrapper]. Heart taps are surfaced through
/// [likeButtonPressed].
class ProductGridView extends StatelessWidget {
  const ProductGridView({
    super.key,
    required this.items,
    required this.isPriceOff,
    required this.likeButtonPressed,
  });

  final List<Product> items;
  final bool Function(Product product) isPriceOff;
  final void Function(int index) likeButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 16, 15, 0),
      child: GridView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.70,
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
        ),
        itemBuilder: (_, index) {
          final product = items[index];
          return OpenContainerWrapper(
            product: product,
            child: ProductGridItem(
              product: product,
              isOnSale: isPriceOff(product),
              onLikePressed: () => likeButtonPressed(index),
            ),
          );
        },
      ),
    );
  }
}
