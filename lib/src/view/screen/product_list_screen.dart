import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/view/widget/category_buttons.dart';
import 'package:e_commerce_flutter/src/view/widget/product_grid_view.dart';
import 'package:e_commerce_flutter/src/view/widget/product_list/featured_product_card.dart';
import 'package:e_commerce_flutter/src/view/widget/product_list/product_list_header.dart';
import 'package:e_commerce_flutter/src/view/widget/product_list/product_search_field.dart';
import 'package:e_commerce_flutter/src/view/widget/section_title.dart';

/// Customer home tab — shows greeting header, search, dynamic category
/// buttons, featured row, and the filtered product grid.
class ProductListScreen extends GetView<ProductController> {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProductListBody(controller: controller);
  }
}

class _ProductListBody extends StatefulWidget {
  const _ProductListBody({required this.controller});

  final ProductController controller;

  @override
  State<_ProductListBody> createState() => _ProductListBodyState();
}

class _ProductListBodyState extends State<_ProductListBody> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    widget.controller.isSearching.value = value.isNotEmpty;
    widget.controller.filterProductsByName(value);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.controller.searchRemote(value);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    widget.controller.filterProductsByName('');
    widget.controller.isSearching.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (c.isLoading.value && c.filteredProducts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () async {
              await c.fetchProducts();
              await c.fetchFeatured();
              await c.fetchCategories();
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: ProductListHeader(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ProductSearchField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      onClear: _clearSearch,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                    child: Obx(() {
                      if (c.categories.isEmpty) return const SizedBox.shrink();
                      return CategoryButtons(
                        categories: c.categories,
                        selected: c.selectedCategory.value,
                        onSelected: c.selectCategory,
                      );
                    }),
                  ),
                ),
                if (!c.isSearching.value && c.featured.isNotEmpty) ...[
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 14, 20, 6),
                      child: SectionTitle(title: 'Featured'),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 190,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        itemCount: c.featured.length,
                        itemBuilder: (_, i) =>
                            FeaturedProductCard(product: c.featured[i]),
                      ),
                    ),
                  ),
                ],
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: SectionTitle(
                      title: c.isSearching.value
                          ? 'Search Results'
                          : (c.selectedCategory.value.isEmpty
                              ? 'New Arrivals'
                              : c.selectedCategory.value),
                    ),
                  ),
                ),
                if (c.filteredProducts.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 60, 20, 60),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 56,
                              color: AppColor.textHint,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No products found',
                              style: TextStyle(color: AppColor.textTertiary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 100),
                    sliver: SliverToBoxAdapter(
                      child: ProductGridView(
                        items: c.filteredProducts,
                        likeButtonPressed: (index) {
                          final product = c.filteredProducts[index];
                          c.toggleFavorite(product);
                        },
                        isPriceOff: c.isPriceOff,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
