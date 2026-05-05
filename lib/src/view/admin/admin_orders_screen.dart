import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/controller/admin_controller.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/core/app_typography.dart';
import 'package:e_commerce_flutter/src/view/admin/widgets/admin_order_card.dart';
import 'package:e_commerce_flutter/src/view/admin/widgets/order_status_filter_chips.dart';
import 'package:e_commerce_flutter/src/view/widget/empty_state.dart';

/// Top-level admin orders screen. Composes the status filter chips and
/// orders list. Each order's card is rendered by [AdminOrderCard].
class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        title: const Text('All Orders', style: AppText.headingLarge),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        actions: [
          IconButton(
            onPressed: controller.fetchOrders,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          OrderStatusFilterChips(controller: controller),
          Expanded(child: _OrdersBody(controller: controller)),
        ],
      ),
    );
  }
}

class _OrdersBody extends StatelessWidget {
  const _OrdersBody({required this.controller});

  final AdminController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final orders = controller.orders;
      final loading = controller.isOrdersLoading.value;
      if (loading && orders.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (orders.isEmpty) {
        return const EmptyState(
          icon: Icons.receipt_long_outlined,
          title: 'No orders yet',
          subtitle: 'Customer orders will appear here.',
        );
      }
      return RefreshIndicator(
        onRefresh: controller.fetchOrders,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: orders.length,
          itemBuilder: (_, i) {
            final order = orders[i];
            return AdminOrderCard(
              order: order,
              onChangeStatus: (status) =>
                  controller.updateOrderStatus(order.id!, status),
            );
          },
        ),
      );
    });
  }
}
