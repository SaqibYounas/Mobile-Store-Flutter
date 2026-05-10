import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/core/services/product_service.dart';
import 'package:e_commerce_flutter/src/model/product.dart';

/// Manages product listing, searching, filtering, and featured products.
/// Single Responsibility: Product catalog management only.
class ProductListController extends GetxController {
  // ---- State ----------------------------------------------------------------
  List<Product> allProducts = [];
  RxList<Product> filteredProducts = <Product>[].obs;
  RxList<Product> featured = <Product>[].obs;

  /// Distinct categories pulled from the backend.
  RxList<String> categories = <String>[].obs;

  /// Currently selected category. Empty string == "All".
  RxString selectedCategory = ''.obs;

  RxBool isLoading = true.obs;
  RxString currentQuery = ''.obs;
  RxBool isSearching = false.obs;

  StreamSubscription<List<Product>>? _liveSub;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchFeatured();
    fetchCategories();
    _subscribeLive();
  }

  @override
  void onClose() {
    _liveSub?.cancel();
    super.onClose();
  }

  // ---- Live Stream Management -----------------------------------------------
  void _subscribeLive() {
    _liveSub?.cancel();
    _liveSub = ProductService.activeStream().listen(_mergeIntoCatalog);
  }

  void _mergeIntoCatalog(List<Product> rows) {
    final favoriteIds =
        allProducts.where((p) => p.isFavorite).map((p) => p.id).toSet();
    final cartMap = {for (final p in allProducts) p.id: p.cartQuantity};

    for (final p in rows) {
      if (favoriteIds.contains(p.id)) p.isFavorite = true;
      if (cartMap.containsKey(p.id)) p.cartQuantity = cartMap[p.id]!;
    }

    allProducts = _sortSaleFirst(rows);
    _applyAllFilters();
  }

  /// Stable sort that floats discounted products to the top while keeping
  /// the relative order (newest first, as returned by the backend) within
  /// each group.
  List<Product> _sortSaleFirst(List<Product> rows) {
    final list = List<Product>.from(rows);
    list.sort((a, b) {
      final aSale = a.hasDiscount ? 0 : 1;
      final bSale = b.hasDiscount ? 0 : 1;
      return aSale.compareTo(bSale);
    });
    return list;
  }

  /// Recompute `filteredProducts` from `allProducts` based on current
  /// selected category + search query. Sale products are always
  /// surfaced first within the result set.
  void _applyAllFilters() {
    Iterable<Product> result = allProducts;
    if (selectedCategory.value.isNotEmpty) {
      final cat = selectedCategory.value.toLowerCase();
      result = result.where((p) => (p.category ?? '').toLowerCase() == cat);
    }
    if (currentQuery.value.isNotEmpty) {
      final q = currentQuery.value.toLowerCase();
      result = result.where((p) =>
          p.name.toLowerCase().contains(q) ||
          (p.description?.toLowerCase().contains(q) ?? false) ||
          (p.category?.toLowerCase().contains(q) ?? false) ||
          p.about.toLowerCase().contains(q));
    }
    filteredProducts.assignAll(_sortSaleFirst(result.toList()));
  }

  // ---- Fetching Products ---------------------------------------------------
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final list = await ProductService.fetchActive();
      _mergeIntoCatalog(list);
    } catch (e) {
      debugPrint('fetchProducts error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFeatured() async {
    try {
      final list = await ProductService.fetchFeatured();
      featured.assignAll(list);
    } catch (e) {
      debugPrint('fetchFeatured error: $e');
    }
  }

  Future<void> fetchCategories() async {
    try {
      final list = await ProductService.fetchCategories();
      categories.assignAll(list);
    } catch (e) {
      debugPrint('fetchCategories error: $e');
    }
  }

  // ---- Searching & Filtering ------------------------------------------------
  Future<void> searchRemote(String query) async {
    currentQuery.value = query;
    try {
      final list = await ProductService.search(query);
      // After remote search returns we still apply the category filter
      // in-memory so search results respect the selected category chip.
      allProducts = _sortSaleFirst(list);
      _applyAllFilters();
    } catch (e) {
      debugPrint('searchRemote error: $e');
    }
  }

  void filterProductsByName(String query) {
    currentQuery.value = query;
    _applyAllFilters();
  }

  /// Switch category. Empty string == "All".
  Future<void> selectCategory(String category) async {
    selectedCategory.value = category;
    if (category.isEmpty) {
      await fetchProducts();
    } else {
      try {
        isLoading.value = true;
        final list = await ProductService.fetchByCategory(category);
        allProducts = _sortSaleFirst(list);
        _applyAllFilters();
      } catch (e) {
        debugPrint('selectCategory error: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  void showAllProducts() {
    currentQuery.value = '';
    _applyAllFilters();
  }

  // ---- Getters --------------------------------------------------------------
  List<Product> get products => filteredProducts.value;
  List<Product> get allProductsList => allProducts;
  bool get hasProducts => allProducts.isNotEmpty;
  bool get hasFilteredResults => filteredProducts.isNotEmpty;
  int get productCount => allProducts.length;
  int get filteredCount => filteredProducts.length;

  (double, double)? getPriceRange() {
    if (allProducts.isEmpty) return null;
    final prices = allProducts.map((p) => p.price).toList();
    return (
      prices.reduce((a, b) => a < b ? a : b),
      prices.reduce((a, b) => a > b ? a : b)
    );
  }
}
