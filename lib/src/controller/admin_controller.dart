import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/core/app_toast.dart';
import 'package:e_commerce_flutter/src/core/services/order_service.dart';
import 'package:e_commerce_flutter/src/core/services/product_service.dart';
import 'package:e_commerce_flutter/src/model/order.dart';
import 'package:e_commerce_flutter/src/model/product.dart';

/// Backs the admin dashboard. Holds the unfiltered product list, current
/// search term, and order list. Subscribes to live product changes so the
/// admin table updates without a manual refresh.
class AdminController extends GetxController {
  RxList<Product> products = <Product>[].obs;
  RxList<OrderModel> orders = <OrderModel>[].obs;

  RxBool isLoading = false.obs;
  RxBool isOrdersLoading = false.obs;
  RxString searchQuery = ''.obs;
  RxnString orderStatusFilter = RxnString();

  StreamSubscription<List<Product>>? _liveSub;

  @override
  void onInit() {
    super.onInit();
    fetchAdminProducts();
    fetchOrders();
    _liveSub = ProductService.adminStream().listen(_applyFilter);
  }

  @override
  void onClose() {
    _liveSub?.cancel();
    super.onClose();
  }

  // ---- products -----------------------------------------------------------
  Future<void> fetchAdminProducts() async {
    try {
      isLoading.value = true;
      final list = await ProductService.fetchAllForAdmin(
        search: searchQuery.value,
      );
      products.assignAll(list);
    } catch (e) {
      AppToast.error('Load failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilter(List<Product> rows) {
    if (searchQuery.value.isEmpty) {
      products.assignAll(rows);
      return;
    }
    final q = searchQuery.value.toLowerCase();
    products.assignAll(
      rows.where((p) =>
          p.name.toLowerCase().contains(q) ||
          (p.description?.toLowerCase().contains(q) ?? false) ||
          (p.category?.toLowerCase().contains(q) ?? false) ||
          p.about.toLowerCase().contains(q)),
    );
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    fetchAdminProducts();
  }

  Future<void> saveProduct(Product product) async {
    try {
      isLoading.value = true;
      final isNew = product.id.isEmpty;
      if (isNew) {
        await ProductService.create(product);
      } else {
        await ProductService.update(product);
      }
      await fetchAdminProducts();
      // Close the form sheet first, then surface the toast.
      if (Get.isBottomSheetOpen ?? false) Get.back();
      if (isNew) {
        AppToast.success('Product added', '${product.name} is now live.');
      } else {
        AppToast.success('Product updated', '${product.name} saved.');
      }
    } catch (e) {
      AppToast.error('Save failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String id, {String? productName}) async {
    try {
      await ProductService.delete(id);
      products.removeWhere((p) => p.id == id);
      AppToast.success(
        'Deleted',
        productName != null
            ? '$productName removed.'
            : 'Product removed from inventory.',
      );
    } catch (e) {
      AppToast.error('Delete failed', e.toString());
    }
  }

  Future<void> toggleActive(Product p) async {
    try {
      await ProductService.setActive(p.id, !p.isActive);
      final idx = products.indexWhere((x) => x.id == p.id);
      if (idx != -1) {
        products[idx] = p.copyWith(isActive: !p.isActive);
        products.refresh();
      }
    } catch (e) {
      AppToast.error('Update failed', e.toString());
    }
  }

  Future<void> toggleFeatured(Product p) async {
    try {
      await ProductService.setFeatured(p.id, !p.isFeatured);
      final idx = products.indexWhere((x) => x.id == p.id);
      if (idx != -1) {
        products[idx] = p.copyWith(isFeatured: !p.isFeatured);
        products.refresh();
      }
    } catch (e) {
      AppToast.error('Update failed', e.toString());
    }
  }

  // ---- orders -------------------------------------------------------------
  Future<void> fetchOrders() async {
    try {
      isOrdersLoading.value = true;
      final list =
          await OrderService.allOrders(statusFilter: orderStatusFilter.value);
      orders.assignAll(list);
    } catch (e) {
      debugPrint('fetchOrders error: $e');
    } finally {
      isOrdersLoading.value = false;
    }
  }

  void filterOrdersByStatus(String? status) {
    orderStatusFilter.value = status;
    fetchOrders();
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await OrderService.updateStatus(orderId, status);
      AppToast.success('Order updated', 'Marked as ${status.label}.');
      await fetchOrders();
    } catch (e) {
      AppToast.error('Update failed', e.toString());
    }
  }
}
